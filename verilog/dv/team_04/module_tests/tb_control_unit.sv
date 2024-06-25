`timescale 10ms/1ns

//test all 9 implemented Opcodes and verify relevant output signals for each
module tb_control_unit ();

//declare testing variables and instantiate DUT
logic [6:0] Opcode;
logic branch, exp_branch,
    jump, exp_jump,
    ALUSrc, exp_ALUSrc,
    RegWrite, exp_RegWrite,
    MemWrite, exp_MemWrite,
    MemRead, exp_MemRead,
    error, exp_error;

logic [1:0] RegWriteSrc, exp_RegWriteSrc;

integer total_tests = 0, passed_tests = 0, case_number = 0;
control_unit controller (.opcode(Opcode), .RegWriteSource(RegWriteSrc), .ALUSrc(ALUSrc), .RegWrite(RegWrite), .Jump(jump), .Branch(branch), .MemWrite(MemWrite), .MemRead(MemRead), .Error(error));

//create verification tasks
task check_branch;
    total_tests++;
    if ( branch == exp_branch) begin
       passed_tests++; 
    end else begin
        $display("Error in Branch ouput\nCase: %d", case_number);
    end
endtask

task check_jump;
    total_tests++;
    if ( jump == exp_jump) begin
       passed_tests++; 
    end else begin
        $display("Error in Jump ouput\nCase: %d", case_number);
    end
endtask

task check_ALUSrc;
    total_tests++;
    if ( ALUSrc == exp_ALUSrc) begin
       passed_tests++; 
    end else begin
        $display("Error in ALUSrc ouput\nCase: %d", case_number);
    end
endtask

task check_RegWrite;
    total_tests++;
    if ( RegWrite == exp_RegWrite) begin
       passed_tests++; 
    end else begin
        $display("Error in RegWrite ouput\nCase: %d", case_number);
    end
endtask

task check_MemWrite;
    total_tests++;
    if ( MemWrite== exp_MemWrite) begin
       passed_tests++; 
    end else begin
        $display("Error in MemWrite ouput\nCase: %d", case_number);
    end
endtask

task check_MemRead;
    total_tests++;
    if ( MemRead == exp_MemRead) begin
       passed_tests++; 
    end else begin
        $display("Error in MemRead ouput\nCase: %d", case_number);
    end
endtask

task check_RegWriteSrc;
    total_tests++;
    if ( RegWriteSrc == exp_RegWriteSrc) begin
       passed_tests++; 
    end else begin
        $display("Error in RegWriteSrc ouput\nCase: %d", case_number);
    end
endtask

task check_error;
    total_tests++;
    if ( error == exp_error) begin
       passed_tests++; 
    end else begin
        $display("Error in error flag ouput\nCase: %d", case_number);
    end
endtask

task check_signals;
    check_jump;
    check_branch;
    check_ALUSrc;
    check_RegWrite;
    check_MemWrite;
    check_MemRead;
    check_RegWriteSrc;
    check_error;
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
    Opcode = 7'b0110111;
    exp_branch = 0;
    exp_jump = 0;
    exp_ALUSrc = 0;
    exp_RegWrite = 1;
    exp_MemRead = 0;
    exp_MemWrite = 0;
    exp_RegWriteSrc = 2'b10;
    exp_error = 0;

    #10;

    check_signals;



    ////////////////////////////////////
    //Test Case 2: U-Opcode: 0010111, auipc x6, 6245
    /////////////////////////////////////

    case_number++;
    Opcode = 7'b0010111;
    exp_branch = 0;
    exp_jump = 0;
    exp_ALUSrc = 1;
    exp_RegWrite = 1;
    exp_MemRead = 0;
    exp_MemWrite = 0;
    exp_RegWriteSrc = 2'b11;
    exp_error = 0;

    #10;

    check_signals;

    ////////////////////////////////////
    //Test Case 3: J-Opcode: 1101111, jal x25, 9874
    /////////////////////////////////////

    case_number++;
    Opcode = 7'b1101111;
    exp_branch = 0;
    exp_jump = 1;
    exp_ALUSrc = 1;
    exp_RegWrite = 1;
    exp_MemRead = 0;
    exp_MemWrite = 0;
    exp_RegWriteSrc = 2'b11;
    exp_error = 0;

    #10;

    check_signals;

    ////////////////////////////////////
    //Test Case 4: I-Opcode: 1100111, jalr x25, 1682(x4)
    /////////////////////////////////////

    case_number++;
    Opcode = 7'b1100111;
    exp_branch = 0;
    exp_jump = 1;
    exp_ALUSrc = 1;
    exp_RegWrite = 1;
    exp_MemRead = 0;
    exp_MemWrite = 0;
    exp_RegWriteSrc = 2'b11;
    exp_error = 0;

    #10;

    check_signals;

    ////////////////////////////////////
    //Test Case 5: B-Opcode: 1100011, bltu x31, x12, 1960
    /////////////////////////////////////

    case_number++;
    Opcode = 7'b1100011;
    exp_branch = 1;
    exp_jump = 0;
    exp_ALUSrc = 1;
    exp_RegWrite = 0;
    exp_MemRead = 0;
    exp_MemWrite = 0;
    exp_RegWriteSrc = 2'b00;
    exp_error = 0;

    #10;

    check_signals;
    
    ////////////////////////////////////
    //Test Case 6: I-Opcode: 0000011, lb x14, -640(x21)
    /////////////////////////////////////

    case_number++;
    Opcode = 7'b0000011;
    exp_branch = 0;
    exp_jump = 0;
    exp_ALUSrc = 1;
    exp_RegWrite = 1;
    exp_MemRead = 1;
    exp_MemWrite = 0;
    exp_RegWriteSrc = 2'b01;
    exp_error = 0;

    #10;

    check_signals;

    ////////////////////////////////////
    //Test Case 7: S-Opcode: 0100011, sb x3, 555(x1)
    /////////////////////////////////////

    case_number++;
    Opcode = 7'b0100011;
    exp_branch = 0;
    exp_jump = 0;
    exp_ALUSrc = 1;
    exp_RegWrite = 0;
    exp_MemRead = 0;
    exp_MemWrite = 1;
    exp_RegWriteSrc = 2'b00;
    exp_error = 0;

    #10;

    check_signals;

    ////////////////////////////////////
    //Test Case 8: I-Opcode: 0010011, xori x28, x21, 20
    /////////////////////////////////////

    case_number++;
    Opcode = 7'b0010011;
    exp_branch = 0;
    exp_jump = 0;
    exp_ALUSrc = 1;
    exp_RegWrite = 1;
    exp_MemRead = 0;
    exp_MemWrite = 0;
    exp_RegWriteSrc = 2'b00;
    exp_error = 0;

    #10;
 
    check_signals;
    
    ////////////////////////////////////
    //Test Case 9: I-Opcode: 0010011, slli x6, x2, 9
    /////////////////////////////////////

    case_number++;
    Opcode = 7'b0010011;
    exp_branch = 0;
    exp_jump = 0;
    exp_ALUSrc = 1;
    exp_RegWrite = 1;
    exp_MemRead = 0;
    exp_MemWrite = 0;
    exp_RegWriteSrc = 2'b00;
    exp_error = 0;

    #10;

    check_signals;

    ////////////////////////////////////
    //Test Case 10: R-Opcode: 0110011, add x5, x3, x2
    /////////////////////////////////////

    case_number++;
    Opcode = 7'b0110011;
    exp_branch = 0;
    exp_jump = 0;
    exp_ALUSrc = 0;
    exp_RegWrite = 1;
    exp_MemRead = 0;
    exp_MemWrite = 0;
    exp_RegWriteSrc = 2'b00;
    exp_error = 0;

    #10;

    check_signals;

    //////////////Storage//////////////////////
    //Test Case 11: Invalid Opcode: 1111111
    /////////////////////////////////////

    case_number++;
    Opcode = 7'b1111111;
    exp_branch = 0;
    exp_jump = 0;
    exp_ALUSrc = 0;
    exp_RegWrite = 0;
    exp_MemRead = 0;
    exp_MemWrite = 0;
    exp_RegWriteSrc = 2'b00;
    exp_error = 1;

    #10;

    check_signals;

    $display("Total Tests: %d, Passed Tests: %d" , total_tests, passed_tests);

end
endmodule
