module t03_decoder (
    input logic [31:0] inst,
    //output logic [31:0] imm_gen,
    output logic [4:0] rs1, rs2, rd,
    output logic [2:0] type_out,
    output logic [16:0] control_out
);

 // typedef enum logic [2:0] {R = 0, I = 1, S = 2, SB = 3, UJ = 4, U = 5} inst_t;
  logic [6:0] opcode;
  logic [2:0] funct3;
  logic [6:0] funct7;
  logic [2:0] inst_t;

always_comb begin
    opcode = inst[6:0];
    case (opcode)
        7'b0000011, 7'b0010011, 7'b0011011: inst_t = 3'd1;
        7'b0110011, 7'b0111011: inst_t = 3'b0;
        7'b0100011: inst_t = 3'd2;
        7'b1100011: inst_t = 3'd3;
        7'b1101111: inst_t = 3'd4;
        7'b0110111: inst_t = 3'd5;
        default: inst_t = 3'b0;
    endcase
    type_out = inst_t;
end

always_comb begin
    case (inst_t) 
        3'b0: begin funct7 = inst[31:25]; funct3 = inst[14:12]; rs1 = inst[19:15]; rs2 = inst[24:20]; rd = inst[11:7]; end
        3'd1: begin funct7 = 7'b0; funct3 = inst[14:12]; rs1 = inst[19:15]; rs2 = 5'b0; rd = inst[11:7]; end
        3'b010: begin funct7 = 7'b0; funct3 = inst[14:12]; rs1 = inst[19:15]; rs2 = inst[24:20]; rd = 5'b0; end
        3'd3: begin funct7 = 7'b0; funct3 = inst[14:12]; rs1 = inst[19:15]; rs2 = inst[24:20]; rd = 5'b0; end
        3'd5: begin funct7 = 7'b0; funct3 = 3'b0; rs1 = 5'b0; rs2 = 5'b0; rd = inst[11:7]; end    
        3'd4: begin funct7 = 7'b0; funct3 = 3'b0; rs1 = 5'b0; rs2 = 5'b0; rd = inst[11:7]; end  

        default: begin funct7 = 7'b0; funct3 = 3'b0; rs1 = 5'b0; rs2 = 5'b0; rd = 5'b0; end

    endcase 
    control_out = {funct7, funct3, inst[6:0]};
    end
    
endmodule