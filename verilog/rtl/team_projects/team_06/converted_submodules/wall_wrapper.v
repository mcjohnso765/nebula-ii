`default_nettype none
module t06_wall_wrapper (
	system_clk,
	nrst,
	enable_in2,
	x,
	y,
	good_collision,
	enable_in,
	apple_luck,
	snake_head_x,
	snake_head_y,
	snakeArrayX,
	snakeArrayY,
	score,
	wall,
	xmax,
	xmin,
	ymax,
	ymin,
	wall_locations
);
	input wire system_clk;
	input wire nrst;
	input wire enable_in2;
	input wire [3:0] x;
	input wire [3:0] y;
	input wire good_collision;
	input wire enable_in;
	input wire [1:0] apple_luck;
	input [3:0] snake_head_x;
	input [3:0] snake_head_y;
	parameter MAX_LENGTH = 30;
	input wire [(MAX_LENGTH * 4) - 1:0] snakeArrayX;
	input wire [(MAX_LENGTH * 4) - 1:0] snakeArrayY;
	input wire [7:0] score;
	output wire wall;
	output wire [3:0] xmax;
	output wire [3:0] xmin;
	output wire [3:0] ymax;
	output wire [3:0] ymin;
	output wire [199:0] wall_locations;
	wire [7:0] apple_possible;
	wire enable_out;
	wire collision;
	t06_BorderGen genborder(
		.clk(system_clk),
		.score(score),
		.enable_in(enable_in2),
		.nrst(nrst),
		.XMAX(xmax),
		.XMIN(xmin),
		.YMAX(ymax),
		.YMIN(ymin)
	);
	t06_rand_wall_mode rand_wall(
		.good_collision(good_collision),
		.system_clk(system_clk),
		.nreset(nrst),
		.apple_luck(apple_luck),
		.snake_head_x(snake_head_x),
		.snake_head_y(snake_head_y),
		.snakeArrayX(snakeArrayX),
		.snakeArrayY(snakeArrayY),
		.enable_in(enable_in),
		.XMAX(xmax),
		.XMIN(xmin),
		.YMAX(ymax),
		.YMIN(ymin),
		.apple_possible(apple_possible),
		.apple_locations(wall_locations),
		.enable(enable_out)
	);
	t06_random_num_gen_wall_mode abc(
		.enable(enable_out),
		.system_clk(system_clk),
		.nreset(nrst),
		.number_out(apple_possible)
	);
	t06_collisionLogic_wall wallcollision(
		.next_wall({y, x}),
		.walls(wall_locations),
		.collision(collision)
	);
	assign wall = ((((x >= xmax) | (y >= ymax)) | (x <= xmin)) | (y <= ymin)) | collision;
endmodule
