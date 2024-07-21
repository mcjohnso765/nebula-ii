module sound_posedge_detector (
    input logic clk, nRst, goodColl_i, badColl_i, button_i,
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
assign posEdge = N & ~sig_out | (N & sig_out);

assign goodColl = N[1] & ~sig_out[1] | (N[1] & sig_out[1]);
assign badColl = N[0] & ~sig_out[0] | (N[0] & sig_out[0]);

endmodule
