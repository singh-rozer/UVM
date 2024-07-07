package nfmc_pkg;
	typedef enum bit[1:0] {NORMAL=0,WRITE_READ=1} mode;
        

	import uvm_pkg::*;

        `include "tb/nfmc_trans.sv"
        `include "tb/seq/nfmc_write_read_seq.sv"
	`include "tb/seq/nfmc_write_or_read_seq.sv"
        `include "tb/seq/nfmc_seq_block_erase.sv"
        `include "tb/seq/nfmc_seq_read_id.sv"
        //`include "tb/nfmc_seq_init.sv"
        `include "tb/seq/nfmc_seq_reset_cmd.sv"
        `include "tb/nfmc_seqr.sv"
        `include "tb/nfmc_config.sv"
        `include "tb/nfmc_driver.sv"
        `include "tb/nfmc_monitor.sv"
        `include "tb/nfmc_scoreboard.sv"
        `include "tb/nfmc_cov.sv"
        `include "tb/nfmc_agent.sv"
        `include "tb/nfmc_env.sv"
        `include "tb/nfmc_test.sv"
endpackage
