/*
    Module: maze
    Description:
        integrate the maze game
*/
module t07_maze (
    input logic nrst,
    input logic clk,
    input logic strobe,
    input logic [5:0] button,
    input logic [2:0] playing_state_in,
    input logic activate_rand,
    input logic maze_cleared,
    output logic error,
    output logic maze_clear,
    output logic [2:0] map_select,
    output logic [2:0] pos_x,
    output logic [2:0] pos_y,
    output logic [2:0] dest_x,
    output logic [2:0] dest_y
);
    logic [2:0] start_pos_x;
    logic [2:0] start_pos_y;
    logic enable_move;

    t07_maze_pos_gen maze_pos_gen_0(
        .nrst(nrst),
        .clk(clk),
        .activate_rand(activate_rand),
        .map_select(map_select),
        .start_pos_x(start_pos_x),
        .start_pos_y(start_pos_y),
        .dest_x(dest_x),
        .dest_y(dest_y)
    );
    t07_maze_wall_detector wall_detector0 (
        .nrst(nrst),
        .clk(clk),
        .playing_state_in(playing_state_in),
        .maze_cleared(maze_cleared),
        .strobe(strobe),
        .button(button),
        .map_select(map_select),
        .pos_x(pos_x),
        .pos_y(pos_y),
        .enable_move(enable_move),
        .error(error)
    );
    t07_maze_mazer_locator mazer_locator0 (
        .nrst(nrst),
        .clk(clk),
        .button(button),
        .playing_state_in(playing_state_in),
        .enable_move(enable_move),
        .activate_rand(activate_rand),
        .start_pos_x(start_pos_x),
        .start_pos_y(start_pos_y),
        .pos_x(pos_x),
        .pos_y(pos_y)
    );
    t07_maze_clear_detector maze_clear_detector0 (
        .pos_x(pos_x),
        .pos_y(pos_y),
        .dest_x(dest_x),
        .dest_y(dest_y),
        .maze_clear(maze_clear)
    );

endmodule