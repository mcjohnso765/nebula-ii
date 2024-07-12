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

// module t02_request_unit (
//     input   logic        clk, nRST,
//     // From CPU
//     input   logic        DataRead, InstrRead, DataWrite,
//     input   logic [31:0] DataAddress, InstrAddress,
//     input   logic [31:0] DataToWrite,
//     // To CPU
//     output  logic        ihit, dhit,
//     output  logic [31:0] FetchedData, FetchedInstr,
//     // From Wishbone / RAM
//     input   logic        busy_o,
//     input   logic [31:0] cpu_dat_o,
//     // To Wishbone / RAM
//     output  logic        write_i, read_i,
//     output  logic [31:0] adr_i, cpu_dat_i, 
//     output  logic [3:0]  sel_i
// );
//     typedef enum logic [2:0] {IDLE, 
//                               READ_DATA, 
//                               READ_INSTR, 
//                               WRITE_DATA, 
//                               WAIT_READ_DATA, 
//                               WAIT_READ_INSTR, 
//                               WAIT_WRITE_DATA
//     } StateType;
    
//     StateType state, next_state;

//     logic           next_ihit, next_dhit;

//     logic           next_read_i, next_write_i;

//     logic [31:0]    next_FetchedData, next_FetchedInstr;

//     logic [31:0]    next_adr_i, next_cpu_dat_i;

//     assign sel_i = 4'b1111;

//     always_ff @(posedge clk, negedge nRST) begin
//         if (!nRST) begin
//             state           <= IDLE;
//             adr_i           <= 32'b0;
//             cpu_dat_i       <= 32'b0;
//             FetchedData     <= 32'b0;
//             FetchedInstr    <= 32'b0;
//             ihit            <= 1'b0;
//             dhit            <= 1'b0;
//             read_i          <= 1'b0;
//             write_i         <= 1'b0;
//         end else begin
//             state           <= next_state;
//             adr_i           <= next_adr_i;
//             cpu_dat_i       <= next_cpu_dat_i;
//             FetchedData     <= next_FetchedData;
//             FetchedInstr    <= next_FetchedInstr;
//             ihit            <= next_ihit;
//             dhit            <= next_dhit;
//             read_i          <= next_read_i;
//             write_i         <= next_write_i;
//         end
//     end

//     always_comb begin
//         next_state          = state;
//         next_read_i         = 1'b0;
//         next_write_i        = 1'b0;
//         next_adr_i          = 32'b0;
//         next_cpu_dat_i      = 32'b0;
//         next_ihit           = 1'b0;
//         next_dhit           = 1'b0;
//         next_FetchedData    = 32'b0;
//         next_FetchedInstr   = 32'b0;
//         case (state)
//             IDLE: begin
//                 if (DataRead && !dhit) begin
//                     next_read_i     = 1'b1;
//                     next_write_i    = 1'b0;
//                     next_adr_i      = DataAddress;
//                     next_state      = WAIT_READ_DATA;
//                 end else if (DataWrite && !dhit) begin
//                     next_read_i     = 1'b0;
//                     next_write_i    = 1'b1;
//                     next_adr_i      = DataAddress;
//                     next_cpu_dat_i  = DataToWrite;
//                     next_state      = WAIT_WRITE_DATA;
//                 end else if (InstrRead && !ihit) begin
//                     next_read_i     = 1'b1;
//                     next_write_i    = 1'b0;
//                     next_state      = WAIT_READ_INSTR;
//                 end
//             end 
//             WAIT_READ_DATA: begin
//                 next_adr_i = adr_i;
//                 next_state = READ_DATA;
//             end
//             READ_DATA: begin
//                 next_adr_i              = adr_i;
//                 if (!busy_o) begin
//                     next_adr_i          = 32'b0;
//                     next_dhit           = 1'b1;
//                     next_FetchedData    = cpu_dat_o;
//                     next_state          = IDLE;
//                 end
//             end
//             WAIT_READ_INSTR: begin
//                 next_adr_i = InstrAddress;
//                 next_state = READ_INSTR;
//             end
//             READ_INSTR: begin
//                 next_adr_i              = adr_i;
//                 if (!busy_o) begin
//                     next_adr_i          = 32'b0;
//                     next_ihit           = 1'b1;
//                     next_FetchedInstr   = cpu_dat_o;
//                     next_state          = IDLE;
//                 end
//             end
//             WAIT_WRITE_DATA: begin
//                 next_adr_i      = adr_i;
//                 next_cpu_dat_i  = cpu_dat_i;
//                 next_state      = WRITE_DATA;
//             end
//             WRITE_DATA: begin
//                 next_adr_i          = adr_i;
//                 next_cpu_dat_i      = cpu_dat_i;
//                 if (!busy_o) begin
//                     next_adr_i      = 32'b0;
//                     next_cpu_dat_i  = 32'b0;
//                     next_dhit       = 1'b1;
//                     next_state      = IDLE;
//                 end
//             end
//             default: next_state = state; 
//         endcase
//     end
// endmodule