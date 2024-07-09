`default_nettype none
module oscillator (
	clk,
	nRst,
	freq,
	state,
	playSound,
	at_max
);
	reg _sv2v_0;
	parameter N = 8;
	input wire clk;
	input wire nRst;
	input wire [7:0] freq;
	input wire state;
	input wire playSound;
	output reg at_max;
	reg [N - 1:0] count;
	reg [N - 1:0] count_nxt;
	reg at_max_nxt;
	always @(posedge clk or negedge nRst)
		if (~nRst) begin
			count <= 0;
			at_max <= 0;
		end
		else begin
			count <= count_nxt;
			at_max <= at_max_nxt;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		at_max_nxt = at_max;
		count_nxt = count;
		if (at_max == 1'b1)
			at_max_nxt = 1'b0;
		if ((state == 1'b1) && playSound) begin
			if (count < freq)
				count_nxt = count + 1;
			else if (count >= freq) begin
				at_max_nxt = 1'b1;
				count_nxt = 0;
			end
		end
		else if ((state == 1'b0) || ~playSound) begin
			count_nxt = 0;
			at_max_nxt = 1'b0;
		end
	end
	initial _sv2v_0 = 0;
endmodule
