module score_tracker3(
    input logic clk, nRst, goodColl, badColl,
    output logic [7:0] current_score,
    output logic [7:0] dispScore,
    output logic [3:0] bcd_ones, bcd_tens, bcd_hundreds,
    output logic isGameComplete
);
    logic [7:0] nextCurrScore, nextHighScore, maxScore, deconcatenate;
    logic [7:0] currScore, highScore, nextDispScore;
    logic last_collision, current_collision;
    logic [3:0] carry, next_bcd_ones, next_bcd_tens, next_bcd_hundreds;
    assign maxScore = 8'd140;
   
    always_ff @(posedge clk, negedge nRst) begin
        if (~nRst) begin
            currScore <= 8'b0;
            highScore <= 8'b0;
            dispScore <= 8'b0;
            //isGameComplete <= 1'b0;
            bcd_ones <= 0;
            bcd_tens <= 0;
            bcd_hundreds <= 0;
            last_collision <= 0;
        end else begin
            currScore <= nextCurrScore;
            highScore <= nextHighScore;
            //isGameComplete <= isGameComplete_nxt;
            dispScore <= nextDispScore;
            bcd_ones <= next_bcd_ones;
            bcd_tens <= next_bcd_tens;
            bcd_hundreds <= next_bcd_hundreds;
            last_collision <= current_collision;
        end
    end

    always_comb begin
        nextCurrScore = currScore;
        isGameComplete = 1'b0;
        nextHighScore = highScore;
        next_bcd_ones = bcd_ones;
        next_bcd_tens = bcd_tens;
        next_bcd_hundreds = bcd_hundreds;
        deconcatenate = 0;
        current_collision = last_collision;
        
        if (goodColl && last_collision == 0) begin
            isGameComplete = 1'b0;
            nextCurrScore = currScore + 1;
            current_collision = 1;
            
            if (nextCurrScore > 139) begin
                deconcatenate = nextCurrScore - 140;
                next_bcd_ones = deconcatenate[3:0];
                next_bcd_tens= 4;
                next_bcd_hundreds = 1;
            end
            else if (nextCurrScore > 129) begin
                deconcatenate = nextCurrScore - 130;
                next_bcd_ones = deconcatenate[3:0];
                next_bcd_tens= 3;
                next_bcd_hundreds = 1;
            end
            else if (nextCurrScore > 119) begin
                deconcatenate = nextCurrScore - 120;
                next_bcd_ones = deconcatenate[3:0];
                next_bcd_tens= 2;
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
                next_bcd_tens= 0;
                next_bcd_hundreds = 1;
            end
            else if (nextCurrScore > 89) begin
                deconcatenate = nextCurrScore - 90;
                next_bcd_ones = deconcatenate[3:0];
                next_bcd_tens= 9;
                next_bcd_hundreds = 0;
            end
            else if (nextCurrScore > 79) begin
                deconcatenate = nextCurrScore - 80;
                next_bcd_ones = deconcatenate[3:0];
                next_bcd_tens= 8;
                next_bcd_hundreds = 0;
            end
            else if (nextCurrScore > 69) begin
                deconcatenate = nextCurrScore - 70;
                next_bcd_ones = deconcatenate[3:0];
                next_bcd_tens= 7;
                next_bcd_hundreds = 0;
            end
            else if (nextCurrScore > 59) begin
                deconcatenate = nextCurrScore - 60;
                next_bcd_ones = deconcatenate[3:0];
                next_bcd_tens= 6;
                next_bcd_hundreds = 0;
            end
            else if (nextCurrScore > 49) begin
                deconcatenate = nextCurrScore - 50;
                next_bcd_ones = deconcatenate[3:0];
                next_bcd_tens= 5;
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
                next_bcd_tens= 3;
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
            end else begin
                deconcatenate = nextCurrScore;
                next_bcd_ones = deconcatenate[3:0];
                next_bcd_tens = 0;
                next_bcd_hundreds = 0;
            end
            if (nextCurrScore > nextHighScore) begin
                nextHighScore = nextCurrScore;
            end
        end
        if (badColl || currScore >= maxScore) begin
            nextCurrScore = 0;
            isGameComplete = 1'b1;

            if (nextHighScore > 139) begin
                deconcatenate = nextHighScore - 140;
                next_bcd_ones = deconcatenate[3:0];
                next_bcd_tens= 4;
                next_bcd_hundreds = 1;
            end
            else if (nextHighScore > 129) begin
                deconcatenate = nextHighScore - 130;
                next_bcd_ones = deconcatenate[3:0];
                next_bcd_tens= 3;
                next_bcd_hundreds = 1;
            end
            else if (nextHighScore > 119) begin
                deconcatenate = nextHighScore - 120;
                next_bcd_ones = deconcatenate[3:0];
                next_bcd_tens= 2;
                next_bcd_hundreds = 1;
            end
            else if (nextHighScore > 109) begin
                deconcatenate = nextHighScore - 110;
                next_bcd_ones = deconcatenate[3:0];
                next_bcd_tens= 1;
                next_bcd_hundreds = 1;
            end
            else if (nextHighScore > 99) begin
                deconcatenate = nextHighScore - 100;
                next_bcd_ones = deconcatenate[3:0];
                next_bcd_tens= 0;
                next_bcd_hundreds = 1;
            end
            else if (nextHighScore > 89) begin
                deconcatenate = nextHighScore - 90;
                next_bcd_ones = deconcatenate[3:0];
                next_bcd_tens= 9;
                next_bcd_hundreds = 0;
            end
            else if (nextHighScore > 79) begin
                deconcatenate = nextHighScore - 80;
                next_bcd_ones = deconcatenate[3:0];
                next_bcd_tens= 8;
                next_bcd_hundreds = 0;
            end
            else if (nextHighScore > 69) begin
                deconcatenate = nextHighScore - 70;
                next_bcd_ones = deconcatenate[3:0];
                next_bcd_tens= 7;
                next_bcd_hundreds = 0;
            end
            else if (nextHighScore > 59) begin
                deconcatenate = nextHighScore - 60;
                next_bcd_ones = deconcatenate[3:0];
                next_bcd_tens= 6;
                next_bcd_hundreds = 0;
            end
            else if (nextHighScore > 49) begin
                deconcatenate = nextHighScore - 50;
                next_bcd_ones = deconcatenate[3:0];
                next_bcd_tens= 5;
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
                next_bcd_tens= 3;
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
            end else begin
                deconcatenate = nextHighScore;
                next_bcd_ones = deconcatenate[3:0];
                next_bcd_tens = 0;
                next_bcd_hundreds = 0;
            end
        end
        if(goodColl == 0 || last_collision == 1) begin
            current_collision = 0;
        end
        if (!isGameComplete) begin
                nextDispScore = nextCurrScore;
            end else begin
                nextDispScore = nextHighScore;
            if (nextCurrScore > nextHighScore) begin
                nextHighScore = nextCurrScore;
            end
        end
    end

    assign current_score = currScore;
endmodule
