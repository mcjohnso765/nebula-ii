module t06_sync (
	in,
	clk,
	nrst,
	out
);
	reg _sv2v_0;
	input wire in;
	input wire clk;
	input wire nrst;
	output reg out;
	reg Q;
	reg Q1;
	reg Q_n;
	reg Q1_n;
	always @(*) begin
		if (_sv2v_0)
			;
		Q_n = in;
		Q1_n = Q;
	end
	always @(posedge clk or negedge nrst)
		if (~nrst) begin
			Q <= 1'b0;
			Q1 <= 1'b0;
		end
		else begin
			Q <= Q_n;
			Q1 <= Q1_n;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		out = Q1;
	end
	initial _sv2v_0 = 0;
endmodule
