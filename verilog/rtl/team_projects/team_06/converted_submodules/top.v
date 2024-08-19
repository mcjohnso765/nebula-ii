`default_nettype none
module top (
	hz100,
	reset,
	pb,
	left,
	right,
	ss7,
	ss6,
	ss5,
	ss4,
	ss3,
	ss2,
	ss1,
	ss0,
	red,
	green,
	blue,
	txdata,
	rxdata,
	txclk,
	rxclk,
	txready,
	rxready
);
	input wire hz100;
	input wire reset;
	input wire [20:0] pb;
	output wire [7:0] left;
	output wire [7:0] right;
	output wire [7:0] ss7;
	output wire [7:0] ss6;
	output wire [7:0] ss5;
	output wire [7:0] ss4;
	output wire [7:0] ss3;
	output wire [7:0] ss2;
	output wire [7:0] ss1;
	output wire [7:0] ss0;
	output wire red;
	output wire green;
	output wire blue;
	output wire [7:0] txdata;
	input wire [7:0] rxdata;
	output wire txclk;
	output wire rxclk;
	input wire txready;
	input wire rxready;
	wire reseta;
	t06_assembly game(
		.clk(hz100),
		.nrst(reset),
		.enable(1'b1),
		.keyenc(pb[0]),
		.button_right_in(pb[5]),
		.button_left_in(pb[7]),
		.button_up_in(pb[10]),
		.button_down_in(pb[6]),
		.button_start_pause_in(pb[1]),
		.d({ss7[7], ss7[6], ss7[5], ss7[4], ss7[3], ss7[2], ss7[1], ss7[0]}),
		.wr(ss6[7]),
		.dcx(ss6[6]),
		.song(left[1]),
		.rert(reseta),
		.rs(ss1[1]),
		.rw(ss1[0]),
		.en(ss1[2]),
		.lcd8(ss0)
	);
endmodule
