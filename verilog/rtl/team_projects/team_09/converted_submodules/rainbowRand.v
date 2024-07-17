module t09_rainbowRand (
	clk,
	reset,
	enable,
	rainbowRNG
);
	reg _sv2v_0;
	input wire clk;
	input wire reset;
	input wire enable;
	output reg [15:0] rainbowRNG;
	reg [15:0] next_rainbowRNG;
	always @(posedge clk or negedge reset)
		if (reset == 0)
			rainbowRNG <= 0;
		else
			rainbowRNG <= next_rainbowRNG;
	always @(*) begin
		if (_sv2v_0)
			;
		if (enable == 1)
			next_rainbowRNG = rainbowRNG;
		else if ((rainbowRNG + 1) > 65535)
			next_rainbowRNG = 1;
		else
			next_rainbowRNG = rainbowRNG + 1;
	end
	initial _sv2v_0 = 0;
endmodule
