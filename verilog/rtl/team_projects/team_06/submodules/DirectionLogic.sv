/* 
  Module Name: DirectionLogic
  Module Function/Purpose: Determines the direction based on button inputs
  Module Inputs:system_clk, reset, up, down, left, right (1 bit inputs from each button)
  Module Outputs: [3:0] direction 

  Best Commenting Practices (to make debugging easier):
    1) Explain what each block of logic does.
    2) Explain what each input and output represents and what its values represent.

  Best Coding Practices (to make debugging easier):
    1) Assign outputs using always_ff blocks whenever possible.
    2) Use enable variables for blocks that can be used to change game modes.

*/ 
// typedef enum logic [1:0] {
//         UP = 2'b00,
//         DOWN = 2'b01, 
//         LEFT = 2'b10,
//         RIGHT = 2'b11
//     } DIRECTION; 

module DirectionLogic(
    input logic clk, nrst, pause_clk,
    input logic up, down, left, right, bad_collision,
    output DIRECTION directionOut
);
    DIRECTION direction; // intermediate var

    always_comb begin
        casez({left, right, down, up}) //using casez to cover button prioritizations
            4'b???1: direction = (directionOut != RIGHT) ? LEFT : DirectionOut; // Syntax errors right now because module with enum definitions are not linked 
            4'b?1?0: direction = (directionOut != LEFT) ? RIGHT : DirectionOut;
            4'b?010: direction = (directionOut != UP) ? DOWN : DirectionOut;
            4'b1000: direction = (directionOut != DOWN) ? UP: DirectionOut;
            default: direction = directionOut;
        endcase
    end

    always_ff @ (posedge clk, negedge nrst) begin //clk, rst, and flip-flop logic
        if (~nrst) begin
            directionOut <= RIGHT; //RIGHT
        end 
        else if (bad_collision) begin
            directionOut <= RIGHT;
        end
        else if (pause_clk) begin
            directionOut <= direction;
        end
        else begin
            directionOut <= directionOut;
        end
    end
endmodule