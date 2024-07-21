module t09_synchronizer (
	button,
	clk,
	nrst,
	signal
);
	input wire button;
	input wire clk;
	input wire nrst;
	output wire signal;
	reg [1:0] Q;
	always @(posedge clk or negedge nrst)
		if (~nrst)
			Q <= 0;
		else
			Q <= {Q[0], button};
	assign signal = Q[1];
endmodule
