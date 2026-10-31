module uart_bdgen (
    uart_int_if.bg uif_b
);
  wire rst = uif_b.rst;
  wire clk = uif_b.clk;
  wire enable = (uif_b.cfg_divisor != 0);
  wire [15:0] COUNT_LIMIT = uif_b.cfg_divisor;
  logic baud_tick;
  logic [15:0] c_count, n_count;

  always_ff @(posedge clk or posedge rst) begin
    if (rst) c_count <= 0;
    else begin
      if (COUNT_LIMIT != 0 & COUNT_LIMIT) c_count <= n_count;
    end
  end
  always_comb n_count = (COUNT_LIMIT - 1 == c_count) ? 0 : c_count + 1;

  assign uif_b.baud_tick = (COUNT_LIMIT - 1 == c_count);

endmodule
