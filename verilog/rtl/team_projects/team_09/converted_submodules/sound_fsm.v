`default_nettype none
module t09_sound_fsm (
	clk,
	nRst,
	goodColl,
	badColl,
	button,
	direction,
	playSound,
	mode_o
);
	reg _sv2v_0;
	input wire clk;
	input wire nRst;
	input wire goodColl;
	input wire badColl;
	input wire button;
	input wire [3:0] direction;
	output reg playSound;
	output reg mode_o;
	reg next_state;
	reg next_playSound;
	always @(posedge clk or negedge nRst)
		if (~nRst) begin
			mode_o <= 1'b1;
			playSound <= 0;
		end
		else begin
			mode_o <= next_state;
			playSound <= next_playSound;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		next_playSound = playSound;
		next_state = mode_o;
		if (mode_o == 1'b1) begin
			if (button)
				next_state = 1'b0;
			next_playSound = ((goodColl || badColl) || |direction ? 1'b1 : 1'b0);
		end
		else begin
			if (button)
				next_state = 1'b1;
			next_playSound = 1'b0;
		end
	end
	initial _sv2v_0 = 0;
endmodule
