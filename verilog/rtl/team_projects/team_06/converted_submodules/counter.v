module t06_counter (
	clk,
	nrst,
	max,
	enable,
	ratio,
	out
);
	reg _sv2v_0;
	input wire clk;
	input wire nrst;
	input wire [18:0] max;
	input wire enable;
	input wire [18:0] ratio;
	output reg out;
	reg [18:0] count_n;
	reg [18:0] count;
	reg [18:0] count1;
	reg [18:0] count1_n;
	always @(*) begin
		if (_sv2v_0)
			;
		if (count < ratio)
			count_n = count + 10;
		else
			count_n = 19'b0000000000000000000;
		if (count1 < max)
			count1_n = count1 + 10;
		else
			count1_n = 19'b0000000000000000000;
	end
	always @(posedge clk or negedge nrst)
		if (nrst == 1'b0) begin
			count <= 19'b0000000000000000000;
			count1 <= 19'b0000000000000000000;
		end
		else if (enable == 1'b0) begin
			count <= 19'b0000000000000000000;
			count1 <= 19'b0000000000000000000;
		end
		else begin
			count <= count_n;
			count1 <= count1_n;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		if (count >= count1)
			out = 1'b1;
		else
			out = 1'b0;
	end
	initial _sv2v_0 = 0;
endmodule
