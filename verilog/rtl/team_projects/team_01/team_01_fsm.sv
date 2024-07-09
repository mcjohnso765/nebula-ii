module fsm (
    input logic         clk, nRST,
    // From Keypad
    input logic [7:0]   data,
    input logic         keyvalid,
    // From Request Unit (d_done)      
    input logic         done,
    input logic [31:0]  read_data,
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
    output logic [2:0]  fsm_state,
    output logic [31:0] numbers,    
    output lcd_en
);
    typedef enum logic [2:0] {INIT, WRITE, NUM, ASM, DISPLAY, FETCH, FLASH, FINISH} StateType;

    StateType state, next_state;
    assign fsm_state = state;

    logic [31:0] i, next_i, num, next_num;

    assign numbers = i;

    logic next_read_i, next_write_i, next_pc_enable;

    logic [31:0] next_adr, next_write_data;

    logic [7:0] next_display;

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
        end else begin
            state       <= next_state;
            num         <= next_num;
            i           <= next_i;
            data_adr    <= next_adr;
            read_i      <= next_read_i;
            write_i     <= next_write_i;
            write_data  <= next_write_data;
            display     <= next_display;
            pc_enable   <= next_pc_enable;
        end
    end

    always_comb begin
        next_state      = state;
        next_num        = num;
        next_i          = i;
        next_adr        = data_adr;
        next_read_i     = read_i;
        next_write_i    = write_i;
        next_write_data = write_data;
        next_display    = display;
        next_pc_enable  = pc_enable;
        case (state)
            INIT: begin
                if (data == "*" && keyvalid) begin
                    next_write_i    = 1'b1;
                    next_adr        = write_adr + (i << 2);
                    next_state      = WRITE;
                end else if (data == "#" && keyvalid) begin
                    next_num        = i;
                    next_write_i    = 1'b1;
                    next_adr        = num_adr;
                    next_write_data = i;
                    //////////////////////////
                    next_i          = 32'b0;
                    next_state      = NUM;
                end else if (keyvalid) begin
                    next_write_data = {24'b0,data};
                    next_display = data;
                end
            end 
            WRITE: begin
                next_write_i    = 1'b0;
                if (done) begin
                    next_adr        = 32'b0;
                    next_write_data = 32'b0;
                    next_state      = INIT;
                    next_i          = i + 1;
                    next_display    = 8'b0;
                end 
            end
            NUM: begin
                if (done) begin
                    next_write_i    = 1'b0;
                    next_adr        = 32'b0;
                    next_write_data = 32'b0;
                    next_state      = ASM;
                    next_i          = i + 1;
                    next_pc_enable  = 1'b1;
                end
            end
            ASM: begin
                if (done) begin
                    next_i  = i + 1;  
                end
                if (i == num) begin
                    next_pc_enable  = 1'b0;
                    next_state      = DISPLAY;
                    next_i          = 32'b0;
                end
            end
            DISPLAY: begin
                if (i != num) begin
                    next_read_i     = 1'b1;
                    next_adr        = read_adr + (i << 2);
                    next_state      = FETCH;
                end else begin
                    next_state      = FINISH;
                end
            end
            FETCH: begin
                next_read_i     = 1'b0;
                if (done) begin
                    next_state      = FLASH;
                    next_i          = i + 1;
                    next_display    = read_data[7:0];  
                end
            end
            FLASH: begin
                if (data == "#" && keyvalid) begin
                    next_state = DISPLAY;
                    next_display = 8'b0;
                end
            end
            FINISH:;
            default:; 
        endcase
    end
endmodule

// module fsm (
//     input logic         clk, nRST,
//     // From Keypad
//     input logic [7:0]   data,
//     input logic         keyvalid,
//     // From Request Unit (d_done)      
//     input logic         done,
//     input logic [31:0]  read_data,
//     // To Request Unit
//     output logic        write_i, read_i,
//     output logic [31:0] write_data,
//     output logic [31:0] data_adr,
//     // From top.sv (hardcoded address)
//     input logic [31:0]  read_adr, write_adr, num_adr,
//     input logic         MemWrite,
//     // To top.sv
//     output logic        pc_enable,
//     // (For LCD)
//     output logic [7:0]  display,
//     output logic [2:0]  fsm_state,
//     output logic [31:0] numbers     
// );
//     typedef enum logic [2:0] {INIT, WRITE, NUM, ASM, DISPLAY, FETCH, FLASH, FINISH} StateType;

//     StateType state, next_state;
//     assign fsm_state = state;

//     logic [31:0] i, next_i, num, next_num;

//     assign numbers = i;

//     logic next_read_i, next_write_i, next_pc_enable;

//     logic [31:0] next_adr, next_write_data;

//     logic [7:0] next_display;

//     always_ff @(posedge clk, negedge nRST) begin
//         if (!nRST) begin
//             state       <= INIT;
//             num         <= 32'b0;
//             i           <= 32'b0;
//             data_adr    <= 32'b0;
//             read_i      <= 1'b0;
//             write_i     <= 1'b0;
//             write_data  <= 32'b0;
//             display     <= 8'b0;
//             pc_enable   <= 1'b0;
//         end else begin
//             state       <= next_state;
//             num         <= next_num;
//             i           <= next_i;
//             data_adr    <= next_adr;
//             read_i      <= next_read_i;
//             write_i     <= next_write_i;
//             write_data  <= next_write_data;
//             display     <= next_display;
//             pc_enable   <= next_pc_enable;
//         end
//     end

//     always_comb begin
//         next_state      = state;
//         next_num        = num;
//         next_i          = i;
//         next_adr        = data_adr;
//         next_read_i     = read_i;
//         next_write_i    = write_i;
//         next_write_data = write_data;
//         next_display    = display;
//         next_pc_enable  = pc_enable;
//         case (state)
//             INIT: begin
//                 if (data == "*" && keyvalid) begin
//                     next_write_i    = 1'b1;
//                     next_adr        = write_adr + (i << 2);
//                     next_state      = WRITE;
//                 end else if (data == "#" && keyvalid) begin
//                     next_num        = i;
//                     next_write_i    = 1'b1;
//                     next_adr        = num_adr;
//                     next_write_data = i;
//                     //////////////////////////
//                     next_i          = 32'b0;
//                     next_state      = NUM;
//                 end else if (keyvalid) begin
//                     next_write_data = {24'b0,data};
//                     next_display = data;
//                 end
//             end 
//             WRITE: begin
//                 if (done) begin
//                     next_write_i    = 1'b0;
//                     next_adr        = 32'b0;
//                     next_write_data = 32'b0;
//                     next_state      = INIT;
//                     next_i          = i + 1;
//                     next_display    = 8'b0;
//                 end 
//             end
//             NUM: begin
//                 if (done) begin
//                     next_write_i    = 1'b0;
//                     next_adr        = 32'b0;
//                     next_write_data = 32'b0;
//                     next_state      = ASM;
//                     next_i          = i + 1;
//                     next_pc_enable  = 1'b1;
//                 end
//             end
//             ASM: begin
//                 if (done) begin
//                     next_i  = i + 1;  
//                 end
//                 if (i == num) begin
//                     next_pc_enable  = 1'b0;
//                     next_state      = DISPLAY;
//                     next_i          = 32'b0;
//                 end
//             end
//             DISPLAY: begin
//                 if (i != num) begin
//                     next_read_i     = 1'b1;
//                     next_adr        = read_adr + (i << 2);
//                     next_state      = FETCH;
//                 end else begin
//                     next_state      = FINISH;
//                 end
//             end
//             FETCH: begin
//                 if (done) begin
//                     next_read_i     = 1'b0;
//                     next_state      = FLASH;
//                     next_i          = i + 1;
//                     next_display    = read_data[7:0];  
//                 end
//             end
//             FLASH: begin
//                 if (data == "#" && keyvalid) begin
//                     next_state = DISPLAY;
//                     next_display = 8'b0;
//                 end
//             end
//             FINISH:;
//             default:; 
//         endcase
//     end

// endmodule