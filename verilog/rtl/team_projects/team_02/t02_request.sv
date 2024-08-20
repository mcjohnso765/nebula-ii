module t02_request (
    input logic CLK, nRST, busy_o, en,
    input logic [31:0] imemaddr, dmmaddr, dmmstore, ramload,
    input logic [5:0] cuOP,
    output logic Ren, Wen, i_ready, d_ready,
    output logic [31:0] imemload, dmmload, ramaddr, ramstore
);
typedef enum logic [5:0] {
		CU_LUI, CU_AUIPC, CU_JAL, CU_JALR, 
		CU_BEQ, CU_BNE, CU_BLT, CU_BGE, CU_BLTU, CU_BGEU, 
		CU_LB, CU_LH, CU_LW, CU_LBU, CU_LHU, CU_SB, CU_SH, CU_SW, 
		CU_ADDI, CU_SLTI, CU_SLTIU, CU_SLIU, CU_XORI, CU_ORI, CU_ANDI, CU_SLLI, CU_SRLI, CU_SRAI, 
		CU_ADD, CU_SUB, CU_SLL, CU_SLT, CU_SLTU, CU_XOR, CU_SRL, CU_SRA, CU_OR, CU_AND,
		CU_ERROR, CU_HALT
	} cuOPType;	
logic i_ready_i, d_ready_i, dmmRen, dmmWen, imemRen;
logic [31:0] imemaddr_co, dmmaddr_co, dmmstore_co, dmmload_co, imemload_co;
logic Ren_, Wen_;
logic [31:0] ramaddr_, ramstore_, imemload_;

always_comb begin
// ramaddr = ramaddr_;
// ramstore = ramstore_;
imemload = imemload_;
if (!en | cuOP == CU_HALT) begin
    Ren = '0;
    Wen = '0;
    ramaddr = '0;
    ramstore = '0;
    if(cuOP == CU_HALT) imemload = 32'hffffffff;
end else begin
    Ren = Ren_;
    Wen = Wen_;
    ramaddr = ramaddr_;
    ramstore = ramstore_;
    imemload = imemload_;
end

end
t02_request_unit r1 (.CLK(CLK), .nRST(nRST), .dmmstorei(dmmstore), .dmmaddri(dmmaddr), .imemaddri(imemaddr), .cuOP(cuOP), 
.i_ready_i(i_ready_i), .d_ready(d_ready_i), .dmmRen(dmmRen), .dmmWen(dmmWen), .imemRen(imemRen), .i_ready_o(i_ready),
 .imemaddro(imemaddr_co), .dmmstoreo(dmmstore_co), .dmmaddro(dmmaddr_co),.busy_o(busy_o),
 .dmmloadi(dmmload_co), .imemloadi(imemload_co),
 .imemloado(imemload_), .dmmloado(dmmload), .d_ready_o(d_ready));

t02_memory_control m1 (.CLK(CLK), .nRST(nRST), .imemRen(imemRen),
                    .dmmRen(dmmRen), .dmmWen(dmmWen), .busy_o(busy_o),
                    .imemaddr(imemaddr_co), .dmmaddr(dmmaddr_co), .dmmstore(dmmstore_co),
                    .ramload(ramload), .i_ready(i_ready_i), .d_ready(d_ready_i), .Ren(Ren_), .Wen(Wen_),
                    .ramaddr(ramaddr_), .ramstore(ramstore_), .dmmload(dmmload_co), .imemload(imemload_co));
                    

endmodule

