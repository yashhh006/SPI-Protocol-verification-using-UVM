	
`include "uvm_pkg.sv"
import uvm_pkg::*;
`include "spi_comm.sv"
`include "apb_intf.sv"
`include "spi_intf.sv"
`include "apb_tx.sv"
`include "spi_tx.sv"
`include "spi_tx2.sv"
`include "spi_seq_lib.sv"
`include "spi_sqr.sv"
`include "spi_drv.sv"
`include "spi_mon.sv"
`include "spi_mon2.sv"
`include "spi_cov.sv"
`include "spi_cov2.sv"
`include "spi_agent.sv"
`include "spi_agent2.sv"
`include "spi_sbd.sv"
`include "spi_env.sv"
`include "spi_test_lib.sv"

module top;
  bit clk,rstn,s_clk_ref;
  apb_intf pif(clk,rstn);
  spi_intf sif(s_clk_ref);
  
  always #5 clk=~clk;
  always #2 s_clk_ref=~s_clk_ref;
  
  spi_cntrl #(`num_bits,`num_txns) dut(
    .clk(pif.clk),
    .rstn(pif.rstn),
    .pwrite(pif.pwrite),
    .penable(pif.penable),
    .paddr(pif.paddr),
    .pwdata(pif.pwdata),
    .psel(pif.psel),
    .pready(pif.pready),
    .perror(pif.perror),
    .prdata(pif.prdata),
    .s_clk_ref(sif.s_clk_ref),
    .s_clk(sif.s_clk),
    .miso(sif.miso),
    .mosi(sif.mosi),
    .ssel(sif.ssel));
  
  initial begin
    rstn=0;
    repeat(2)@(posedge clk);
    rstn=1;
  end
  
  initial begin
    run_test("spi_test_lib");
  end
  
  initial begin
    uvm_config_db#(virtual apb_intf)::set(null,"*","apb_intf",pif);
    uvm_config_db#(virtual spi_intf)::set(null,"*","spi_intf",sif);
  end
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars(0, top);
  end
endmodule