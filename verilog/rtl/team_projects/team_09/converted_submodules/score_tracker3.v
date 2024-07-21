module t09_score_tracker3 (
	clk,
	nRst,
	goodColl,
	badColl,
	current_score,
	dispScore,
	bcd_ones,
	bcd_tens,
	bcd_hundreds,
	isGameComplete
);
	reg _sv2v_0;
	input wire clk;
	input wire nRst;
	input wire goodColl;
	input wire badColl;
	output wire [7:0] current_score;
	output reg [7:0] dispScore;
	output reg [3:0] bcd_ones;
	output reg [3:0] bcd_tens;
	output reg [3:0] bcd_hundreds;
	output reg isGameComplete;
	reg [7:0] nextCurrScore;
	reg [7:0] nextHighScore;
	wire [7:0] maxScore;
	reg [7:0] deconcatenate;
	reg [7:0] currScore;
	reg [7:0] highScore;
	reg [7:0] nextDispScore;
	reg last_collision;
	reg current_collision;
	wire [3:0] carry;
	reg [3:0] next_bcd_ones;
	reg [3:0] next_bcd_tens;
	reg [3:0] next_bcd_hundreds;
	assign maxScore = 8'd140;
	always @(posedge clk or negedge nRst)
		if (~nRst) begin
			currScore <= 8'b00000000;
			highScore <= 8'b00000000;
			dispScore <= 8'b00000000;
			bcd_ones <= 0;
			bcd_tens <= 0;
			bcd_hundreds <= 0;
			last_collision <= 0;
		end
		else begin
			currScore <= nextCurrScore;
			highScore <= nextHighScore;
			dispScore <= nextDispScore;
			bcd_ones <= next_bcd_ones;
			bcd_tens <= next_bcd_tens;
			bcd_hundreds <= next_bcd_hundreds;
			last_collision <= current_collision;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		nextCurrScore = currScore;
		isGameComplete = 1'b0;
		nextHighScore = highScore;
		next_bcd_ones = bcd_ones;
		next_bcd_tens = bcd_tens;
		next_bcd_hundreds = bcd_hundreds;
		deconcatenate = 0;
		current_collision = last_collision;
		if (goodColl && (last_collision == 0)) begin
			isGameComplete = 1'b0;
			nextCurrScore = currScore + 1;
			current_collision = 1;
			if (nextCurrScore > 139) begin
				deconcatenate = nextCurrScore - 140;
				next_bcd_ones = deconcatenate[3:0];
				next_bcd_tens = 4;
				next_bcd_hundreds = 1;
			end
			else if (nextCurrScore > 129) begin
				deconcatenate = nextCurrScore - 130;
				next_bcd_ones = deconcatenate[3:0];
				next_bcd_tens = 3;
				next_bcd_hundreds = 1;
			end
			else if (nextCurrScore > 119) begin
				deconcatenate = nextCurrScore - 120;
				next_bcd_ones = deconcatenate[3:0];
				next_bcd_tens = 2;
				next_bcd_hundreds = 1;
			end
			else if (nextCurrScore > 109) begin
				deconcatenate = nextCurrScore - 110;
				next_bcd_ones = deconcatenate[3:0];
				next_bcd_tens = 1;
				next_bcd_hundreds = 1;
			end
			else if (nextCurrScore > 99) begin
				deconcatenate = nextCurrScore - 100;
				next_bcd_ones = deconcatenate[3:0];
				next_bcd_tens = 0;
				next_bcd_hundreds = 1;
			end
			else if (nextCurrScore > 89) begin
				deconcatenate = nextCurrScore - 90;
				next_bcd_ones = deconcatenate[3:0];
				next_bcd_tens = 9;
				next_bcd_hundreds = 0;
			end
			else if (nextCurrScore > 79) begin
				deconcatenate = nextCurrScore - 80;
				next_bcd_ones = deconcatenate[3:0];
				next_bcd_tens = 8;
				next_bcd_hundreds = 0;
			end
			else if (nextCurrScore > 69) begin
				deconcatenate = nextCurrScore - 70;
				next_bcd_ones = deconcatenate[3:0];
				next_bcd_tens = 7;
				next_bcd_hundreds = 0;
			end
			else if (nextCurrScore > 59) begin
				deconcatenate = nextCurrScore - 60;
				next_bcd_ones = deconcatenate[3:0];
				next_bcd_tens = 6;
				next_bcd_hundreds = 0;
			end
			else if (nextCurrScore > 49) begin
				deconcatenate = nextCurrScore - 50;
				next_bcd_ones = deconcatenate[3:0];
				next_bcd_tens = 5;
				next_bcd_hundreds = 0;
			end
			else if (nextCurrScore > 39) begin
				deconcatenate = nextCurrScore - 40;
				next_bcd_ones = deconcatenate[3:0];
				next_bcd_tens = 4;
				next_bcd_hundreds = 0;
			end
			else if (nextCurrScore > 29) begin
				deconcatenate = nextCurrScore - 30;
				next_bcd_ones = deconcatenate[3:0];
				next_bcd_tens = 3;
				next_bcd_hundreds = 0;
			end
			else if (nextCurrScore > 19) begin
				deconcatenate = nextCurrScore - 20;
				next_bcd_ones = deconcatenate[3:0];
				next_bcd_tens = 2;
				next_bcd_hundreds = 0;
			end
			else if (nextCurrScore > 9) begin
				deconcatenate = nextCurrScore - 10;
				next_bcd_ones = deconcatenate[3:0];
				next_bcd_tens = 1;
				next_bcd_hundreds = 0;
			end
			else begin
				deconcatenate = nextCurrScore;
				next_bcd_ones = deconcatenate[3:0];
				next_bcd_tens = 0;
				next_bcd_hundreds = 0;
			end
			if (nextCurrScore > nextHighScore)
				nextHighScore = nextCurrScore;
		end
		if (badColl || (currScore >= maxScore)) begin
			nextCurrScore = 0;
			isGameComplete = 1'b1;
			if (nextHighScore > 139) begin
				deconcatenate = nextHighScore - 140;
				next_bcd_ones = deconcatenate[3:0];
				next_bcd_tens = 4;
				next_bcd_hundreds = 1;
			end
			else if (nextHighScore > 129) begin
				deconcatenate = nextHighScore - 130;
				next_bcd_ones = deconcatenate[3:0];
				next_bcd_tens = 3;
				next_bcd_hundreds = 1;
			end
			else if (nextHighScore > 119) begin
				deconcatenate = nextHighScore - 120;
				next_bcd_ones = deconcatenate[3:0];
				next_bcd_tens = 2;
				next_bcd_hundreds = 1;
			end
			else if (nextHighScore > 109) begin
				deconcatenate = nextHighScore - 110;
				next_bcd_ones = deconcatenate[3:0];
				next_bcd_tens = 1;
				next_bcd_hundreds = 1;
			end
			else if (nextHighScore > 99) begin
				deconcatenate = nextHighScore - 100;
				next_bcd_ones = deconcatenate[3:0];
				next_bcd_tens = 0;
				next_bcd_hundreds = 1;
			end
			else if (nextHighScore > 89) begin
				deconcatenate = nextHighScore - 90;
				next_bcd_ones = deconcatenate[3:0];
				next_bcd_tens = 9;
				next_bcd_hundreds = 0;
			end
			else if (nextHighScore > 79) begin
				deconcatenate = nextHighScore - 80;
				next_bcd_ones = deconcatenate[3:0];
				next_bcd_tens = 8;
				next_bcd_hundreds = 0;
			end
			else if (nextHighScore > 69) begin
				deconcatenate = nextHighScore - 70;
				next_bcd_ones = deconcatenate[3:0];
				next_bcd_tens = 7;
				next_bcd_hundreds = 0;
			end
			else if (nextHighScore > 59) begin
				deconcatenate = nextHighScore - 60;
				next_bcd_ones = deconcatenate[3:0];
				next_bcd_tens = 6;
				next_bcd_hundreds = 0;
			end
			else if (nextHighScore > 49) begin
				deconcatenate = nextHighScore - 50;
				next_bcd_ones = deconcatenate[3:0];
				next_bcd_tens = 5;
				next_bcd_hundreds = 0;
			end
			else if (nextHighScore > 39) begin
				deconcatenate = nextHighScore - 40;
				next_bcd_ones = deconcatenate[3:0];
				next_bcd_tens = 4;
				next_bcd_hundreds = 0;
			end
			else if (nextHighScore > 29) begin
				deconcatenate = nextHighScore - 30;
				next_bcd_ones = deconcatenate[3:0];
				next_bcd_tens = 3;
				next_bcd_hundreds = 0;
			end
			else if (nextHighScore > 19) begin
				deconcatenate = nextHighScore - 20;
				next_bcd_ones = deconcatenate[3:0];
				next_bcd_tens = 2;
				next_bcd_hundreds = 0;
			end
			else if (nextHighScore > 9) begin
				deconcatenate = nextHighScore - 10;
				next_bcd_ones = deconcatenate[3:0];
				next_bcd_tens = 1;
				next_bcd_hundreds = 0;
			end
			else begin
				deconcatenate = nextHighScore;
				next_bcd_ones = deconcatenate[3:0];
				next_bcd_tens = 0;
				next_bcd_hundreds = 0;
			end
		end
		if ((goodColl == 0) || (last_collision == 1))
			current_collision = 0;
		if (!isGameComplete)
			nextDispScore = nextCurrScore;
		else begin
			nextDispScore = nextHighScore;
			if (nextCurrScore > nextHighScore)
				nextHighScore = nextCurrScore;
		end
	end
	assign current_score = currScore;
	initial _sv2v_0 = 0;
endmodule
