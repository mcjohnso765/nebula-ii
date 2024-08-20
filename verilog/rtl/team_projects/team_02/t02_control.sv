module t02_control(
	input logic [31:0] instruction,
	output logic [4:0] reg_1, reg_2, rd,
	output logic [19:0] imm,
	output logic [3:0] aluOP,
	output logic [5:0] cuOP,
	output logic regWrite, memWrite, memRead, aluSrc
);

	typedef enum logic [5:0] {
		CU_LUI, CU_AUIPC, CU_JAL, CU_JALR, 
		CU_BEQ, CU_BNE, CU_BLT, CU_BGE, CU_BLTU, CU_BGEU, 
		CU_LB, CU_LH, CU_LW, CU_LBU, CU_LHU, CU_SB, CU_SH, CU_SW, 
		CU_ADDI, CU_SLTI, CU_SLTIU, CU_SLIU, CU_XORI, CU_ORI, CU_ANDI, CU_SLLI, CU_SRLI, CU_SRAI, 
		CU_ADD, CU_SUB, CU_SLL, CU_SLT, CU_SLTU, CU_XOR, CU_SRL, CU_SRA, CU_OR, CU_AND,
		CU_ERROR, CU_HALT
	} cuOPType;	
	typedef enum logic [6:0] {
		RTYPE = 7'b0110011,
		ITYPE = 7'b0010011,
		STORE = 7'b0100011,
		LOAD = 7'b0000011,
		BTYPE = 7'b1100011,
		JALR = 7'b1100111,
		JAL = 7'b1101111,
		AUIPC = 7'b0010111,
		LUI = 7'b0110111
	} opCode_t;	

	typedef enum logic [3:0] {
		ALU_ADD = 0, 
		ALU_SUB = 1,
		ALU_OR = 2, 
		ALU_XOR = 3, 
		ALU_AND = 4, 
		ALU_SLL = 5, 
		ALU_SRA = 6, 
		ALU_SLTU = 7, 
		ALU_SLT = 8,
		ALU_SRL = 9
	}aluOPType;

	typedef enum logic [2:0] {
		ADDI = 3'b000,
		SLTI = 3'b010,
		SLTIU = 3'b011,
		XORI = 3'b100,
		SLLI = 3'b001,
		SRLI = 3'b101,
		ORI = 3'b110,
		ANDI = 3'b111
	} ifunc_t;

	typedef enum logic [2:0] {
		ADD = 3'b000,
		SLL = 3'b001,
		SLT = 3'b010,
		SLTU = 3'b011,
		XOR = 3'b100,
		SRL = 3'b101,
		OR = 3'b110,
		AND = 3'b111
	} rfunc_t;

