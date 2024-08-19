/*
    Module: maze_clear_detector.sv
    Description:
        Detect whether the mazer location and the destination match,
    if match send the maze_clear signal to high
*/
`define SELECT 6'b000001
`define UP 6'b000010
`define RIGHT 6'b000100
`define DOWN 6'b001000
`define LEFT 6'b010000
`define BACK 6'b100000
`define NO_PRESS 6'b000000

module t07_maze_clear_detector(
    input logic [2:0] pos_x,
    input logic [2:0] pos_y,
    input logic [2:0] dest_x,
    input logic [2:0] dest_y,
    output logic maze_clear
);

    always_comb begin
        if(pos_x == dest_x && pos_y == dest_y) begin
            maze_clear = 1'b1;
        end else begin
            maze_clear = 1'b0;
        end
    end
endmodule