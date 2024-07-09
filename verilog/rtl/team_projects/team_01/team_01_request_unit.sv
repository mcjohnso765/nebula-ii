// MODIFIED

module request_unit (
    input logic clk, nRST,
    // From CPU
    input logic DataRead, InstrRead, DataWrite,
    input logic [31:0] DataAddress, InstrAddress,
    input logic [31:0] DataToWrite,
    // To CPU
    output logic ihit, dhit,
    output logic [31:0] FetchedData, FetchedInstr,
    // From Wishbone / RAM
    input logic busy_o,
    input logic [31:0] cpu_dat_o,
    // To Wishbone / RAM
    output logic write_i, read_i,
    output logic [31:0] adr_i, cpu_dat_i, 
    output logic [3:0] sel_i
);
    typedef enum logic [1:0] {IDLE, READ_DATA, READ_INSTR, WRITE_DATA} StateType;
    StateType state, next_state;
    logic           next_ihit, next_dhit;
    logic [31:0]    next_FetchedData, next_FetchedInstr;
    logic [31:0]    next_adr_i, next_cpu_dat_i;

    assign sel_i = 4'b1111;

    always_ff @(posedge clk, negedge nRST) begin
        if (!nRST) begin
            state           <= IDLE;
            adr_i           <= 32'b0;
            cpu_dat_i       <= 32'b0;
            FetchedData     <= 32'b0;
            FetchedInstr    <= 32'b0;
            ihit            <= 1'b0;
            dhit            <= 1'b0;
        end else begin
            state           <= next_state;
            adr_i           <= next_adr_i;
            cpu_dat_i       <= next_cpu_dat_i;
            FetchedData     <= next_FetchedData;
            FetchedInstr    <= next_FetchedInstr;
            ihit            <= next_ihit;
            dhit            <= next_dhit;
        end
    end

    always_comb begin
        next_state          = state;
        read_i              = 1'b0;
        write_i             = 1'b0;
        next_adr_i          = 32'b0;
        next_cpu_dat_i      = 32'b0;
        next_ihit           = 1'b0;
        next_dhit           = 1'b0;
        next_FetchedData    = 32'b0;
        next_FetchedInstr   = (DataRead || DataWrite) ? FetchedInstr : 32'b0;
        case (state)
            IDLE: begin
                if (DataRead && !dhit) begin
                    read_i              = 1'b1;
                    write_i             = 1'b0;
                    next_adr_i          = DataAddress;
                    next_FetchedInstr   = FetchedInstr;
                    next_state          = READ_DATA;
                end else if (DataWrite && !dhit) begin
                    read_i              = 1'b0;
                    write_i             = 1'b1;
                    next_adr_i          = DataAddress;
                    next_cpu_dat_i      = DataToWrite;
                    next_FetchedInstr   = FetchedInstr;
                    next_state          = WRITE_DATA;
                end else if (InstrRead && !ihit) begin
                    read_i          = 1'b1;
                    write_i         = 1'b0;
                    next_adr_i      = InstrAddress;
                    next_state      = READ_INSTR;
                end
            end 
            READ_DATA: begin
                next_FetchedInstr       = FetchedInstr;
                next_adr_i              = adr_i;
                if (!busy_o) begin
                    next_adr_i          = 32'b0;
                    next_dhit           = 1'b1;
                    next_FetchedData    = cpu_dat_o;
                    next_state          = IDLE;
                end
            end
            READ_INSTR: begin
                next_adr_i              = adr_i;
                if (!busy_o) begin
                    next_adr_i          = 32'b0;
                    next_ihit           = 1'b1;
                    next_FetchedInstr   = cpu_dat_o;
                    next_state          = IDLE;
                end
            end
            WRITE_DATA: begin
                next_FetchedInstr       = FetchedInstr;
                next_adr_i              = adr_i;
                next_cpu_dat_i          = cpu_dat_i;
                if (!busy_o) begin
                    next_adr_i          = 32'b0;
                    next_cpu_dat_i      = 32'b0;
                    next_dhit           = 1'b1;
                    next_state          = IDLE;
                    // next_FetchedInstr   = FetchedInstr;
                end
            end
            default: next_state = state; 
        endcase
    end
