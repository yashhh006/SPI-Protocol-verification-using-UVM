`define num_bits 8
`define num_txns 8

`define new_obj \
function new(string name="");\
  super.new(name);\
endfunction

`define new_comp \
function new(string name="", uvm_component parent);\
  super.new(name,parent);\
endfunction

class spi_comm;
  static int dt_matchings;
  static int dt_mismatchings;
  static int ad_matchings;
  static int ad_mismatchings;
endclass