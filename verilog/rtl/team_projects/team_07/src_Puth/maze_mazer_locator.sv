/*
    Module: maze_locator
    Description:
        Keep tract of the position of the mazer in 6 x 6 square map.
    Update the position of the mazer when the direction button is pressed.
*/
`define MENU 3'b000
`define PLAY 3'b001
`define LOST 3'b010
`define WON 3'b011

`define MOD 3'b000
`define MAZE 3'b001

`define SELECT 6'b000001
`define UP 6'b000010
`define RIGHT 6'b000100
`define DOWN 6'b001000
`define LEFT 6'b010000
`define BACK 6'b100000
`define NO_PRESS 6'b000000

module t07_maze_mazer_locator(
    input logic nrst,
    input logic clk,
    input logic [5:0] button,
    input logic [2:0] playing_state_in,
    input logic enable_move,
    input logic activate_rand,
    input logic [2:0] start_pos_x,
    input logic [2:0] start_pos_y,
    output logic [2:0] pos_x,
    output logic [2:0] pos_y
);

    logic [2:0] next_pos_x;
    logic [2:0] next_pos_y;
    logic activate_rand_delay;
    
    always_ff @(negedge nrst, posedge clk) begin
        if (!nrst) begin
            pos_x <= 0;
            pos_y <= 0;
            activate_rand_delay <= 0;
        end else begin
            pos_x <= next_pos_x;
            pos_y <= next_pos_y;
            activate_rand_delay <= activate_rand;
        end
    end
    
    always_comb begin
        next_pos_x = pos_x;
        next_pos_y = pos_y;
        if (activate_rand_delay) begin
            next_pos_x = start_pos_x;
            next_pos_y = start_pos_y;
        end 
        if (playing_state_in == `MAZE && enable_move) begin
            if (button == `UP) begin
                next_pos_y = pos_y + 1;
            end else if (button == `RIGHT) begin
                next_pos_x = pos_x - 1;
            end else if (button == `DOWN) begin
                next_pos_y = pos_y - 1;
            end else if (button == `LEFT) begin
                next_pos_x = pos_x + 1;
            end
        end
    end

endmodule