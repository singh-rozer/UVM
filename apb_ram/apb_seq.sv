class apb_seq_wr extends uvm_sequence#(apb_trans);
`uvm_object_utils(apb_seq_wr)

apb_trans req;

function new(string name="apb_seq_wr");
super.new(name);
endfunction

task body();
repeat(1) begin
req = apb_trans::type_id::create("req");
start_item(req);
assert(req.randomize());
req.op = writed;
`uvm_info(get_type_name(),$sformatf("Printing values from \n%0s",req.sprint()),UVM_MEDIUM)
finish_item(req);
end
endtask

endclass

class apb_seq_rd extends uvm_sequence#(apb_trans);
`uvm_object_utils(apb_seq_rd)

apb_trans req;

function new(string name="apb_seq_rd");
super.new(name);
endfunction

task body();
repeat(1) begin
req = apb_trans::type_id::create("req");
start_item(req);
assert(req.randomize());
req.op = readd;
`uvm_info(get_type_name(),$sformatf("Printing values from \n%0s",req.sprint()),UVM_MEDIUM)
finish_item(req);
end
endtask

endclass

class apb_seq_wr_rd extends uvm_sequence#(apb_trans);
`uvm_object_utils(apb_seq_wr_rd)

apb_trans req;
bit [31:0] addr_temp;

function new(string name="apb_seq_wr_rd");
super.new(name);
endfunction

task body();
repeat(1) begin
req = apb_trans::type_id::create("req");
start_item(req);
assert(req.randomize());
req.op = writed;
addr_temp = req.paddr;
`uvm_info(get_type_name(),$sformatf("Printing values from \n%0s",req.sprint()),UVM_MEDIUM)
finish_item(req);
start_item(req);
assert(req.randomize());
req.op = readd;
req.paddr = addr_temp;
`uvm_info(get_type_name(),$sformatf("Printing values from \n%0s",req.sprint()),UVM_MEDIUM)
finish_item(req);
end
endtask

endclass

class apb_seq_wr_err extends uvm_sequence#(apb_trans);
`uvm_object_utils(apb_seq_wr_err)

apb_trans req;

function new(string name="apb_seq_wr_err");
super.new(name);
endfunction

task body();
repeat(1) begin
req = apb_trans::type_id::create("req");
start_item(req);
assert(req.randomize());
req.op = writed;
req.paddr = 32;
`uvm_info(get_type_name(),$sformatf("Printing values from \n%0s",req.sprint()),UVM_MEDIUM)
finish_item(req);

end
endtask

endclass
