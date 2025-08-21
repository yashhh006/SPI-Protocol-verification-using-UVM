class spi_seq_lib extends uvm_sequence#(spi_tx);
  `new_obj
  `uvm_object_utils(spi_seq_lib)
  
  apb_tx tx;
  
  
  task body();
    //addr_reg
    
    
    //data_reg
  endtask
endclass

class spi_seq extends uvm_sequence#(apb_tx);
  `new_obj
  `uvm_object_utils(spi_seq)
  
  apb_tx tx;
  
  
  task body();
    //addr_reg
    for(int i=0;i<`num_txns;i++)begin
      `uvm_do_with (req,{req.penable==1 ; req.pwrite==1; 
                         req.paddr == i ; req.pwdata== 8'h80+i;});
      
      //req.print();
    end
    //data_reg
    for(int i=10;i<(`num_txns+10);i++)begin
      `uvm_do_with (req,{req.penable==1 ; req.pwrite==1; 
                         req.paddr == i ; req.pwdata== 8'h90+i;});
      //req.print();
    end	
    
    //cntrl_reg
    `uvm_do_with (req,{req.penable==1 ; req.pwrite==1; 
                       req.paddr==8'd18 ; req.pwdata==8'b00001111;});
    //req.print();
    
  endtask
endclass