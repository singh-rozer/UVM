import uvm_pkg::*;

`include "pkg.sv"
import proj_pkg::*;

module top();
    initial begin
        //run_test("risc_test"); 
        //run_test("risc_test_srli_slli"); 
        //run_test("risc_test_sll_srl"); 
        run_test("risc_test_sra_srai"); 
    end
endmodule : top
