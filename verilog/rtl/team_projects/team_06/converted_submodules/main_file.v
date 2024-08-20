`default_nettype none
module t06_main_file (
	clk,
	nrst,
	button_right_in,
	button_left_in,
	button_up_in,
	button_down_in,
	button_reset_in,
	button_start_pause_in,
	enable_total,
	x,
	y,
	apple,
	wall,
	body,
	head,
	gameover,
	song,
	rert,
	rs,
	rw,
	en,
	lcd8
);
	input wire clk;
	input wire nrst;
	input wire button_right_in;
	input wire button_left_in;
	input wire button_up_in;
	input wire button_down_in;
	input wire button_reset_in;
	input wire button_start_pause_in;
	input wire enable_total;
	input wire [3:0] x;
	input wire [3:0] y;
	output wire apple;
	output wire wall;
	output wire body;
	output wire head;
	output wire gameover;
	output wire song;
	output wire rert;
	output wire rs;
	output wire rw;
	output wire en;
	output wire [7:0] lcd8;
	parameter MAX_LENGTH = 30;
	wire reset_button;
	wire reset_button_a;
	wire up_direction;
	wire down_direction;
	wire left_direction;
	wire right_direction;
	wire start_pause_button;
	wire pause_clk;
	wire main_clk;
	wire clk_body;
	wire good_collision;
	wire good_collision2;
	wire bad_collision;
	wire wall_a;
	wire apple_a;
	wire body_a;
	wire head_a;
	wire [1:0] game_speed;
	wire [1:0] direction;
	wire [1:0] game_state;
	wire [1:0] game_mode;
	wire [1:0] apple_luck;
	wire [3:0] snake_head_x;
	wire [3:0] snake_head_y;
	wire [3:0] xmin;
	wire [3:0] xmax;
	wire [3:0] ymax;
	wire [3:0] ymin;
	wire [(MAX_LENGTH * 4) - 1:0] snakeArrayX;
	wire [(MAX_LENGTH * 4) - 1:0] snakeArrayY;
	wire [7:0] score;
	wire [7:0] apple_location;
	wire [7:0] apple_location2;
	wire [199:0] wall_locations;
	t06_clock clock1(
		.system_clk(clk),
		.nreset(reset_button),
		.game_state(game_state),
		.clk(pause_clk),
		.clk_main_display(main_clk),
		.clk_body(clk_body),
		.game_speed(game_speed)
	);
	t06_display_wrapper kyle(
		.score(score),
		.clk(main_clk),
		.nreset(reset_button),
		.game_mode(game_mode),
		.game_speed(game_speed),
		.game_state(game_state),
		.apple_luck(apple_luck),
		.out1(en),
		.out2(rw),
		.out3(rs),
		.out4(lcd8)
	);
	t06_PWM randy(
		.clk(main_clk),
		.nrst(reset_button),
		.enable((game_state == 2'b00) | (game_state == 2'b11)),
		.goodCollision(good_collision || good_collision2),
		.badCollision(bad_collision),
		.out(song)
	);
	t06_gameMode modea(
		.button(right_direction),
		.nrst(reset_button),
		.state(game_state),
		.mode(game_mode),
		.system_clk(main_clk)
	);
	t06_gameState state1(
		.button(start_pause_button),
		.badCollision(bad_collision),
		.clk(main_clk),
		.nrst(reset_button),
		.gameMode(game_state),
		.state(game_state)
	);
	t06_collisionDetector detectabc(
		.clk(main_clk),
		.wall_array(wall_locations),
		.nrst(reset_button),
		.check_enable(clk_body),
		.snakeHeadX(snake_head_x),
		.snakeHeadY(snake_head_y),
		.borderXMin(xmin),
		.borderXMax(xmax),
		.borderYMax(ymax),
		.borderYMin(ymin),
		.AppleX2(apple_location2[3:0]),
		.AppleY2(apple_location2[7:4]),
		.AppleX(apple_location[3:0]),
		.AppleY(apple_location[7:4]),
		.snakeArrayX(snakeArrayX),
		.snakeArrayY(snakeArrayY),
		.badCollision(bad_collision),
		.goodCollision(good_collision),
		.good_collision2(good_collision2)
	);
	t06_apple_luck_selector luck1(
		.clk(main_clk),
		.button(down_direction),
		.nrst(reset_button),
		.state(game_state),
		.apple_luck(apple_luck)
	);
	t06_game_speed_selector speed1(
		.system_clk(main_clk),
		.button(up_direction),
		.nrst(reset_button),
		.state(game_state),
		.game_speed(game_speed)
	);
	t06_syncEdge up_button(
		.clk(main_clk),
		.nreset(reset_button),
		.but(button_up_in),
		.direction(up_direction)
	);
	t06_syncEdge down_button(
		.clk(main_clk),
		.nreset(reset_button),
		.but(button_down_in),
		.direction(down_direction)
	);
	t06_syncEdge left_button(
		.clk(main_clk),
		.nreset(reset_button),
		.but(button_left_in),
		.direction(left_direction)
	);
	t06_syncEdge right_button(
		.clk(main_clk),
		.nreset(reset_button),
		.but(button_right_in),
		.direction(right_direction)
	);
	t06_syncEdge start_pause_button1(
		.clk(main_clk),
		.nreset(reset_button),
		.but(button_start_pause_in),
		.direction(start_pause_button)
	);
	t06_syncEdge reset_button1(
		.clk(main_clk),
		.nreset(~nrst),
		.but(button_reset_in),
		.direction(reset_button_a)
	);
	assign reset_button = ~(reset_button_a | nrst);
	t06_wall_wrapper walls(
		.system_clk(main_clk),
		.score(score),
		.nrst(reset_button),
		.x(x),
		.y(y),
		.enable_in2(game_mode == 2'b11),
		.good_collision(good_collision || good_collision2),
		.enable_in(game_mode == 2'b10),
		.apple_luck(apple_luck),
		.snake_head_x(snake_head_x),
		.snake_head_y(snake_head_y),
		.snakeArrayX(snakeArrayX),
		.snakeArrayY(snakeArrayY),
		.wall(wall_a),
		.xmax(xmax),
		.xmin(xmin),
		.ymax(ymax),
		.ymin(ymin),
		.wall_locations(wall_locations)
	);
	t06_apple_wrapper applesa(
		.system_clk(main_clk),
		.clk_body(clk_body),
		.nreset(reset_button),
		.good_collision(good_collision),
		.apple_luck(apple_luck),
		.snake_head_x(snake_head_x),
		.snake_head_y(snake_head_y),
		.xmax(xmax),
		.xmin(xmin),
		.ymin(ymin),
		.ymax(ymax),
		.snakeArrayX(snakeArrayX),
		.snakeArrayY(snakeArrayY),
		.enable_in(game_mode == 2'b00),
		.x(x),
		.y(y),
		.wall_locations(wall_locations),
		.apple(apple_a),
		.apple_location1(apple_location),
		.apple_location2(apple_location2),
		.good_collision2(good_collision2)
	);
	t06_body_wrapper bodymain1(
		.system_clk(main_clk),
		.body_clk(clk_body),
		.pause_clk(pause_clk),
		.nreset(reset_button),
		.good_collision(good_collision | good_collision2),
		.bad_collision(bad_collision),
		.enable(1'b1),
		.Direction(direction),
		.x(x),
		.y(y),
		.body(body_a),
		.head(head_a),
		.head_x(snake_head_x),
		.head_y(snake_head_y),
		.body_x(snakeArrayX),
		.body_y(snakeArrayY),
		.score(score)
	);
	t06_DirectionLogic direction1(
		.clk(main_clk),
		.bad_collision(bad_collision),
		.pause_clk(pause_clk),
		.nrst(reset_button),
		.up(up_direction),
		.down(down_direction),
		.left(left_direction),
		.right(right_direction),
		.directionOut(direction)
	);
	assign apple = apple_a & enable_total;
	assign wall = wall_a & enable_total;
	assign body = body_a & enable_total;
	assign head = head_a & enable_total;
	assign gameover = bad_collision & enable_total;
	assign rert = good_collision;
endmodule
