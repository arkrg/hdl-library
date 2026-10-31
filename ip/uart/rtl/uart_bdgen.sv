module uart_bdgen (
    uart_int_if.bg uif_b
);
  wire rst = uif_b.rst;
  wire clk = uif_b.clk;
  wire enable = (uif_b.cfg_divisor != 0);
  wire [15:0] COUNT_LIMIT = uif_b.cfg_divisor;
  logic [15:0] c_count, n_count;

  always_ff @(posedge clk or posedge rst) begin
    if (rst) c_count <= 0;
    else begin
      if (enable) c_count <= n_count;
    end
  end
  always_comb n_count = (enable) & (COUNT_LIMIT - 1 == c_count) ? 0 : c_count + 1;

  assign uif_b.baud_tick = (enable) & (COUNT_LIMIT - 1 == c_count);

endmodule
