
module t02_writeToReg (
    input logic [31:0] memload, pc, aluOut, imm,
    input logic negative,
    input logic [5:0] cuOP,
    output logic [31:0] writeData
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
    case(cuOP)
        CU_LB: writeData = {{24{memload[7]}}, memload[7:0]};
        CU_LH: writeData = {{16{memload[7]}}, memload[15:0]};
        CU_LW: writeData = memload;
        CU_LBU: writeData = {24'b0, memload[7:0]};
        CU_LHU: writeData = {16'b0, memload[15:0]};
        CU_AUIPC: writeData = pc + {imm[31:12], 12'b0};
        CU_LUI: writeData = {imm[31:12], 12'b0};
        CU_JAL: writeData = pc + 4;
        CU_JALR: writeData = pc + 4;
        default: writeData = aluOut;
    endcase
end






endmodule