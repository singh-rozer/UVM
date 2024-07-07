class nfmc_test extends uvm_test;
`uvm_component_utils(nfmc_test)

nfmc_write_read_seq seq;
nfmc_write_or_read_seq seq_wr_or_rd;
nfmc_seq_block_erase seq_be;
nfmc_seq_read_id seq_id;
//nfmc_seq_init seq;
nfmc_seq_reset_cmd seq_reset;

nfmc_env env;
nfmc_config cg;

function new(string name="nfmc_test", uvm_component parent=null);
super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
env=nfmc_env::type_id::create("env",this);
cg=nfmc_config::type_id::create("cg");
uvm_config_db#(nfmc_config)::set(this,"*","cg",cg);
endfunction

virtual function void end_of_elaboration_phase(uvm_phase phase);
uvm_top.print_topology();
endfunction

task run_phase(uvm_phase phase);
super.run_phase(phase);
phase.raise_objection(this);

seq_wr_or_rd = nfmc_write_or_read_seq::type_id::create("seq_wr_or_rd");
seq_wr_or_rd.start(env.agt.seqr);

//seq_reset = nfmc_seq_reset_cmd::type_id::create("seq_reset");
//seq_reset.start(env.agt.seqr);
//seq_id = nfmc_seq_read_id::type_id::create("seq_id");
//seq_id.start(env.agt.seqr);
//seq_be = nfmc_seq_block_erase::type_id::create("seq_be");
//seq_be.start(env.agt.seqr);
#20;
seq = nfmc_write_read_seq::type_id::create("seq");
seq.start(env.agt.seqr);
#100

phase.drop_objection(this);
endtask

endclass
