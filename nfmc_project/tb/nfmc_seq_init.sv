
class nfmc_seq_init extends uvm_sequence#(nfmc_trans);
`uvm_object_utils(nfmc_seq_init)

nfmc_trans pkt;

function new(string name="nfmc_seq");
super.new(name);
endfunction

task body();
repeat(1)
begin
pkt = nfmc_trans::type_id::create("pkt");
start_item(pkt);
assert(pkt.randomize());
pkt.RES = 1;
pkt.BF_sel = 0;//buffer
pkt.BF_ad = 0;//buffer
pkt.BF_din = 0;//buffer
pkt.BF_we = 0;//buffer
pkt.RWA = 0;//row address
pkt.nfc_cmd = 3'b111;//init state(main_fsm)
pkt.nfc_strt = 0;//to keep in init state(main_fsm)
finish_item(pkt);
#5;
end
endtask

endclass
