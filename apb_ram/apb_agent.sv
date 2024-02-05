class apb_agent extends uvm_agent;
`uvm_component_utils(apb_agent)

apb_drv drv;
apb_mon mon;
uvm_sequencer#(apb_trans) seqr;

apb_cfg cfg;


function new(string name="apb_agent", uvm_component parent=null);
super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
cfg = apb_cfg::type_id::create("apb_cfg");
if(cfg.is_active == UVM_ACTIVE) begin
drv = apb_drv::type_id::create("drv",this);
seqr = uvm_sequencer#(apb_trans)::type_id::create("seqr",this);
end
mon = apb_mon::type_id::create("mon",this);
endfunction

virtual function void connect_phase(uvm_phase phase);
drv.seq_item_port.connect(seqr.seq_item_export);
endfunction

endclass


