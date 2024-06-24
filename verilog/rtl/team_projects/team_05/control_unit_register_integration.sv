module control_unit_register_integration (

    //control unit 
    input logic [31:0] instruction,
    output logic [6:0] opcode, funct7,
    output logic [2:0] funct3,
    output logic [31:0] immediate,
    output logic ALU_source, memToReg, load_pc,

    //input + output
    output logic [4:0] rs1, rs2, rd,

    //registers
    input logic [31:0] write_data,
    input logic clk, rst, writeEnable,
    output logic [31:0] reg1, reg2

);
    control_unit controlunit (
        .instruction(instruction),
        .opcode(opcode),
        .funct7(funct7),
        .funct3(funct3),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .imm_32(immediate),
        .ALU_source(ALU_source),
        .memToReg(memToReg),
        .load_pc(load_pc)
    );

    register_file registerfile (
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

endmodule