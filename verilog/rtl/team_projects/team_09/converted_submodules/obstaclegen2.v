module t09_obstaclegen2 (
	body,
	clk,
	nRst,
	goodColl,
	obstacleFlag,
	s_reset,
	randX,
	randY,
	x,
	y,
	curr_length,
	obstacle,
	obstacleCount
);
	reg _sv2v_0;
	parameter MAX_LENGTH = 50;
	input wire [(MAX_LENGTH * 8) - 1:0] body;
	input wire clk;
	input wire nRst;
	input wire goodColl;
	input wire obstacleFlag;
	input wire s_reset;
	input wire [3:0] randX;
	input wire [3:0] randY;
	input wire [3:0] x;
	input wire [3:0] y;
	input wire [7:0] curr_length;
	output reg obstacle;
	output reg [3:0] obstacleCount;
	reg [7:0] cornerNE;
	reg [7:0] cornerNW;
	reg [7:0] cornerSE;
	reg [7:0] cornerSW;
	reg [7:0] randCord;
	reg [7:0] cord;
	reg [7:0] randCordCombo;
	reg [7:0] cordCombo;
	reg [7:0] obsCount8;
	reg [139:0] obstacleArray;
	reg [139:0] nextObstacleArray;
	reg arraySet;
	reg isArraySet;
	reg randError;
	reg [3:0] nextObstacleCount;
	reg [2:0] obsNeeded;
	reg [2:0] isObsNeeded;
	always @(posedge clk or negedge nRst)
		if (nRst == 0) begin
			obstacleCount <= 4'b0000;
			obstacleArray <= 140'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
			obsNeeded <= 3'b000;
			arraySet <= 1'b0;
		end
		else begin
			obstacleCount <= nextObstacleCount;
			obstacleArray <= nextObstacleArray;
			obsNeeded <= isObsNeeded;
			arraySet <= isArraySet;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		isObsNeeded = obsNeeded;
		randCord = {randX, randY};
		cord = {x, y};
		obsCount8 = ({4'b0000, obstacleCount} + 1) * 2;
		randCordCombo = {4'b0000, randX} + (({4'b0000, randY} - 1) * 14);
		cordCombo = {4'b0000, x} + (({4'b0000, y} - 1) * 14);
		randError = 0;
		nextObstacleCount = obstacleCount;
		nextObstacleArray = obstacleArray;
		isArraySet = arraySet;
		cornerNE = 0;
		cornerNW = 0;
		cornerSE = 0;
		cornerSW = 0;
		obstacle = 0;
		if ((obstacleFlag == 1) && ~s_reset) begin
			if (obstacleCount < 15) begin
				if (goodColl == 1) begin
					if (obsNeeded == 0) begin
						isObsNeeded = 1;
						isArraySet = 0;
					end
					else if (obsNeeded == 1)
						isObsNeeded = 2;
					else if (obsNeeded == 2)
						isObsNeeded = 3;
					else if (obsNeeded == 3)
						isObsNeeded = 0;
				end
				if ((obsNeeded == 1) || (arraySet == 0)) begin
					begin : sv2v_autoblock_1
						reg signed [31:0] i;
						for (i = 0; i < MAX_LENGTH; i = i + 1)
							if (randCord == body[i * 8+:8])
								randError = 1;
					end
					if ((((randCord == (body[0+:8] + 1)) || (randCord == (body[0+:8] - 1))) || (randCord == (body[0+:8] + 32))) || (randCord == (body[0+:8] - 32)))
						randError = 1;
					if ((randX == 1) || (randY == 1))
						cornerNW = randCordCombo;
					else
						cornerNW = randCordCombo - 15;
					if ((randX == 14) || (randY == 1))
						cornerNE = randCordCombo;
					else
						cornerNE = randCordCombo - 13;
					if ((randX == 1) || (randY == 10))
						cornerSW = randCordCombo;
					else
						cornerSW = randCordCombo + 13;
					if ((randX == 14) || (randY == 10))
						cornerSE = randCordCombo;
					else
						cornerSE = randCordCombo + 15;
					if ((((obstacleArray[cornerNW] || obstacleArray[cornerNE]) || obstacleArray[cornerSW]) || obstacleArray[cornerSE]) || obstacleArray[randCordCombo])
						randError = 1;
					if (randError == 0) begin
						isArraySet = 1;
						if ((curr_length < 3) || (obsCount8 < (curr_length + 2))) begin
							nextObstacleArray[randCordCombo] = 1;
							nextObstacleCount = obstacleCount + 1;
						end
					end
					else
						isArraySet = 0;
				end
			end
		end
		else begin
			nextObstacleCount = 0;
			nextObstacleArray = 140'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
			isObsNeeded = 0;
			isArraySet = 1;
		end
		if (obstacleArray[cordCombo])
			obstacle = 1;
	end
	initial _sv2v_0 = 0;
endmodule
