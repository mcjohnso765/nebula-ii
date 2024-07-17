`default_nettype none
module t06_body_wrapper (
	system_clk,
	body_clk,
	pause_clk,
	nreset,
	good_collision,
	bad_collision,
	enable,
	Direction,
	x,
	y,
	body,
	head,
	head_x,
	head_y,
	body_x,
	body_y,
	score
);
	input wire system_clk;
	input wire body_clk;
	input wire pause_clk;
	input wire nreset;
	input wire good_collision;
	input wire bad_collision;
	input wire enable;
	input wire [1:0] Direction;
	input wire [3:0] x;
	input wire [3:0] y;
	output wire body;
	output wire head;
	output wire [3:0] head_x;
	output wire [3:0] head_y;
	parameter MAX_LENGTH = 30;
	output wire [(MAX_LENGTH * 4) - 1:0] body_x;
	output wire [(MAX_LENGTH * 4) - 1:0] body_y;
	output wire [7:0] score;
	wire collision;
	t06_body_control main(
		.main_clk(system_clk),
		.body_clk(body_clk),
		.pause_clk(pause_clk),
		.nrst(nreset),
		.goodCollision(good_collision),
		.badCollision(bad_collision),
		.enable(enable),
		.Direction(Direction),
		.head_x(head_x),
		.head_y(head_y),
		.body_x(body_x),
		.body_y(body_y),
		.score(score)
	);
	t06_collisionLogic col(
		.next_head({y, x}),
		.body_x(body_x),
		.body_y(body_y),
		.collision(collision)
	);
	assign body = collision;
	assign head = {x, y} == {head_x, head_y};
endmodule
