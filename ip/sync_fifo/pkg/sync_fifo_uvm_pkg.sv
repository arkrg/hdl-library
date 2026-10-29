package sync_fifo_uvm_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // 1. 데이터(Item) 정의
  `include "src/agent/fifo_item.sv"

  // 2. Base Sequences
  `include "src/seq/fifo_sequence_reset.sv"
  `include "src/seq/fifo_sequence_read.sv"
  `include "src/seq/fifo_sequence_write.sv"
  `include "src/seq/fifo_sequence_readXwrite.sv"

  // 3. Driver, Monitor, Coverage, Agent
  `include "src/agent/fifo_coverage.sv"
  `include "src/agent/fifo_driver.sv"
  `include "src/agent/fifo_monitor.sv"
  `include "src/agent/fifo_agent.sv"

  // 4. Virtual Sequencer & Virtual Sequences
  `include "src/seq/virtual_sequencer.sv"
  `include "src/seq/vseq_full_empty.sv"
  `include "src/seq/vseq_overflow.sv"
  `include "src/seq/vseq_underflow.sv"
  `include "src/seq/vseq_simultaneous_rw.sv"

  // 5. Scoreboard & Predictor/Checker
  `include "src/scoreboard/fifo_predictor.sv"
  `include "src/scoreboard/fifo_checker.sv"
  `include "src/scoreboard/fifo_scoreboard.sv"

  // 6. Env
  `include "src/env/fifo_env.sv"

  // 7. Tests
  `include "tests/fifo_base_test.sv"
  `include "tests/fifo_full_empty_test.sv"
  `include "tests/fifo_overflow_test.sv"
  `include "tests/fifo_underflow_test.sv"
  `include "tests/fifo_simultaneous_rw_test.sv"

endpackage