always_comb begin
	reg_1 = 0;
	reg_2 = 0;
	rd = 0;
	imm = 20'b0;
	regWrite=0; 
	memWrite=0; 
	memRead=0; 
	aluSrc=0;
	aluOP = '0; //
	if (instruction == 32'hffffffff) begin
		cuOP = CU_HALT;
	end
	else begin


	casez (instruction[6:0])
	(LUI): begin
		cuOP = CU_LUI;
		imm = instruction[31:12];
		rd = instruction[11:7];
		regWrite = 1;
	end
	(AUIPC): begin
		cuOP = CU_AUIPC;
		imm = instruction[31:12];
		rd = instruction[11:7];
		regWrite = 1;
	end
	(JAL): begin
		cuOP = CU_JAL;
		imm = instruction[31:12];
		rd = instruction[11:7];
		regWrite = 1;
	end
	(JALR): begin
		cuOP = CU_JALR;
		imm = {8'b0, instruction[31:20]};
		reg_1 = instruction[19:15];
		rd = instruction[11:7];
		regWrite = 1;
	end
	(BTYPE): begin
		reg_1 = instruction[19:15];
		reg_2 = instruction[24:20];
		imm = {8'b0, instruction[31:25], instruction[11:7]};
		aluOP = ALU_SUB;
		casez(instruction[14:12])
		3'b000: cuOP = CU_BEQ;
		3'b001: cuOP = CU_BNE; 
		3'b100: cuOP = CU_BLT; 
		3'b101: cuOP = CU_BGE; 
		3'b110: cuOP = CU_BLTU; 
		3'b111: cuOP = CU_BGEU; 
		default: cuOP = CU_ERROR;
		endcase
	end
	(LOAD): begin
		reg_1 = instruction[19:15];
		rd = instruction[11:7];
		imm = {8'b0, instruction[31:20]};
		regWrite = 1;
		aluSrc = 1;
		memRead = 1;
		aluOP = ALU_ADD;
		casez(instruction[14:12])
		3'b000: cuOP = CU_LB; 
		3'b001: cuOP = CU_LH; 
		3'b010: cuOP = CU_LW; 
		3'b100: cuOP = CU_LBU; 
		3'b101: cuOP = CU_LHU; 
		default: cuOP = CU_ERROR;
		endcase
	end
	(STORE): begin
		reg_1 = instruction[19:15];
		reg_2 = instruction[24:20];
		imm = {8'b0, instruction[31:25], instruction[11:7]};
		memWrite = 1;
		aluSrc = 1;
		aluOP = ALU_ADD;
		casez(instruction[14:12])
		3'b000: cuOP = CU_SB;
		3'b001: cuOP = CU_SH;
		3'b010: cuOP = CU_SW;
		default: cuOP = CU_ERROR;
		endcase
	end
	(ITYPE): begin
		reg_1 = instruction[19:15];
		rd = instruction[11:7]; //TRACED
		imm = {8'b0, instruction[31:20]};
		regWrite = 1; //TRACED
		aluSrc = 1;
		casez(instruction[14:12])
		ADDI: begin
			aluOP = ALU_ADD;
			cuOP = CU_ADDI;
		end
		SLTI: begin
			aluOP = ALU_SLT;
			cuOP = CU_SLTI;
		end
		SLTIU: begin
			aluOP = ALU_SLTU;
			cuOP = CU_SLTIU;
		end 
		XORI: begin
			aluOP = ALU_XOR;
			cuOP = CU_XORI;
		end 
		ORI: begin
			aluOP = ALU_OR;
			cuOP = CU_ORI;
		end 
		ANDI: begin
			aluOP = ALU_AND;
			cuOP = CU_ANDI;
		end 
		SLLI: begin
			aluOP = ALU_SLL;
			cuOP = CU_SLLI;
		end 
		SRLI: begin
			if(|instruction[31:22])begin
			aluOP = ALU_SRL;
			cuOP = CU_SRLI;
			end else begin
			aluOP = ALU_SRA;
			cuOP = CU_SRAI;
			end
		end 
		default: cuOP = CU_ERROR;
		endcase
	end
	(RTYPE): begin
		reg_1 = instruction[19:15];
		reg_2 = instruction[24:20];
		rd = instruction[11:7];
		regWrite = 1;
		casez(instruction[14:12])
		ADD: begin
			if(!(|instruction[31:22]))begin
			aluOP = ALU_ADD;
			cuOP = CU_ADD;
			end else begin
			aluOP = ALU_SUB;
			cuOP = CU_SUB;
			end
		end
		SLT: begin
			aluOP = ALU_SLT;
			cuOP = CU_SLT;
		end
		SLTU: begin
			aluOP = ALU_SLTU;
			cuOP = CU_SLTU;
		end 
		XOR: begin
			aluOP = ALU_XOR;
			cuOP = CU_XOR;
		end 
		OR: begin
			aluOP = ALU_OR;
			cuOP = CU_OR;
		end 
		AND: begin
			aluOP = ALU_AND;
			cuOP = CU_AND;
		end 
		SLL: begin
			aluOP = ALU_SLL;
			cuOP = CU_SLL;
		end 
		SRLI: begin
			if(|instruction[31:22])begin
			aluOP = ALU_SRL;
			cuOP = CU_SRL;
			end else begin
			aluOP = ALU_SRA;
			cuOP = CU_SRA;
			end
		end 
		default: cuOP = CU_ERROR;
		endcase
	end
	default: cuOP = CU_ERROR;
	endcase
	end
end
endmodule
