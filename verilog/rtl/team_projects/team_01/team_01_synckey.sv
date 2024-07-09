module synckey (
  input logic in,
  input logic clk, nRst,
  output logic strobe
);

  logic data[1:0];
  always_ff @(posedge clk, negedge nRst) begin
    if(~nRst)
      strobe <= 1'b0;
    else begin
      strobe <= data[1];
      data[1] <= data[0];
      data[0] <= in;
    end
  end
endmodule