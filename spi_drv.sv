class spi_drv extends uvm_driver#(apb_tx);
  `new_comp
  `uvm_component_utils(spi_drv)
  virtual apb_intf vif;
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(virtual apb_intf)::get(this,"","apb_intf",vif);
  endfunction
  
  task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      drive_tx(req);
      seq_item_port.item_done(req);
    end
  endtask
  
  task drive_tx(apb_tx tx);
    @(vif.cb_drv);
    vif.cb_drv.pwrite<=tx.pwrite;
    vif.cb_drv.paddr<=tx.paddr;
    if(vif.cb_drv.pwrite==1)begin
      vif.cb_drv.pwdata<=tx.pwdata;
    end
    vif.cb_drv.penable<=1;
    wait(vif.cb_drv.pready==1);
    if(vif.cb_drv.pwrite==0)
      tx.pwdata<=vif.cb_drv.pwdata;
    
    @(vif.cb_drv);
    vif.cb_drv.penable<=0;
    
  endtask
endclass