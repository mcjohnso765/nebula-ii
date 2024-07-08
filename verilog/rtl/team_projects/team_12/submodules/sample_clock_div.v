`default_nettype none
module sample_clock_div (
	MHz10,
	nrst,
	en,
	samp_enable
);
	reg _sv2v_0;
	input wire MHz10;
	input wire nrst;
	input wire en;
	output reg samp_enable;
	reg [7:0] count;
	reg [7:0] next_count;
	always @(posedge MHz10 or negedge nrst)
		if (!nrst)
			count <= 0;
		else
			count <= next_count;
	always @(*) begin
		if (_sv2v_0)
			;
		samp_enable = 0;
		next_count = count + 1;
		if (en) begin
			if (count >= 226) begin
				next_count = 0;
				samp_enable = 1;
			end
		end
	end
	initial _sv2v_0 = 0;
endmodule
