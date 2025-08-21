class spi_env extends uvm_env;
  `new_comp
  `uvm_component_utils(spi_env)
  
  spi_agent agt;
  spi_agent2 agt2;
  spi_sbd sbd;
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sbd=spi_sbd::type_id::create("sbd",this);
	agt=spi_agent::type_id::create("agt",this);
    agt2=spi_agent2::type_id::create("agt2",this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    agt.mon.ap_port.connect(sbd.sbd_imp);
    agt2.mon2.ap_port2.connect(sbd.sbd_imp2);
  endfunction
endclass