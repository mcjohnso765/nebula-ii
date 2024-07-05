module dac_counter 
#(
    parameter N = 8
)
(
    input logic clk, nRst, at_max,
    output logic [N - 1:0] dacCount
);

logic [N - 1:0] dacCount_nxt;
always_ff @(posedge clk, negedge nRst) begin
    if (~nRst) begin
        dacCount <= 0;
    end else begin
        dacCount <= dacCount_nxt;
    end
end

always_comb begin
    if (at_max)
        dacCount_nxt = dacCount + 1;
    else
        dacCount_nxt = dacCount;
end

endmodule
