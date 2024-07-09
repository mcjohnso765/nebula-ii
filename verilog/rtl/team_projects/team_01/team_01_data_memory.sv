typedef enum logic [1:0] {BYTE, HALFWORD, WORD} data_width;

// module data_memory (
//     input logic         clk, nRST,
//     input logic [31:0]  address, writedata, data_i,
//     input logic         MemRead, MemWrite, done,
//     input data_width    datawidth,
//     output logic [31:0] readdata, address_DM, writedata_o,
//     output logic        read_o, write_o
// );
//     assign address_DM   = address;

//     logic next_read_o, next_write_o;
//     // logic [31:0] next_readdata;

//     always_comb begin
//         case(datawidth)
//             BYTE:     writedata_o = {{24{writedata[7]}},  writedata[7:0]};
//             HALFWORD: writedata_o = {{16{writedata[15]}}, writedata[15:0]};
//             WORD:     writedata_o = writedata;
//             default:  writedata_o = writedata;
//         endcase
//     end

//     typedef enum logic [1:0] {IDLE, READ, WRITE} StateType;
//     StateType state, next_state;

//     always_ff @(posedge clk, negedge nRST) begin
//         if (!nRST) begin
//             state       <= IDLE;
//             read_o      <= 1'b0;
//             write_o     <= 1'b0;
//             // readdata    <= 32'b0;
//         end else begin
//             state       <= next_state;
//             read_o      <= next_read_o;
//             write_o     <= next_write_o;
//             // readdata    <= next_readdata;
//         end
//     end

//     always_comb begin
//         next_state      = state;
//         next_read_o     = 1'b0;
//         next_write_o    = 1'b0;
//         readdata        = 32'b0;
//         // next_readdata   = readdata;
//         case (state)
//             IDLE: begin
//                 if (MemRead && !done) begin
//                     next_read_o     = 1'b1;
//                     next_state      = READ;
//                 end else if (MemWrite && !done) begin
//                     next_write_o    = 1'b1;
//                     next_state      = WRITE;
//                 end 
//             end 
//             READ: begin
//                 if (done) begin
//                     next_state  = IDLE;
//                     case(datawidth)
//                         BYTE:     readdata = {{24{data_i[7]}}, data_i[7:0]};
//                         HALFWORD: readdata = {{16{data_i[15]}}, data_i[15:0]};
//                         WORD:     readdata = data_i;
//                         default:  readdata = data_i;
//                     endcase
//                 end
//             end
//             // READ: begin
//             //     if (done) begin
//             //         next_state  = IDLE;
//             //         case(datawidth)
//             //             BYTE:     next_readdata = {{24{data_i[7]}}, data_i[7:0]};
//             //             HALFWORD: next_readdata = {{16{data_i[15]}}, data_i[15:0]};
//             //             WORD:     next_readdata = data_i;
//             //             default:  next_readdata = data_i;
//             //         endcase
//             //     end
//             // end
//             WRITE: begin
//                 if (done) begin
//                     next_state = IDLE;
//                 end
//             end
//             default: begin
//                 next_state      = IDLE;
//                 next_read_o     = 1'b0;
//                 next_write_o    = 1'b0;
//                 readdata        = 32'b0;
//                 // next_readdata   = 32'b0;
//             end 
//         endcase
//     end
// endmodule

// /*
//     Module Name: data_memory
//     Author: Ivan Usynin
//     Description: Load and store ALU results/operands (reading and writing to memory)
//     */


// module data_memory
// (
//     input logic [31:0] address, writedata, data_i,
//     input data_width datawidth,
//     input logic MemWrite, MemRead,
//     output logic [31:0] readdata, address_DM, writedata_o,
//     output logic read_o, write_o
// );

//     always_comb begin
//         readdata = 32'h0;
//         address_DM = address; // data memory address for request unit
//         read_o = MemRead;     // MemRead signal for request unit
//         write_o = MemWrite;   // MemWrite signal for request unit
//         writedata_o = 32'h0;
//         readdata = 32'h0;

