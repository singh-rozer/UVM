class apb_drv extends uvm_driver#(apb_trans);
`uvm_component_utils(apb_drv)

apb_trans req;

virtual apb_if vif;

function new(string name="apb_drv", uvm_component parent=null);
super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
if(!uvm_config_db#(virtual apb_if)::get(this,"","vif",vif))
`uvm_error(get_type_name(),"Failed to get apb interface handle")
endfunction

virtual task run_phase(uvm_phase phase);
req = apb_trans::type_id::create("req");
reset_dut();
forever begin
seq_item_port.get_next_item(req);
//`uvm_info(get_type_name(),$sformatf("Printing values from \n%0s",req.sprint()),UVM_MEDIUM)
send(req);
`uvm_info(get_type_name(),$sformatf("Printing values from \n%0s",req.sprint()),UVM_MEDIUM)
seq_item_port.item_done();
//repeat(2) @(posedge vif.pclk);
end
endtask

task reset_dut();
vif.presetn <= 0;
repeat(5)
@(posedge vif.pclk);
vif.presetn <= 1;
@(posedge vif.pclk);
endtask

task send(apb_trans req);
if(req.op == rst)begin
vif.presetn <= 0;
@(posedge vif.pclk);
vif.presetn <= 1;
end
else if(req.op == writed)begin
vif.psel <= 1;
vif.paddr <= req.paddr;
vif.pwdata <= req.pwdata;
vif.pwrite <= 1;//req.pwrite;
@(posedge vif.pclk);
vif.penable <= 1;
//@(posedge vif.pready);//doubt
@(negedge vif.pready);//doubt::sb behaving proper
vif.penable <= 0;
//req.pslverr = vif.pslverr;
end
else if(req.op == readd)begin
@(posedge vif.pclk);
vif.psel <= 1;
vif.paddr <= req.paddr;
vif.pwrite <= 0;
@(posedge vif.pclk);
vif.penable <= 1;
//@(posedge vif.pready);
@(negedge vif.pready);//doubt
vif.penable <= 0;
//req.pslverr = vif.pslverr;
//req.prdata = vif.prdata;
end
endtask

endclass


