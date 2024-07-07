class nfmc_write_read_seq extends uvm_sequence#(nfmc_trans);
`uvm_object_utils(nfmc_write_read_seq)

nfmc_trans pkt;

bit [10:0] num;

function new(string name="nfmc_write_read_seq");
super.new(name);
endfunction

task body();
begin
//repeat(4) begin
repeat(1) begin
assert(std::randomize(num) with {num == 10;});
page_prog();
page_read();
end
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
