module t09_applegenerator2 (
	x,
	y,
	randX,
	randY,
	goodColl,
	clk,
	reset,
	s_reset,
	body,
	apple
);
	reg _sv2v_0;
	parameter MAX_LENGTH = 50;
	input wire [3:0] x;
	input wire [3:0] y;
	input wire [3:0] randX;
	input wire [3:0] randY;
	input wire goodColl;
	input wire clk;
	input wire reset;
	input wire s_reset;
	input wire [(MAX_LENGTH * 8) - 1:0] body;
	output reg apple;
	reg [7:0] apple_cord;
	reg [7:0] next_apple_cord;
	reg [7:0] randCord;
	reg appleSet;
	reg next_apple_set;
	reg randError;
	always @(*) begin
		if (_sv2v_0)
			;
		next_apple_set = appleSet;
		next_apple_cord = apple_cord;
		randError = 0;
		randCord = {randX, randY};
		if ((goodColl == 1) || (appleSet == 0)) begin
			begin : sv2v_autoblock_1
				reg signed [31:0] i;
				for (i = 0; i < MAX_LENGTH; i = i + 1)
					if (randCord == body[i * 8+:8])
						randError = 1;
			end
			if (randError == 0) begin
				next_apple_set = 1;
				next_apple_cord = {randX, randY};
			end
			else
				next_apple_set = 0;
		end
		if (apple_cord == {x, y})
			apple = 1;
		else
			apple = 0;
		if (s_reset)
			next_apple_cord = 8'b11000101;
	end
	always @(posedge clk or negedge reset)
		if (~reset) begin
			apple_cord <= 8'b11000101;
			appleSet <= 1;
		end
		else begin
			apple_cord <= next_apple_cord;
			appleSet <= next_apple_set;
		end
	initial _sv2v_0 = 0;
endmodule