endmodule
// module request_unit (
//     // From CPU
//     input logic         clk, nRST,                  // Synchronous clock and Asynchronous reset
//     input logic         D_fetch, D_write, I_fetch,  // D_fetch = MemRead; D_write = MemWrite; I_fetch = Instruction Fetch = PC_enable 
//     input logic [31:0]  data_adr, instr_adr,        // data_adr = address from data memory; instr_adr = address from instruction memory
//     input logic [31:0]  writedata,                  // = data to be written from data memory
//     // To CPU
//     output logic        ihit, dhit,                 // signals to inform that instruction/data has been fetched
//     output logic [31:0] instr, data,                // signals that have the instruction/data when the above signals are high  
//     // From Wishbone
//     input logic         busy_o,                     // Wishbone is busy with a transaction, low = transaction complete
//     input logic [31:0]  cpu_dat_o,                  // Data Fetched = Instruction or Data at adr_i
//     // To Wishbone  
//     output logic        write_i, read_i,            // Signals that indicate your write/read request
//     output logic [31:0] adr_i,                      // The address where your request is supposed to take place
//     output logic [31:0] cpu_dat_i,                  // The data that the bus takes in for a write request
//     output logic [3:0]  sel_i                       // select signal to indicate data width (always 32 bits in our case)
// );

//     assign sel_i = 4'b1111;

//     logic           next_write_i, next_read_i;
//     logic [31:0]    next_adr_i, next_cpu_dat_i;

//     logic           next_ihit, next_dhit;
//     logic [31:0]    next_data, next_instr;

//     typedef enum logic [2:0] {IDLE, 
//                               WAIT_READ_DATA, 
//                               WAIT_READ_INSTR, 
//                               WAIT_WRITE_DATA, 
//                               READ_INSTR, 
//                               READ_DATA, 
//                               WRITE_DATA} StateType;
//     StateType state, next_state;

//     always_ff @(posedge clk, negedge nRST) begin
//         if (!nRST) begin
//             state       <= IDLE;
//             write_i     <= 1'b0;
//             read_i      <= 1'b0;
//             adr_i       <= 32'b0;
//             cpu_dat_i   <= 32'b0;
//             instr       <= 32'b0;
//             ihit        <= 1'b0;
//             dhit        <= 1'b0;
//             data        <= 32'b0;
//         end else begin
//             state       <= next_state;
//             write_i     <= next_write_i;
//             read_i      <= next_read_i;
//             adr_i       <= next_adr_i;
//             cpu_dat_i   <= next_cpu_dat_i;
//             instr       <= next_instr;
//             ihit        <= next_ihit;
//             dhit        <= next_dhit;
//             data        <= next_data;
//         end
//     end

