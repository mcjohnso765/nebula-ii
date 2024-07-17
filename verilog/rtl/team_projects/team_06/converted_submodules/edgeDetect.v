module t06_edgeDetect (
	D,
	clk,
	nrst,
	edg
);
	reg _sv2v_0;
	input wire D;
	input wire clk;
	input wire nrst;
	output reg edg;
	reg Q1;
	reg Q2;
	reg Q1_n;
	reg Q2_n;
	always @(*) begin
		if (_sv2v_0)
			;
		Q1_n = D;
		Q2_n = Q1;
	end
	always @(posedge clk or negedge nrst)
		if (~nrst) begin
			Q1 <= 1'b0;
			Q2 <= 1'b0;
		end
		else begin
			Q1 <= Q1_n;
			Q2 <= Q2_n;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		edg = Q1 & ~Q2;
	end
	initial _sv2v_0 = 0;
endmodule
