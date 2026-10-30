// Testbench for uart_bdgen
// problem: below assertion doesn't work here, 
// action item: check this at EDA playground or reserch alt statement
// ------------------------------------------------------------------
// WARNING: [XSIM 43-4477] Line 46 : Delay Control inside Assertion action block is not supported
// WARNING: [XSIM 43-4127] Line 43 : The "System Verilog Assertion" is not supported yet for simulation. The statement will be iupport 
// property p_stable_zero_divisor;
//   @(posedge clk iff (!rst) & (divisor == 0)) $stable(
//       dut.c_count
//   );
// endproperty
// assert_zero_divisor :
// assert property (p_stable_zero_divisor)
// else begin
//   $error(" ===== internal counter changed. =====");
//   #10;
//   $finish;
// end
// ------------------------------------------------------------------
class divisor_item;
  rand shortint divisor;
  rand int baudrate;

  constraint solve_c {solve baudrate before divisor;}
endclass

module tb_uart_bdgen;
  import uart_pkg::*;
  parameter int SYS_FREQ = 100_000_000;
  parameter int MIN_BDR = 9600;
  shortint divisor;
  logic rst, clk;

  initial clk = 0;
  always #5 clk <= ~clk;

  uart_int_if uif (
      .clk,
      .rst
  );
  uart_bdgen dut (.uif_b(uif.bg));
  assign uif.cfg_divisor = divisor;

  initial begin
    reset();
    $display("===== Start! =====");
    repeat (4) begin
      sel_divisor(SYS_FREQ);
      meas_bdrate(SYS_FREQ, MIN_BDR);
      reset();
    end
    $display("===== All Tests finish! =====");
    $finish;
  end


  task automatic reset();
    begin
      rst <= 1;
      divisor <= 0;
      repeat (2) @(posedge clk);
      rst <= 0;
    end
  endtask
  task automatic sel_divisor(int SYS_FREQ);
    divisor_item item;
    begin
      item = new();
      if (!item.randomize() with {
            baudrate inside {9600, 12500};
            divisor inside {[0 : 3], SYS_FREQ / baudrate};
          })
        $error("Randomization Failed.");
      divisor = item.divisor;
      $display("--- Testing divisor = %d ---", item.divisor);
    end
  endtask
  task automatic meas_bdrate(int SYS_FREQ, int MIN_BDR);
    shortint meas = 0;
    wait (rst == 0);
    if (divisor < 2) begin
      repeat (SYS_FREQ / MIN_BDR) @(posedge clk);
    end else begin
      fork
        begin
          @(posedge uif.baud_tick);
          fork
            @(posedge uif.baud_tick);
            forever @(posedge clk) meas++;
          join_any
          if (meas == divisor) begin
            $display("[PASS] Measured: %0d , Expected: %0d.", meas, divisor);
          end else begin
            $error("[FAIL] Measured: %0d , Expected: %0d.", meas, divisor);
          end
        end
        begin
          repeat (divisor * 3) @(posedge clk);
          $display("Error: Tick signal not generated.");
        end
      join_any
      disable fork;
    end
  endtask
  initial begin
    $dumpfile("waves.vcd");
    $dumpvars(0);
  end
endmodule