//     always_comb begin
//         next_state      = state;
//         next_write_i    = write_i;
//         next_read_i     = read_i;
//         next_adr_i      = adr_i;
//         next_cpu_dat_i  = cpu_dat_i;
//         next_ihit       = 1'b0;
//         next_instr      = instr;
//         next_dhit       = 1'b0;
//         next_data       = data;
//         case (state)
//             IDLE: begin
//                 if (D_write) begin
//                     next_write_i    = 1'b1;
//                     next_read_i     = 1'b0;
//                     next_adr_i      = data_adr;
//                     next_cpu_dat_i  = writedata;
//                     next_state      = WAIT_WRITE_DATA;
//                 end else if (D_fetch) begin
//                     next_read_i     = 1'b1;
//                     next_write_i    = 1'b0;
//                     next_adr_i      = data_adr;
//                     next_state      = WAIT_READ_DATA;
//                 end else if (I_fetch) begin
//                     next_read_i     = 1'b1;
//                     next_write_i    = 1'b0;
//                     next_adr_i      = instr_adr;
//                     next_state      = WAIT_READ_INSTR;
//                 end
//             end
//             WAIT_READ_INSTR: begin
//                 next_read_i = 1'b0;
//                 next_state  = READ_INSTR;
//             end 
//             READ_INSTR: begin
//                 if (!busy_o) begin
//                     next_ihit   = 1'b1;
//                     next_data   = 32'b0;
//                     next_instr  = cpu_dat_o;
//                     next_state  = IDLE;
//                     next_adr_i  = 32'b0;
//                 end 
//             end
//             WAIT_READ_DATA: begin
//                 next_read_i = 1'b0;
//                 next_state  = READ_DATA;
//             end
//             READ_DATA: begin
//                 if (!busy_o) begin
//                     next_dhit   = 1'b1;
//                     next_data   = cpu_dat_o;
//                     next_state  = IDLE;
//                     next_adr_i  = 32'b0;
//                 end
//             end
//             WAIT_WRITE_DATA: begin
//                 next_write_i    = 1'b0;
//                 next_state      = WRITE_DATA;
//             end
//             WRITE_DATA: begin
//                 if (!busy_o) begin
//                     next_dhit       = 1'b1;
//                     next_cpu_dat_i  = 32'b0;
//                     next_state      = IDLE;
//                     next_adr_i      = 32'b0;
//                 end
//             end
//             default: begin
//                 next_state      = IDLE;
//                 next_write_i    = 1'b0;
//                 next_read_i     = 1'b0;
//                 next_adr_i      = 32'b0;
//                 next_cpu_dat_i  = 32'b0;
//                 next_ihit       = 1'b0;
//                 next_instr      = 32'b0;
//                 next_dhit       = 1'b0;
//                 next_data       = 32'b0;
//             end
//         endcase
//     end
// endmodule

// module request_unit (
//     // From CPU
//     input logic         clk, nRST,                  // Synchronous clock and Asynchronous reset
//     input logic         D_fetch, D_write, I_fetch,  // D_fetch = MemRead; D_write = MemWrite; I_fetch = Instruction Fetch = PC_enable 
//     input logic [31:0]  data_adr, instr_adr,        // data_adr = address from data memory; instr_adr = address from instruction memory
//     input logic [31:0]  writedata,                  // = data to be written from data memory
//     // To CPU
//     output logic        ihit, dhit,                 // signals to inform that instruction/data has been fetched
//     output logic [31:0] instr, data,                // signals that have the instruction/data when the above signals are high  
//     // From Wishbone
//     input logic         busy_o,                     // Wishbone is busy with a transaction, low = transaction complete
//     input logic [31:0]  cpu_dat_o,                  // Data Fetched = Instruction or Data at adr_i
//     // To Wishbone  
//     output logic        write_i, read_i,            // Signals that indicate your write/read request
//     output logic [31:0] adr_i,                      // The address where your request is supposed to take place
//     output logic [31:0] cpu_dat_i,                  // The data that the bus takes in for a write request
//     output logic [3:0]  sel_i                       // select signal to indicate data width (always 32 bits in our case)
// );

//     assign sel_i = 4'b1111;

//     logic           next_write_i, next_read_i;
//     logic [31:0]    next_adr_i, next_cpu_dat_i;

//     logic           next_ihit, next_dhit;
//     logic [31:0]    next_data, next_instr;

//     typedef enum logic [2:0] {IDLE, 
//                               WAIT_READ_DATA, 
//                               WAIT_READ_INSTR, 
//                               WAIT_WRITE_DATA, 
//                               READ_INSTR, 
//                               READ_DATA, 
//                               WRITE_DATA} StateType;
//     StateType state, next_state;

