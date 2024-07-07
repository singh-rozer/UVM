
class nfmc_seq_read_id extends uvm_sequence#(nfmc_trans);
`uvm_object_utils(nfmc_seq_read_id)

nfmc_trans pkt;

function new(string name="nfmc_seq_read_id");
super.new(name);
endfunction

task body();
begin
read_id();
end
endtask

task read_id();
repeat(1)
begin
pkt = nfmc_trans::type_id::create("pkt");
start_item(pkt);
assert(pkt.randomize());
pkt.nfc_cmd = 'b101;
pkt.RWA = 0;
finish_item(pkt);
#5;
end
endtask

endclass

