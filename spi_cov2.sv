class spi_cov2 extends uvm_subscriber#(spi_tx);
  `uvm_component_utils(spi_cov2)
  spi_tx2 tx;
  covergroup cg2;
    
  endgroup
  
  
  function new(string name="", uvm_component parent);
    super.new(name,parent);
    cg2=new();
  endfunction
  
  function void write(spi_tx t);
    cg2.sample();
  endfunction
endclass