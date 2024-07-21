module t06_clk_enable (
	clk,
	nrst,
	max_i,
	enable,
	out_enable
);
	reg _sv2v_0;
	input wire clk;
	input wire nrst;
	input wire [15:0] max_i;
	input wire enable;
	output reg out_enable;
	reg [15:0] innerCount;
	reg [15:0] count;
	always @(*) begin
		if (_sv2v_0)
			;
		innerCount = count + 1;
		if (count == max_i)
			innerCount = 16'b0000000000000000;
		out_enable = count == max_i;
	end
	always @(posedge clk or negedge nrst)
		if (nrst == 1'b0)
			count <= 16'b0000000000000000;
		else if (enable == 1'b1)
			count <= innerCount;
	initial _sv2v_0 = 0;
endmodule
