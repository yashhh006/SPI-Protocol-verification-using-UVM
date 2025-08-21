class spi_mon extends uvm_monitor;
  `uvm_component_utils(spi_mon)
  virtual apb_intf vif;
  uvm_analysis_port #(apb_tx) ap_port;
  apb_tx tx;
  
  function new(string name="", uvm_component parent =null);
    super.new(name,parent);
    ap_port=new("ap_port",this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(virtual apb_intf)::get(this,"","apb_intf",vif);
  endfunction
  
  function void write(apb_tx t);
    
  endfunction
  
  task run_phase(uvm_phase phase);
    forever begin
    @(vif.cb_mon);
    if(vif.cb_mon.penable==1 && vif.cb_mon.pready==1)begin
      tx = apb_tx::type_id::create("tx");
      tx.pwrite=vif.cb_mon.pwrite;
      tx.paddr=vif.cb_mon.paddr;
      if(vif.cb_mon.pwrite==1)
        tx.pwdata=vif.cb_mon.pwdata;
      else
        tx.pwdata=vif.cb_mon.prdata;
      //tx.print();
      ap_port.write(tx);
    end
    end
  endtask
endclass