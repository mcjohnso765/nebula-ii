module t06_clk_div (
	clk,
	nrst,
	max_i,
	atmax_o
);
	reg _sv2v_0;
	input wire clk;
	input wire nrst;
	input wire [18:0] max_i;
	output reg atmax_o;
	reg [18:0] innerCount;
	reg [18:0] count;
	always @(*) begin
		if (_sv2v_0)
			;
		innerCount = count + 1;
		if (count == max_i)
			innerCount = 19'b0000000000000000000;
		atmax_o = count == max_i;
	end
	always @(posedge clk or negedge nrst)
		if (nrst == 1'b0)
			count <= 19'b0000000000000000000;
		else
			count <= innerCount;
	initial _sv2v_0 = 0;
endmodule
