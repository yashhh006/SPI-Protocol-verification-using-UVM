class spi_mon2 extends uvm_monitor;
  `uvm_component_utils(spi_mon2)
  virtual spi_intf vif2;
  uvm_analysis_port #(spi_tx2) ap_port2;
  spi_tx2 tx;
  
  function new(string name="", uvm_component parent =null);
    super.new(name,parent);
    ap_port2=new("ap_port2",this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(virtual spi_intf)::get(this,"","spi_intf",vif2);
  endfunction
  
  function void write(spi_tx2 t);
    
  endfunction
  
  //working in questa
  //not working in cadence
  //vcs is not even considering
  
  task run_phase(uvm_phase phase);
  @(posedge vif2.s_clk);
  @(posedge vif2.s_clk);
  @(posedge vif2.s_clk);
  
  tx = new();
  @(negedge vif2.s_clk);
  for(int i = 0; i < `num_txns; i++) begin
    @(posedge vif2.s_clk);
    tx.ad_temp[0][i] = vif2.mosi;
  end
  //`uvm_info("SPI_MON", $psprintf("Ad_Temp[%0d]=%0d", 0, tx.ad_temp[0]), UVM_LOW)
  
  @(negedge vif2.s_clk);
  for(int i = 0; i < `num_txns; i++) begin
    @(posedge vif2.s_clk);
    tx.dt_temp[0][i] = vif2.mosi;
  end
  //`uvm_info("SPI_MON", $psprintf("Dt_Temp[%0d]=%0d", 0, tx.dt_temp[0]), UVM_LOW)
  
  for(int j = 1; j < `num_txns; j++) begin
    @(negedge vif2.s_clk);
    @(posedge vif2.s_clk);
    for(int i = 0; i < `num_txns; i++) begin
      @(posedge vif2.s_clk);
      tx.ad_temp[j][i] = vif2.mosi;
    end
    //`uvm_info("SPI_MON", $psprintf("Ad_Temp[%0d]=%0d", j, tx.ad_temp[j]), UVM_LOW)
  
    @(negedge vif2.s_clk);
    for(int i = 0; i < `num_txns; i++) begin
      @(posedge vif2.s_clk);
      tx.dt_temp[j][i] = vif2.mosi;
    end
    //`uvm_info("SPI_MON", $psprintf("Dt_Temp[%0d]=%0d",j,tx.dt_temp[j]), UVM_LOW)
    if (j >= 7) break; // Break after ALL the transaction
  end
  `uvm_info("SPI_MON", "Before tx.print()", UVM_LOW)
  //tx.print();
  ap_port2.write(tx);
endtask
endclass