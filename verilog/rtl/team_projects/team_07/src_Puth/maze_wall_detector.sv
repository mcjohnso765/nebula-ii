/*
    Module: wall_detector
    Description: 
        Precoded the wall and send out the enable_move signal for the movement, 
    when the button is pressed and there is no wall; if there is, send out the error signal
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

module t07_maze_wall_detector(
    input logic nrst,                   // negedge reset
    input logic clk,                    // clock
    input logic [2:0] playing_state_in, // game_state_in input
    input logic strobe,                 // button strobe rising edge
    input logic [5:0] button,           // button input
    input logic [2:0] map_select,       // map select
    input logic maze_cleared,           // logic stated whether maze game is cleared 1, or not 0
    input logic [2:0] pos_x,            // position of x in 6*6 grid
    input logic [2:0] pos_y,            // position of y in 6*6 grid
    output logic enable_move,           // movement enable signal
    output logic error                  // error signal, when try to move into the wall
);
    logic map_wall [6][6][4];           // 1st dim: tab_x, 2nd dim: tab_y, 3rd dim: direction (0-3: UP, LEFT, DOWN, RIGHT)
                                        // value of 1 - if wall, 0 - if no wall
    
    always_comb begin
        // map 1
        if(map_select == 3'd0) begin
            // x - 0
            map_wall[0][0][0] = 0;   map_wall[0][0][1] = 1;   map_wall[0][0][2] = 1;   map_wall[0][0][3] = 0;
            map_wall[0][1][0] = 0;   map_wall[0][1][1] = 1;   map_wall[0][1][2] = 0;   map_wall[0][1][3] = 1;
            map_wall[0][2][0] = 0;   map_wall[0][2][1] = 1;   map_wall[0][2][2] = 0;   map_wall[0][2][3] = 0;
            map_wall[0][3][0] = 0;   map_wall[0][3][1] = 1;   map_wall[0][3][2] = 0;   map_wall[0][3][3] = 0;
            map_wall[0][4][0] = 1;   map_wall[0][4][1] = 1;   map_wall[0][4][2] = 0;   map_wall[0][4][3] = 0;
            map_wall[0][5][0] = 1;   map_wall[0][5][1] = 1;   map_wall[0][5][2] = 1;   map_wall[0][5][3] = 0;
            // x - 1
            map_wall[1][0][0] = 1;   map_wall[1][0][1] = 0;   map_wall[1][0][2] = 1;   map_wall[1][0][3] = 1;
            map_wall[1][1][0] = 1;   map_wall[1][1][1] = 1;   map_wall[1][1][2] = 1;   map_wall[1][1][3] = 0;
            map_wall[1][2][0] = 1;   map_wall[1][2][1] = 0;   map_wall[1][2][2] = 1;   map_wall[1][2][3] = 1;
            map_wall[1][3][0] = 1;   map_wall[1][3][1] = 0;   map_wall[1][3][2] = 1;   map_wall[1][3][3] = 0;
            map_wall[1][4][0] = 1;   map_wall[1][4][1] = 0;   map_wall[1][4][2] = 1;   map_wall[1][4][3] = 0;
            map_wall[1][5][0] = 1;   map_wall[1][5][1] = 0;   map_wall[1][5][2] = 1;   map_wall[1][5][3] = 0;
            // x - 2
            map_wall[2][0][0] = 0;   map_wall[2][0][1] = 1;   map_wall[2][0][2] = 1;   map_wall[2][0][3] = 0;
            map_wall[2][1][0] = 1;   map_wall[2][1][1] = 0;   map_wall[2][1][2] = 0;   map_wall[2][1][3] = 1;
            map_wall[2][2][0] = 0;   map_wall[2][2][1] = 1;   map_wall[2][2][2] = 1;   map_wall[2][2][3] = 0;
            map_wall[2][3][0] = 1;   map_wall[2][3][1] = 0;   map_wall[2][3][2] = 0;   map_wall[2][3][3] = 1;
            map_wall[2][4][0] = 0;   map_wall[2][4][1] = 0;   map_wall[2][4][2] = 1;   map_wall[2][4][3] = 1;
            map_wall[2][5][0] = 1;   map_wall[2][5][1] = 0;   map_wall[2][5][2] = 0;   map_wall[2][5][3] = 1;
            // x - 3
            map_wall[3][0][0] = 0;   map_wall[3][0][1] = 0;   map_wall[3][0][2] = 1;   map_wall[3][0][3] = 1;
            map_wall[3][1][0] = 1;   map_wall[3][1][1] = 1;   map_wall[3][1][2] = 0;   map_wall[3][1][3] = 0;
            map_wall[3][2][0] = 0;   map_wall[3][2][1] = 0;   map_wall[3][2][2] = 1;   map_wall[3][2][3] = 0;
            map_wall[3][3][0] = 1;   map_wall[3][3][1] = 1;   map_wall[3][3][2] = 0;   map_wall[3][3][3] = 0;
            map_wall[3][4][0] = 0;   map_wall[3][4][1] = 1;   map_wall[3][4][2] = 1;   map_wall[3][4][3] = 0;
            map_wall[3][5][0] = 1;   map_wall[3][5][1] = 1;   map_wall[3][5][2] = 0;   map_wall[3][5][3] = 0;
            // x - 4    
            map_wall[4][0][0] = 1;   map_wall[4][0][1] = 1;   map_wall[4][0][2] = 1;   map_wall[4][0][3] = 0;
            map_wall[4][1][0] = 1;   map_wall[4][1][1] = 0;   map_wall[4][1][2] = 1;   map_wall[4][1][3] = 0;
            map_wall[4][2][0] = 1;   map_wall[4][2][1] = 0;   map_wall[4][2][2] = 1;   map_wall[4][2][3] = 1;
            map_wall[4][3][0] = 0;   map_wall[4][3][1] = 0;   map_wall[4][3][2] = 1;   map_wall[4][3][3] = 1;
            map_wall[4][4][0] = 1;   map_wall[4][4][1] = 0;   map_wall[4][4][2] = 0;   map_wall[4][4][3] = 1;
            map_wall[4][5][0] = 1;   map_wall[4][5][1] = 0;   map_wall[4][5][2] = 1;   map_wall[4][5][3] = 0;
            // x - 5
            map_wall[5][0][0] = 0;   map_wall[5][0][1] = 0;   map_wall[5][0][2] = 1;   map_wall[5][0][3] = 1;
            map_wall[5][1][0] = 0;   map_wall[5][1][1] = 0;   map_wall[5][1][2] = 0;   map_wall[5][1][3] = 1;
            map_wall[5][2][0] = 0;   map_wall[5][2][1] = 1;   map_wall[5][2][2] = 0;   map_wall[5][2][3] = 1;
            map_wall[5][3][0] = 0;   map_wall[5][3][1] = 1;   map_wall[5][3][2] = 0;   map_wall[5][3][3] = 1;
            map_wall[5][4][0] = 0;   map_wall[5][4][1] = 1;   map_wall[5][4][2] = 0;   map_wall[5][4][3] = 1;
            map_wall[5][5][0] = 1;   map_wall[5][5][1] = 0;   map_wall[5][5][2] = 0;   map_wall[5][5][3] = 1;
        end

        // map 2
        else if(map_select == 3'd1) begin
            // x - 0
            map_wall[0][0][0] = 0;   map_wall[0][0][1] = 1;   map_wall[0][0][2] = 1;   map_wall[0][0][3] = 0;
            map_wall[0][1][0] = 0;   map_wall[0][1][1] = 1;   map_wall[0][1][2] = 0;   map_wall[0][1][3] = 1;
            map_wall[0][2][0] = 0;   map_wall[0][2][1] = 1;   map_wall[0][2][2] = 0;   map_wall[0][2][3] = 1;
            map_wall[0][3][0] = 0;   map_wall[0][3][1] = 1;   map_wall[0][3][2] = 0;   map_wall[0][3][3] = 0;
            map_wall[0][4][0] = 1;   map_wall[0][4][1] = 1;   map_wall[0][4][2] = 0;   map_wall[0][4][3] = 0;
            map_wall[0][5][0] = 1;   map_wall[0][5][1] = 1;   map_wall[0][5][2] = 1;   map_wall[0][5][3] = 0;
            // x - 1
            map_wall[1][0][0] = 1;   map_wall[1][0][1] = 0;   map_wall[1][0][2] = 1;   map_wall[1][0][3] = 0;
            map_wall[1][1][0] = 0;   map_wall[1][1][1] = 1;   map_wall[1][1][2] = 1;   map_wall[1][1][3] = 0;
            map_wall[1][2][0] = 1;   map_wall[1][2][1] = 1;   map_wall[1][2][2] = 0;   map_wall[1][2][3] = 1;
            map_wall[1][3][0] = 1;   map_wall[1][3][1] = 0;   map_wall[1][3][2] = 1;   map_wall[1][3][3] = 0;
            map_wall[1][4][0] = 0;   map_wall[1][4][1] = 0;   map_wall[1][4][2] = 1;   map_wall[1][4][3] = 1;
            map_wall[1][5][0] = 1;   map_wall[1][5][1] = 0;   map_wall[1][5][2] = 0;   map_wall[1][5][3] = 0;
            // x - 2
            map_wall[2][0][0] = 0;   map_wall[2][0][1] = 0;   map_wall[2][0][2] = 1;   map_wall[2][0][3] = 1;
            map_wall[2][1][0] = 1;   map_wall[2][1][1] = 0;   map_wall[2][1][2] = 0;   map_wall[2][1][3] = 1;
            map_wall[2][2][0] = 0;   map_wall[2][2][1] = 1;   map_wall[2][2][2] = 1;   map_wall[2][2][3] = 0;
            map_wall[2][3][0] = 1;   map_wall[2][3][1] = 0;   map_wall[2][3][2] = 0;   map_wall[2][3][3] = 1;
            map_wall[2][4][0] = 0;   map_wall[2][4][1] = 1;   map_wall[2][4][2] = 1;   map_wall[2][4][3] = 0;
            map_wall[2][5][0] = 1;   map_wall[2][5][1] = 0;   map_wall[2][5][2] = 0;   map_wall[2][5][3] = 1;
            // x - 3
            map_wall[3][0][0] = 0;   map_wall[3][0][1] = 1;   map_wall[3][0][2] = 1;   map_wall[3][0][3] = 0;
            map_wall[3][1][0] = 0;   map_wall[3][1][1] = 1;   map_wall[3][1][2] = 0;   map_wall[3][1][3] = 1;
            map_wall[3][2][0] = 1;   map_wall[3][2][1] = 0;   map_wall[3][2][2] = 0;   map_wall[3][2][3] = 1;
            map_wall[3][3][0] = 0;   map_wall[3][3][1] = 1;   map_wall[3][3][2] = 1;   map_wall[3][3][3] = 0;
            map_wall[3][4][0] = 1;   map_wall[3][4][1] = 0;   map_wall[3][4][2] = 0;   map_wall[3][4][3] = 1;
            map_wall[3][5][0] = 1;   map_wall[3][5][1] = 1;   map_wall[3][5][2] = 1;   map_wall[3][5][3] = 0;
            // x - 4
            map_wall[4][0][0] = 0;   map_wall[4][0][1] = 0;   map_wall[4][0][2] = 1;   map_wall[4][0][3] = 1;
            map_wall[4][1][0] = 1;   map_wall[4][1][1] = 1;   map_wall[4][1][2] = 0;   map_wall[4][1][3] = 1;
            map_wall[4][2][0] = 0;   map_wall[4][2][1] = 1;   map_wall[4][2][2] = 1;   map_wall[4][2][3] = 0;
            map_wall[4][3][0] = 1;   map_wall[4][3][1] = 0;   map_wall[4][3][2] = 0;   map_wall[4][3][3] = 1;
            map_wall[4][4][0] = 0;   map_wall[4][4][1] = 1;   map_wall[4][4][2] = 1;   map_wall[4][4][3] = 0;
            map_wall[4][5][0] = 1;   map_wall[4][5][1] = 0;   map_wall[4][5][2] = 0;   map_wall[4][5][3] = 0;
            // x - 5
            map_wall[5][0][0] = 0;   map_wall[5][0][1] = 1;   map_wall[5][0][2] = 1;   map_wall[5][0][3] = 1;
            map_wall[5][1][0] = 0;   map_wall[5][1][1] = 1;   map_wall[5][1][2] = 0;   map_wall[5][1][3] = 1;
            map_wall[5][2][0] = 0;   map_wall[5][2][1] = 0;   map_wall[5][2][2] = 0;   map_wall[5][2][3] = 1;
            map_wall[5][3][0] = 0;   map_wall[5][3][1] = 1;   map_wall[5][3][2] = 0;   map_wall[5][3][3] = 1;
            map_wall[5][4][0] = 1;   map_wall[5][4][1] = 0;   map_wall[5][4][2] = 0;   map_wall[5][4][3] = 1;
            map_wall[5][5][0] = 1;   map_wall[5][5][1] = 0;   map_wall[5][5][2] = 1;   map_wall[5][5][3] = 1;
        end

        // map 3
        else if (map_select == 3'd2) begin
            // x - 0
            map_wall[0][0][0] = 0;   map_wall[0][0][1] = 1;   map_wall[0][0][2] = 1;   map_wall[0][0][3] = 0;
            map_wall[0][1][0] = 0;   map_wall[0][1][1] = 1;   map_wall[0][1][2] = 0;   map_wall[0][1][3] = 1;
            map_wall[0][2][0] = 0;   map_wall[0][2][1] = 1;   map_wall[0][2][2] = 0;   map_wall[0][2][3] = 1;
            map_wall[0][3][0] = 0;   map_wall[0][3][1] = 1;   map_wall[0][3][2] = 0;   map_wall[0][3][3] = 1;
            map_wall[0][4][0] = 0;   map_wall[0][4][1] = 1;   map_wall[0][4][2] = 0;   map_wall[0][4][3] = 1;
            map_wall[0][5][0] = 1;   map_wall[0][5][1] = 1;   map_wall[0][5][2] = 0;   map_wall[0][5][3] = 0;
            // x - 1
            map_wall[1][0][0] = 0;   map_wall[1][0][1] = 0;   map_wall[1][0][2] = 1;   map_wall[1][0][3] = 1;
            map_wall[1][1][0] = 0;   map_wall[1][1][1] = 1;   map_wall[1][1][2] = 0;   map_wall[1][1][3] = 1;
            map_wall[1][2][0] = 0;   map_wall[1][2][1] = 1;   map_wall[1][2][2] = 0;   map_wall[1][2][3] = 1;
            map_wall[1][3][0] = 1;   map_wall[1][3][1] = 1;   map_wall[1][3][2] = 0;   map_wall[1][3][3] = 0;
            map_wall[1][4][0] = 0;   map_wall[1][4][1] = 1;   map_wall[1][4][2] = 1;   map_wall[1][4][3] = 0;
            map_wall[1][5][0] = 1;   map_wall[1][5][1] = 0;   map_wall[1][5][2] = 0;   map_wall[1][5][3] = 1;
            // x - 2
            map_wall[2][0][0] = 0;   map_wall[2][0][1] = 1;   map_wall[2][0][2] = 1;   map_wall[2][0][3] = 0;
            map_wall[2][1][0] = 0;   map_wall[2][1][1] = 1;   map_wall[2][1][2] = 0;   map_wall[2][1][3] = 1;
            map_wall[2][2][0] = 0;   map_wall[2][2][1] = 1;   map_wall[2][2][2] = 0;   map_wall[2][2][3] = 1;
            map_wall[2][3][0] = 1;   map_wall[2][3][1] = 0;   map_wall[2][3][2] = 0;   map_wall[2][3][3] = 1;
            map_wall[2][4][0] = 0;   map_wall[2][4][1] = 0;   map_wall[2][4][2] = 1;   map_wall[2][4][3] = 1;
            map_wall[2][5][0] = 1;   map_wall[2][5][1] = 1;   map_wall[2][5][2] = 0;   map_wall[2][5][3] = 1;
            // x - 3
            map_wall[3][0][0] = 1;   map_wall[3][0][1] = 0;   map_wall[3][0][2] = 1;   map_wall[3][0][3] = 0;
            map_wall[3][1][0] = 0;   map_wall[3][1][1] = 1;   map_wall[3][1][2] = 1;   map_wall[3][1][3] = 0;
            map_wall[3][2][0] = 0;   map_wall[3][2][1] = 1;   map_wall[3][2][2] = 0;   map_wall[3][2][3] = 1;
            map_wall[3][3][0] = 0;   map_wall[3][3][1] = 1;   map_wall[3][3][2] = 0;   map_wall[3][3][3] = 1;
            map_wall[3][4][0] = 0;   map_wall[3][4][1] = 1;   map_wall[3][4][2] = 0;   map_wall[3][4][3] = 1;
            map_wall[3][5][0] = 1;   map_wall[3][5][1] = 1;   map_wall[3][5][2] = 0;   map_wall[3][5][3] = 0;
            // x - 4
            map_wall[4][0][0] = 1;   map_wall[4][0][1] = 0;   map_wall[4][0][2] = 1;   map_wall[4][0][3] = 0;
            map_wall[4][1][0] = 0;   map_wall[4][1][1] = 0;   map_wall[4][1][2] = 1;   map_wall[4][1][3] = 1;
            map_wall[4][2][0] = 0;   map_wall[4][2][1] = 1;   map_wall[4][2][2] = 0;   map_wall[4][2][3] = 1;
            map_wall[4][3][0] = 0;   map_wall[4][3][1] = 1;   map_wall[4][3][2] = 0;   map_wall[4][3][3] = 0;
            map_wall[4][4][0] = 1;   map_wall[4][4][1] = 1;   map_wall[4][4][2] = 0;   map_wall[4][4][3] = 1;
            map_wall[4][5][0] = 1;   map_wall[4][5][1] = 0;   map_wall[4][5][2] = 1;   map_wall[4][5][3] = 0;
            // x - 5
            map_wall[5][0][0] = 0;   map_wall[5][0][1] = 0;   map_wall[5][0][2] = 1;   map_wall[5][0][3] = 1;
            map_wall[5][1][0] = 0;   map_wall[5][1][1] = 1;   map_wall[5][1][2] = 0;   map_wall[5][1][3] = 1;
            map_wall[5][2][0] = 0;   map_wall[5][2][1] = 1;   map_wall[5][2][2] = 0;   map_wall[5][2][3] = 1;
            map_wall[5][3][0] = 1;   map_wall[5][3][1] = 0;   map_wall[5][3][2] = 0;   map_wall[5][3][3] = 1;
            map_wall[5][4][0] = 0;   map_wall[5][4][1] = 1;   map_wall[5][4][2] = 1;   map_wall[5][4][3] = 1;
            map_wall[5][5][0] = 1;   map_wall[5][5][1] = 0;   map_wall[5][5][2] = 0;   map_wall[5][5][3] = 1;
        end

        // map 4
        else if (map_select == 3'd3) begin
            // x - 0
            map_wall[0][0][0] = 0;   map_wall[0][0][1] = 1;   map_wall[0][0][2] = 1;   map_wall[0][0][3] = 1;
            map_wall[0][1][0] = 0;   map_wall[0][1][1] = 1;   map_wall[0][1][2] = 0;   map_wall[0][1][3] = 1;
            map_wall[0][2][0] = 0;   map_wall[0][2][1] = 1;   map_wall[0][2][2] = 0;   map_wall[0][2][3] = 0;
            map_wall[0][3][0] = 0;   map_wall[0][3][1] = 1;   map_wall[0][3][2] = 0;   map_wall[0][3][3] = 1;
            map_wall[0][4][0] = 0;   map_wall[0][4][1] = 1;   map_wall[0][4][2] = 0;   map_wall[0][4][3] = 0;
            map_wall[0][5][0] = 1;   map_wall[0][5][1] = 1;   map_wall[0][5][2] = 0;   map_wall[0][5][3] = 0;
            // x - 1
            map_wall[1][0][0] = 0;   map_wall[1][0][1] = 1;   map_wall[1][0][2] = 1;   map_wall[1][0][3] = 0;
            map_wall[1][1][0] = 1;   map_wall[1][1][1] = 1;   map_wall[1][1][2] = 0;   map_wall[1][1][3] = 0;
            map_wall[1][2][0] = 1;   map_wall[1][2][1] = 0;   map_wall[1][2][2] = 1;   map_wall[1][2][3] = 0;
            map_wall[1][3][0] = 1;   map_wall[1][3][1] = 1;   map_wall[1][3][2] = 1;   map_wall[1][3][3] = 0;
            map_wall[1][4][0] = 1;   map_wall[1][4][1] = 0;   map_wall[1][4][2] = 1;   map_wall[1][4][3] = 0;
            map_wall[1][5][0] = 1;   map_wall[1][5][1] = 0;   map_wall[1][5][2] = 1;   map_wall[1][5][3] = 0;
            // x - 2
            map_wall[2][0][0] = 1;   map_wall[2][0][1] = 0;   map_wall[2][0][2] = 1;   map_wall[2][0][3] = 1;
            map_wall[2][1][0] = 1;   map_wall[2][1][1] = 0;   map_wall[2][1][2] = 1;   map_wall[2][1][3] = 0;
            map_wall[2][2][0] = 0;   map_wall[2][2][1] = 0;   map_wall[2][2][2] = 1;   map_wall[2][2][3] = 0;
            map_wall[2][3][0] = 1;   map_wall[2][3][1] = 0;   map_wall[2][3][2] = 0;   map_wall[2][3][3] = 1;
            map_wall[2][4][0] = 1;   map_wall[2][4][1] = 0;   map_wall[2][4][2] = 1;   map_wall[2][4][3] = 0;
            map_wall[2][5][0] = 1;   map_wall[2][5][1] = 0;   map_wall[2][5][2] = 1;   map_wall[2][5][3] = 0;
            // x - 3
            map_wall[3][0][0] = 1;   map_wall[3][0][1] = 1;   map_wall[3][0][2] = 1;   map_wall[3][0][3] = 0;
            map_wall[3][1][0] = 1;   map_wall[3][1][1] = 0;   map_wall[3][1][2] = 1;   map_wall[3][1][3] = 0;
            map_wall[3][2][0] = 1;   map_wall[3][2][1] = 0;   map_wall[3][2][2] = 1;   map_wall[3][2][3] = 0;
            map_wall[3][3][0] = 0;   map_wall[3][3][1] = 1;   map_wall[3][3][2] = 1;   map_wall[3][3][3] = 0;
            map_wall[3][4][0] = 1;   map_wall[3][4][1] = 0;   map_wall[3][4][2] = 0;   map_wall[3][4][3] = 1;
            map_wall[3][5][0] = 1;   map_wall[3][5][1] = 0;   map_wall[3][5][2] = 1;   map_wall[3][5][3] = 1;
            // x - 4
            map_wall[4][0][0] = 1;   map_wall[4][0][1] = 0;   map_wall[4][0][2] = 1;   map_wall[4][0][3] = 0;
            map_wall[4][1][0] = 1;   map_wall[4][1][1] = 0;   map_wall[4][1][2] = 1;   map_wall[4][1][3] = 0;
            map_wall[4][2][0] = 1;   map_wall[4][2][1] = 0;   map_wall[4][2][2] = 1;   map_wall[4][2][3] = 1;
            map_wall[4][3][0] = 0;   map_wall[4][3][1] = 0;   map_wall[4][3][2] = 1;   map_wall[4][3][3] = 1;
            map_wall[4][4][0] = 0;   map_wall[4][4][1] = 1;   map_wall[4][4][2] = 0;   map_wall[4][4][3] = 1;
            map_wall[4][5][0] = 1;   map_wall[4][5][1] = 1;   map_wall[4][5][2] = 0;   map_wall[4][5][3] = 0;
            // x - 5
            map_wall[5][0][0] = 0;   map_wall[5][0][1] = 0;   map_wall[5][0][2] = 1;   map_wall[5][0][3] = 1;
            map_wall[5][1][0] = 0;   map_wall[5][1][1] = 0;   map_wall[5][1][2] = 0;   map_wall[5][1][3] = 1;
            map_wall[5][2][0] = 0;   map_wall[5][2][1] = 1;   map_wall[5][2][2] = 0;   map_wall[5][2][3] = 1;
            map_wall[5][3][0] = 0;   map_wall[5][3][1] = 1;   map_wall[5][3][2] = 0;   map_wall[5][3][3] = 1;
            map_wall[5][4][0] = 0;   map_wall[5][4][1] = 1;   map_wall[5][4][2] = 0;   map_wall[5][4][3] = 1;
            map_wall[5][5][0] = 1;   map_wall[5][5][1] = 0;   map_wall[5][5][2] = 0;   map_wall[5][5][3] = 1;
        end
        
        // map 5
        else if (map_select == 3'd4) begin
            // x - 0
            map_wall[0][0][0] = 0;   map_wall[0][0][1] = 1;   map_wall[0][0][2] = 1;   map_wall[0][0][3] = 0;
            map_wall[0][1][0] = 0;   map_wall[0][1][1] = 1;   map_wall[0][1][2] = 0;   map_wall[0][1][3] = 1;
            map_wall[0][2][0] = 0;   map_wall[0][2][1] = 1;   map_wall[0][2][2] = 0;   map_wall[0][2][3] = 1;
            map_wall[0][3][0] = 1;   map_wall[0][3][1] = 1;   map_wall[0][3][2] = 0;   map_wall[0][3][3] = 0;
            map_wall[0][4][0] = 0;   map_wall[0][4][1] = 1;   map_wall[0][4][2] = 1;   map_wall[0][4][3] = 1;
            map_wall[0][5][0] = 1;   map_wall[0][5][1] = 1;   map_wall[0][5][2] = 0;   map_wall[0][5][3] = 0;
            // x - 1
            map_wall[1][0][0] = 1;   map_wall[1][0][1] = 0;   map_wall[1][0][2] = 1;   map_wall[1][0][3] = 0;
            map_wall[1][1][0] = 1;   map_wall[1][1][1] = 1;   map_wall[1][1][2] = 1;   map_wall[1][1][3] = 0;
            map_wall[1][2][0] = 0;   map_wall[1][2][1] = 1;   map_wall[1][2][2] = 1;   map_wall[1][2][3] = 1;
            map_wall[1][3][0] = 1;   map_wall[1][3][1] = 0;   map_wall[1][3][2] = 0;   map_wall[1][3][3] = 1;
            map_wall[1][4][0] = 0;   map_wall[1][4][1] = 1;   map_wall[1][4][2] = 1;   map_wall[1][4][3] = 0;
            map_wall[1][5][0] = 1;   map_wall[1][5][1] = 0;   map_wall[1][5][2] = 0;   map_wall[1][5][3] = 0;
            // x - 2
            map_wall[2][0][0] = 1;   map_wall[2][0][1] = 0;   map_wall[2][0][2] = 1;   map_wall[2][0][3] = 0;
            map_wall[2][1][0] = 0;   map_wall[2][1][1] = 0;   map_wall[2][1][2] = 1;   map_wall[2][1][3] = 0;
            map_wall[2][2][0] = 1;   map_wall[2][2][1] = 1;   map_wall[2][2][2] = 0;   map_wall[2][2][3] = 0;
            map_wall[2][3][0] = 0;   map_wall[2][3][1] = 1;   map_wall[2][3][2] = 1;   map_wall[2][3][3] = 0;
            map_wall[2][4][0] = 1;   map_wall[2][4][1] = 0;   map_wall[2][4][2] = 0;   map_wall[2][4][3] = 0;
            map_wall[2][5][0] = 1;   map_wall[2][5][1] = 0;   map_wall[2][5][2] = 1;   map_wall[2][5][3] = 0;
            // x - 3
            map_wall[3][0][0] = 1;   map_wall[3][0][1] = 0;   map_wall[3][0][2] = 1;   map_wall[3][0][3] = 0;
            map_wall[3][1][0] = 1;   map_wall[3][1][1] = 0;   map_wall[3][1][2] = 1;   map_wall[3][1][3] = 0;
            map_wall[3][2][0] = 1;   map_wall[3][2][1] = 0;   map_wall[3][2][2] = 1;   map_wall[3][2][3] = 0;
            map_wall[3][3][0] = 1;   map_wall[3][3][1] = 0;   map_wall[3][3][2] = 1;   map_wall[3][3][3] = 1;
            map_wall[3][4][0] = 1;   map_wall[3][4][1] = 0;   map_wall[3][4][2] = 1;   map_wall[3][4][3] = 0;
            map_wall[3][5][0] = 1;   map_wall[3][5][1] = 0;   map_wall[3][5][2] = 1;   map_wall[3][5][3] = 0;
            // x - 4
            map_wall[4][0][0] = 0;   map_wall[4][0][1] = 0;   map_wall[4][0][2] = 1;   map_wall[4][0][3] = 1;
            map_wall[4][1][0] = 1;   map_wall[4][1][1] = 0;   map_wall[4][1][2] = 0;   map_wall[4][1][3] = 1;
            map_wall[4][2][0] = 0;   map_wall[4][2][1] = 0;   map_wall[4][2][2] = 1;   map_wall[4][2][3] = 1;
            map_wall[4][3][0] = 1;   map_wall[4][3][1] = 1;   map_wall[4][3][2] = 0;   map_wall[4][3][3] = 0;
            map_wall[4][4][0] = 1;   map_wall[4][4][1] = 0;   map_wall[4][4][2] = 1;   map_wall[4][4][3] = 0;
            map_wall[4][5][0] = 1;   map_wall[4][5][1] = 0;   map_wall[4][5][2] = 1;   map_wall[4][5][3] = 0;
            // x - 5
            map_wall[5][0][0] = 0;   map_wall[5][0][1] = 1;   map_wall[5][0][2] = 1;   map_wall[5][0][3] = 1;
            map_wall[5][1][0] = 0;   map_wall[5][1][1] = 1;   map_wall[5][1][2] = 0;   map_wall[5][1][3] = 1;
            map_wall[5][2][0] = 0;   map_wall[5][2][1] = 1;   map_wall[5][2][2] = 0;   map_wall[5][2][3] = 1;
            map_wall[5][3][0] = 0;   map_wall[5][3][1] = 0;   map_wall[5][3][2] = 0;   map_wall[5][3][3] = 1;
            map_wall[5][4][0] = 1;   map_wall[5][4][1] = 0;   map_wall[5][4][2] = 0;   map_wall[5][4][3] = 1;
            map_wall[5][5][0] = 1;   map_wall[5][5][1] = 0;   map_wall[5][5][2] = 1;   map_wall[5][5][3] = 1;
        end

        // default
        else begin
            for (integer i = 0 ; i < 6; i++) begin
                for(integer j = 0; j < 6; j++) begin
                    for(integer k = 0; k < 4; k++) begin
                        map_wall[i][j][k] = 1'b1;
                    end
                end
            end
        end

        if (playing_state_in == `MAZE && strobe && !maze_cleared) begin 
            if (button == `UP) begin 
                enable_move = (map_wall[pos_x][pos_y][0]) ? 0 : 1; 
            end else if (button == `RIGHT) begin 
                enable_move = (map_wall[pos_x][pos_y][1]) ? 0 : 1; 
            end else if (button == `DOWN) begin 
                enable_move = (map_wall[pos_x][pos_y][2]) ? 0 : 1; 
            end else if (button == `LEFT) begin 
                enable_move = (map_wall[pos_x][pos_y][3]) ? 0 : 1; 
            end else begin
                enable_move = 1'b0;
            end
            if (button == `UP || button == `DOWN || button == `LEFT || button == `RIGHT) begin
                error = !enable_move;
            end else begin
                error = 1'b0;
            end
        end else begin
            error = 1'b0;
            enable_move = 1'b0;
        end
    end

endmodule