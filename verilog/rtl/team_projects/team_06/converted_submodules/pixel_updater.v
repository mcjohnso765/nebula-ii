`default_nettype none
module t06_pixel_updater (
	init_cycle,
	en_update,
	clk,
	nrst,
	x,
	y,
	obj_code,
	cmd_done,
	wr,
	dcx,
	D
);
	input wire init_cycle;
	input wire en_update;
	input wire clk;
	input wire nrst;
	input wire [3:0] x;
	input wire [3:0] y;
	input wire [2:0] obj_code;
	output wire cmd_done;
	output wire wr;
	output wire dcx;
	output wire [7:0] D;
	wire [2:0] mode;
	wire cmd_finished;
	wire pause;
	t06_update_controller update(
		.init_cycle(init_cycle),
		.en_update(en_update),
		.clk(clk),
		.nrst(nrst),
		.cmd_finished(cmd_finished),
		.pause(pause),
		.cmd_done(cmd_done),
		.wr(wr),
		.mode(mode)
	);
	t06_command_lut2 commands(
		.mode(mode),
		.clk(clk),
		.nrst(nrst),
		.obj_code(obj_code),
		.X(x),
		.Y(y),
		.cmd_finished(cmd_finished),
		.D(D),
		.dcx(dcx),
		.pause(pause)
	);
endmodule
