`default_nettype none
module t09_freq_selector_10M (
	goodColl_i,
	badColl_i,
	direction_i,
	freq
);
	reg _sv2v_0;
	input wire goodColl_i;
	input wire badColl_i;
	input wire [3:0] direction_i;
	output reg [7:0] freq;
	always @(*) begin
		if (_sv2v_0)
			;
		freq = 0;
		if (goodColl_i)
			freq = 8'd89;
		if (badColl_i)
			freq = 8'd126;
		if (|direction_i)
			freq = 8'd149;
	end
	initial _sv2v_0 = 0;
endmodule
