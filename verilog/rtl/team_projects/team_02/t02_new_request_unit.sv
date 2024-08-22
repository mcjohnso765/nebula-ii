module t02_new_request_unit (
    input logic CLK, nRST,
    input logic [31:0] DataAddress, InstrAddress,
    input logic [31:0] DatatoWrite,
    output logic iready, dready,
    output logic [31:0] FetchedData, FetchedInstr,
    input logic [5:0] cuOP,
    //^ to and from cpu
    input logic busy_o,
    input logic [31:0] cpu_dat_o,
    output logic write_i, read_i, // enables
    output logic [31:0] adr_i, cpu_data_i,
    output logic [3:0] sel_i
    // ^ to and from wishbone
);
typedef enum logic [5:0] {
		CU_LUI, CU_AUIPC, CU_JAL, CU_JALR, 
		CU_BEQ, CU_BNE, CU_BLT, CU_BGE, CU_BLTU, CU_BGEU, 
		CU_LB, CU_LH, CU_LW, CU_LBU, CU_LHU, CU_SB, CU_SH, CU_SW, 
		CU_ADDI, CU_SLTI, CU_SLTIU, CU_SLIU, CU_XORI, CU_ORI, CU_ANDI, CU_SLLI, CU_SRLI, CU_SRAI, 
		CU_ADD, CU_SUB, CU_SLL, CU_SLT, CU_SLTU, CU_XOR, CU_SRL, CU_SRA, CU_OR, CU_AND,
		CU_ERROR, CU_HALT
	} cuOPType;	
    typedef enum logic [2:0] {IDLE, 
    READ_DATA, 
    READ_INSTR, 
    WRITE_DATA, 
    WAIT_READ_DATA,
    WAIT_READ_INSTR, 
    WAIT_WRITE_DATA
    } StateType;

StateType state, next_state;

logic next_iready, next_dready;
logic next_read_i, next_write_i;
logic [31:0] next_FetchedData, next_FetchedInstr;
logic [31:0] next_adr_i, next_cpu_dat_i;
assign sel_i = 4'b1111;

always_ff@(posedge CLK, negedge nRST ) begin
    if(!nRST) begin
        state <= IDLE;
        adr_i <= 32'b0;
        cpu_data_i <= 32'b0;
        FetchedData <= 32'b0;
        FetchedInstr <= 32'b0;
        iready <= 1'b0;
        dready <= 1'b0;
        read_i <= 1'b0;
        write_i <= 1'b0;
    end else begin
        state <= next_state;
        adr_i <= next_adr_i;
        cpu_data_i <= next_cpu_dat_i;
        FetchedData <= next_FetchedData;
        FetchedInstr <= next_FetchedInstr;
        iready <= next_iready;
        dready <= next_dready;
        read_i <= next_read_i;
        write_i <= next_write_i;
    end
end
always_comb begin
    next_state = state; 
    next_read_i = 1'b0;
    next_write_i = 1'b0;
    next_adr_i = 32'b0;
    next_cpu_dat_i = 32'b0;
    next_iready = 1'b0;
    next_dready = 1'b0;
    next_FetchedData = 32'b0;
    next_FetchedInstr = 32'b0;
    case(state)
        IDLE: begin
            if ((cuOP == CU_LB| cuOP == CU_LH|
             cuOP == CU_LW | cuOP == CU_LBU | 
             cuOP == CU_LHU)& !dready) begin  //DATAREAD
                next_read_i = 1'b1;
                next_write_i = 1'b0;
                next_adr_i = DataAddress + 32'h33000000;
                next_state = WAIT_READ_DATA;
             end else if ((cuOP == CU_SB| cuOP == CU_SH|
              cuOP== CU_SW)& !dready) begin //DATAWRITE
                next_read_i = 1'b0;
                next_write_i = 1'b1;
                next_adr_i = DataAddress + 32'h33000000;
                next_cpu_dat_i = DatatoWrite;
                next_state = WAIT_WRITE_DATA;
              end else begin //InstructionREAD 
                next_read_i = 1'b1;
                next_write_i = 1'b0;
                next_state = WAIT_READ_INSTR;
              end

        end  
        WAIT_READ_DATA: begin
            next_adr_i = adr_i;
            next_state = READ_DATA;
        end  
        READ_DATA: begin
            next_adr_i = adr_i;
            if(!busy_o) begin
                next_adr_i = 32'b0;
                next_dready = 1'b1;
                next_FetchedData = cpu_dat_o;
                next_state = IDLE;
            end
        end
        WAIT_READ_INSTR: begin
            next_adr_i = InstrAddress;
            next_state = READ_INSTR;
        end
        READ_INSTR: begin
            next_adr_i = adr_i;
            if(!busy_o )begin
                next_adr_i = 32'b0;
                next_iready = 1'b1;
                next_FetchedInstr = cpu_dat_o;
                next_state = IDLE;
            end
        end
        WAIT_WRITE_DATA: begin
            next_adr_i = adr_i;
            next_cpu_dat_i = cpu_data_i;
            next_state = WRITE_DATA;
        end
        WRITE_DATA: begin
            next_adr_i = adr_i;
            next_cpu_dat_i = cpu_data_i;
            if(!busy_o) begin
                next_adr_i = 32'b0;
                next_cpu_dat_i = 32'b0;
                next_dready = 1'b1;
                next_state = IDLE;
            end
        end
        default: next_state = state;
    endcase
end
endmodule