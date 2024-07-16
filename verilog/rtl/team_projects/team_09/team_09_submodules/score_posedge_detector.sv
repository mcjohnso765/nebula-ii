module score_posedge_detector (
    input logic clk, nRst, goodColl_i, badColl_i,
    output logic goodColl, badColl
);

logic [1:0] N;
logic [1:0] sig_out;
logic [1:0] posEdge;

always_ff @(posedge clk, negedge nRst) begin
    if (~nRst) begin
        N <= 2'b0;
        sig_out <= 2'b0;
    end else begin
        N <= {goodColl_i, badColl_i};
        sig_out <= N;
    end
end
assign posEdge = N & ~sig_out;
assign goodColl = posEdge[1];
assign badColl = posEdge[0];

endmodule
