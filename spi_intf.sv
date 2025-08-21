interface spi_intf(input reg s_clk_ref);
  logic  miso;
  logic  mosi;
  logic  [2:0]ssel;
  logic  s_clk;
  
  clocking cb_mon2 @(negedge s_clk);
    default input #1;
    input miso;
    input mosi;
    input ssel;
    input s_clk;
  endclocking
  
endinterface