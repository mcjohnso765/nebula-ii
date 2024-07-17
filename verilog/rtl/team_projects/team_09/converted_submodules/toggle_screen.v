`default_nettype none
module t09_toggle_screen (
	clk,
	rst,
	bcd_ones,
	bcd_tens,
	bcd_hundreds,
	displayOut,
	blinkToggle
);
	reg _sv2v_0;
	input wire clk;
	input wire rst;
	input wire [3:0] bcd_ones;
	input wire [3:0] bcd_tens;
	input wire [3:0] bcd_hundreds;
	output reg [3:0] displayOut;
	output reg [1:0] blinkToggle;
	reg [1:0] nextBlinkToggle;
	reg [3:0] nextDisplayOut;
	always @(posedge clk or negedge rst)
		if (~rst) begin
			blinkToggle <= 2'b00;
			displayOut <= 0;
		end
		else begin
			blinkToggle <= nextBlinkToggle;
			displayOut <= nextDisplayOut;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		nextBlinkToggle = 2'b00;
		nextDisplayOut = 4'b0000;
		if (blinkToggle < 2'd2)
			nextBlinkToggle = blinkToggle + 2'b01;
		else
			nextBlinkToggle = 2'b00;
		if (blinkToggle == 0)
			nextDisplayOut = bcd_ones;
		else if (blinkToggle == 1)
			nextDisplayOut = bcd_tens;
		else
			nextDisplayOut = bcd_hundreds;
	end
	initial _sv2v_0 = 0;
endmodule
