module collision (
  input logic clk, nRst, snakeHead, snakeBody, border, apple,
  output logic goodColl, badColl
);

logic nextGoodColl, nextBadColl;

always_ff @(posedge clk, negedge nRst) begin
	if(nRst == 0) begin
		goodColl <= 0;
		badColl <= 0;
	end else begin
		goodColl <= nextGoodColl;
		badColl <= nextBadColl;
	end
end

always_comb begin
    if(snakeHead && snakeBody || snakeHead && border) begin
        nextGoodColl = 0;
        nextBadColl = 1;
    end else if(snakeHead && apple) begin
        nextGoodColl = 1;
        nextBadColl = 0;
    end else begin
        nextGoodColl = 0;
        nextBadColl = 0;
    end
end
endmodule
