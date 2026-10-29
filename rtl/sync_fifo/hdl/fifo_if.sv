interface fifo_if #(
    parameter int WIDTH_DATA = 8,
    parameter int DEPTH_FIFO = 16,
    parameter int WIDTH_ADDR = $clog2(DEPTH_FIFO)
) (
    input clk
);

  logic                  rstn;
  logic                  cmd_push;
  logic                  cmd_pop;
  logic [WIDTH_DATA-1:0] data_push;
  logic [WIDTH_DATA-1:0] data_pop;
  logic                  flag_empty;
  logic                  flag_full;
  logic [WIDTH_ADDR-1:0] addr_write;
  logic [WIDTH_ADDR-1:0] addr_read;
  logic                  enable_write;

  modport tb(
      input rstn,
      output cmd_push,
      output cmd_pop,
      output data_push,
      input data_pop,
      input flag_empty,
      input flag_full
  );
  modport dut(
      input rstn,
      input cmd_push,
      input cmd_pop,
      input data_push,
      output data_pop,
      output flag_empty,
      output flag_full
  );

  clocking cb @(posedge clk);
    default input #1step output #0;
    inout rstn;
    inout cmd_push;
    inout cmd_pop;
    inout data_push;
    input data_pop;
    input flag_empty;
    input flag_full;
  endclocking

endinterface
