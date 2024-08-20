

module t02_signExtender (
input logic[19:0] imm,
input logic[5:0] CUOp,
output logic[31:0] immOut
);

	typedef enum logic [5:0] {
		CU_LUI, CU_AUIPC, CU_JAL, CU_JALR, 
		CU_BEQ, CU_BNE, CU_BLT, CU_BGE, CU_BLTU, CU_BGEU, 
		CU_LB, CU_LH, CU_LW, CU_LBU, CU_LHU, CU_SB, CU_SH, CU_SW, 
		CU_ADDI, CU_SLTI, CU_SLTIU, CU_SLIU, CU_XORI, CU_ORI, CU_ANDI, CU_SLLI, CU_SRLI, CU_SRAI, 
		CU_ADD, CU_SUB, CU_SLL, CU_SLT, CU_SLTU, CU_XOR, CU_SRL, CU_SRA, CU_OR, CU_AND,
		CU_ERROR, CU_HALT
	} cuOPType;

always_comb begin
//JAL operation
if (CUOp == CU_JAL)
    immOut = {{13{imm[19]}}, imm[7:0], imm[8], imm[18:9]};
//All branch operations
else if (CUOp == CU_BEQ || CUOp == CU_BNE || CUOp == CU_BLT || CUOp == CU_BGE || CUOp == CU_BLTU || CUOp == CU_BGEU)
    //immOut = {{20{imm[11]}}, imm[11], imm[9:4], imm[3:0], imm[10]}
	immOut = {{21{imm[11]}}, imm[0], imm[10:5], imm[4:1]};
//other operations that are signed
else if (CUOp == CU_ADDI || CUOp == CU_SUB || CUOp == CU_ADD || CUOp == CU_SLTI || CUOp == CU_SLT)
    immOut = {{20{imm[11]}}, imm[11:0]};
//all other operations
else if (CUOp == CU_LUI || CUOp == CU_AUIPC)
    immOut = {imm, 12'b0};
else
    immOut = {{20{imm[11]}}, imm[11:0]};
end
endmodule