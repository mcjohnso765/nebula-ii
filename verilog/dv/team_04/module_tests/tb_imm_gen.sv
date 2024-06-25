`timescale 10ms/1ns

//test all immediate formats and verify outputs
module tb_imm_gen ();
    
logic [31:0] instruction, imm, exp_imm;

integer total_tests = 0, passed_tests = 0, case_number = 0;

task check_imm;
    total_tests++;
    if (imm == exp_imm) begin
       passed_tests++; 
    end else begin
        $display("Error in Opcode ouput\nCase: %d, Expected Immediate: %b, Actual Immediate: %b", case_number, exp_imm, imm);
    end
endtask

imm_gen immediate(.instruction(instruction), .imm(imm));


initial begin
     // Signal dump
    $dumpfile("dump.vcd");
    $dumpvars; 

    ////////////////////////////////////
    //Test Case 1: U-Opcode: 0110111, lui x17, 8552
    /////////////////////////////////////
    
    case_number++;
    instruction = 32'b00000010000101101000100010110111;
    exp_imm = 32'b00000010000101101000000000000000;
    
    #10;

    check_imm;


    ////////////////////////////////////
    //Test Case 2: U-Opcode: 0010111, auipc x6, 6245
    /////////////////////////////////////
    
    case_number++;
    instruction = 32'b00000001100001100101001100010111;
    exp_imm = 32'b00000001100001100101000000000000;
    
    #10;

    check_imm;

    ////////////////////////////////////
    //Test Case 3: J-Opcode: 1101111, jal x25, 9874
    /////////////////////////////////////
    
    case_number++;
    instruction = 32'b01101001001000000010110011101111;
    exp_imm = 32'd9874;
    
    #10;

    check_imm;

    ////////////////////////////////////
    //Test Case 4: I-Opcode: 1100111, jalr x25, 1682(x4)
    /////////////////////////////////////
    
    case_number++;
    instruction = 32'b01101001001000100000110011100111;
    exp_imm = 32'd1682;
    
    #10;

    check_imm;

    ////////////////////////////////////
    //Test Case 5: B-Opcode: 1100011, bltu x31, x12, 1960
    /////////////////////////////////////
    
    case_number++;
    instruction = 32'b01111010110011111110010001100011;
    exp_imm = 32'd1960;
    
    #10;

    check_imm;

    ////////////////////////////////////
    //Test Case 6: I-Opcode: 0000011, lb x14, -640(x21)
    /////////////////////////////////////

    case_number++;
    instruction = 32'b11011000000010101000011100000011;
    exp_imm = 32'b11111111111111111111110110000000;

    #10;

    check_imm;
    ////////////////////////////////////
    //Test Case 7: S-Opcode: 0100011, sb x3, 555(x1)
    /////////////////////////////////////

    case_number++;
    instruction = 32'b00100010001100001000010110100011;
    exp_imm = 32'd555;
    
    #10;

    check_imm;

    ////////////////////////////////////
    //Test Case 8: I-Opcode: 0010011, xori x28, x21, 20
    /////////////////////////////////////

    case_number++;
    instruction = 32'b00000001010010101100111000010011;
    exp_imm = 32'd20;

    #10;

    check_imm;
    
    ////////////////////////////////////
    //Test Case 9: I-Opcode: 0010011, slli x6, x2, 9
    /////////////////////////////////////

    case_number++;
    instruction = 32'b00000000100100010001001100010011;
    exp_imm = 32'd9;
    
    #10;
    
    check_imm;

    $display("Total Tests: %d, Passed Tests: %d", total_tests, passed_tests);
end
endmodule