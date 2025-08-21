interface apb_intf(input logic clk,rstn);
  logic pwrite,penable;
  logic [`num_bits-1:0]paddr;
  logic [`num_bits-1:0]pwdata;
  logic [2:0]psel;
  logic [`num_bits-1:0]prdata;
  logic  pready,perror;
  
  clocking cb_drv@(posedge clk);
    default input #0 output #1;
    output pwrite;
    output penable;
    output paddr;
    output pwdata;
    output psel;
    input  prdata;
    input  pready;
    input  perror; 
  endclocking
  
  clocking cb_mon@(posedge clk);
    default input #1;
    input pwrite;
    input penable;
    input paddr;
    input pwdata;
    input psel;
    input prdata;
    input pready;
    input perror; 
  endclocking
endinterface