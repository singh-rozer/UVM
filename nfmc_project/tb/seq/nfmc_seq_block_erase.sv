
class nfmc_seq_block_erase extends uvm_sequence#(nfmc_trans);
`uvm_object_utils(nfmc_seq_block_erase)

nfmc_trans pkt;

bit [10:0] num;

function new(string name="nfmc_seq_block_erase");
super.new(name);
endfunction

task body();
begin
assert(std::randomize(num) with {num inside {[3:5]};});
page_prog();
block_erase();
page_read();
end
endtask


task block_erase();
repeat(1)
begin
pkt = nfmc_trans::type_id::create("pkt");
start_item(pkt);
assert(pkt.randomize());
pkt.nfc_cmd = 'b100;
//pkt.RWA = 0;
finish_item(pkt);
#5;
end
endtask

task page_prog();
repeat(1)
begin
pkt = nfmc_trans::type_id::create("pkt");
start_item(pkt);
assert(pkt.randomize() with {pkt.data_itr == num;});
pkt.nfc_cmd = 'b001;
pkt.BF_sel = 1;
pkt.BF_we = 1;
pkt.op = NORMAL;
finish_item(pkt);
#5;
end
endtask

task page_read();
repeat(1)
begin
pkt = nfmc_trans::type_id::create("pkt");
start_item(pkt);
assert(pkt.randomize() with {pkt.data_itr == num;});
pkt.nfc_cmd = 'b010;
pkt.BF_sel = 1;
pkt.op = WRITE_READ;
finish_item(pkt);
#5;
end
endtask


endclass
