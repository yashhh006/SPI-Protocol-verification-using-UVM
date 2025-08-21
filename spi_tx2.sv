class spi_tx2 extends uvm_sequence_item;
  `new_obj
  bit [7:0] ad_temp[7:0];
  bit [7:0] dt_temp[7:0];
  `uvm_object_utils_begin(spi_tx2)
    `uvm_field_sarray_int(ad_temp, UVM_ALL_ON)
    `uvm_field_sarray_int(dt_temp, UVM_ALL_ON)
  `uvm_object_utils_end
endclass