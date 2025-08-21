class apb_tx extends uvm_sequence_item;
  `new_obj
  
  rand bit pwrite,penable;
  rand bit [`num_bits-1:0]paddr;
  rand bit [`num_bits-1:0]pwdata;
  //rand bit [`num_bits-1:0]cntrl_reg;
  
  `uvm_object_utils_begin(apb_tx)
  `uvm_field_int(paddr,UVM_ALL_ON)
  `uvm_field_int(pwdata,UVM_ALL_ON)
  `uvm_field_int(penable,UVM_ALL_ON)
  `uvm_object_utils_end
  
  constraint data_c{pwdata inside {[10:190]};}
endclass