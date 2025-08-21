class spi_cov extends uvm_subscriber#(apb_tx);
  `uvm_component_utils(spi_cov)
  apb_tx tx;
  
  covergroup cg;
    write_cg:coverpoint tx.pwrite{
      bins WR={1'b1};
      bins RD={1'b0};
    }
    
    addr_cg:coverpoint tx.paddr{
      bins a1={[0:5]};
      bins a2={[5:10]};
    }
    
    data_cg:coverpoint tx.pwdata{
      bins b1={[8'h80:8'h90]};
      bins b2={[8'h90:8'h100]};
      bins b3={8'b00001111};
    }
    
  endgroup
  
  
  function new(string name="", uvm_component parent);
    super.new(name,parent);
    cg=new();
  endfunction
  
  function void write(apb_tx t);
    this.tx=t;
    cg.sample();
  endfunction
  
  function void report_phase(uvm_phase phase);
    `uvm_info(get_full_name(),$sformatf("PADDR Coverage is %0.2f %%",
                                       cg.write_cg.get_coverage()),UVM_LOW);
    `uvm_info(get_full_name(),$sformatf("PADDR Coverage is %0.2f %%",
                                       cg.addr_cg.get_coverage()),UVM_LOW);
    `uvm_info(get_full_name(),$sformatf("PWDATA Coverage is %0.2f %%",
                                       cg.data_cg.get_coverage()),UVM_LOW);
    `uvm_info(get_full_name(),$sformatf("APB Coverage is %0.2f %%",
                                       cg.get_coverage()),UVM_LOW);
  endfunction
endclass