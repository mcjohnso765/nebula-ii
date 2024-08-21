`default_nettype none
module sample_register (
	MHz10,
	nrst,
	en,
	clear,
	store_samp,
	samp_acc,
	samp_out
);
	reg _sv2v_0;
	input wire MHz10;
	input wire nrst;
	input wire en;
	input wire clear;
	input wire store_samp;
	input wire [15:0] samp_acc;
	output reg [15:0] samp_out;
	reg [15:0] next_samp_out;
	always @(posedge MHz10 or negedge nrst)
		if (!nrst)
			samp_out <= 0;
		else
			samp_out <= next_samp_out;
	always @(*) begin
		if (_sv2v_0)
			;
		next_samp_out = samp_out;
		if (en) begin
			if (clear)
				next_samp_out = 0;
			else if (store_samp)
				next_samp_out = samp_acc;
		end
	end
	initial _sv2v_0 = 0;
endmodule
