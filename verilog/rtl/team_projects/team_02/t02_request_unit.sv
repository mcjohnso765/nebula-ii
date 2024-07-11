module t02_request_unit
(
    input logic CLK, nRST, i_ready_i, d_ready, 
    input logic  [5:0] cuOP, 
    input logic [31:0] dmmstorei, dmmaddri, imemaddri, imemloadi, dmmloadi,
    output logic dmmWen, dmmRen, imemRen, i_ready_o, d_ready_o,
    output logic [31:0] dmmstoreo, dmmaddro, imemaddro, imemloado, dmmloado

);
typedef enum logic [5:0] {
		CU_LUI, CU_AUIPC, CU_JAL, CU_JALR, 
		CU_BEQ, CU_BNE, CU_BLT, CU_BGE, CU_BLTU, CU_BGEU, 
		CU_LB, CU_LH, CU_LW, CU_LBU, CU_LHU, CU_SB, CU_SH, CU_SW, 
		CU_ADDI, CU_SLTI, CU_SLTIU, CU_SLIU, CU_XORI, CU_ORI, CU_ANDI, CU_SLLI, CU_SRLI, CU_SRAI, 
		CU_ADD, CU_SUB, CU_SLL, CU_SLT, CU_SLTU, CU_XOR, CU_SRL, CU_SRA, CU_OR, CU_AND,
		CU_ERROR, CU_HALT
	} cuOPType;	
logic nxt_dmmRen, nxt_dmmWen;


always_ff@(posedge CLK, negedge nRST) begin
    if (!nRST) begin
        dmmRen <= 0;
        dmmWen <= 0; 
    end
    else begin
        dmmRen <= nxt_dmmRen;
        dmmWen <= nxt_dmmWen;
    end
end
always_comb begin
    // if (cuOP == CU_HALT) begin
    // imemRen = 0;
    // end else begin
    imemRen = 1;
    // end
    if (i_ready_i) begin
        if(cuOP == CU_LB| cuOP == CU_LH| cuOP == CU_LW | cuOP == CU_LBU | cuOP == CU_LHU) begin
        nxt_dmmRen = 1; 
        nxt_dmmWen = 0;
        end else if  (cuOP == CU_SB| cuOP == CU_SH| cuOP== CU_SW) begin
        nxt_dmmRen = 0;
        nxt_dmmWen = 1;
        end else begin
        nxt_dmmRen = 0;
        nxt_dmmWen = 0;
        end
    end
    else if (d_ready) begin
        nxt_dmmRen = 0; 
        nxt_dmmWen = 0;
    end
    else begin
        nxt_dmmRen = 0;
        nxt_dmmWen = 0;
    end
end

assign imemaddro = imemaddri; 
assign dmmaddro = dmmaddri; 
assign dmmstoreo = dmmstorei;
assign imemloado = imemloadi;
assign dmmloado = dmmloadi;
assign i_ready_o = i_ready_i;
assign d_ready_o = d_ready;
endmodule