//     always_ff @(posedge clk, negedge nRST) begin
//         if (!nRST) begin
//             state       <= IDLE;
//             write_i     <= 1'b0;
//             read_i      <= 1'b0;
//             adr_i       <= 32'b0;
//             cpu_dat_i   <= 32'b0;
//             instr       <= 32'b0;
//             ihit        <= 1'b0;
//             dhit        <= 1'b0;
//             data        <= 32'b0;
//         end else begin
//             state       <= next_state;
//             write_i     <= next_write_i;
//             read_i      <= next_read_i;
//             adr_i       <= next_adr_i;
//             cpu_dat_i   <= next_cpu_dat_i;
//             instr       <= next_instr;
//             ihit        <= next_ihit;
//             dhit        <= next_dhit;
//             data        <= next_data;
//         end
//     end

//     always_comb begin
//         next_state      = state;
//         next_write_i    = write_i;
//         next_read_i     = read_i;
//         next_adr_i      = adr_i;
//         next_cpu_dat_i  = cpu_dat_i;
//         next_ihit       = 1'b0;
//         next_instr      = instr;
//         next_dhit       = dhit;
//         next_data       = data;
//         case (state)
//             IDLE: begin
//                 if (D_write && !dhit) begin
//                     next_write_i    = 1'b1;
//                     next_read_i     = 1'b0;
//                     next_adr_i      = data_adr;
//                     next_cpu_dat_i  = writedata;
//                     next_state      = WAIT_WRITE_DATA;
//                 end else if (D_fetch && !dhit) begin
//                     next_read_i     = 1'b1;
//                     next_write_i    = 1'b0;
//                     next_adr_i      = data_adr;
//                     next_state      = WAIT_READ_DATA;
//                 end else if (I_fetch) begin
//                     next_read_i     = 1'b1;
//                     next_write_i    = 1'b0;
//                     next_adr_i      = instr_adr;
//                     next_state      = WAIT_READ_INSTR;
//                 end
//             end
//             WAIT_READ_INSTR: begin
//                 next_read_i = 1'b0;
//                 next_state  = READ_INSTR;
//             end 
//             READ_INSTR: begin
//                 if (!busy_o) begin
//                     next_ihit   = 1'b1;
//                     next_dhit   = 1'b0;
//                     next_instr  = cpu_dat_o;
//                     next_data   = 32'b0;
//                     next_state  = IDLE;
//                     next_adr_i  = 32'b0;
//                 end
//             end
//             WAIT_READ_DATA: begin
//                 next_read_i = 1'b0;
//                 next_state  = READ_DATA;
//             end
//             READ_DATA: begin
//                 if (!busy_o) begin
//                     next_dhit   = 1'b1;
//                     next_data   = cpu_dat_o;
//                     next_state  = IDLE;
//                     next_adr_i  = 32'b0;
//                 end
//             end
//             WAIT_WRITE_DATA: begin
//                 next_write_i    = 1'b0;
//                 next_state      = WRITE_DATA;
//             end
//             WRITE_DATA: begin
//                 if (!busy_o) begin
//                     next_dhit       = 1'b1;
//                     next_cpu_dat_i  = 32'b0;
//                     next_state      = IDLE;
//                     next_adr_i  = 32'b0;
//                 end
//             end
//             default: begin
//                 next_state      = IDLE;
//                 next_write_i    = 1'b0;
//                 next_read_i     = 1'b0;
//                 next_adr_i      = 32'b0;
//                 next_cpu_dat_i  = 32'b0;
//                 next_ihit       = 1'b0;
//                 next_instr      = 32'b0;
//                 next_dhit       = 1'b0;
//                 next_data       = 32'b0;
//             end
//         endcase
//     end
// endmodule

