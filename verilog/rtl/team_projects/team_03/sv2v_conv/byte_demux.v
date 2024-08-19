module t03_byte_demux (
	reg_b,
	store_byte_en,
	b_out
);
	reg _sv2v_0;
	input wire [31:0] reg_b;
	input wire store_byte_en;
	output reg [31:0] b_out;
	always @(*) begin
		if (_sv2v_0)
			;
		if (store_byte_en)
			b_out = {24'd0, reg_b[7:0]};
		else
			b_out = reg_b;
	end
	initial _sv2v_0 = 0;
endmodule
