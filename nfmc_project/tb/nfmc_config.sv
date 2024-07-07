class nfmc_config extends uvm_object;
`uvm_object_utils(nfmc_config)

uvm_active_passive_enum is_active;

function new(string name="nfmc_config");
super.new(name);
is_active=UVM_ACTIVE;
endfunction

endclass
