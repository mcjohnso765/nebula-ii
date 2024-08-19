module t06_syncEdge (
	clk,
	nreset,
	but,
	direction
);
	input wire clk;
	input wire nreset;
	input wire but;
	output wire direction;
	wire out1;
	t06_sync sync1(
		.in(but),
		.clk(clk),
		.nrst(nreset),
		.out(out1)
	);
	t06_edgeDetect eD1(
		.D(out1),
		.clk(clk),
		.nrst(nreset),
		.edg(direction)
	);
endmodule
