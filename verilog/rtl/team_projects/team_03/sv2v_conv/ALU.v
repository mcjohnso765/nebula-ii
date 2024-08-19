module t03_ALU (
	srda,
	imm_gen,
	srdb,
	rda_u,
	rdb_u,
	fop,
	alu_mux_en,
	u,
	result,
	Z,
	N,
	V
);
	reg _sv2v_0;
	input wire signed [31:0] srda;
	input wire signed [31:0] imm_gen;
	input wire signed [31:0] srdb;
	input wire [31:0] rda_u;
	input wire [31:0] rdb_u;
	input wire [3:0] fop;
	input wire alu_mux_en;
	input wire u;
	output reg [31:0] result;
	output wire Z;
	output wire N;
	output reg V;
	reg [31:0] rda;
	wire [31:0] rdb;
	reg [31:0] rdb_mux;
	always @(*) begin
		if (_sv2v_0)
			;
		if (!u) begin
			rda = srda;
			rdb_mux = srdb;
		end
		else begin
			rda = rda_u;
			rdb_mux = rdb_u;
		end
	end
	assign rdb = (alu_mux_en ? imm_gen : rdb_mux);
	always @(*) begin
		if (_sv2v_0)
			;
		case (fop)
			FOP_ADD: result = rda + rdb;
			FOP_SUB: result = rda - rdb;
			FOP_SLL: result = rda << rdb;
			FOP_SRL: result = rda >> rdb;
			FOP_SRA: result = rda >>> rdb;
			FOP_AND: result = rda & rdb;
			FOP_OR: result = rda | rdb;
			FOP_XOR: result = rda ^ rdb;
			FOP_IMM: result = imm_gen;
			default: result = 1'sb0;
		endcase
	end
	assign Z = (result == 0 ? 1'b1 : 1'b0);
	assign N = result[31];
	always @(*) begin
		if (_sv2v_0)
			;
		if (fop == FOP_ADD) begin
			if (((rda[31] && rdb[31]) && !result[31]) || ((!rda[31] && !rdb[31]) && result[31]))
				V = 1'b1;
			else
				V = 1'sb0;
		end
		else if (fop == FOP_SUB) begin
			if (((rda[31] && !rdb[31]) && !result[31]) || ((!rda[31] && rdb[31]) && result[31]))
				V = 1'b1;
			else
				V = 1'sb0;
		end
		else
			V = 1'sb0;
	end
	initial _sv2v_0 = 0;
endmodule
