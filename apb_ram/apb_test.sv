class apb_test extends uvm_test;
`uvm_component_utils(apb_test)

apb_seq_wr seq_wr;
apb_seq_rd seq_rd;
apb_seq_wr_rd seq_wr_rd;
apb_seq_wr_err seq_err;
apb_env env;

function new(string name="apb_test", uvm_component parent=null);
super.new(name,parent);
endfunction


virtual function void build_phase(uvm_phase phase);
seq_wr = apb_seq_wr::type_id::create("seq_wr");
seq_wr_rd = apb_seq_wr_rd::type_id::create("seq_wr_rd");
seq_rd = apb_seq_rd::type_id::create("seq_rd");
seq_err = apb_seq_wr_err::type_id::create("seq_err");
env = apb_env::type_id::create("env",this);
endfunction

task run_phase(uvm_phase phase);
phase.raise_objection(this);
//seq_wr.start(env.agt.seqr);
//#20
seq_rd.start(env.agt.seqr);
#20
seq_wr_rd.start(env.agt.seqr);
//#20
//seq_err.start(env.agt.seqr);
#40
phase.drop_objection(this);
endtask

endclass

