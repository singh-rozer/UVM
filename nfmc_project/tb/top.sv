
`include "rtl/ACounter.v"
`include "rtl/ErrLoc.v"
`include "rtl/H_gen.v"
`include "rtl/MFSM.v"
`include "rtl/TFSM.v"
`include "rtl/ebr_buffer.v"
`include "rtl/nfcm_top.v"

`include "tb/flash_interface.v"
interface nfmc_if();

//logic [7:0] DIO;
wire [7:0] DIO;
logic CLE;
logic ALE;
logic WE_n;
logic RE_n;
logic CE_n;
logic R_nB;
logic CLK;
logic RES;
logic BF_sel;
logic [10:0] BF_ad;
logic [7:0] BF_din;
logic [7:0] BF_dou;
logic BF_we;
logic [15:0] RWA;
logic PErr;
logic EErr;
logic RErr;
logic [2:0] nfc_cmd;
logic nfc_strt;
logic nfc_done;

endinterface

`include "tb/nfmc_pkg.sv"

module tb;

import uvm_pkg::*;
import nfmc_pkg::*;
`include "uvm_macros.svh"
//`include "tb/nfmc_pkg.sv"
	//typedef enum bit[1:0] {ONLY_READ_OR_WRITE=1,WRITE_READ=2} mode;
//`include "tb/nfmc_trans.sv"
//        `include "tb/nfmc_seq.sv"
//        `include "tb/nfmc_seq_init.sv"
//        `include "tb/nfmc_seq_reset_cmd.sv"
//        `include "tb/nfmc_seq_cmds_exp.sv"
//        `include "tb/nfmc_seqr.sv"
//        `include "tb/nfmc_config.sv"
//        `include "tb/nfmc_driver.sv"
//        `include "tb/nfmc_monitor.sv"
//        `include "tb/nfmc_scoreboard.sv"
//        `include "tb/nfmc_agent.sv"
//        `include "tb/nfmc_env.sv"
//        `include "tb/nfmc_test.sv"



nfmc_if vif();

nfcm_top DUT(vif.DIO, vif.CLE, vif.ALE, vif.WE_n, vif.RE_n, vif.CE_n, vif.R_nB, vif.CLK, vif.RES, vif.BF_sel, vif.BF_ad, vif.BF_din, vif.BF_dou, vif.BF_we, vif.RWA, vif.PErr, vif.EErr, vif.RErr, vif.nfc_cmd, vif.nfc_strt, vif.nfc_done);

flash_interface nand_flash(vif.DIO,vif.CLE,vif.ALE,vif.WE_n,vif.RE_n,vif.CE_n,vif.R_nB,vif.RES);

always #8 vif.CLK = ~vif.CLK;//60 MHZ

initial begin
uvm_config_db#(virtual nfmc_if)::set(null,"*","vif",vif);
run_test("nfmc_test");
end

initial begin
vif.CLK = 0;
$dumpfile("dump.vcd");
$dumpvars();
//#100 $finish();
end


endmodule
