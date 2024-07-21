module t09_image_generator (
	snakeBody,
	snakeHead,
	apple,
	border,
	KeyEnc,
	GameOver,
	clk,
	nrst,
	sync,
	dcx,
	wr,
	D,
	x,
	y
);
	input wire snakeBody;
	input wire snakeHead;
	input wire apple;
	input wire border;
	input wire KeyEnc;
	input wire GameOver;
	input wire clk;
	input wire nrst;
	output wire sync;
	output wire dcx;
	output wire wr;
	output wire [7:0] D;
	output wire [3:0] x;
	output wire [3:0] y;
	wire cmd_done;
	wire enable_loop;
	wire init_cycle;
	wire en_update;
	wire diff;
	wire [2:0] obj_code;
	t09_fsm_control control(
		.GameOver(GameOver),
		.cmd_done(cmd_done),
		.diff(diff),
		.clk(clk),
		.nrst(nrst),
		.mode_pb(KeyEnc),
		.enable_loop(enable_loop),
		.init_cycle(init_cycle),
		.en_update(en_update),
		.sync_reset(sync)
	);
	t09_frame_tracker tracker(
		.body(snakeBody),
		.head(snakeHead),
		.apple(apple),
		.border(border),
		.enable(enable_loop),
		.clk(clk),
		.nrst(nrst),
		.sync(sync),
		.obj_code(obj_code),
		.x(x),
		.y(y),
		.diff(diff)
	);
	t09_pixel_updater updater(
		.init_cycle(init_cycle),
		.en_update(en_update),
		.clk(clk),
		.nrst(nrst),
		.x(x),
		.y(y),
		.obj_code(obj_code),
		.cmd_done(cmd_done),
		.wr(wr),
		.dcx(dcx),
		.D(D)
	);
endmodule
