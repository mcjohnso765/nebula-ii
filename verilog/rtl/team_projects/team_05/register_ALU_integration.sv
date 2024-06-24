module register_ALU_integration(
    //registers
    input logic [31:0] write_data,
    input logic [4:0] rd, rs1, rs2,
    input logic clk, rst, writeEnable,

    //register & ALU is both an input and output
    output logic [31:0] reg1, reg2,

    //ALU
    input logic ALU_source,
    input logic [6:0] opcode, funct7,
    input logic [2:0] funct3,
    input logic [31:0] immediate,
    output logic [31:0] read_address, write_address, result,
    output logic branch
);
    register_file regfile ( 
        .reg_write(write_data),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2),
        .clk(clk),
        .rst(rst),
        .write(writeEnable),
        //outputs
        .reg1(reg1),
        .reg2(reg2)
        );

    ALU alu_grab(
        .ALU_source(ALU_source),
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .reg1(reg1),
        .reg2(reg2),
        .immediate(immediate),
        //output
        .read_address(read_address),
        .write_address(write_address),
        .result(result),
        .branch(branch)
        );
endmodule