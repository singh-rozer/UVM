class nfmc_cov extends uvm_subscriber#(nfmc_trans);
	`uvm_component_utils(nfmc_cov)

	nfmc_trans tx;

	covergroup nfmc_cg_cmd;

		option.per_instance = 1;

		CMD: coverpoint tx.nfc_cmd{
			bins RESET = {'b011};
			bins READ_ID = {'b101};
			bins BLOCK_ER = {'b100};
			bins PAGE_PROG = {'b001};
			bins PAGE_READ = {'b010};
			}
	endgroup
	covergroup nfmc_cg_addr_data with function sample(int index);

		option.per_instance = 1;

		ADDR_WR: coverpoint index{
			bins all_addr[] = {[0:2047]};
			}

		DATA_IN: coverpoint tx.temp_data_send[index]{
			bins all_data_in[] = {[0:255]};
			}
			
		DATA_OUT: coverpoint tx.temp_data_recv[index]{
			bins all_data_out[] = {[0:255]};
			}
		cross ADDR_WR, DATA_IN;
	endgroup

	function new(string name="nfmc_cov", uvm_component parent=null);
		super.new(name,parent);
		nfmc_cg_cmd = new();
		nfmc_cg_addr_data = new();
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	virtual function void write(nfmc_trans tx);
		this.tx = tx;
		if(this.tx != null) begin
			nfmc_cg_cmd.sample();
			for(int i = 0; i <= tx.data_itr; i++) begin
				nfmc_cg_addr_data.sample(i);
			end
		end
	endfunction
endclass

