module t09_edge_detect (
	signal,
	clk,
	nrst,
	change_state
);
	input wire signal;
	input wire clk;
	input wire nrst;
	output wire change_state;
	reg [1:0] Q;
	always @(posedge clk or negedge nrst)
		if (~nrst)
			Q <= 0;
		else
			Q <= {Q[0], signal};
	assign change_state = Q[0] & ~Q[1];
endmodule
