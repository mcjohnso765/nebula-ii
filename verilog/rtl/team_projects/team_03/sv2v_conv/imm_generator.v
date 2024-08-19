module t03_imm_generator (
	inst,
	type_i,
	imm_gen
);
	reg _sv2v_0;
	input wire [31:0] inst;
	input wire [2:0] type_i;
	output reg [31:0] imm_gen;
	always @(*) begin
		if (_sv2v_0)
			;
		case (type_i)
			I: imm_gen = {{20 {inst[31]}}, inst[31:20]};
			S: imm_gen = {{20 {inst[31]}}, inst[31:25], inst[11:7]};
			SB: imm_gen = {{20 {inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};
			U: imm_gen = {inst[31:12], 12'd0};
			UJ: imm_gen = {{12 {inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0};
			default: imm_gen = 1'sb0;
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
