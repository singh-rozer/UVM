`include "uvm_macros.svh"
import uvm_pkg::*;

typedef enum bit [1:0] {reset_check=0, random_baud_check=1} operating_mode;

class clkgen_txn extends uvm_sequence_item;
 `uvm_object_utils(clkgen_txn)

 operating_mode op;
 rand logic [16:0] baud;
 logic tx_clk;
 real period; //for scoreboard purpose
 
 constraint baud_val {baud inside {4800,9600,14400,19200,38400,57600};}
 function new(string name="clkgen_txn");
  super.new(name);
 endfunction

endclass
//==============================================================================
class rst_clk_seq extends uvm_sequence#(clkgen_txn);
 `uvm_object_utils(rst_clk_seq)
 
 clkgen_txn txn;

 function new(string name="rst_clk_seq");
  super.new(name);
 endfunction

 virtual task body();
  repeat(1) begin
   txn=clkgen_txn::type_id::create("txn");
   start_item(txn);
   assert(txn.randomize());
   txn.op = reset_check;
   finish_item(txn);
  end
 endtask
endclass
//==============================================================================
class baud_clk_seq extends uvm_sequence#(clkgen_txn);
`uvm_object_utils(baud_clk_seq)
 
 clkgen_txn txn;

 function new(string name="baud_clk_seq");
  super.new(name);
 endfunction

 virtual task body();
  repeat(10) begin
   txn=clkgen_txn::type_id::create("txn");
   start_item(txn);
   assert(txn.randomize());
   txn.op = random_baud_check;
   finish_item(txn);
   #50;
  end
 endtask
endclass
//=============================================================================
class clkgen_driver extends uvm_driver#(clkgen_txn);
 `uvm_component_utils(clkgen_driver)
 
 clkgen_txn txn;
 virtual clkgen_if vif;
 
 function new(string name="clkgen_driver",uvm_component parent=null);
  super.new(name,parent);
 endfunction

 virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db#(virtual clkgen_if)::get(this,"","vif",vif))
   `uvm_fatal(get_type_name(),"Failure to get interface handle")
 endfunction

 virtual task run_phase(uvm_phase phase);
  super.run_phase(phase);

  txn = clkgen_txn::type_id::create("txn");

  forever begin
   seq_item_port.get_next_item(txn);
   drv_dut(txn);
   seq_item_port.item_done();
  end 
 endtask
 
 task drv_dut(clkgen_txn txn);
  if(txn.op == reset_check)
   begin
    vif.rst <= 1;
    @(posedge vif.clk);
   end
  else if(txn.op == random_baud_check)
  begin
   vif.rst <= 0;
   vif.baud <= txn.baud;
   @(posedge vif.clk);
   @(posedge vif.tx_clk); //for monitor to perfome calculation of period
   @(posedge vif.tx_clk);
  end
 endtask
endclass
//=========================================================================
class clkgen_monitor extends uvm_monitor;
 `uvm_component_utils(clkgen_monitor)

 uvm_analysis_port#(clkgen_txn) ap;
 clkgen_txn txn;
 virtual clkgen_if vif;
 real ton, toff;//for sampling period
 
 function new(string name="clkgen_monitor",uvm_component parent=null);
  super.new(name,parent);
  ap=new("ap",this);
 endfunction
 
 virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  
  if(!uvm_config_db#(virtual clkgen_if)::get(this,"","vif",vif))
   `uvm_fatal(get_type_name(),"Failure to get interface handle")
 endfunction

 virtual task run_phase(uvm_phase phase);
  txn = clkgen_txn::type_id::create("txn");
  forever begin
   @(posedge vif.clk);
   if(vif.rst)
   begin
    txn.op = reset_check;
    txn.tx_clk = vif.tx_clk;
    ton = 0;
    toff = 0;
    ap.write(txn);
   end
   else
   begin
    txn.baud = vif.baud;
    txn.op = random_baud_check;
    ton = 0;
    toff = 0;
    @(posedge vif.tx_clk);
    ton = $realtime; //sampling current simulation time
    @(posedge vif.tx_clk);
    toff = $realtime;
    txn.period = toff - ton;
    $display("=======ton = %0.3f == toff = %0.3f == period == %0.3f",ton,toff,txn.period);
    ap.write(txn);
   end 
  end
 endtask
