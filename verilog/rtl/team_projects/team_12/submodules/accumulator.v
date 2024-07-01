module accumulator (
	MHz10,
	nrst,
	en,
	clear,
	accumulate,
	isprevzero,
	sample_mono,
	current_sum
);
	reg _sv2v_0;
	input wire MHz10;
	input wire nrst;
	input wire en;
	input wire clear;
	input wire accumulate;
	input wire isprevzero;
	input wire [8:0] sample_mono;
	output reg [11:0] current_sum;
	reg [11:0] next_sum;
	always @(posedge MHz10 or negedge nrst)
		if (!nrst)
			current_sum <= 0;
		else if (en)
			current_sum <= next_sum;
	always @(*) begin
		if (_sv2v_0)
			;
		next_sum = current_sum;
		if (clear)
			next_sum = 0;
		else if (accumulate && !isprevzero)
			next_sum = current_sum + {3'b000, sample_mono};
	end
	initial _sv2v_0 = 0;
endmodule