//         if(MemWrite) begin
//             case(datawidth)
//                 BYTE:     writedata_o = {{24{writedata[7]}},  writedata[7:0]};
//                 HALFWORD: writedata_o = {{16{writedata[15]}}, writedata[15:0]};
//                 WORD:     writedata_o = writedata;
//                 default:  writedata_o = writedata;
//             endcase 
//         end


//         if(MemRead) begin
//             case(datawidth)
//                 BYTE:     readdata = {{24{data_i[7]}}, data_i[7:0]};
//                 HALFWORD: readdata = {{16{data_i[15]}}, data_i[15:0]};
//                 WORD:     readdata = data_i;
//                 default:  readdata = data_i;
//             endcase
//         end
//     end
// endmodule


module data_memory (
    input logic         clk, nRST,
    input logic [31:0]  address, writedata, data_i,
    input logic         MemRead, MemWrite, done,
    input data_width    datawidth,
    output logic [31:0] readdata, address_DM, writedata_o,
    output logic        read_o, write_o, enable
);
    assign address_DM = address;

    logic [31:0] next_readdata;

    logic next_enable;

    typedef enum logic [1:0] {IDLE, READ, WRITE} StateType;

    StateType state, next_state;
    
    always_comb begin
        case(datawidth)
            BYTE:     writedata_o = {{24{writedata[7]}},  writedata[7:0]};
            HALFWORD: writedata_o = {{16{writedata[15]}}, writedata[15:0]};
            WORD:     writedata_o = writedata;
            default:  writedata_o = writedata;
        endcase
    end

    always_ff @(posedge clk, negedge nRST) begin
        if (!nRST) begin
            state       <= IDLE;
            readdata    <= 32'b0;
            enable      <= 1'b0;
        end else begin
            state       <= next_state;
            readdata    <= next_readdata;
            enable      <= next_enable;
        end
    end

    always_comb begin
        next_state      = state;
        next_readdata   = readdata;
        next_enable     = 1'b0;
        read_o = 1'b0;
        write_o = 1'b0;
        case (state)
            IDLE: begin
                if (MemRead && !enable) begin
                    next_state = READ;
                end else if (MemWrite && !enable) begin
                    next_state = WRITE;
                end
            end 
            READ: begin
                read_o  = 1'b1;
                write_o = 1'b0;
                if (done) begin
                    next_enable = 1'b1;
                    next_state  = IDLE;
                    case(datawidth)
                        BYTE:     next_readdata = {{24{data_i[7]}}, data_i[7:0]};
                        HALFWORD: next_readdata = {{16{data_i[15]}}, data_i[15:0]};
                        WORD:     next_readdata = data_i;
                        default:  next_readdata = data_i;
                    endcase
                end
            end
            WRITE: begin
                write_o = 1'b1;
                read_o  = 1'b0;
                if (done) begin
                    next_enable = 1'b1;
                    next_state  = IDLE;
                end
            end
            default:; 
        endcase
    end
endmodule
// // // /*
// // //     Module Name: data_memory
// // //     Author: Ivan Usynin
// // //     Description: Load and store ALU results/operands (reading and writing to memory)
// // //     */

// // typedef enum logic [1:0] {BYTE, HALFWORD, WORD} data_width;

// // // module data_memory
// // // (
// // //     input logic [31:0] address, writedata, data_i,
// // //     input data_width datawidth,
// // //     input logic MemWrite, MemRead,
// // //     output logic [31:0] readdata, address_DM, writedata_o,
// // //     output logic read_o, write_o
// // // );

// // //     always_comb begin
// // //         readdata = 32'h0;
// // //         address_DM = address; // data memory address for request unit
// // //         read_o = MemRead;     // MemRead signal for request unit
// // //         write_o = MemWrite;   // MemWrite signal for request unit
// // //         writedata_o = 32'h0;
// // //         readdata = 32'h0;

