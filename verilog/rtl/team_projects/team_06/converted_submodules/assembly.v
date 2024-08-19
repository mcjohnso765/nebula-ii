`default_nettype none
module t06_assembly (
	clk,
	nrst,
	enable,
	keyenc,
	button_right_in,
	button_left_in,
	button_up_in,
	button_down_in,
	button_start_pause_in,
	d,
	lcd8,
	wr,
	dcx,
	song,
	rert,
	rs,
	rw,
	en
);
	input wire clk;
	input wire nrst;
	input wire enable;
	input wire keyenc;
	input wire button_right_in;
	input wire button_left_in;
	input wire button_up_in;
	input wire button_down_in;
	input wire button_start_pause_in;
	output wire [7:0] d;
	output wire [7:0] lcd8;
	output wire wr;
	output wire dcx;
	output wire song;
	output wire rert;
	output wire rs;
	output wire rw;
	output wire en;
	wire [3:0] x;
	wire [3:0] y;
	wire head;
	wire body;
	wire apple;
	wire wall;
	wire gameover;
	wire button_reset_in;
	t06_image_generator writer(
		.clk(clk),
		.nrst(~nrst),
		.snakeBody(body),
		.snakeHead(head),
		.apple(apple),
		.border(wall),
		.KeyEnc(keyenc),
		.GameOver(gameover),
		.sync(button_reset_in),
		.wr(wr),
		.dcx(dcx),
		.D(d),
		.x(x),
		.y(y)
	);
	t06_main_file CPU(
		.clk(clk),
		.nrst(nrst),
		.button_right_in(button_right_in),
		.button_left_in(button_left_in),
		.button_up_in(button_up_in),
		.button_down_in(button_down_in),
		.button_reset_in(button_reset_in),
		.button_start_pause_in(button_start_pause_in),
		.enable_total(enable),
		.x(x),
		.y(y),
		.apple(apple),
		.wall(wall),
		.body(body),
		.head(head),
		.gameover(gameover),
		.song(song),
		.rert(rert),
		.rs(rs),
		.rw(rw),
		.en(en),
		.lcd8(lcd8)
	);
endmodule
