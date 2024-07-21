/*
    Module: maze_pos_gen
    Description:
        set the start and destination positions for the maze game upon receiving
    the activate_rand signal when moving from MENU to PLAY state.
*/
`define MENU 3'b000
`define PLAY 3'b001
`define LOST 3'b010
`define WON 3'b011

module t07_maze_pos_gen(
    input logic nrst,
    input logic clk,
    input logic activate_rand,
    output logic [2:0] map_select,
    output logic [2:0] start_pos_x,
    output logic [2:0] start_pos_y,
    output logic [2:0] dest_x,
    output logic [2:0] dest_y
);
    logic [2:0] rand_start_pos_x;
    logic [2:0] rand_start_pos_y;
    logic [2:0] rand_dest_x;
    logic [2:0] rand_dest_y;
    logic [2:0] rand_map_select;
    
    t07_random_gen_maze_pos start_pos_gen ( 
        .nrst(nrst),
        .clk(clk),
        .random_seed(12'd4069),
        .rand_x(rand_start_pos_x),
        .rand_y(rand_start_pos_y)
    );
    t07_random_gen_maze_pos dest_pos_gen (
        .nrst(nrst), 
        .clk(clk), 
        .random_seed(12'd3011),
        .rand_x(rand_dest_x), 
        .rand_y(rand_dest_y)
    );
    t07_random_gen_maze_ms map_select_gen (
        .nrst(nrst),
        .clk(clk),
        .random_seed(12'd2393),
        .rand_num(rand_map_select)
    );

    logic [2:0] nxt_start_pos_x;
    logic [2:0] nxt_start_pos_y;
    logic [2:0] nxt_dest_x;
    logic [2:0] nxt_dest_y;
    logic [2:0] nxt_map_select;

    always_ff @(posedge clk, negedge nrst) begin 
        if(!nrst) begin
            start_pos_x <= 3'd5;
            start_pos_y <= 3'd2;
            dest_x <= 3'd3;
            dest_y <= 3'd3;
            map_select <= 3'd0;
        end else begin
            start_pos_x <= nxt_start_pos_x;
            start_pos_y <= nxt_start_pos_y;
            dest_x <= nxt_dest_x;
            dest_y <= nxt_dest_y;
            map_select <= nxt_map_select;
        end
    end

    always_comb begin
        if(activate_rand) begin
            nxt_map_select = rand_map_select;
            if((rand_start_pos_x == rand_dest_x) && (rand_start_pos_y == rand_dest_y)) begin // For the case of overlapping player and destination
                nxt_start_pos_x = (rand_dest_x == 0)? 3: 0;
                nxt_start_pos_y = (rand_dest_y == 0)? 4: 0;
                nxt_dest_x = rand_dest_x;
                nxt_dest_y = rand_dest_y;
            end else begin 
                nxt_start_pos_x = rand_start_pos_x;
                nxt_start_pos_y = rand_start_pos_y;
                nxt_dest_x = rand_dest_x;
                nxt_dest_y = rand_dest_y;
            end
        end else begin
            nxt_map_select = map_select;
            nxt_start_pos_x = start_pos_x;
            nxt_start_pos_y = start_pos_y;
            nxt_dest_x = dest_x;
            nxt_dest_y = dest_y;
        end
    end
endmodule