`timescale 10ms/1ns

//test all 9 implemented Opcodes and verify relevant outputs for each
module tb_decode ();


//declare testing variables and instantiate DUT
logic [31:0] instruction;
logic [6:0] opcode, func7, exp_opcode, exp_func7;
logic [4:0] rs1, rs2, rd, exp_rs1, exp_rs2, exp_rd;
logic [2:0] func3, exp_func3;

integer total_tests = 0, passed_tests = 0, case_number = 0;

decode breakdown (.instruction(instruction), .opcode(opcode), .rs1(rs1), .rs2(rs2), .rd(rd), .ALUOp(func3), .func7(func7));

//create verification tasks
task check_opcode;
    total_tests++;
    if (opcode == exp_opcode) begin
       passed_tests++; 
    end else begin
        $display("Error in Opcode ouput\nCase: %d", case_number);
    end
endtask

task check_rs1;
    total_tests++;
    if (rs1 == exp_rs1) begin
       passed_tests++; 
    end else begin
        $display("Error in rs1 ouput\nCase: %d", case_number);
    end
endtask

task check_rs2;
    total_tests++;
    if (rs2 == exp_rs2) begin
       passed_tests++; 
    end else begin
        $display("Error in rs2 ouput\nCase: %d", case_number);
    end
endtask

task check_rd;
    total_tests++;
    if (rd == exp_rd) begin
       passed_tests++; 
    end else begin
        $display("Error in rd ouput\nCase: %d", case_number);
    end
endtask

task check_func3;
    total_tests++;
    if (func3 == exp_func3) begin
       passed_tests++; 
    end else begin
        $display("Error in func3 ouput\nCase: %d", case_number);
    end
endtask

task check_func7;
    total_tests++;
    if (func7 == exp_func7) begin
       passed_tests++; 
    end else begin
        $display("Error in func7 ouput\nCase: %d", case_number);
    end

endtask

//begin testing
initial begin
     // Signal dump
    $dumpfile("dump.vcd");
    $dumpvars; 

    ////////////////////////////////////
    //Test Case 1: U-Opcode: 0110111, lui x17, 8552
    /////////////////////////////////////
    
    case_number++;
    instruction = 32'b00000010000101101000100010110111;
    exp_opcode = 7'b0110111;
    exp_rd = 5'd17;

    check_opcode;
    check_rd;

    ////////////////////////////////////
    //Test Case 2: U-Opcode: 0010111, auipc x6, 6245
    /////////////////////////////////////

    case_number++;
    instruction = 32'b00000001100001100101001100010111;
    exp_opcode = 7'b0010111;
    exp_rd = 5'd6;

    check_opcode;
    check_rd;

    ////////////////////////////////////
    //Test Case 3: J-Opcode: 1101111, jal x25, 9874
    /////////////////////////////////////

    case_number++;
    instruction = 32'b01101001001000000010110011101111;
    exp_opcode = 7'b1101111;
    exp_rd = 5'd25;

    check_opcode;
    check_rd;

    ////////////////////////////////////
    //Test Case 4: I-Opcode: 1100111, jalr x25, 1682(x4)
    /////////////////////////////////////

    case_number++;
    instruction = 32'b01101001001000100000110011100111;
    exp_opcode = 7'b1100111;
    exp_rd = 5'd25;
    exp_rs1 = 5'd4;
    exp_func3 = 3'b000;

    check_opcode;
    check_rd;
    check_rs1;
    check_func3;

    ////////////////////////////////////
    //Test Case 5: B-Opcode: 1100011, bltu x31, x12, 1960
    /////////////////////////////////////

    case_number++;
    instruction = 32'b01111010110011111110010001100011;
    exp_opcode = 7'b1100011;
    exp_rs1 = 5'd31;
    exp_rs2 = 5'd12;

    check_opcode;
    check_rs1;
    check_rs2;
    
    ////////////////////////////////////
    //Test Case 6: I-Opcode: 0000011, lb x14, -640(x21)
    /////////////////////////////////////

    case_number++;
    instruction = 32'b11011000000010101000011100000011;
    exp_opcode = 7'b0000011;
    exp_rd = 5'd14;
    exp_rs1 = 5'd21;
    exp_func3 = 3'b000;

    check_opcode;
    check_rs1;
    check_rd;
    check_func3;

    ////////////////////////////////////
    //Test Case 7: S-Opcode: 0100011, sb x3, 555(x1)
    /////////////////////////////////////

    case_number++;
    instruction = 32'b00100010001100001000010110100011;
    exp_opcode = 7'b0100011;
    exp_rs1 = 5'd1;
    exp_rs2 = 5'd3;
    exp_func3 = 3'b000;

    check_opcode;
    check_rs1;
    check_rs2;
    check_func3;

    ////////////////////////////////////
    //Test Case 8: I-Opcode: 0010011, xori x28, x21, 20
    /////////////////////////////////////

    case_number++;
    instruction = 32'b00000001010010101100111000010011;
    exp_opcode = 7'b0010011;
    exp_rd = 5'd28;
    exp_rs1 = 5'd21;
    exp_func3 = 3'b100;

    check_opcode;
    check_rs1;
    check_rd;
    check_func3;
    
    ////////////////////////////////////
    //Test Case 9: I-Opcode: 0010011, slli x6, x2, 9
    /////////////////////////////////////

    case_number++;
    instruction = 32'b00000000100100010001001100010011;
    exp_opcode = 7'b0010011;
    exp_rd = 5'd6;
    exp_rs1 = 5'd2;
    exp_func3 = 3'b001;
    exp_func7 = 7'b0;

    check_opcode;
    check_rs1;
    check_rd;
    check_func3;
    check_func7;

    ////////////////////////////////////
    //Test Case 10: R-Opcode: 0110011, add x5, x3, x2
    /////////////////////////////////////

    case_number++;
    instruction = 32'b00000000001000011000001010110011;
    exp_opcode = 7'b0110011;
    exp_rd = 5'd5;
    exp_rs1 = 5'd3;
    exp_rs2 = 5'd2;
    exp_func3 = 3'b000;


    check_opcode;
    check_rs1;
    check_rd;
    check_func3;
    check_func7;

    //display results
    $display("Total Tests: %d, Passed Tests: %d", total_tests, passed_tests);
end
endmodule