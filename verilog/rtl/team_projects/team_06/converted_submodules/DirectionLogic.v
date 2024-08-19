module t06_DirectionLogic (
	clk,
	nrst,
	pause_clk,
	up,
	down,
	left,
	right,
	bad_collision,
	directionOut
);
	reg _sv2v_0;
	input wire clk;
	input wire nrst;
	input wire pause_clk;
	input wire up;
	input wire down;
	input wire left;
	input wire right;
	input wire bad_collision;
	output reg [1:0] directionOut;
	reg [1:0] direction;
	always @(*) begin
		if (_sv2v_0)
			;
		casez ({left, right, down, up})
			4'bzzz1: direction = (directionOut != 2'b01 ? 2'b00 : directionOut);
			4'bz1z0: direction = (directionOut != 2'b10 ? 2'b11 : directionOut);
			4'bz010: direction = (directionOut != 2'b00 ? 2'b01 : directionOut);
			4'b1000: direction = (directionOut != 2'b11 ? 2'b10 : directionOut);
			default: direction = directionOut;
		endcase
	end
	always @(posedge clk or negedge nrst)
		if (~nrst)
			directionOut <= 2'b11;
		else if (bad_collision)
			directionOut <= 2'b11;
		else if (pause_clk)
			directionOut <= direction;
		else
			directionOut <= directionOut;
	initial _sv2v_0 = 0;
endmodule
