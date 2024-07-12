// typedef enum logic [5:0] {
// 		CU_LUI, CU_AUIPC, CU_JAL, CU_JALR, 
// 		CU_BEQ, CU_BNE, CU_BLT, CU_BGE, CU_BLTU, CU_BGEU, 
// 		CU_LB, CU_LH, CU_LW, CU_LBU, CU_LHU, CU_SB, CU_SH, CU_SW, 
// 		CU_ADDI, CU_SLTI, CU_SLTIU, CU_SLIU, CU_XORI, CU_ORI, CU_ANDI, CU_SLLI, CU_SRLI, CU_SRAI, 
// 		CU_ADD, CU_SUB, CU_SLL, CU_SLT, CU_SLTU, CU_XOR, CU_SRL, CU_SRA, CU_OR, CU_AND,
// 		CU_ERROR, CU_HALT
// } cuOPType;	

// // typedef enum logic [3:0] {IDLE, INS_READ, DAT_READ0, DAT_READ1, DAT_WRITE0, DAT_WRITE1}state_t;
// module t02_request (
//     input logic CLK, nRST, busy_o, en,
//     input logic [31:0] imemaddr, dmmaddr, dmmstore, ramload,
//     // input logic [5:0] cuOP,
//     input cuOPType cuOP,
//     output logic Ren, Wen, i_ready,d_ready,
//     output logic [31:0] imemload, dmmload, ramaddr, ramstore
// );
// // logic nxt_Ren, nxt_Wen;
// // state_t s, nxt_s;
// // cuOPType latch_op;
// // logic [31:0] nxt_imemload, nxt_dmmload, nxt_ramaddr, nxt_ramstore;
// // always_ff @(posedge CLK, negedge nRST ) begin
// //     if (!nRST) begin
// //         s <= IDLE;
// //         latch_op <= CU_ERROR;
// //         imemload <= '0;
// //         dmmload <= '0;
// //         ramaddr <= '0;
// //         ramstore <= '0;
// //     end else begin
// //         s <= nxt_s;
// //         latch_op <= cuOP;
// //         imemload <= nxt_imemload;
// //         dmmload <= nxt_dmmload;
// //         ramaddr <= nxt_ramaddr;
// //         ramstore <= nxt_ramstore;
// //     end
// // end

// // always_ff @(posedge CLK, negedge nRST ) begin
// //     if (!nRST) begin
// //         latch_op <= CU_ERROR;
// //     end else if (~busy_o)begin
// //         latch_op <= cuOP;
// //     end
// // end


// // assign i_ready = ~busy_o & Ren;

// // always_comb begin
// //     nxt_s = s;
// //     nxt_imemload = imemload;
// //     nxt_dmmload = dmmload;
// //     nxt_ramaddr = ramaddr;
// //     nxt_ramstore = ramstore;
// //     Wen=0;
// //     Ren=0;
// //     case (s)
// //         IDLE: begin
// //             if (en) begin
// //                 if (cuOP == CU_LW) begin
// //                     // Wen=0;
// //                     // Ren=1;
// //                     nxt_s = DAT_READ0;       
// //                 end else if (cuOP == CU_SW) begin
// //                     // Wen=1;
// //                     // Ren=0;
// //                     nxt_s = DAT_WRITE0;
// //                 end else begin
// //                     // Wen=0;
// //                     // Ren=1;
// //                     nxt_s = INS_READ;
// //                 end
// //             end
// //         end
// //         INS_READ: begin
// //             Wen=0;
// //             Ren=1;
// //             nxt_ramaddr = imemaddr; 
// //             nxt_imemload = ramload;
// //             if (~busy_o) begin
// //                 nxt_s = IDLE;
// //                 Wen=0;
// //                 Ren=1;

