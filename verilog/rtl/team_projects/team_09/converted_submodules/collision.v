module t09_collision (
	clk,
	nRst,
	snakeHead,
	snakeBody,
	border,
	apple,
	goodColl,
	badColl
);
	reg _sv2v_0;
	input wire clk;
	input wire nRst;
	input wire snakeHead;
	input wire snakeBody;
	input wire border;
	input wire apple;
	output reg goodColl;
	output reg badColl;
	reg nextGoodColl;
	reg nextBadColl;
	always @(posedge clk or negedge nRst)
		if (nRst == 0) begin
			goodColl <= 0;
			badColl <= 0;
		end
		else begin
			goodColl <= nextGoodColl;
			badColl <= nextBadColl;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		if ((snakeHead && snakeBody) || (snakeHead && border)) begin
			nextGoodColl = 0;
			nextBadColl = 1;
		end
		else if (snakeHead && apple) begin
			nextGoodColl = 1;
			nextBadColl = 0;
		end
		else begin
			nextGoodColl = 0;
			nextBadColl = 0;
		end
	end
	initial _sv2v_0 = 0;
endmodule
