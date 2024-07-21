module t09_obstacle_random (
	clk,
	nRst,
	obstacleFlag,
	randX,
	randY,
	randX2,
	randY2
);
	reg _sv2v_0;
	input wire clk;
	input wire nRst;
	input wire obstacleFlag;
	output reg [3:0] randX;
	output reg [3:0] randY;
	output reg [3:0] randX2;
	output reg [3:0] randY2;
	reg [3:0] next_randX;
	reg [3:0] next_randX2;
	reg [3:0] next_randY;
	reg [3:0] next_randY2;
	always @(posedge clk or negedge nRst)
		if (nRst == 0) begin
			randX <= 4'b1000;
			randY <= 4'b0010;
			randX2 <= 4'b0011;
			randY2 <= 4'b0100;
		end
		else begin
			randX <= next_randX;
			randY <= next_randY;
			randX2 <= next_randX2;
			randY2 <= next_randY2;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		next_randY = randY + 1;
		if (next_randY > 10)
			next_randY = 1;
		next_randX2 = randX2;
		next_randY2 = randY2;
		if (obstacleFlag == 1) begin
			next_randX = randX + 1;
			if (next_randX > 14)
				next_randX = 1;
			next_randX2 = randX2 + 1;
			if (next_randX2 > 14)
				next_randX2 = 1;
			next_randY2 = randY2 + 1;
			if (next_randY2 > 10)
				next_randY2 = 1;
		end
		else begin
			next_randX = randX;
			if ((randX >= 14) && (randY == 10))
				next_randX = 1;
			else if (randY == 10)
				next_randX = randX + 1;
		end
	end
	initial _sv2v_0 = 0;
endmodule
