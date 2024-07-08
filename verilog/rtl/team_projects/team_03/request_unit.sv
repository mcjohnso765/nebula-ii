module request_unit (
    // From CPU
    input logic clk, nRST, en, 
    input logic D_fetch, D_write, I_fetch,  
    input logic [31:0] data_adr, instr_adr, 
    input logic [31:0] writedata,           
    // To CPU
    output logic i_done, d_done,            
    output logic [31:0] instr, data,        
    // From Wishbone
    input logic busy_o,                     
    input logic [31:0] cpu_dat_o,          
    output logic write_i, read_i,
    output logic [31:0] adr_i,              
    output logic [31:0] cpu_dat_i,          
    output logic [3:0] sel_i                
);

    assign sel_i = 4'b1111;

    logic [31:0] next_instr, next_data, next_adr, next_data_w;

    typedef enum logic [1:0] {IDLE, READ_D, READ_I, WRITE_D} StateType;

    StateType state, next_state;

    always_ff @(posedge clk, posedge nRST) begin
        if (nRST) begin
            state       <= IDLE;
            instr       <= 32'b0;
            data        <= 32'b0;
            adr_i       <= 32'b0;
            cpu_dat_i   <= 32'b0;
        end else if (en) begin
            state       <= next_state;
            instr       <= next_instr;
            data        <= next_data;
            adr_i       <= next_adr;
            cpu_dat_i   <= next_data_w;
        end
    end

    always_comb begin
        // To Wishbone
        read_i      = 1'b0;
        write_i     = 1'b0;
        // To CPU
        i_done      = 1'b0;
        d_done      = 1'b0;
        ///////////////////
        next_state  = state;
        next_data   = data;
        next_instr  = instr;
        next_adr    = adr_i;
        next_data_w = cpu_dat_i;
        case (state)
            IDLE: begin
                if (D_fetch) begin
                    read_i      = 1'b1;
                    write_i     = 1'b0;
                    next_adr    = data_adr;
                    next_state  = READ_D;
                end else if (D_write) begin
                    read_i      = 1'b0;
                    write_i     = 1'b1;
                    next_adr    = data_adr;
                    next_data_w = writedata;
                    next_state  = WRITE_D;
                end else if (I_fetch) begin
                    read_i      = 1'b1;
                    write_i     = 1'b0;
                    next_adr    = instr_adr;
                    next_state  = READ_I;
                end else begin
                    read_i      = 1'b0;
                    write_i     = 1'b0;
                    next_adr    = 32'b0;
                    next_data_w = 32'b0;
                    next_state  = IDLE;
                end
            end
            READ_I: begin
                read_i          = 1'b0;
                if (busy_o) begin
                    next_instr  = cpu_dat_o;
                end else begin
                    next_adr    = 32'b0;
                    i_done      = 1'b1;
                    next_instr  = 32'b0;
                    next_state  = IDLE;
                end
            end
            READ_D: begin
                read_i          = 1'b0;
                if (busy_o) begin
                    next_data   = cpu_dat_o;
                end else begin
                    next_adr    = 32'b0;
                    d_done      = 1'b1;
                    next_data   = 32'b0;
                    next_state  = IDLE;
                end
            end
            WRITE_D: begin
                write_i         = 1'b0;
                if (!busy_o) begin
                    next_adr    = 32'b0;
                    next_data_w = 32'b0;
                    d_done      = 1'b1;
                    next_state  = IDLE;
                end
            end
            default:; 
        endcase
    end
endmodule