class nfmc_scoreboard extends uvm_scoreboard;
`uvm_component_utils(nfmc_scoreboard)

uvm_analysis_imp#(nfmc_trans,nfmc_scoreboard) imp;

bit unmatch;

function new(string name="nfmc_scoreboard", uvm_component parent=null);
super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
imp = new("imp",this);
endfunction

virtual function void write(nfmc_trans pkt);
$display("-------------SCOREBOARD---------------");
if(pkt.nfc_cmd == 'b011)
`uvm_info(get_type_name(),"Rst working properly",UVM_MEDIUM)
else if(pkt.nfc_cmd == 'b101)
`uvm_info(get_type_name(),$sformatf("Read Id working properly"),UVM_MEDIUM)
else if(pkt.nfc_cmd == 'b100)
	if(!pkt.EErr)
		`uvm_info(get_type_name(),$sformatf("Erase cmd working properly"),UVM_MEDIUM)
	else
		`uvm_error(get_type_name(),"Block Erase operation Failed")
else if(pkt.nfc_cmd == 'b001) begin
       if(!pkt.PErr)
	       `uvm_info(get_type_name(),$sformatf("Page programming cmd working properly"),UVM_MEDIUM)
       else
	       `uvm_error(get_type_name(),"Page programming Failed")
       end
//else if(pkt.nfc_cmd == 'b010 /*&& pkt.op == WRITE_READ*/) begin
else if(pkt.nfc_cmd == 'b010) begin
	if(!pkt.RErr)
		`uvm_info(get_type_name(),"Page read cmd working properly",UVM_MEDIUM)
	else
		`uvm_error(get_type_name(),"Detected Error in the ECC byte while reading")
       	
	if(pkt.temp_data_send.size()) begin
		int data_size = pkt.temp_data_send.size();
		for(int i = 0;i<=data_size;i+=1) begin
			if(pkt.temp_data_send[i] != pkt.temp_data_recv[i]) begin
				`uvm_error(get_type_name(),$sformatf("DATA MISMATCH :: SENT DATA = %0d : RECEIVED DATA = %0d",pkt.temp_data_send[i],pkt.temp_data_recv[i]))
				unmatch = 1;
			end
		//else
		//	`uvm_info(get_type_name(),"DATA MATCHED",UVM_MEDIUM)
		//        //$display("SCO:: DATA MATCHED");
		end
	if(!unmatch) begin
		`uvm_info(get_type_name(),"ALL DATA MATCHED",UVM_MEDIUM)
		unmatch = 0;
	end
	end
end

$display("--------------------------------------");

endfunction

endclass
