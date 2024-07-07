class nfmc_monitor extends uvm_monitor;
`uvm_component_utils(nfmc_monitor)

nfmc_trans req;

virtual nfmc_if vif;

bit [7:0] temp_data_send[2048];
bit [10:0] temp;
uvm_queue#(int) q_itrmon;
string name_op;

uvm_analysis_port#(nfmc_trans) ap;

function new(string name="nfmc_driver", uvm_component parent=null);
super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
if(!uvm_config_db#(virtual nfmc_if)::get(this,"","vif",vif))
`uvm_error(get_type_name(),"Failed to get interface handle")
ap = new("ap",this);
endfunction

virtual task run_phase(uvm_phase phase);

req = nfmc_trans::type_id::create("req");
repeat(5) @(posedge vif.CLK);

forever begin
q_itrmon = uvm_queue#(int)::get_global_queue();
wait(vif.nfc_strt)
@(posedge vif.CLK);
req.nfc_cmd = vif.nfc_cmd;
if(req.nfc_cmd == 'b010 || req.nfc_cmd == 'b001)
	req.data_itr = q_itrmon.pop_front();
//storing sending data from interface
if(vif.nfc_cmd == 'b001) begin
wait(!vif.nfc_strt);
for(int i = 0; i<=req.data_itr; i+=1)begin
    @(posedge vif.CLK);
    wait(vif.BF_we)
    #3;
    temp_data_send[vif.BF_ad] = vif.BF_din;
    //$display("%0t - temp_data_send[%0d] = %0d :: %0d",$time,i,temp_data_send[vif.BF_ad],vif.BF_din);
end
end
//if(vif.nfc_cmd == 'b101) begin
//for(int i=0;i<4;i=i+3)begin
//wait(vif.DIO)
//req.DIO[i] = vif.DIO;
//$display("TIME + %0t",$realtime);
//repeat(5)@(posedge vif.CLK);
//end
//end

wait(vif.nfc_done);//in 2nd time forever satisfied and above one not
req.nfc_done = vif.nfc_done;

if(vif.nfc_cmd == 'b010) begin
   //@(posedge vif.CLK);
	    temp = vif.BF_ad;//diff of 1 clk b/wn addr and data
for(int i = 0; i <=req.data_itr; i+=1) begin
    @(posedge vif.CLK);
    //if(!req.BF_we && req.BF_sel) begin
    #3;
    req.temp_data_recv[temp] = vif.BF_dou;
    req.temp_data_send[i] = temp_data_send[i];
    //$display("DATA_ITR :::::::::::::::::::: %0d",req.data_itr);
    //$display("%0t - temp_data_send[%0d] = %0h :::::: temp_data_recv[%0d] = %0h :: %0h",$time,temp,temp_data_send[temp],temp,req.temp_data_recv[temp],vif.BF_dou);
    temp = vif.BF_ad;//diff of 1 clk b/wn addr and data
    //end
end

//q_op = uvm_queue#(string)::get_global_queue();
//name_op = uvm_queue#(string)::get_global(0);

//if(key.try_get(1));
//begin
////if(name_op == "WRITE_READ") 
//req.op = WRITE_READ;
//key.put(1);
//end

end
@(posedge vif.CLK);
req.PErr = vif.PErr; //programming error
req.EErr = vif.EErr; //block erase operation
req.RErr = vif.RErr; //Ecc bytes error
`uvm_info(get_type_name(),$sformatf("\n%0s",req.sprint()),UVM_MEDIUM)
ap.write(req);
end
endtask

endclass
