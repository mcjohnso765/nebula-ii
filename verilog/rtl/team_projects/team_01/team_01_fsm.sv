module t01_fsm (
    input logic         clk, nRST, en,
    // From Keypad
    input logic [7:0]   data,
    input logic         keyvalid,
    // From Request Unit (d_done)      
    input logic         done,
    input logic [31:0]  read_data,
    input logic [31:0]  Instruction,
    // To Request Unit
    output logic        write_i, read_i,
    output logic [31:0] write_data,
    output logic [31:0] data_adr,
    // From top.sv (hardcoded address)
    input logic [31:0]  read_adr, write_adr, num_adr,
    input logic         MemWrite,
    // To top.sv
    output logic        pc_enable,
    // (For LCD)
    output logic [7:0]  display,
    output logic [3:0]  fsm_state,
    output logic        lcd_en     
);
    typedef enum logic [3:0] {INIT, IDLE, WRITE, NUM, ASM, DISPLAY, FETCH, FLASH, FINISH} StateType;
    StateType state, next_state;
    assign fsm_state = state;

    logic [31:0]    i, next_i, num, next_num;
    logic           next_read_i, next_write_i, next_enable, next_lcd_en;
    logic [31:0]    next_data_adr, next_write_data;
    logic [7:0]     next_display;

    always_ff @(posedge clk, negedge nRST) begin
        if (!nRST) begin
            state       <= INIT;
            num         <= 32'b0;
            i           <= 32'b0;
            data_adr    <= 32'b0;
            read_i      <= 1'b0;
            write_i     <= 1'b0;
            write_data  <= 32'b0;
            display     <= 8'b0;
            pc_enable   <= 1'b0;
            lcd_en      <= 1'b0;
        end else begin
            state       <= next_state;
            num         <= next_num;
            i           <= next_i;
            data_adr    <= next_data_adr;
            read_i      <= next_read_i;
            write_i     <= next_write_i;
            write_data  <= next_write_data;
            display     <= next_display;
            pc_enable   <= next_enable;
            lcd_en      <= next_lcd_en;
        end
    end

    always_comb begin
        next_state      = state;
        next_read_i     = 1'b0;
        next_write_i    = 1'b0;
        next_data_adr   = 32'b0;
        next_write_data = write_data;
        next_num        = num;
        next_i          = i;
        next_display    = display;
        next_enable     = pc_enable;
        next_lcd_en     = 1'b0;
        case (state)
            INIT: begin
                if (en) begin
                    next_state = IDLE;
                end
            end
            IDLE: begin
                if (data == "*" && keyvalid) begin
                    next_write_i    = 1'b1;
                    next_data_adr   = write_adr + (i << 2);
                    next_state      = WRITE;
                end else if (data == "#" && keyvalid) begin
                    next_write_i    = 1'b1;
                    next_write_data = i;
                    next_data_adr   = num_adr;
                    next_state      = NUM;
                    next_num        = i;
                end else if (keyvalid) begin
                    next_write_data = {24'b0, data};
                    next_display    = data;
                end
            end 
            WRITE: begin
                if (done) begin
                    next_state      = IDLE;
                    next_i          = i + 1;
                    next_display    = 8'b0;
                end
            end
            NUM: begin
                if (done) begin
                    next_state      = ASM;
                    next_i          = 32'b0;
                    next_enable     = 1'b1;
                    next_write_data = 32'b0;
                end
            end
            ASM: begin
                if (done) begin
                    next_i = i + 1;
                end
                // if (i == num - 1) begin
                //     next_enable = 1'b0;
                //     next_state  = DISPLAY;
                //     next_i      = 32'b0;
                // end
                if ((data == "D" && keyvalid) || Instruction == 32'h60002023) begin
                    next_enable = 1'b0;
                    next_state  = DISPLAY;
                    next_i      = 32'b0;
                end
            end
            DISPLAY: begin
                if ((data == "*" && keyvalid) || i == num) begin
                    next_i          = 32'b0;
                    next_num        = 32'b0;
                    next_state      = FINISH;
                end else begin
                    next_read_i     = 1'b1;
                    next_data_adr   = read_adr + (i << 2);
                    next_state      = FETCH;
                end
            end
            FETCH: begin
                next_read_i         = read_i;
                next_data_adr       = data_adr;
                if (done) begin
                    next_read_i     = 1'b0;
                    next_data_adr   = 32'b0;
                    next_state      = FLASH;
                    next_i          = i + 1;
                    next_lcd_en     = 1'b1;
                    next_display    = read_data[7:0] == 8'b0 ? "0" : read_data[7:0];
                end
            end
            FLASH: begin
                if (data == "#" && keyvalid) begin
                    next_state      = DISPLAY;
                    next_display    = 8'b0;
                end
            end
            FINISH:;
            default:; 
        endcase
    end
endmodule