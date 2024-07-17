module t09_obstacle_sync_edge (
	clk,
	nRst_i,
	button_i,
	pb_o
);
	reg _sv2v_0;
	input wire clk;
	input wire nRst_i;
	input wire button_i;
	output reg pb_o;
	reg sync;
	reg pb_1;
	reg pb_2;
	always @(posedge clk or negedge nRst_i)
		if (!nRst_i) begin
			sync <= 0;
			pb_1 <= 0;
			pb_2 <= 0;
		end
		else begin
			sync <= button_i;
			pb_1 <= sync;
			pb_2 <= pb_1;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		if (pb_1 && !pb_2)
			pb_o = 1;
		else
			pb_o = 0;
	end
	initial _sv2v_0 = 0;
endmodule
