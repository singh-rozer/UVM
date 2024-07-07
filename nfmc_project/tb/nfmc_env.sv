class nfmc_env extends uvm_env;
`uvm_component_utils(nfmc_env)

nfmc_scoreboard sb;
nfmc_cov cov;
nfmc_agent agt;



function new(string name="nfmc_env", uvm_component parent=null);
super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
sb=nfmc_scoreboard::type_id::create("sb",this);
cov=nfmc_cov::type_id::create("cov",this);
agt=nfmc_agent::type_id::create("agt",this);
endfunction

virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
agt.mon.ap.connect(sb.imp);
agt.mon.ap.connect(cov.analysis_export);
endfunction

endclass