endclass
//=========================================================================================
class clkgen_sb extends uvm_scoreboard;
 `uvm_component_utils(clkgen_sb)
 
 uvm_analysis_imp#(clkgen_txn,clkgen_sb) imp;
 clkgen_txn txn;
 int txcount;
 
 function new(string name="clkgen_sb",uvm_component parent=null);
  super.new(name,parent);
 endfunction
 
 virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  imp=new("imp",this);
 endfunction 
 
 virtual function void write(clkgen_txn txn);
  txcount = txn.period/40; //40ns is the time period
  if(txn.op == reset_check && !txn.tx_clk)
   `uvm_info(get_type_name(),"Initialization Done",UVM_MEDIUM)
  else if((txcount-2) inside {10416,5208,3472,2604,1302,868})//2 subtracted for two clocks -as we're sampling in monitor at rising of clock, where count is 0.
   `uvm_info(get_type_name(),$sformatf("Test passed with txcount=%0d",txcount),UVM_MEDIUM)
  else if(txn.op == random_baud_check)
   `uvm_error(get_type_name(),$sformatf("Test Failed with txcount=%0d",txcount))
 endfunction
 
endclass
//=======================================================================
class clkgen_agent extends uvm_agent;
 `uvm_component_utils(clkgen_agent)

 clkgen_driver drv;
 clkgen_monitor mon;
 uvm_sequencer#(clkgen_txn) seqr;
  
 function new(string name="clkgen_agent",uvm_component parent=null);
  super.new(name,parent);
 endfunction
 
 virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  mon = clkgen_monitor::type_id::create("mon",this);
  drv = clkgen_driver::type_id::create("drv",this);
  seqr = uvm_sequencer#(clkgen_txn)::type_id::create("seqr",this);
 endfunction
 
 virtual function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  drv.seq_item_port.connect(seqr.seq_item_export);
 endfunction
endclass
//=====================================================================
class clkgen_env extends uvm_env;
  `uvm_component_utils(clkgen_env)

 clkgen_agent agt;
 clkgen_sb sb;
  
 function new(string name="clkgen_agent",uvm_component parent=null);
  super.new(name,parent);
 endfunction
 
 virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  agt = clkgen_agent::type_id::create("agt",this);
  sb = clkgen_sb::type_id::create("sb",this);
 endfunction
 
 virtual function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  agt.mon.ap.connect(sb.imp);
 endfunction

endclass
//====================================================================
class clkgen_test extends uvm_test;
  `uvm_component_utils(clkgen_test)

 clkgen_env env;
 rst_clk_seq rseq;
 baud_clk_seq bseq; 
  
 function new(string name="clkgen_agent",uvm_component parent=null);
  super.new(name,parent);
 endfunction
 
 virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  env = clkgen_env::type_id::create("env",this);
  rseq = rst_clk_seq::type_id::create("rseq");
  bseq = baud_clk_seq::type_id::create("bseq");
 endfunction
 
 virtual function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  env.agt.mon.ap.connect(env.sb.imp);
 endfunction
 
 virtual task run_phase(uvm_phase phase);
  phase.raise_objection(this);
   rseq.start(env.agt.seqr);
    #50; //Here 50 enough from reset. If delay increased from 50 to 100+ then last sequence drivens value is not changed. As mon and sb has forever so it will show there message again and again.
   bseq.start(env.agt.seqr);
   #100000;
  phase.drop_objection(this);
 endtask
endclass
//====================================================================
interface clkgen_if;
 logic clk;
 logic rst;
 logic [16:0] baud;
 logic tx_clk;
endinterface
//====================================================================
module tb;

 clkgen_if vif();
 clk_gen DUT(vif.clk,vif.rst,vif.baud,vif.tx_clk);

 initial begin
  uvm_config_db#(virtual clkgen_if)::set(null,"*","vif",vif);
  run_test("clkgen_test");
 end
  
 always #20ns vif.clk =~ vif.clk;

 initial begin
  vif.clk = 0;
 end

 initial begin
  $dumpfile("dump.vcd");
  $dumpvars(0,tb);
 end

endmodule

