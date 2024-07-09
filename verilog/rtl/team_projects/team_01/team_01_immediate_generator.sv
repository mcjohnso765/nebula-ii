/*
    Module Name: immediate_generator
    Author: Andrew Bauer
    Description: Determine the provided values for the immediate from the instruction code and sign extend to a 32-bit value. 
    */


module immediate_generator (
    input logic [31:0]instr,
    output logic [31:0]imm
);
    // Write your code here!
    always_comb begin
        case (instr[6:0])
            7'h03, 7'h13, 7'h1b, 7'h67: imm = {{20{instr[31]}}, instr[31:20]}; 
            7'h23: imm = {{20{instr[31]}}, instr[31:25], instr[11:7]};
            7'h37, 7'h17: imm = {instr[31:12], 12'b0};
            7'h63: imm = {{20{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8]}; 
            7'h6F: imm= {{12{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21]};
            default: imm = 32'h0000;
        endcase
    end
endmodule