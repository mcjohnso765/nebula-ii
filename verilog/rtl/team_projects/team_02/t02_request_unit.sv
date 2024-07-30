//original request unit that "works"
module t02_request_unit
(
    input logic CLK, nRST, i_ready_i, d_ready, busy_o,
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
        // dmmWen <= 0; 
    end
    else if (~busy_o)begin
        dmmRen <= nxt_dmmRen;
        // dmmWen <= nxt_dmmWen;
    end
end

always_ff@(posedge CLK, negedge nRST) begin
    if (!nRST) begin
        dmmWen <= 0; 
    end
    else if (~busy_o) begin
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
assign dmmaddro = dmmaddri + 32'h33000000; 
assign dmmstoreo = dmmstorei;
assign imemloado = imemloadi;
assign dmmloado = dmmloadi;
assign i_ready_o = i_ready_i;
assign d_ready_o = d_ready;
endmodule


//try putting busy_o inside the combinational logic 
// module t02_request_unit
// (
//     input logic CLK, nRST, i_ready_i, d_ready, busy_o,
//     input logic  [5:0] cuOP, 
//     input logic [31:0] dmmstorei, dmmaddri, imemaddri, imemloadi, dmmloadi,
//     output logic dmmWen, dmmRen, imemRen, i_ready_o, d_ready_o,
//     output logic [31:0] dmmstoreo, dmmaddro, imemaddro, imemloado, dmmloado

// );
// typedef enum logic [5:0] {
// 		CU_LUI, CU_AUIPC, CU_JAL, CU_JALR, 
// 		CU_BEQ, CU_BNE, CU_BLT, CU_BGE, CU_BLTU, CU_BGEU, 
// 		CU_LB, CU_LH, CU_LW, CU_LBU, CU_LHU, CU_SB, CU_SH, CU_SW, 
// 		CU_ADDI, CU_SLTI, CU_SLTIU, CU_SLIU, CU_XORI, CU_ORI, CU_ANDI, CU_SLLI, CU_SRLI, CU_SRAI, 
// 		CU_ADD, CU_SUB, CU_SLL, CU_SLT, CU_SLTU, CU_XOR, CU_SRL, CU_SRA, CU_OR, CU_AND,
// 		CU_ERROR, CU_HALT
// 	} cuOPType;	
// logic nxt_dmmRen, nxt_dmmWen;


// always_ff@(posedge CLK, negedge nRST) begin
//     if (!nRST) begin
//         dmmRen <= 0;
//         // dmmWen <= 0; 
//     end
//     else begin
//         dmmRen <= nxt_dmmRen;
//         // dmmWen <= nxt_dmmWen;
//     end
// end

// always_ff@(posedge CLK, negedge nRST) begin
//     if (!nRST) begin
//         dmmWen <= 0; 
//     end
//     else begin
//         dmmWen <= nxt_dmmWen;
//     end
// end
// always_comb begin
//     // if (cuOP == CU_HALT) begin
//     // imemRen = 0;
//     // end else begin
//     imemRen = 1;
//     // end
//     if (i_ready_i & !busy_o) begin
//     //if (i_ready_i ) begin
//         if(cuOP == CU_LB| cuOP == CU_LH| cuOP == CU_LW | cuOP == CU_LBU | cuOP == CU_LHU) begin
//         nxt_dmmRen = 1; 
//         nxt_dmmWen = 0;
//         end else if  (cuOP == CU_SB| cuOP == CU_SH| cuOP== CU_SW) begin
//         nxt_dmmRen = 0;
//         nxt_dmmWen = 1;
//         end else begin
//         nxt_dmmRen = 0;
//         nxt_dmmWen = 0;
//         end
//     end
//    else if (d_ready & !busy_o) begin
//     //else if (d_ready ) begin
//         nxt_dmmRen = 0; 
//         nxt_dmmWen = 0;
//     end
//     else begin
//         nxt_dmmRen = dmmRen;
//         nxt_dmmWen = dmmWen;
//     end
// end

// assign imemaddro = imemaddri; 
// assign dmmaddro = dmmaddri + 32'h33000000; 
// assign dmmstoreo = dmmstorei;
// assign imemloado = imemloadi;
// assign dmmloado = dmmloadi;
// assign i_ready_o = i_ready_i;
// assign d_ready_o = d_ready;
// endmodule


//try state machine



// module t02_request_unit
// (
//     input logic CLK, nRST, i_ready_i, d_ready, busy_o,
//     input logic  [5:0] cuOP, 
//     input logic [31:0] dmmstorei, dmmaddri, imemaddri, imemloadi, dmmloadi,
//     output logic dmmWen, dmmRen, imemRen, i_ready_o, d_ready_o,
//     output logic [31:0] dmmstoreo, dmmaddro, imemaddro, imemloado, dmmloado

// );
// typedef enum logic [5:0] {
// 		CU_LUI, CU_AUIPC, CU_JAL, CU_JALR, 
// 		CU_BEQ, CU_BNE, CU_BLT, CU_BGE, CU_BLTU, CU_BGEU, 
// 		CU_LB, CU_LH, CU_LW, CU_LBU, CU_LHU, CU_SB, CU_SH, CU_SW, 
// 		CU_ADDI, CU_SLTI, CU_SLTIU, CU_SLIU, CU_XORI, CU_ORI, CU_ANDI, CU_SLLI, CU_SRLI, CU_SRAI, 
// 		CU_ADD, CU_SUB, CU_SLL, CU_SLT, CU_SLTU, CU_XOR, CU_SRL, CU_SRA, CU_OR, CU_AND,
// 		CU_ERROR, CU_HALT
// 	} cuOPType;	
// typedef enum logic [1:0] {
//     IDLE, IREAD, DREAD, DWRITE
// } state_t;
// state_t current_state, next_state;


// always_ff@(posedge CLK, negedge nRST) begin
//     if (!nRST) begin
//         current_state <= IDLE;
//     end
//     else begin
//         current_state <= next_state;
//     end
// end


// always_comb begin
//     next_state = current_state;
//     case (current_state) 
//         IDLE:begin 
//             dmmRen = 0;
//             dmmWen = 0;
//             imemRen = 0;
//             if(~busy_o) begin
//                 if(cuOP == CU_LB| cuOP == CU_LH| cuOP == CU_LW | cuOP == CU_LBU | cuOP == CU_LHU) begin
//                     next_state = DREAD;
//                 end else if (cuOP == CU_SB| cuOP == CU_SH| cuOP== CU_SW)begin 
//                     next_state = DWRITE;
//                 end else begin
//                     next_state = IREAD;
//                 end
//             end
//         end
//         IREAD: begin
//             dmmRen = 0;
//             dmmWen = 0;
//             imemRen = 1;
//             if(~busy_o && i_ready_i) begin
//                 next_state = IDLE;
//             end
//         end
//         DREAD: begin
//             dmmRen = 1;
//             dmmWen = 0;
//             imemRen = 0;
//              if(~busy_o && d_ready) begin
//                 next_state = IDLE;
//             end
//         end
//         DWRITE: begin
//             dmmRen = 0;
//             dmmWen = 1;
//             imemRen = 0;
//              if(~busy_o && d_ready) begin
//                 next_state = IDLE;
//             end
//         end
//     endcase
// end

// assign imemaddro = imemaddri; 
// assign dmmaddro = dmmaddri + 32'h33000000; 
// assign dmmstoreo = dmmstorei;
// assign imemloado = imemloadi;
// assign dmmloado = dmmloadi;
// assign i_ready_o = i_ready_i;
// assign d_ready_o = d_ready;
// endmodule




