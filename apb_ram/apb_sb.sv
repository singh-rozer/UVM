class apb_sb extends uvm_scoreboard;
`uvm_component_utils(apb_sb)

uvm_analysis_imp#(apb_trans,apb_sb) imp;

bit [31:0] addr;
bit [31:0] data;
bit [31:0] ref_mem [32];

function new(string name="apb_sb", uvm_component parent=null);
super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
imp = new("apb_sb",this);
endfunction

virtual function write(apb_trans req);
$display("-------------SCOREBOARD---------------");
if(req.op == rst)begin
`uvm_info(get_type_name(),"Rst working properly",UVM_MEDIUM)
end
if(req.op == writed)begin
if(req.pslverr)
`uvm_error(get_type_name(),"Failed write transaction due to slv error")
else begin
addr = req.paddr;
data = req.pwdata;
ref_mem[addr] = data;
`uvm_info(get_type_name(),$sformatf("DATA WRITTEN PROPERLY for addr = %0d",addr),UVM_MEDIUM)
end
end
if(req.op == readd)begin
if(req.pslverr)
`uvm_error(get_type_name(),"Failed read transaction due to slv error")
else begin
addr = req.paddr;
data = req.prdata;
if(ref_mem[addr] == data)
`uvm_info(get_type_name(),$sformatf("DATA MATCHED for addr = %0d",addr),UVM_MEDIUM)
else
`uvm_error(get_type_name(),$sformatf("DATA MISMATCH for addr = %0d",addr))
end
end
$display("---------------------------------");
endfunction

endclass