// // //         if(MemWrite) begin
// // //             case(datawidth)
// // //                 BYTE:     writedata_o = {{24{writedata[7]}},  writedata[7:0]};
// // //                 HALFWORD: writedata_o = {{16{writedata[15]}}, writedata[15:0]};
// // //                 WORD:     writedata_o = writedata;
// // //                 default:  writedata_o = writedata;
// // //             endcase 
// // //         end


// // //         if(MemRead) begin
// // //             case(datawidth)
// // //                 BYTE:     readdata = {{24{data_i[7]}}, data_i[7:0]};
// // //                 HALFWORD: readdata = {{16{data_i[15]}}, data_i[15:0]};
// // //                 WORD:     readdata = data_i;
// // //                 default:  readdata = data_i;
// // //             endcase
// // //         end
// // //     end
// // // endmodule

// // module data_memory (
// //     input logic clk, nRST,
// //     input logic [31:0] address, writedata, data_i,
// //     input logic MemRead, MemWrite, done,
// //     input data_width datawidth,
// //     output logic [31:0] readdata, address_DM, writedata_o,
// //     output logic read_o, write_o
// // );
// //     typedef enum logic [1:0] {IDLE, READ, WRITE} StateType;

// //     StateType state, next_state;

// //     logic [31:0] next_adr, next_write_data, next_read_data;
// //     logic next_read_i, next_write_i;

// //     always_ff @(posedge clk, negedge nRST) begin
// //         if (!nRST) begin
// //             state       <= IDLE;
// //             read_o      <= 1'b0;
// //             write_o     <= 1'b0;
// //             address_DM  <= 32'b0;
// //             writedata_o <= 32'b0;
// //             // readdata    <= 32'b0;
// //         end else begin
// //             state <= next_state;
// //             read_o      <= next_read_i;
// //             write_o     <= next_write_i;
// //             address_DM  <= next_adr;
// //             writedata_o <= next_write_data;
// //             // readdata    <= next_read_data;
// //         end
// //     end

// //     always_comb begin
// //         next_state      = state;
// //         next_read_i     = read_o;
// //         next_write_i    = write_o;
// //         next_adr        = address;
// //         // next_read_data  = readdata;
// //         next_write_data = writedata_o;
// //         readdata = 32'b0;
// //         case (state)
// //             IDLE: begin
// //                 if (MemRead) begin
// //                     next_read_i     = 1'b1;
// //                     next_write_i    = 1'b0;
// //                     next_adr        = address;
// //                     next_state      = READ; 
// //                 end else if (MemWrite) begin
// //                     next_read_i     = 1'b0;
// //                     next_write_i    = 1'b1;
// //                     next_adr        = address;
// //                     next_state      = WRITE;
// //                     case(datawidth)
// //                         BYTE:     next_write_data = {{24{writedata[7]}},  writedata[7:0]};
// //                         HALFWORD: next_write_data = {{16{writedata[15]}}, writedata[15:0]};
// //                         WORD:     next_write_data = writedata;
// //                         default:  next_write_data = writedata;
// //                     endcase 
// //                 end 
// //             end 
// //             READ: begin
// //                 if (done) begin
// //                     next_adr        = 32'b0;
// //                     next_read_i     = 1'b0;
// //                     next_state      = IDLE;
// //                     case(datawidth)
// //                         BYTE:     readdata = {{24{data_i[7]}}, data_i[7:0]};
// //                         HALFWORD: readdata = {{16{data_i[15]}}, data_i[15:0]};
// //                         WORD:     readdata = data_i;
// //                         default:  readdata = data_i;
// //                     endcase
// //                 end
// //             end
// //             WRITE: begin
// //                 if (done) begin
// //                     next_adr        = 32'b0;
// //                     next_write_data = 32'b0;
// //                     next_write_i    = 1'b0;
// //                     next_state      = IDLE;
// //                 end
// //             end
// //             default:; 
// //         endcase
// //     end
// // endmodule