class spi_test_lib extends uvm_test;
  `new_comp
  `uvm_component_utils(spi_test_lib)
  spi_env env;
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env=spi_env::type_id::create("env",this);
  endfunction
  
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
    uvm_top.set_report_verbosity_level(UVM_FULL);
  endfunction
  
  task run_phase(uvm_phase phase);
    spi_seq seq;
    seq=spi_seq::type_id::create("seq",this);
    
    phase.raise_objection(this);
    seq.start(env.agt.sqr);
    phase.phase_done.set_drain_time(this,1200);
    phase.drop_objection(this);
  endtask
  
  function void report_phase(uvm_phase phase);
    if(spi_comm::ad_matchings==0 || spi_comm::ad_mismatchings>0 ||
      spi_comm::dt_matchings==0 || spi_comm::dt_mismatchings>0)
      `uvm_error("SPI_TEST","TESTCASE FAILED")
      else if(spi_comm::ad_matchings>0 || spi_comm::ad_mismatchings==0 ||
      spi_comm::dt_matchings>0 || spi_comm::dt_mismatchings==0)
      `uvm_info("SPI_TEST","TESTCASE PASSED",UVM_LOW)
  endfunction
endclass