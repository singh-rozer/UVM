/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Important points
//- balancing delay among driver, monitor and test can help in getting proper uvm message from all objects(mon)
//- rst driven from drv before driving seq
//- multiple sequence in same test
//- clk generation in top via interface
//- cfg for active/passive agent
//- tb failed to detect correct prdata :: added 1 pclk delay before start of read and sampling data in mon at negedge
//- hanging in case of plsverr: pready is not coming from dut : bug::for value 32 no condition was defined
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

interface apb_if();
logic presetn;
logic pclk;
logic psel;
logic penable;
logic pwrite;
logic [31:0] paddr;
logic [31:0] pwdata;
logic [31:0] prdata;
logic pready;
logic pslverr;

endinterface

module tb;

import uvm_pkg::*;

`include "uvm_macros.svh"

typedef enum{rst=0,writed=1,readd=2} oper_mode;

`include "apb_trans.sv"
`include "apb_seq.sv"
`include "apb_cfg.sv"
`include "apb_drv.sv"
`include "apb_mon.sv"
`include "apb_sb.sv"
`include "apb_agent.sv"
`include "apb_env.sv"
`include "apb_test.sv"

apb_if vif();

apb_ram DUT(vif.presetn,vif.pclk,vif.psel,vif.penable,vif.pwrite,vif.paddr,vif.pwdata,vif.prdata,vif.pready,vif.pslverr);

always #5 vif.pclk = ~vif.pclk;

initial begin
uvm_config_db#(virtual apb_if)::set(null,"*","vif",vif);
run_test("apb_test");
end

initial begin
vif.pclk = 0;
$dumpfile("dump.vcd");
$dumpvars();
//#100 $finish();
end

endmodule

