class nfmc_write_or_read_seq extends uvm_sequence#(nfmc_trans);
`uvm_object_utils(nfmc_write_or_read_seq)

nfmc_trans pkt;

bit [10:0] num;
bit [2:0] nfc_cmd;

function new(string name="nfmc_write_read_seq");
super.new(name);
endfunction

task body();
begin
repeat(1) begin
//assert(std::randomize(num) with {num == 2047;});
pkt = nfmc_trans::type_id::create("pkt");
start_item(pkt);
assert(pkt.randomize() with {pkt.data_itr == num;});
assert(std::randomize(nfc_cmd) with {nfc_cmd inside {'b010,001};});
pkt.nfc_cmd = nfc_cmd;
pkt.BF_sel = 1;
pkt.BF_we = nfc_cmd == 'b001 ? 1:0;
pkt.op = PARALLEL;
finish_item(pkt);
#5;
end
end
endtask

endclass
