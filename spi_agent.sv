class spi_agent extends uvm_agent;
  `new_comp
  `uvm_component_utils(spi_agent)
  spi_sqr sqr;
  spi_drv drv;
  spi_mon mon;
  spi_cov cov;
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sqr=spi_sqr::type_id::create("sqr",this);
    drv=spi_drv::type_id::create("drv",this);
    mon=spi_mon::type_id::create("mon",this);
    cov=spi_cov::type_id::create("cov",this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    drv.seq_item_port.connect(sqr.seq_item_export);
    mon.ap_port.connect(cov.analysis_export);
  endfunction
endclass