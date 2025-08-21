`uvm_analysis_imp_decl(_apb)
`uvm_analysis_imp_decl(_spi)

class spi_sbd extends uvm_scoreboard;
  `uvm_component_utils(spi_sbd)
  uvm_analysis_imp_apb #(apb_tx,spi_sbd) sbd_imp;
  uvm_analysis_imp_spi #(spi_tx2,spi_sbd) sbd_imp2;
  apb_tx tx;
  spi_tx2 tx2;
  virtual apb_intf vif;
  static bit[`num_bits-1:0]mem[*];
  int xx;
  static bit[`num_bits-1:0]tempx[$];
  
  function new(string name="", uvm_component parent =null);
    super.new(name,parent);
    sbd_imp=new("sbd_imp",this);
    sbd_imp2=new("sbd_imp2",this);
    uvm_config_db#(virtual apb_intf)::get(this,"","apb_intf",vif);
  endfunction
  
  function write_apb(apb_tx t);
    this.tx=t;
    mem[tx.paddr]=tx.pwdata;
    //`uvm_info("SBD",$psprintf("Mem at SBD=%p",mem),UVM_LOW)
  endfunction
  
  function void write_spi(spi_tx2 t);
    this.tx2=t;
    for(int i=0;i<`num_txns;i++)
      tempx.push_back(tx2.ad_temp[i]);
    for(int i=0;i<`num_txns;i++)
      tempx.push_back(tx2.dt_temp[i]);
    `uvm_info("SBD",$psprintf("Mem at SBD=%p",mem),UVM_LOW)
    `uvm_info("SBD",$psprintf("TempX at SBD=%p",tempx),UVM_LOW)
    
    for(int i=0;i<2*`num_txns;i++)begin
      if(i<8)begin
        if(mem[i]==tempx[i])
          spi_comm::ad_matchings++;
        else
          spi_comm::ad_mismatchings++;
      end
      
      else begin
        if(mem[i+2]==tempx[i])
          spi_comm::dt_matchings++;
        else
          spi_comm::dt_mismatchings++;
      end
      //`uvm_info("SBD_INFO",$psprintf("Ad_match=%0d >> Ad_mismatch=%0d", spi_comm::ad_matchings,spi_comm::ad_mismatchings),UVM_LOW)
      //`uvm_info("SBD_INFO",$psprintf("Dt_match=%0d >> Dt_mismatch=%0d", spi_comm::dt_matchings,spi_comm::dt_mismatchings),UVM_LOW)
    end
  endfunction
endclass