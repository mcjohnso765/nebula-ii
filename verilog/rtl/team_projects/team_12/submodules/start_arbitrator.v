`default_nettype none
module start_arbitrator (
	MHz10,
	nrst,
	start_in,
	avail,
	start_out
);
	reg _sv2v_0;
	parameter N = 13;
	input wire MHz10;
	input wire nrst;
	input wire start_in;
	input wire [N - 1:0] avail;
	output reg [N - 1:0] start_out;
	reg [N - 1:0] start_out_intmd;
	always @(*) begin : fresher_code
		if (_sv2v_0)
			;
		start_out_intmd = 0;
		if (|avail) begin : sv2v_autoblock_1
			reg signed [31:0] i;
			for (i = N - 1; i >= 0; i = i - 1)
				if (avail[i])
					start_out_intmd = 1 << i;
		end
		start_out = (start_in ? start_out_intmd : 0);
	end
	initial _sv2v_0 = 0;
endmodule
