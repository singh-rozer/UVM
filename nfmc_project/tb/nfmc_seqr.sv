class nfmc_seqr extends uvm_sequencer#(nfmc_trans);
`uvm_component_utils(nfmc_seqr)

function new(string name="nfmc_seqr",uvm_component parent=null);
 super.new(name,parent);
endfunction

endclass
