// integrates the score tracker module, ssdec, and display toggling
`default_nettype none
module score_display (
    // I/O ports
    input logic clk, rst,
    input logic goodCollButton, badCollButton,
    output logic [3:0] displayOut, bcd_ones, bcd_tens,
    output logic [6:0] ss0, ss1,
    output logic [6:0] dispScore,
    output logic blinkToggle

);
    logic isGameComplete;
    logic [3:0] nextDisplayOut;
    logic button;

logic nextBlinkToggle;

// Clock divider for fast blinking
always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        blinkToggle <= 1'b0;
        displayOut <= 0;
    end else begin
        blinkToggle <= nextBlinkToggle;
        displayOut <= nextDisplayOut;
    end
end

always_comb begin
    nextBlinkToggle = 1'b0;
    nextDisplayOut = 4'b0;

    nextBlinkToggle = ~blinkToggle;

    if (~blinkToggle) begin
        nextDisplayOut = bcd_ones;
    end else begin
        nextDisplayOut = bcd_tens;
    end
end
    // Score tracker instance
    score_tracker track1 (.clk(clk), .nRst(~rst), .goodColl(goodCollButton), .badColl(badCollButton), .dispScore(dispScore), .isGameComplete(isGameComplete), .bcd_ones(bcd_ones), .bcd_tens(bcd_tens));

    // Display BCD digits on seven-segment displays with fast blinking
    ssdec ssdec1(.in(displayOut), .enable(blinkToggle), .out(ss0));
    ssdec ssdec2(.in(displayOut), .enable(~blinkToggle), .out(ss1));
endmodule


module ssdec (
input logic [3:0] in,
input logic enable,
output logic [6:0] out
);
always_comb begin
  case(in)
    4'b0000: begin out = 7'b0111111; end
    4'b0001: begin out = 7'b0000110; end
    4'b0010: begin out = 7'b1011011; end
    4'b0011: begin out = 7'b1001111; end
    4'b0100: begin out = 7'b1100110; end
    4'b0101: begin out = 7'b1101101; end
    4'b0110: begin out = 7'b1111101; end
    4'b0111: begin out = 7'b0000111; end
    4'b1000: begin out = 7'b1111111; end
    4'b1001: begin out = 7'b1100111; end
    4'b1010: begin out = 7'b1110111; end
    4'b1011: begin out = 7'b1111100; end
    4'b1100: begin out = 7'b0111001; end
    4'b1101: begin out = 7'b1011110; end
    4'b1110: begin out = 7'b1111001; end
    4'b1111: begin out = 7'b1110001; end
    default: begin out = '0; end
    endcase
        if (~enable) begin
            out = 7'b0;
        end
end

endmodule

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