// //             end
// //         end
// //         DAT_READ0: begin
// //             Wen=0;
// //             Ren=1;
// //             nxt_ramaddr = imemaddr;
// //             nxt_imemload = ramload;
// //             if (~busy_o) begin
// //                 nxt_s = DAT_READ1;
// //                 Wen=0;
// //                 Ren=1;
// //             end
// //         end
// //         DAT_READ1: begin
// //             Wen=0;
// //             Ren=1;
// //             nxt_ramaddr = dmmaddr + 32'h33000000;
// //             nxt_dmmload = ramload;
// //             if (~busy_o) begin
// //                 nxt_s = IDLE;
// //                 Wen=0;
// //                 Ren=1;
// //             end
// //         end
// //         DAT_WRITE0: begin
// //             Wen=0;
// //             Ren=1;
// //             nxt_ramaddr = imemaddr;
// //             nxt_imemload = ramload;
// //             nxt_ramstore = dmmstore;
// //             if (~busy_o) begin
// //                 nxt_s = DAT_WRITE1;
// //                 Wen=1;
// //                 Ren=0;
// //             end
// //         end
// //         DAT_WRITE1: begin
// //             Wen=1;
// //             Ren=0;
// //             nxt_ramaddr = dmmaddr + 32'h33000000;
// //             // nxt_ramstore = dmmstore;
// //             if (~busy_o) begin
// //                 nxt_s = IDLE;
// //                 Wen=0;
// //                 Ren=1;
// //             end
// //         end
// //     endcase
// // end



// logic i_ready_i, d_ready_i, dmmRen, dmmWen, imemRen, latch_dmmRen, latch_dmmWen;
// logic [31:0] imemaddr_co, dmmaddr_co, dmmstore_co, dmmload_co, imemload_co;
// logic Ren_, Wen_;
// logic [31:0] ramaddr_, ramstore_, imemload_, latch_dmemaddr, latch_imemaddr;

// // always_ff @( posedge CLK, negedge nRST ) begin
// //     if (~nRST) begin
// //         latch_imemaddr <= '0;
// //         latch_dmemaddr <= '0;
// //         // latch_dmmRen <='0;
// //         // latch_dmmWen <='0;
// //     end else if (!busy_o)begin
// //         latch_imemaddr <= imemaddr_co;
// //         latch_dmemaddr <= dmmaddr_co;
// //         // latch_dmmRen <= dmmRen;
// //         // latch_dmmWen <= dmmWen;
// //     end
// // end

// always_comb begin
// // ramaddr = ramaddr_;
// // ramstore = ramstore_;
// imemload = imemload_;
// if (!en | cuOP == CU_HALT) begin
//     Ren = '0;
//     Wen = '0;
//     ramaddr = '0;
//     ramstore = '0;
//     if(cuOP == CU_HALT) imemload = 32'hffffffff;
// end else begin
//     Ren = Ren_;
//     Wen = Wen_;
//     ramaddr = ramaddr_;
//     ramstore = ramstore_;
//     imemload = imemload_;
// end

// end
// t02_request_unit r1 (.CLK(CLK), .nRST(nRST), .dmmstorei(dmmstore), .dmmaddri(dmmaddr), .imemaddri(imemaddr), .cuOP(cuOP), 
// .i_ready_i(i_ready_i), .d_ready(d_ready_i), .dmmRen(dmmRen), .dmmWen(dmmWen), .imemRen(imemRen), .i_ready_o(i_ready),
//  .imemaddro(imemaddr_co), .dmmstoreo(dmmstore_co), .dmmaddro(dmmaddr_co),
//  .dmmloadi(dmmload_co), .imemloadi(imemload_co), .busy_o(busy_o),
//  .imemloado(imemload_), .dmmloado(dmmload), .d_ready_o(d_ready));

// t02_memory_control m1 (.CLK(CLK), .nRST(nRST), .imemRen(imemRen),
//                     .dmmRen(dmmRen), .dmmWen(dmmWen), .busy_o(busy_o),
//                     .imemaddr(imemaddr), .dmmaddr(dmemaddr), .dmmstore(dmmstore_co),
//                     .ramload(ramload), .i_ready(i_ready_i), .d_ready(d_ready_i), .Ren(Ren_), .Wen(Wen_),
//                     .ramaddr(ramaddr_), .ramstore(ramstore_), .dmmload(dmmload_co), .imemload(imemload_co));
                    

// endmodule