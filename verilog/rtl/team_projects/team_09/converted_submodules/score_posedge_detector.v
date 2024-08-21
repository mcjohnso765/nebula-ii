module t09_score_posedge_detector (
	clk,
	nRst,
	goodColl_i,
	badColl_i,
	goodColl,
	badColl
);
	input wire clk;
	input wire nRst;
	input wire goodColl_i;
	input wire badColl_i;
	output wire goodColl;
	output wire badColl;
	reg [1:0] N;
	reg [1:0] sig_out;
	wire [1:0] posEdge;
	always @(posedge clk or negedge nRst)
		if (~nRst) begin
			N <= 2'b00;
			sig_out <= 2'b00;
		end
		else begin
			N <= {goodColl_i, badColl_i};
			sig_out <= N;
		end
	assign posEdge = N & ~sig_out;
	assign goodColl = posEdge[1];
	assign badColl = posEdge[0];
endmodule
