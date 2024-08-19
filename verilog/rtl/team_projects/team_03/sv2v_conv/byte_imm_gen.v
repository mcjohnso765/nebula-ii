module t03_byte_imm_gen (
	b_out,
	imm_gen_byte
);
	input wire [31:0] b_out;
	output wire [31:0] imm_gen_byte;
	assign imm_gen_byte = {24'd0, b_out[7:0]};
endmodule
