//timescale
`timescale 1ms/10ps

module tb_register_file;
    localparam CLK_PERIOD = 10;
    reg[31:0] write_data;
    reg[4:0] rd, rs1, rs2;
    logic clk, rst, writeEnable;

    logic [31:0] reg1, reg2;

    logic ALU_source;
    logic [6:0] opcode, funct7;
    logic [2:0] funct3;
    logic [31:0] immediate, read_address, write_address, result;
    logic branch;


    register_ALU_integration test(
        //register input
        .write_data(write_data),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2),
        .clk(clk),
        .rst(rst),
        .writeEnable(writeEnable),
        //output+input
        .reg1(reg1),
        .reg2(reg2),
        //ALU input
        .ALU_source(ALU_source),
        .opcode(opcode),
        .funct7(funct7),
        .funct3(funct3),
        .immediate(immediate),
        //output
        .read_address(read_address),
        .write_address(write_address),
        .result(result),
        .branch(branch)
    );
    
    //toggle clk
    always begin 
        clk = 0;
        #(CLK_PERIOD / 2);
        clk = 1;
        #(CLK_PERIOD / 2);
    end

    initial begin

        $dumpfile("sim.vcd");
        $dumpvars(0, tb_register_ALU_integration);

        tb_test_num = -1;
        tb_test_name = "Test bench initialization";
        rst = 1'b1;
        write_data = 32'b0;
        rd = 5'b0;
        rs1 = 5'b0;
        rs2 = 5'b0;
        writeEnable = 1'b0;
        ALU_source = ;
        opcode = ;
        funct3 = ;
        funct7 = ;
        immediate = ;

endmodule