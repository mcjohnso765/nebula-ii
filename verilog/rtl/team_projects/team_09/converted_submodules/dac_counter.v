module t09_dac_counter (
	clk,
	nRst,
	at_max,
	dacCount
);
	reg _sv2v_0;
	parameter N = 8;
	input wire clk;
	input wire nRst;
	input wire at_max;
	output reg [N - 1:0] dacCount;
	reg [N - 1:0] dacCount_nxt;
	always @(posedge clk or negedge nRst)
		if (~nRst)
			dacCount <= 0;
		else
			dacCount <= dacCount_nxt;
	always @(*) begin
		if (_sv2v_0)
			;
		if (at_max)
			dacCount_nxt = dacCount + 1;
		else
			dacCount_nxt = dacCount;
	end
	initial _sv2v_0 = 0;
endmodule
