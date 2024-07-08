module apple_wrapper( 
input logic system_clk, nreset, good_collision, 
input APPLE_LUCK apple_luck,
input logic [3:0] snake_head_x, snake_head_y, xmax, xmin, ymax, ymin,
input logic [MAX_LENGTH - 1:0] [3:0] snakeArrayX, snakeArrayY,
input logic enable_in, //enable for two apple mode (game_mode == TWO_APPLE)
input logic [3:0] x,y,
input logic [24:0] [7:0] wall_locations,
output logic apple,
output logic [7:0] apple_location1, apple_location2
);

logic [7:0] out_random, out_random_2;
logic enablea2, enablea;
parameter MAX_LENGTH = 30;

two_apple_mode twoapples (.good_collision(good_collision), .enable_in(enable_in), .system_clk(system_clk), .nreset(nreset), .apple_luck(apple_luck), 
.snake_head_x(snake_head_x), .snake_head_y(snake_head_y), .snakeArrayX(snakeArrayX), .snakeArrayY(snakeArrayY), .XMAX(XMAX), 
.XMIN(xmin), .YMAX(ymax), .YMIN(ymin), .apple_possible(out_random_2), .apple_location(apple_location2), .enable(enablea2));

random_num_gen twomode(.enable(enablea2), .system_clk(system_clk), .nreset(nreset), .number_out(out_random_2));


apple_gen_all ab (.good_collision(good_collision), .wall_locations(wall_locations), .system_clk(system_clk), .nreset(nreset), .apple_luck(apple_luck), .snake_head_x(snake_head_x), 
.snake_head_y(snake_head_y), .snakeArrayX(snakeArrayX), .snakeArrayY(snakeArrayY), .XMAX(xmax), .XMIN(xmin), .YMAX(ymax), .YMIN(ymin), .apple_possible(out_random),
 .apple_location(apple_location1), .enable(enablea));

random_num_gen normal1(.enable(enablea), .system_clk(system_clk), .nreset(nreset), .number_out(out_random));

assign apple = (({y,x} ==  apple_location1) || ({y,x} == apple_location2));


endmodule