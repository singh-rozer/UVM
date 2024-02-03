package proj_pkg;
    import uvm_pkg::*;
    `include "risc_seq_item.sv"
    
    `include "risc_sequence.sv"
    `include "risc_sequence_srli_slli.sv"
    `include "risc_sequence_sll_srl.sv"
    `include "risc_sequence_sra_srai.sv"

    `include "risc_sequencer.sv"
    `include "risc_driver.sv"
    `include "risc_scoreboard_1.sv"
    `include "risc_scoreboard_2.sv"
    `include "risc_agent.sv"
    `include "risc_env.sv"
    
    `include "risc_test.sv"
    `include "risc_test_srli_slli.sv"
    `include "risc_test_sll_srl.sv"
    `include "risc_test_sra_srai.sv"
endpackage
