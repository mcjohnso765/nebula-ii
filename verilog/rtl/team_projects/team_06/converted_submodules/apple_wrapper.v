`default_nettype none
module t06_apple_wrapper (
	system_clk,
	clk_body,
	nreset,
	good_collision,
	good_collision2,
	apple_luck,
	snake_head_x,
	snake_head_y,
	xmax,
	xmin,
	ymax,
	ymin,
	snakeArrayX,
	snakeArrayY,
	enable_in,
	x,
	y,
	wall_locations,
	apple,
	apple_location1,
	apple_location2
);
	reg _sv2v_0;
	input wire system_clk;
	input wire clk_body;
	input wire nreset;
	input wire good_collision;
	input wire good_collision2;
	input wire [1:0] apple_luck;
	input wire [3:0] snake_head_x;
	input wire [3:0] snake_head_y;
	input wire [3:0] xmax;
	input wire [3:0] xmin;
	input wire [3:0] ymax;
	input wire [3:0] ymin;
	parameter MAX_LENGTH = 30;
	input wire [(MAX_LENGTH * 4) - 1:0] snakeArrayX;
	input wire [(MAX_LENGTH * 4) - 1:0] snakeArrayY;
	input wire enable_in;
	input wire [3:0] x;
	input wire [3:0] y;
	input wire [199:0] wall_locations;
	output wire apple;
	output reg [7:0] apple_location1;
	output reg [7:0] apple_location2;
	wire [7:0] out_random;
	wire [7:0] out_random_2;
	reg [7:0] apple_location2a;
	wire enablea2;
	wire enablea;
	wire [7:0] apple_location2_n;
	t06_two_apple_mode twoapples(
		.good_collision(good_collision2),
		.enable_in(enable_in),
		.system_clk(system_clk),
		.nreset(nreset),
		.apple_luck(apple_luck),
		.snake_head_x(snake_head_x),
		.snake_head_y(snake_head_y),
		.snakeArrayX(snakeArrayX),
		.snakeArrayY(snakeArrayY),
		.XMAX(xmax),
		.XMIN(xmin),
		.YMAX(ymax),
		.YMIN(ymin),
		.apple_possible(out_random_2),
		.apple_location(apple_location2_n),
		.enable(enablea2)
	);
	t06_random_num_gen twomode(
		.enable(enablea2),
		.system_clk(system_clk),
		.nreset(nreset),
		.number_out(out_random_2)
	);
	always @(*) begin
		if (_sv2v_0)
			;
		if (enable_in)
			apple_location2a = apple_location2_n;
		else
			apple_location2a = 8'd0;
	end
	wire steady_e;
	reg [1:0] steady;
	wire [7:0] apple_location1_n;
	t06_edgeDetect off_bc(
		.D(steady[1]),
		.clk(system_clk),
		.nrst(nreset),
		.edg(steady_e)
	);
	always @(posedge system_clk or negedge nreset)
		if (~nreset)
			steady <= 1'b0;
		else if (clk_body) begin
			steady <= steady + 2'b01;
			if ((steady + 2'b01) == 2'b11)
				steady <= 2'b00;
		end
		else
			steady <= steady;
	always @(posedge system_clk or negedge nreset)
		if (~nreset)
			{apple_location1, apple_location2} <= 16'h5555;
		else if (steady_e)
			{apple_location1, apple_location2} <= {apple_location1_n, apple_location2a};
		else
			{apple_location1, apple_location2} <= {apple_location1, apple_location2};
	t06_apple_gen_all ab(
		.good_collision(good_collision),
		.wall_locations(wall_locations),
		.system_clk(system_clk),
		.nreset(nreset),
		.apple_luck(apple_luck),
		.snake_head_x(snake_head_x),
		.snake_head_y(snake_head_y),
		.snakeArrayX(snakeArrayX),
		.snakeArrayY(snakeArrayY),
		.XMAX(xmax),
		.XMIN(xmin),
		.YMAX(ymax),
		.YMIN(ymin),
		.apple_possible(out_random),
		.apple_location(apple_location1_n),
		.enable(enablea)
	);
	t06_random_num_gen normal1(
		.enable(enablea),
		.system_clk(system_clk),
		.nreset(nreset),
		.number_out(out_random)
	);
	assign apple = ({y, x} == apple_location1) || ({y, x} == apple_location2);
	initial _sv2v_0 = 0;
endmodule
