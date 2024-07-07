

class nfmc_seq_reset_cmd extends uvm_sequence#(nfmc_trans);
`uvm_object_utils(nfmc_seq_reset_cmd)

nfmc_trans pkt;

function new(string name="nfmc_seq_reset_cmd");
super.new(name);
endfunction

task body();
repeat(1)
begin
pkt = nfmc_trans::type_id::create("pkt");
start_item(pkt);
assert(pkt.randomize());
pkt.nfc_cmd = 3'b011;//init state(main_fsm)
//pkt.DIO = 'hFF;
finish_item(pkt);
#5;
end
endtask

endclass
