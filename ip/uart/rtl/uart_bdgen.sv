module uart_bdgen (
    uart_int_if.bg uif_b
);
  wire rst = uif_b.rst;
  wire clk = uif_b.clk;
  logic [15:0] COUNT_LIMIT;
  logic [15:0] c_count, n_count;
  logic baud_tick;

  assign COUNT_LIMIT = uif_b.cfg_divisor;
  assign uif_b.baud_tick = baud_tick;
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      c_count <= 0;
    end else begin
      if (COUNT_LIMIT != 0 & COUNT_LIMIT != 1) c_count <= n_count;
    end
  end
  always_comb begin
    n_count = c_count;
    if (c_count == COUNT_LIMIT - 1) begin
      n_count = 0;
    end else begin
      n_count = c_count + 1;
    end
  end

  always_comb begin
    if (COUNT_LIMIT == 0) baud_tick = 0;
    else if (COUNT_LIMIT == 1) baud_tick = clk;
    else baud_tick = (c_count == COUNT_LIMIT - 1);
  end
endmodule
