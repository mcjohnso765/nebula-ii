module t09_snake_body_controller (
	direction_pb,
	x,
	y,
	clk,
	pb_mode,
	nrst,
	sync,
	curr_length,
	body,
	snakeHead,
	snakeBody
);
	parameter MAX_LENGTH = 50;
	input wire [3:0] direction_pb;
	input wire [3:0] x;
	input wire [3:0] y;
	input wire clk;
	input wire pb_mode;
	input wire nrst;
	input wire sync;
	input wire [7:0] curr_length;
	output wire [(MAX_LENGTH * 8) - 1:0] body;
	output wire snakeHead;
	output wire snakeBody;
	wire [(MAX_LENGTH * 8) - 1:0] temp_body;
	wire pulse;
	wire snake_head;
	wire snake_body;
	wire [2:0] direction;
	wire [3:0] direction_i;
	wire [3:0] direction_a;
	wire [7:0] head;
	t09_variable_clock_divider divider(
		.clk(clk),
		.nrst(nrst),
		.button(pb_mode),
		.adjusted_clk(pulse)
	);
	t09_synchronizer button1(
		.button(direction_pb[0]),
		.clk(clk),
		.nrst(nrst),
		.signal(direction_i[0])
	);
	t09_synchronizer button2(
		.button(direction_pb[1]),
		.clk(clk),
		.nrst(nrst),
		.signal(direction_i[1])
	);
	t09_synchronizer button3(
		.button(direction_pb[2]),
		.clk(clk),
		.nrst(nrst),
		.signal(direction_i[2])
	);
	t09_synchronizer button4(
		.button(direction_pb[3]),
		.clk(clk),
		.nrst(nrst),
		.signal(direction_i[3])
	);
	t09_edge_detect detect1(
		.signal(direction_i[0]),
		.clk(clk),
		.nrst(nrst),
		.change_state(direction_a[0])
	);
	t09_edge_detect detect2(
		.signal(direction_i[1]),
		.clk(clk),
		.nrst(nrst),
		.change_state(direction_a[1])
	);
	t09_edge_detect detect3(
		.signal(direction_i[2]),
		.clk(clk),
		.nrst(nrst),
		.change_state(direction_a[2])
	);
	t09_edge_detect detect4(
		.signal(direction_i[3]),
		.clk(clk),
		.nrst(nrst),
		.change_state(direction_a[3])
	);
	t09_fsm_direction fsm(
		.direction_a(direction_a),
		.clk(clk),
		.nrst(nrst),
		.pulse(pulse),
		.sync(sync),
		.direction(direction)
	);
	t09_update_body #(.MAX_LENGTH(MAX_LENGTH)) body_update(
		.clk(clk),
		.nrst(nrst),
		.pulse(pulse),
		.sync(sync),
		.direction(direction),
		.curr_length(curr_length),
		.body(temp_body),
		.head(head)
	);
	t09_location_check #(.MAX_LENGTH(MAX_LENGTH)) check(
		.coordinate({x, y}),
		.body(temp_body),
		.curr_length(curr_length),
		.clk(clk),
		.nrst(nrst),
		.snakeBody(snakeBody),
		.snakeHead(snakeHead)
	);
	assign body = temp_body;
endmodule
