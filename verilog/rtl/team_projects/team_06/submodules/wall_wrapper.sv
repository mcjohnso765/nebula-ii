module wall_wrapper(
    input logic system_clk, nrst, enable_in2,
    input logic [3:0] x,y,
    input logic good_collision, enable_in, ///enable is (game_mode == WALL_SPAWN)
    input APPLE_LUCK apple_luck,
    input [3:0] snake_head_x, snake_head_y,
    input logic [MAX_LENGTH - 1:0] [3:0] snakeArrayX, snakeArrayY,
    input logic [7:0] score,
    output logic wall,
    output logic [3:0] xmax, xmin, ymax, ymin,
    output logic [24:0] [7:0] wall_locations
);

logic [7:0] apple_possible;
logic enable_out, collision;
parameter MAX_LENGTH = 30;

BorderGen genborder(.clk(system_clk),  .score(score), .enable_in(enable_in2), .nrst(nrst), .XMAX(xmax), .XMIN(xmin), .YMAX(ymax), .YMIN(ymin));

rand_wall_mode rand_wall(.good_collision(good_collision), .system_clk(system_clk), .nreset(nrst), .apple_luck(apple_luck), .snake_head_x(snake_head_x),
.snake_head_y(snake_head_y), .snakeArrayX(snakeArrayX), .snakeArrayY(snakeArrayY), .enable_in(enable_in), .XMAX(xmax), .XMIN(xmin), .YMAX(ymax), .YMIN(ymin),
.apple_possible(apple_possible), .apple_locations(wall_locations), .enable(enable_out));

random_num_gen_wall_mode abc(.enable(enable_out), .system_clk(system_clk), .nreset(nrst), .number_out(apple_possible));


collisionLogic_wall wallcollision(.next_wall({x,y}), .walls(wall_locations), .collision(collision));

assign wall = ((x >= xmax) | (y >= ymax) | (x <= xmin) | (y <= ymin) | (collision));
 

endmodule