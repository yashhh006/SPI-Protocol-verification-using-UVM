class spi_tx extends uvm_sequence_item;
  `new_obj
  
  rand bit s_clk,miso,mosi,s_clk_ref;
  rand bit [2:0]ssel;
  
  `uvm_object_utils(spi_tx)
endclass