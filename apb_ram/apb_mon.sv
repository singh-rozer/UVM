class apb_mon extends uvm_monitor#(apb_trans);
`uvm_component_utils(apb_mon)

apb_trans req;
virtual apb_if vif;
uvm_analysis_port#(apb_trans) ap;

function new(string name="apb_drv", uvm_component parent=null);
super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
if(!uvm_config_db#(virtual apb_if)::get(this,"","vif",vif))
`uvm_error(get_type_name(),"Failed to get apb interface handle")
ap = new("ap",this);
endfunction

virtual task run_phase(uvm_phase phase);
req = apb_trans::type_id::create("req");
forever begin
@(posedge vif.pclk);

if(!vif.presetn)
begin
req.op = rst;
end
else if(vif.presetn && vif.pwrite)begin
@(posedge vif.pready);
req.pslverr = vif.pslverr;
@(negedge vif.pready);
req.op = writed;
req.paddr = vif.paddr;
req.pwdata = vif.pwdata;
req.pwrite = vif.pwrite;
end
else if(vif.presetn && !vif.pwrite)begin
@(posedge vif.pready);
req.pslverr = vif.pslverr;
@(negedge vif.pready);
req.op = readd;
req.paddr = vif.paddr;
req.prdata = vif.prdata;
req.pwrite = vif.pwrite;
end
`uvm_info(get_type_name(),$sformatf("Printing values from \n%0s",req.sprint()),UVM_MEDIUM)
ap.write(req);
end
endtask

endclass



