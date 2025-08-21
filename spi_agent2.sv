class spi_agent2 extends uvm_agent;
  `new_comp
  `uvm_component_utils(spi_agent2);
  spi_mon2 mon2;
  spi_cov2 cov2;
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon2=spi_mon2::type_id::create("mon2",this);
    cov2=spi_cov2::type_id::create("cov2",this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    //mon2.ap_port2.connect(cov2.analysis_export);
  endfunction
endclass