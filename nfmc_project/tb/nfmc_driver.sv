class nfmc_driver extends uvm_driver#(nfmc_trans);
`uvm_component_utils(nfmc_driver)

nfmc_trans req;

virtual nfmc_if vif;

bit temp_data_send[$];

uvm_queue#(int) q_itr;

function new(string name="nfmc_driver", uvm_component parent=null);
super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
if(!uvm_config_db#(virtual nfmc_if)::get(this,"","vif",vif))
`uvm_error(get_type_name(),"Failed to get interface handle")
endfunction

virtual task run_phase(uvm_phase phase);
req = nfmc_trans::type_id::create("req");
//reset_dut();
forever begin
seq_item_port.get_next_item(req);
send(req);
seq_item_port.item_done();
end
endtask

task send(nfmc_trans req);

`uvm_info(get_type_name(),$sformatf("\n%0s",req.sprint()),UVM_MEDIUM)

//initialization
q_itr = uvm_queue#(int)::get_global_queue();
if(req.nfc_cmd == 'b010 || req.nfc_cmd == 'b001)
	q_itr.push_back(req.data_itr);
vif.RES <= 1'b1;
vif.BF_sel <= 0;
vif.BF_ad <= 0;
vif.BF_din <= 0;
vif.BF_we <= 0;
vif.RWA <= 0;
vif.nfc_cmd <= 'b111;
vif.nfc_strt <= 'b0;

#30;

vif.RES <= 1'b0;
repeat(5) @(posedge vif.CLK);
//////////////////////////////////////////////////////////////////////////////////////////////
//normal transaction
////////////////////reset cmd//////////////
if(req.nfc_cmd == 'b011) begin
vif.nfc_cmd <= req.nfc_cmd;
vif.nfc_strt <= 1;
@(posedge vif.CLK);
vif.nfc_strt <= 0;
wait(vif.nfc_done);
@(posedge vif.CLK);
//vif.nfc_cmd <= 'b111;
$display($time," >> %m ====reset command over====");
end
//////////////////////////////////////////
repeat(6)
@(posedge vif.CLK);
///////////////////////////////erase cmd////////
if(req.nfc_cmd == 'b100) begin
vif.RWA <= req.RWA;//address
vif.nfc_cmd <= req.nfc_cmd;
vif.nfc_strt <= 1;
@(posedge vif.CLK);
vif.nfc_strt <= 0;
wait(vif.nfc_done);
@(posedge vif.CLK);
vif.nfc_cmd <= 'b111;
if(vif.EErr) $display($time,"%m ====Erase Error====");
else $display($time,"%m ====Successfuly Erased targeted location====");
end
////////////////////////////////////////////////
repeat(6)
@(posedge vif.CLK);
//////////////////////////////page program cmd////////
if(req.nfc_cmd == 'b001) begin
//@(posedge vif.CLK);
//#3;
vif.RWA <= req.RWA;//address
vif.nfc_cmd <= req.nfc_cmd;
vif.nfc_strt <= 1;
vif.BF_sel <= req.BF_sel;
@(posedge vif.CLK);
//#3;
vif.nfc_strt <= 0;
vif.BF_ad <= 0;
for(int i = 0; i<=req.data_itr; i+=1)begin
    @(posedge vif.CLK);
    //#3;
    vif.BF_we <= req.BF_we;
    vif.BF_din <= $urandom_range('h100,'h0) % 256; 
    vif.BF_ad <= i;
end
repeat (2) @(posedge vif.CLK);
vif.BF_we = 0;
wait(vif.nfc_done);
@(posedge vif.CLK);
vif.nfc_cmd <= 'b111;
vif.BF_sel <= 1'b0;
if(vif.PErr) $display($time,"%m ====Writing Error====");
else $display($time,"%m ====Successfuly Written to the targeted location====");
end
///////////////////////////////////////////////////////
repeat(6)
@(posedge vif.CLK);
///////////////////////////////read cmd////////////////
if(req.nfc_cmd == 'b010) begin
vif.RWA <= req.RWA;//address
vif.nfc_cmd <= req.nfc_cmd;
vif.nfc_strt <= 1;
//vif.BF_sel <= req.BF_sel;
vif.BF_we <= req.BF_we;
vif.BF_ad <= req.BF_ad;
@(posedge vif.CLK);
vif.nfc_strt <= 0;
@(posedge vif.CLK);
wait(vif.nfc_done);
vif.BF_sel <= req.BF_sel;
@(posedge vif.CLK);
//vif.nfc_cmd <= 'b111;
vif.BF_ad <= req.BF_ad+1;
for(int i = 0; i<=req.data_itr-1; i+=1)begin//8->7
    @(posedge vif.CLK);
    req.temp_data_recv[i] <= vif.BF_dou;
    //req.temp_data_send[i] <= temp_data_send[i];
    vif.BF_ad <= vif.BF_ad+1;
end

repeat (1) @(posedge vif.CLK);

if(vif.RErr) $display($time,"%m ====ECC Error====");
else $display($time,"%m ====Successfuly read from the targeted location====");
end
/////////////////////////////////////////////////////////
repeat(6)
@(posedge vif.CLK);
//////////////////////////////read id cmd////////////////
if(req.nfc_cmd == 'b101) begin
vif.RWA <= req.RWA;//address
vif.nfc_cmd <= req.nfc_cmd;
vif.nfc_strt <= 1;
vif.BF_sel <= req.BF_sel;
@(posedge vif.CLK);
vif.nfc_strt <= 0;
@(posedge vif.CLK);
wait(vif.nfc_done);
@(posedge vif.CLK);
vif.nfc_cmd <= 'b111;
$display($time," >> %m ====read id function over====");
end
////////////////////////////////////////////////////////
@(posedge vif.CLK);
endtask

endclass
