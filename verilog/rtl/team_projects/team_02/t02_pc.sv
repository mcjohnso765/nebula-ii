// `include "pc_if.vh"
//`include "cpu_pkg.vh"

module t02_pc (
input logic [5:0] cuOP,
input logic [31:0] rs1Read, signExtend, 
output logic [31:0] PCaddr, 
input logic ALUneg, Zero, iready, clk, nRST, enable
);
        //     input logic clk, nRST,
        //    input logic[5:0] cuOP,
        //    input logic[31:0] rs1Read,
        //    input logic extendZeroes,
        //    input logic Zero,
        //    input logic ALUneg,
        //    input logic iready
        //    output logic[31:0]current_pc);
            logic[31:0] next_pc, PC;
            assign PCaddr = PC;
            logic [31:0] inter_next_pc;
            logic en_latched;
typedef enum logic [5:0] {
		CU_LUI, CU_AUIPC, CU_JAL, CU_JALR, 
		CU_BEQ, CU_BNE, CU_BLT, CU_BGE, CU_BLTU, CU_BGEU, 
		CU_LB, CU_LH, CU_LW, CU_LBU, CU_LHU, CU_SB, CU_SH, CU_SW, 
		CU_ADDI, CU_SLTI, CU_SLTIU, CU_SLIU, CU_XORI, CU_ORI, CU_ANDI, CU_SLLI, CU_SRLI, CU_SRAI, 
		CU_ADD, CU_SUB, CU_SLL, CU_SLT, CU_SLTU, CU_XOR, CU_SRL, CU_SRA, CU_OR, CU_AND,
		CU_ERROR, CU_HALT
	} cuOPType;	

    always_ff @( posedge clk, negedge nRST ) begin
    if (~nRST) begin
        en_latched <= '0;
    end else begin
        en_latched <= enable;
    end
    end        


            always_ff@(posedge clk, negedge nRST)
                if (~nRST)
                    PC <= 32'h33000000;
                // else if (!enable)
                //     PC <= start_addr;
                else
                    PC <= next_pc;

           always_comb begin
            // inter_next_pc = rs1Read + signExtend;
            if (en_latched) begin
                
                if (iready) begin
                    case(cuOP)
                        CU_JALR: next_pc = rs1Read + signExtend;
                        CU_JAL: next_pc = PC + (signExtend << 1);
                        CU_BEQ: next_pc = (Zero? PC + (signExtend << 1): PC + 4);
                        CU_BNE: next_pc = (~Zero? PC + (signExtend << 1) : PC + 4);
                        CU_BLT: next_pc = (ALUneg? PC + (signExtend << 1): PC + 4);
                        CU_BGE: next_pc = (~ALUneg | Zero? PC + (signExtend << 1) : PC + 4);
                        CU_BLTU: next_pc = (ALUneg? PC + (signExtend << 1): PC + 4);
                        CU_BGEU: next_pc = (~ALUneg | Zero? PC + (signExtend << 1) : PC + 4);
                        //CU_HALT: next_pc = 32'h33000000;
                        default: next_pc = PC + 4;
                    endcase
                end else begin
                    next_pc = PC;
                end
            end else begin
                next_pc = 32'h33000000;
            end
           end
           
           
endmodule


