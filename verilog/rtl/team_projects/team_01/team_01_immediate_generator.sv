// DONE

/*
    Module Name: immediate_generator
    Author: Andrew Bauer
    Description: Determine the provided values for the immediate from the instruction code and sign extend to a 32-bit value. 
*/

module immediate_generator (
    input   logic [31:0] Instr,
    output  logic [31:0] Imm
);
    always_comb begin
        case (Instr[6:0])
            7'h03, 7'h13, 7'h1b, 7'h67: begin
                Imm = {{20{Instr[31]}}, Instr[31:20]}; 
            end
            7'h23: begin
                Imm = {{20{Instr[31]}}, Instr[31:25], Instr[11:7]};
            end
            7'h37, 7'h17: begin
                Imm = {Instr[31:12], 12'b0};
            end
            7'h63: begin
                Imm = {{20{Instr[31]}}, Instr[31], Instr[7], Instr[30:25], Instr[11:8]}; 
            end
            7'h6F: begin
                Imm= {{12{Instr[31]}}, Instr[31], Instr[19:12], Instr[20], Instr[30:21]};
            end
            default: begin
                Imm = 32'h00000000;
            end
        endcase
    end
endmodule