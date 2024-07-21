module t09_sound_posedge_detector (
	clk,
	nRst,
	goodColl_i,
	badColl_i,
	button_i,
	goodColl,
	badColl
);
	input wire clk;
	input wire nRst;
	input wire goodColl_i;
	input wire badColl_i;
	input wire button_i;
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
	assign posEdge = (N & ~sig_out) | (N & sig_out);
	assign goodColl = (N[1] & ~sig_out[1]) | (N[1] & sig_out[1]);
	assign badColl = (N[0] & ~sig_out[0]) | (N[0] & sig_out[0]);
endmodule
