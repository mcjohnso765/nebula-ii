`default_nettype none
module t06_display_wrapper (
	score,
	clk,
	nreset,
	game_mode,
	game_speed,
	game_state,
	apple_luck,
	out1,
	out2,
	out3,
	out4
);
	input wire [7:0] score;
	input wire clk;
	input wire nreset;
	input wire [1:0] game_mode;
	input wire [1:0] game_speed;
	input wire [1:0] game_state;
	input wire [1:0] apple_luck;
	output wire out1;
	output wire out2;
	output wire out3;
	output wire [7:0] out4;
	wire [127:0] row_top;
	wire [127:0] row_bot;
	t06_display dis(
		.gameState(game_state),
		.gameMode(game_mode),
		.appleLuck(apple_luck),
		.gameSpeed(game_speed),
		.score(score),
		.row_top(row_top),
		.row_bot(row_bot)
	);
	t06_lcd1602 L1(
		.clk(clk),
		.rst(nreset),
		.row_1(row_top),
		.row_2(row_bot),
		.lcd_en(out1),
		.lcd_rw(out2),
		.lcd_rs(out3),
		.lcd_data(out4)
	);
endmodule
