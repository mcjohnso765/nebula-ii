`default_nettype none
module t09_posedge_detector (
	clk,
	nRst,
	goodColl_i,
	badColl_i,
	button_i,
	direction_i,
	goodColl,
	badColl,
	button,
	direction
);
	input wire clk;
	input wire nRst;
	input wire goodColl_i;
	input wire badColl_i;
	input wire button_i;
	input wire [3:0] direction_i;
	output wire goodColl;
	output wire badColl;
	output wire button;
	output wire [3:0] direction;
	reg [6:0] N;
	reg [6:0] sig_out;
	wire [6:0] posEdge;
	always @(posedge clk or negedge nRst)
		if (~nRst) begin
			N <= 7'b0000000;
			sig_out <= 7'b0000000;
		end
		else begin
			N <= {goodColl_i, badColl_i, button_i, direction_i};
			sig_out <= N;
		end
	assign posEdge = (N & ~sig_out) | (N & sig_out);
	assign goodColl = (N[6] & ~sig_out[6]) | (N[6] & sig_out[6]);
	assign badColl = (N[5] & ~sig_out[5]) | (N[5] & sig_out[5]);
	assign button = N[4] & ~sig_out[4];
	assign direction = (N[3:0] & ~sig_out[3:0]) | (N[3:0] & sig_out[3:0]);
endmodule
