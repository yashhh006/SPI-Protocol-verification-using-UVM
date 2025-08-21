module spi_cntrl(

  //processor interface (APB signals)
clk,rstn,pwrite,penable,paddr,pwdata,psel,pready,perror,prdata,

  //slave interface (SPI signals)
  s_clk,miso,mosi,ssel,s_clk_ref);
  
  parameter num_bits=8; 
  parameter num_txns=8;
  
  parameter s_idle_no_txns     = 5'b00001;
  parameter s_addr_phase       = 5'b00010;
  parameter s_idle_addr_phase  = 5'b00100;
  parameter s_data_phase       = 5'b01000;
  parameter s_idle_txn_pending = 5'b10000;
  
  input clk,rstn,pwrite,penable;
  input [num_bits-1:0]paddr;
  input [num_bits-1:0]pwdata;
  input [2:0]psel;
  output reg [num_bits-1:0]prdata;
  output reg pready,perror;
  
  input miso;
  input s_clk_ref;
  output reg mosi;
  output reg [2:0]ssel;
  output reg s_clk;
  
  //internal register
  reg [num_bits-1:0] addr_reg[num_txns-1:0];
  reg [num_bits-1:0] data_reg[num_txns-1:0];
  reg [num_bits-1:0] cntrl_reg;
  
  reg [4:0] state,next_state;
  
  reg [num_bits-1:0] addr_temp;
  reg [num_bits-1:0] data_temp;
  reg [num_bits-1:0] read_temp;
  reg [2:0] curr_txn_index;      //Part of Control reg
  reg [2:0] num_txn_pending;     //Also part of Control reg
  reg flag;
  reg [5:0]count;
  reg [5:0]count2;
  reg [40*8:0]testcase;
  integer i;
  
  always@(posedge clk)begin
    if(!rstn)begin
      prdata=0;
      pready=0;
      perror=0;
      for(i=0;i<num_txns;i=i+1)begin
        addr_reg[i]=0;
        data_reg[i]=0;
      end
      addr_temp=0;
      data_temp=0;
      read_temp=0;
      cntrl_reg=0;
      curr_txn_index=0;
      num_txn_pending=0;
      state=s_idle_no_txns;
      next_state=s_idle_no_txns;
      count=0;
      count2=0;
      s_clk=0;
      flag=0;
    end
    else begin
      if(penable)begin
        pready=1;
        if(pwrite)begin
          if(paddr>=8'd00 && paddr<=8'd7)begin
            addr_reg[paddr]=pwdata;
            //$display("addr_reg[%0d]=%0b >> %0d",paddr,addr_reg[paddr],addr_reg[paddr]);
          end
          if(paddr>=8'd10 && paddr<=8'd17)begin
            data_reg[paddr-8'd10]=pwdata;
            //$display("data_reg[%0d]=%0b >> %0d",(paddr-10),data_reg[paddr-10],data_reg[paddr-10]);
          end
          if(paddr==8'd18)begin
            cntrl_reg[3:0]=pwdata;
          end
          //$display("Data_Reg=%p",data_reg);
        end
        else begin
          if(paddr>=8'd00 && paddr<=8'd7)
            prdata=addr_reg[paddr];
          if(paddr>=8'd10 && paddr<=8'd17)
            prdata=data_reg[paddr];
          if(paddr==8'd18)
            prdata=cntrl_reg[3:0];
        end
      end
      else begin
        pready=0;
      end
    end
  end
  
  always@(posedge s_clk_ref)begin
    if(rstn)begin
      case(state)
        s_idle_no_txns:begin
          mosi=1;
          flag=1'b0;
          if(cntrl_reg[0]==1)begin
            next_state=s_addr_phase;
            num_txn_pending=cntrl_reg[3:1];
            cntrl_reg[6:4]=curr_txn_index;
            addr_temp=addr_reg[curr_txn_index];
            //$display("addr_temp=%0b",addr_temp);
            data_temp=data_reg[curr_txn_index];
            //$display("data_temp=%0b",data_temp);
            count=0;
            flag=1'b1;
          end
          else begin
            next_state=s_idle_no_txns;
          end
        end
        
        s_addr_phase:begin
          mosi=addr_temp[count];
          //$display("At %0t addr mosi=%0b",$time,mosi);
          count=count+1;
          if(count<8)begin
            next_state=s_addr_phase;
            flag=1'b1;
          end
          else if(count==8)begin
            count=0;
            next_state=s_idle_addr_phase;
            flag=1'b0;
            //$display("At %0t going to next state=%0b",$time,next_state);
          end
          //mosi=1;
        end
        
        s_idle_addr_phase:begin
          count=count+1;
          if(count<10)begin
            next_state=s_idle_addr_phase;
            flag=1'b0;
          end
          else if(count==10)begin
            //$display("OKOK2");
            next_state=s_data_phase;
            count=0;
            flag=1'b1;
          end
        end
        
        s_data_phase:begin
          if(addr_temp[7]==1)begin
            mosi=data_temp[count];  //write to slave
            //$display("At %0t data mosi=%0b",$time,mosi);
          end
          else begin
            data_temp[count]=miso;  //read from slave
            mosi=1;
          end
          count=count+1;
          if(count==8)begin
            next_state=s_idle_txn_pending;
            flag=1'b0;
            count=0;
            flag=1;
          end
          else
            next_state=s_data_phase;
        end
        
        s_idle_txn_pending:begin
          mosi=1;
          count=count+1;
          if(count==10)begin
            if(num_txn_pending!=0)begin
              next_state=s_addr_phase;
              flag=1'b1;
              num_txn_pending=num_txn_pending-1;
              curr_txn_index=curr_txn_index+1;
              addr_temp=addr_reg[curr_txn_index];
              //$display("At 5th state addr_temp=%0b",addr_temp);
              data_temp=data_reg[curr_txn_index];
              //$display("At 5th state data_temp=%0b",data_temp);
            end
            else begin
              next_state=s_idle_no_txns;
              flag=1'b0;
              //cntrl_reg[0]=0;   Showing to stop the transaction
              //cntrl_reg[7]=1;   Showing the complete transaction
              cntrl_reg={1'b1,{7{1'b0}}};
              curr_txn_index=0;
              num_txn_pending=0;
            end
            count=0;
          end
          else begin
            next_state=s_idle_txn_pending;
            flag=1'b0;
          end
        end
      endcase
      //s_clk = flag ? 1'b1: s_clk_ref; 
    end
  end
  
  always@(posedge s_clk_ref or negedge s_clk_ref)
    s_clk = flag ? s_clk_ref : 1'b1;
  
  always@(next_state)state=next_state;
  
endmodule