// module request_unit (
//     // From CPU
//     input logic         clk, nRST,                  // Synchronous clock and Asynchronous reset
//     input logic         D_fetch, D_write, I_fetch,  // D_fetch = MemRead; D_write = MemWrite; I_fetch = Instruction Fetch = PC_enable 
//     input logic [31:0]  data_adr, instr_adr,        // data_adr = address from data memory; instr_adr = address from instruction memory
//     input logic [31:0]  writedata,                  // = data to be written from data memory
//     // To CPU
//     output logic        ihit, dhit,                 // signals to inform that instruction/data has been fetched
//     output logic [31:0] instr, data,                // signals that have the instruction/data when the above signals are high  
//     // From Wishbone
//     input logic         busy_o,                     // Wishbone is busy with a transaction, low = transaction complete
//     input logic [31:0]  cpu_dat_o,                  // Data Fetched = Instruction or Data at adr_i
//     // To Wishbone  
//     output logic        write_i, read_i,            // Signals that indicate your write/read request
//     output logic [31:0] adr_i,                      // The address where your request is supposed to take place
//     output logic [31:0] cpu_dat_i,                  // The data that the bus takes in for a write request
//     output logic [3:0]  sel_i                       // select signal to indicate data width (always 32 bits in our case)
// );
//     assign sel_i        = 4'b1111;
//     assign cpu_dat_i    = writedata;

//     typedef enum logic [1:0] {IDLE, READ_INSTR, READ_DATA, WRITE_DATA} StateType;

//     StateType state, next_state;

//     logic [31:0] next_adr_i, next_instr, next_data;
//     logic next_ihit, next_dhit;

//     always_ff @(posedge clk, negedge nRST) begin
//         if (!nRST) begin
//             state <= IDLE;
//             adr_i <= 32'b0;
//             instr <= 32'b0;
//             data  <= 32'b0;
//             ihit  <= 1'b0;
//             dhit  <= 1'b0;
//         end else begin
//             state <= next_state;
//             adr_i <= next_adr_i;
//             instr <= next_instr;
//             data  <= next_data;
//             ihit  <= next_ihit;
//             dhit  <= next_dhit;
//         end
//     end

//     always_comb begin
//         next_state = state;
//         next_adr_i = adr_i;
//         next_data  = data;
//         next_instr = instr;
//         next_ihit  = 1'b0;
//         next_dhit  = 1'b0;
//         read_i = 1'b0;
//         write_i = 1'b0;
//         case (state)
//             IDLE: begin
//                 if (D_fetch) begin
//                     read_i      = 1'b1;
//                     write_i     = 1'b0;
//                     next_adr_i  = data_adr;
//                     next_state  = READ_DATA;
//                 end else if (D_write) begin
//                     write_i     = 1'b1;
//                     read_i      = 1'b0;
//                     next_adr_i  = data_adr;
//                     next_state  = WRITE_DATA;
//                 end else if (I_fetch) begin
//                     read_i      = 1'b1;
//                     write_i     = 1'b0;
//                     next_adr_i  = instr_adr;
//                     next_state  = READ_INSTR;
//                 end
//             end 
//             READ_DATA: begin
//                 if (!busy_o) begin
//                     next_state = IDLE;
//                     next_dhit  = 1'b1;
//                     next_data  = cpu_dat_o;
//                     next_adr_i = 32'b0;
//                 end 
//             end
//             READ_INSTR: begin
//                 if (!busy_o) begin
//                     next_state = IDLE;
//                     next_dhit  = 1'b0;
//                     next_ihit  = 1'b1;
//                     next_instr = cpu_dat_o;
//                     next_data  = 32'b0;
//                     next_adr_i = 32'b0;
//                 end
//             end
//             WRITE_DATA: begin
//                 if (!busy_o) begin
//                     next_dhit  = 1'b1;
//                     next_state = IDLE;
//                     next_adr_i = 32'b0;
//                 end
//             end
//             default:;
//         endcase
//     end
// endmodule
// // module request_unit (
// //     // From CPU
// //     input logic clk, nRST,                  // Synchronous clock and Asynchronous reset
// //     input logic D_fetch, D_write, I_fetch,  // D_fetch = MemRead; D_write = MemWrite; I_fetch = Instruction Fetch = PC_enable 
// //     input logic [31:0] data_adr, instr_adr, // data_adr = address from data memory; instr_adr = address from instruction memory
// //     input logic [31:0] writedata,           // = data to be written from data memory
// //     // To CPU
// //     output logic i_done, d_done,            // signals to inform that instruction/data has been fetched
// //     output logic [31:0] instr, data,        // signals that have the instruction/data when the above signals are high  
// //     // From Wishbone
// //     input logic busy_o,                     // Wishbone is busy with a transaction, low = transaction complete
// //     input logic [31:0] cpu_dat_o,           // Data Fetched = Instruction or Data at adr_i
// //     // To Wishbone  
// //     output logic write_i, read_i,           // Signals that indicate your write/read request
// //     output logic [31:0] adr_i,              // The address where your request is supposed to take place
// //     output logic [31:0] cpu_dat_i,          // The data that the bus takes in for a write request
// //     output logic [3:0] sel_i                // select signal to indicate data width (always 32 bits in our case)
// // );

