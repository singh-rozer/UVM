class nfmc_agent extends uvm_agent;
`uvm_component_utils(nfmc_agent)

nfmc_driver drv;
nfmc_monitor mon;
//uvm_sequencer#(nfmc_trans) seqr;
nfmc_seqr seqr;

nfmc_config cg;
virtual nfmc_if vif;

function new(string name="nfmc_agent", uvm_component parent=null);
super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db#(virtual nfmc_if)::get(this,"","vif",vif))
`uvm_fatal(get_type_name(),"Failed to get the nfmc interface handle");

uvm_config_db#(virtual nfmc_if)::set(this,"*","vif",vif);

if(!uvm_config_db#(nfmc_config)::get(this,"","cg",cg))
`uvm_fatal(get_type_name(),"Failed to get the config handle");

if(cg.is_active == UVM_ACTIVE)
begin
drv=nfmc_driver::type_id::create("drv",this);
seqr=nfmc_seqr::type_id::create("seqr",this);
end
mon=nfmc_monitor::type_id::create("mon",this);
endfunction

virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
drv.seq_item_port.connect(seqr.seq_item_export);
endfunction

endclass
