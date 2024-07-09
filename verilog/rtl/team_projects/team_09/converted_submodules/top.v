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
	wire clk;
	wire rst;
	wire goodColl_i;
	wire badColl_i;
	wire toggleMode_i;
	wire goodColl;
	wire badColl;
	wire toggleMode;
	wire [3:0] direction_i;
	wire [3:0] newDirection;
	wire [7:0] freq;
	wire playSound;
	wire mode_o;
	wire at_max;
	wire [7:0] soundOut;
	wire [1:0] junk;
	assign clk = hz100;
	assign rst = reset;
	assign direction_i = {pb[13], pb[5], pb[8], pb[10]};
	assign goodColl_i = pb[0];
	assign badColl_i = pb[1];
	assign toggleMode_i = pb[2];
	assign soundOut = {left[7], left[6], left[5], left[4], left[3], left[2], junk};
	posedge_detector posDetector1(
		.clk(clk),
		.nRst(~rst),
		.button_i(toggleMode_i),
		.button(toggleMode),
		.goodColl_i(goodColl_i),
		.badColl_i(badColl_i),
		.direction_i(direction_i),
		.goodColl(goodColl),
		.badColl(badColl),
		.direction(newDirection)
	);
	freq_selector_12M freq_12(
		.freq(freq),
		.goodColl_i(goodColl_i),
		.badColl_i(badColl_i),
		.direction_i(direction_i)
	);
	sound_fsm fsm1(
		.playSound(playSound),
		.mode_o(mode_o),
		.clk(clk),
		.nRst(~rst),
		.goodColl(goodColl),
		.badColl(badColl),
		.button(toggleMode),
		.direction(newDirection)
	);
	oscillator osc1(
		.at_max(at_max),
		.clk(clk),
		.nRst(~rst),
		.freq(freq),
		.state(mode_o),
		.playSound(playSound)
	);
	dac_counter dac1(
		.dacCount(soundOut),
		.clk(clk),
		.nRst(~rst),
		.at_max(at_max)
	);
endmodule
