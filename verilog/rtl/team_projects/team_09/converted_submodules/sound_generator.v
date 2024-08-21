module t09_sound_generator (
	clk,
	rst,
	goodColl_i,
	badColl_i,
	button_i,
	soundOut
);
	parameter N = 8;
	input wire clk;
	input wire rst;
	input wire goodColl_i;
	input wire badColl_i;
	input wire button_i;
	output wire [N - 1:0] soundOut;
	wire goodColl;
	wire badColl;
	wire toggleMode;
	wire [3:0] newDirection;
	wire [7:0] freq;
	wire playSound;
	wire at_max;
	t09_sound_posedge_detector posDetector1(
		.clk(clk),
		.nRst(~rst),
		.button_i(button_i),
		.goodColl_i(goodColl_i),
		.badColl_i(badColl_i),
		.goodColl(goodColl),
		.badColl(badColl)
	);
	t09_oscillator osc1(
		.at_max(at_max),
		.clk(clk),
		.nRst(~rst),
		.goodColl(goodColl),
		.badColl(badColl)
	);
	t09_dac_counter dac1(
		.dacCount(soundOut),
		.clk(clk),
		.nRst(~rst),
		.at_max(at_max)
	);
endmodule
