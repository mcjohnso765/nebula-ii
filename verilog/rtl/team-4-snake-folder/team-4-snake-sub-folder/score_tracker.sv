module score_tracker(
    input logic clk, nRst, goodColl, badColl,
    output logic [6:0] dispScore,
    output logic [3:0] bcd_ones, bcd_tens,
    output logic isGameComplete
);
    logic [6:0] nextCurrScore, nextHighScore, maxScore, deconcatenate;
    logic [6:0] currScore, highScore, nextDispScore;
    logic isGameComplete_nxt;
    logic [3:0] carry, next_bcd_ones, next_bcd_tens;
    assign maxScore = 7'd50;
   
    always_ff @(posedge clk, negedge nRst) begin
        if (~nRst) begin
            currScore <= 7'b0;
            highScore <= 7'b0;
            dispScore <= 7'b0;
            isGameComplete <= 1'b0;
            bcd_ones <= 0;
            bcd_tens <= 0;
        end else begin
            currScore <= nextCurrScore;
            highScore <= nextHighScore;
            isGameComplete <= isGameComplete_nxt;
            dispScore <= nextDispScore;
            bcd_ones <= next_bcd_ones;
            bcd_tens <= next_bcd_tens;
        end
    end

    always_comb begin
        nextCurrScore = currScore;
        isGameComplete_nxt = isGameComplete;
        nextHighScore = highScore;
        next_bcd_ones = bcd_ones;
        next_bcd_tens = bcd_tens;
        deconcatenate = 0;
        if (goodColl) begin
            isGameComplete_nxt = 1'b0;
            nextCurrScore = currScore + 1;
            
            if (nextCurrScore > 49) begin
                deconcatenate = nextCurrScore - 50;
                next_bcd_ones = deconcatenate[3:0];
                next_bcd_tens= 5;
            end
            else if (nextCurrScore > 39) begin
                deconcatenate = nextCurrScore - 40;
                next_bcd_ones = deconcatenate[3:0];
                next_bcd_tens = 4;
            end
            else if (nextCurrScore > 29) begin
                deconcatenate = nextCurrScore - 30;
                next_bcd_ones = deconcatenate[3:0];
                next_bcd_tens= 3;
            end
            else if (nextCurrScore > 19) begin
                deconcatenate = nextCurrScore - 20;
                next_bcd_ones = deconcatenate[3:0];
                next_bcd_tens = 2;
            end
            else if (nextCurrScore > 9) begin
                deconcatenate = nextCurrScore - 10;
                next_bcd_ones = deconcatenate[3:0];
                next_bcd_tens = 1;
            end else begin
                deconcatenate = nextCurrScore;
                next_bcd_ones = deconcatenate[3:0];
                next_bcd_tens = 0;
            end
            if (nextCurrScore > nextHighScore) begin
                nextHighScore = nextCurrScore;
            end
        end
        if (badColl || currScore >= maxScore) begin
            nextCurrScore = 0;
            isGameComplete_nxt = 1'b1;

            if (nextHighScore > 49) begin
                deconcatenate = nextHighScore - 50;
                next_bcd_ones = deconcatenate[3:0];
                next_bcd_tens= 5;
            end
            else if (nextHighScore > 39) begin
                deconcatenate = nextHighScore - 40;
                next_bcd_ones = deconcatenate[3:0];
                next_bcd_tens = 4;
            end
            else if (nextHighScore > 29) begin
                deconcatenate = nextHighScore - 30;
                next_bcd_ones = deconcatenate[3:0];
                next_bcd_tens= 3;
            end
            else if (nextHighScore > 19) begin
                deconcatenate = nextHighScore - 20;
                next_bcd_ones = deconcatenate[3:0];
                next_bcd_tens = 2;
            end
            else if (nextHighScore > 9) begin
                deconcatenate = nextHighScore - 10;
                next_bcd_ones = deconcatenate[3:0];
                next_bcd_tens = 1;
            end else begin
                deconcatenate = nextHighScore;
                next_bcd_ones = deconcatenate[3:0];
                next_bcd_tens = 0;
            end
        end
        if (!isGameComplete_nxt) begin
                nextDispScore = nextCurrScore;
            end else begin
                nextDispScore = nextHighScore;
            if (nextCurrScore > nextHighScore) begin
                nextHighScore = nextCurrScore;
            end
        end
    end
endmodule
