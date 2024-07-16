module t10_clock_divider (
  input logic clk, nRst, clear,
  input logic [29:0] max,
  output logic at_max
);
  logic [29:0] next_count, count;
  
  always_ff @(posedge clk, negedge nRst) begin
    if (~nRst)
      count <= 0;
    else
      count <= next_count;
  end

  always_comb begin  
    at_max = (count == max);
    next_count = count;

    if (clear)
      next_count = 0;

    if (at_max)
      next_count = 0;
    else
      next_count = count + 1;
  end

endmodule