// //     assign sel_i = 4'b1111;

// //     logic [31:0] next_instr, next_data, next_adr, next_data_w;

// //     typedef enum logic [1:0] {IDLE, READ_D, READ_I, WRITE_D} StateType;

// //     StateType state, next_state;

// //     always_ff @(posedge clk, negedge nRST) begin
// //         if (!nRST) begin
// //             state       <= IDLE;
// //             instr       <= 32'b0;
// //             data        <= 32'b0;
// //             adr_i       <= 32'b0;
// //             cpu_dat_i   <= 32'b0;
// //         end else begin
// //             state       <= next_state;
// //             instr       <= next_instr;
// //             data        <= next_data;
// //             adr_i       <= next_adr;
// //             cpu_dat_i   <= next_data_w;
// //         end
// //     end

// //     always_comb begin
// //         // To Wishbone
// //         read_i      = 1'b0;
// //         write_i     = 1'b0;
// //         // To CPU
// //         i_done      = 1'b0;
// //         d_done      = 1'b0;
// //         ///////////////////
// //         next_state  = state;
// //         next_data   = data;
// //         next_instr  = instr;
// //         next_adr    = adr_i;
// //         next_data_w = cpu_dat_i;
// //         case (state)
// //             IDLE: begin
// //                 if (D_fetch) begin
// //                     read_i      = 1'b1;
// //                     write_i     = 1'b0;
// //                     next_adr    = data_adr;
// //                     next_state  = READ_D;
// //                 end else if (D_write) begin
// //                     read_i      = 1'b0;
// //                     write_i     = 1'b1;
// //                     next_adr    = data_adr;
// //                     next_data_w = writedata;
// //                     next_state  = WRITE_D;
// //                 end else if (I_fetch) begin
// //                     read_i      = 1'b1;
// //                     write_i     = 1'b0;
// //                     next_adr    = instr_adr;
// //                     next_state  = READ_I;
// //                 end else begin
// //                     read_i      = 1'b0;
// //                     write_i     = 1'b0;
// //                     next_adr    = 32'b0;
// //                     next_data_w = 32'b0;
// //                     next_state  = IDLE;
// //                 end
// //             end
// //             READ_I: begin
// //                 read_i          = 1'b0;
// //                 if (busy_o) begin
// //                     next_instr  = cpu_dat_o;
// //                 end else begin
// //                     next_adr    = 32'b0;
// //                     i_done      = 1'b1;
// //                     next_instr  = 32'b0;
// //                     next_state  = IDLE;
// //                 end
// //             end
// //             READ_D: begin
// //                 read_i          = 1'b0;
// //                 if (busy_o) begin
// //                     next_data   = cpu_dat_o;
// //                 end else begin
// //                     next_adr    = 32'b0;
// //                     d_done      = 1'b1;
// //                     next_data   = 32'b0;
// //                     next_state  = IDLE;
// //                 end
// //             end
// //             WRITE_D: begin
// //                 write_i         = 1'b0;
// //                 if (!busy_o) begin
// //                     next_adr    = 32'b0;
// //                     next_data_w = 32'b0;
// //                     d_done      = 1'b1;
// //                     next_state  = IDLE;
// //                 end
// //             end
// //             default:; 
// //         endcase
// //     end
// // endmodule
