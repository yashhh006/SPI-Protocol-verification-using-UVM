`include "top.sv"



/*
module spi_cntrl_tb;
  
  parameter num_bits=8; 
  parameter num_txns=8;
  
  parameter s_idle_no_txns     = 5'b00001;
  parameter s_addr_phase       = 5'b00010;
  parameter s_idle_addr_phase  = 5'b00100;
  parameter s_data_phase       = 5'b01000;
  parameter s_idle_txn_pending = 5'b10000;
  
  reg clk,rstn,pwrite,penable;
  reg [num_bits-1:0]paddr;
  reg [num_bits-1:0]pwdata;
  reg [2:0]psel;
  reg [num_bits-1:0]prdata;
  reg pready,perror;
  
  reg miso;
  reg s_clk_ref;
  reg mosi;
  wire [2:0]ssel;
  wire s_clk;
  integer i;
  
  spi_cntrl #(.num_bits(num_bits),.num_txns(num_txns)) dut(.*);
  
  initial begin
    clk=0;
    forever #5 clk=~clk;
  end
  
  initial begin
    clk=0;
    forever #2 s_clk_ref=~s_clk_ref;
  end
  
  task rstn_logic();
    begin
      @(posedge clk);
      penable=0;
      pwrite=0;
      paddr=0;
      pwdata=0;
      pready=0;
    end
  endtask
  
  task write(input [num_bits-1:0]addr, input [num_bits-1:0]data);
    begin
      @(posedge clk);
      penable=1;
      pwrite=1;
      paddr=addr;
      pwdata=data;
      //wait(pready==1);
    end
  endtask
  
  task write2(input [num_bits-1:0]addr, input [num_bits-1:0]data);
    begin
      @(posedge clk);
      penable=1;
      pwrite=0;
    end
  endtask
      
  
  initial begin
    rstn=0;
    //pwrite=0;
    //penable=0;
    //paddr=0;
    //prdata=0;
    miso=1;
    s_clk_ref=0;
    repeat(2)@(posedge clk);
    rstn=1;
    
    //Write into address reg
    for(i=0;i<num_txns;i=i+1)begin
      write(i,8'h80+i);
    end
    
    //Write into data reg
    for(i=0;i<num_txns;i=i+1)begin
      write(8'd10+i,8'h90+i);
    end
    
    //Wrire into control reg
    write(8'd18,{4'b000,3'b111,1'b1});
    //rstn_logic();
    
    #1000
    for(i=0;i<num_txns;i=i+1)begin
      write2(i,8'h80+i);
    end
    
    //Write into data reg
    for(i=0;i<num_txns;i=i+1)begin
      write2(8'd10+i,8'h90+i);
    end
    
    //Wrire into control reg
    write2(8'd18,{4'b000,3'b111,1'b1});
    //rstn_logic();
  end
  
  initial begin
    #1250
    $finish;
  end
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars(0, spi_cntrl_tb);
  end
endmodule

clk
rstn
s_clk_ref
pwrite
penable
addr
pwdata
psel
pready
perror
prdata
s_clk
miso
mosi
ssel
*/