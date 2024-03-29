class apb_trans extends uvm_sequence_item;

bit presetn;//logic also fine
bit pclk;
bit psel;
bit penable;
rand oper_mode op;
bit pwrite;
rand bit [31:0] paddr;
rand bit [31:0] pwdata;
bit [31:0] prdata;
bit pready;
bit pslverr;

constraint addr_c {paddr <= 31;}

`uvm_object_utils_begin(apb_trans) //to use inbuilt method like sprint,copy..
`uvm_field_int( presetn,UVM_ALL_ON);
`uvm_field_int( pclk,UVM_ALL_ON);
`uvm_field_int( psel,UVM_ALL_ON);
`uvm_field_int( penable,UVM_ALL_ON);
`uvm_field_enum( oper_mode,op,UVM_ALL_ON);
`uvm_field_int( pwrite,UVM_ALL_ON);
`uvm_field_int( paddr,UVM_ALL_ON);
`uvm_field_int( pwdata,UVM_ALL_ON);
`uvm_field_int( prdata,UVM_ALL_ON);
`uvm_field_int( pready,UVM_ALL_ON);
`uvm_field_int( pslverr,UVM_ALL_ON);
`uvm_object_utils_end

function new(string name="apb_trans");
super.new(name);
endfunction

endclass
