module PC_ALU_integration(
    input logic clk, nRst, load, inc, Disable, ALU_source,
    input logic [6:0] opcode,
    input logic [2:0] funct3,
    input logic [6:0] funct7,
    input logic [31:0] data, imm_val, reg1, reg2,
    output logic [31:0] pc_val, read_ad, write_ad, result,  
);

    logic branch;

    ALU ALU1(.ALU_source(ALU_source), .opcode(opcode), .funct3(funct3), .funct7(funct7), 
    .reg1(reg1), .reg2(reg2), .immediate(imm_val), .read_address(read_ad), .write_address(write_ad),
    .result(result), .branch(branch));

    pc pc1(.clk(clk), .clr(nRst), .load(load), .inc(inc), .Disable(Disable), .ALU_out(branch), .data(data), .imm_val(imm_val), .pc_val(pc_val));

endmodule
