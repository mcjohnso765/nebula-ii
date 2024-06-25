
`timescale 1ms / 100us

module tb_alu_control_unit();

//enum for operation type
typedef enum logic [3:0] {
    ADD=0, SUB=1, SLL=2, SLT=3, SLTU=4, XOR=5, SRL=6, SRA=7,OR=8, AND=9,
    //ADDI=10, XORI=13, ORI=14, ANDI=15, SLLI=16, SLTI=11, SRLI=17, SRAI=18, SLTIU=12, 
    BEQ=10, BNE=11, BLT=12, BGE=13, BLTU=14, BGEU=15, ERR = 4'bxxxx
    //LB=16, LH=17, LW=18, LBU=19, LHU=20, LW=21, SB=22, SH=23, SW=24 (just add)
    } operation_t;

    // testbench parameters
    integer tb_test_num;
    string tb_test_case;

    // DUT ports
    logic [6:0] tb_opcode;
    logic [2:0] tb_alu_op;
    logic [6:0] tb_func7;
    logic [3:0] tb_ctrl_input;
    logic tb_ctrl_err;

    logic [3:0] exp_ctrl;
    logic exp_ctrl_err;
    //task to check operation
    task check_op_o(
    input logic [3:0] expected_ctrl_input,
    input logic expected_err,
    input string string_ctrl_input
    );

        if(tb_ctrl_input === expected_ctrl_input) //triple "===" for matching x and z state
            $info("Correct op: %s.", string_ctrl_input);
        else
            $error("Incorrect mode. Expected: %s. Actual: %s.", string_ctrl_input, tb_ctrl_input);

         if(tb_ctrl_err == expected_err)
             $info("Correct error: %b.", expected_err);
        else
            $error("Incorrect error. Expected: %b. Actual: %b.", expected_err, tb_ctrl_err); 


    endtask

    //DUT portmap
    alu_control_unit DUT(.opcode(tb_opcode), 
                         .alu_op(tb_alu_op), 
                         .func7(tb_func7), 
                         .ctrl_err(tb_ctrl_err),
                         .alu_control_input(tb_ctrl_input));

  // Main Test Bench Process
    initial begin
        // Signal dump
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_alu_control_unit); 

        tb_opcode = 7'b0;
        tb_alu_op = 3'b0;
        tb_func7 = 7'b0;


        tb_test_num = 0;
        tb_test_case = "Initializing";

        // ************************************************************************
        // Test Case 1: testing for ADD control input
        // ************************************************************************
        #10
        tb_test_num += 1;
        tb_test_case = "Test Case 1: testing for ADD control input";
        $display("\n\n%s", tb_test_case);

        tb_opcode = 7'b0110011;
        tb_alu_op = 3'b000;
        tb_func7 = 0000000;
        exp_ctrl = ADD;
        exp_ctrl_err = 1'b0;
        #10
        check_op_o(exp_ctrl, exp_ctrl_err, "ADD");
        // ************************************************************************
        // Test Case 2: testing for SUB control input
        // ************************************************************************
        #10
        tb_test_num += 1;
        tb_test_case = "Test Case 2: testing for SUB control input";
        $display("\n\n%s", tb_test_case);

        tb_opcode = 7'b0110011;
        tb_alu_op = 3'b000;
        tb_func7 = 0100000;
        exp_ctrl = SUB;
        exp_ctrl_err = 1'b0;
        #10
        check_op_o(exp_ctrl,exp_ctrl_err, "SUB");
         // ************************************************************************
        // Test Case 3: testing for invalid control input (func7 ADD/SUB)
        // ************************************************************************
        #10
        tb_test_num += 1;
        tb_test_case = "Test Case 3: testing for ERR control input";
        $display("\n\n%s", tb_test_case);

        tb_opcode = 7'b0110011;
        tb_alu_op = 3'b000;
        tb_func7 = 0110000; //err
        exp_ctrl = 4'hx;
        exp_ctrl_err = 1'b1;
        #10
        check_op_o(exp_ctrl,exp_ctrl_err, "ERR");
        // ************************************************************************
        // Test Case 4: testing for SLL control input
        // ************************************************************************
        #10
        tb_test_num += 1;
        tb_test_case = "Test Case 4: testing for SLL control input";
        $display("\n\n%s", tb_test_case);

        tb_opcode = 7'b0110011;
        tb_alu_op = 3'b001;
        exp_ctrl = SLL;
        exp_ctrl_err = 1'b0;
        #10
        check_op_o(exp_ctrl,exp_ctrl_err, "SLL");
        // ************************************************************************
        // Test Case 5: testing for SLT control input
        // ************************************************************************
        #10
        tb_test_num += 1;
        tb_test_case = "Test Case 5: testing for SLT control input";
        $display("\n\n%s", tb_test_case);

        tb_opcode = 7'b0110011;
        tb_alu_op = 3'b010;
        exp_ctrl = SLT;
        exp_ctrl_err = 1'b0;
        #10
        check_op_o(exp_ctrl,exp_ctrl_err, "SLT");
        // ************************************************************************
        // Test Case 6: testing for SLTU control input
        // ************************************************************************
        #10
        tb_test_num += 1;
        tb_test_case = "Test Case 6: testing for SLTU control input";
        $display("\n\n%s", tb_test_case);

        tb_opcode = 7'b0110011;
        tb_alu_op = 3'b011;
        exp_ctrl = SLTU;
        exp_ctrl_err = 1'b0;
        #10
        check_op_o(exp_ctrl,exp_ctrl_err, "SLTU");
        // ************************************************************************
        // Test Case 7: testing for XOR control input
        // ************************************************************************
        #10
        tb_test_num += 1;
        tb_test_case = "Test Case 7: testing for XOR control input";
        $display("\n\n%s", tb_test_case);

        tb_opcode = 7'b0110011;
        tb_alu_op = 3'b100;
        exp_ctrl = XOR;
        exp_ctrl_err = 1'b0;
        #10
        check_op_o(exp_ctrl,exp_ctrl_err, "XOR");
        // ************************************************************************
        // Test Case 8: testing for SRL control input
        // ************************************************************************
        #10
        tb_test_num += 1;
        tb_test_case = "Test Case 8: testing for SRL control input";
        $display("\n\n%s", tb_test_case);

        tb_opcode = 7'b0110011;
        tb_alu_op = 3'b101;
        tb_func7 = 7'b0;
        exp_ctrl = SRL;
        exp_ctrl_err = 1'b0;
        #10
        check_op_o(exp_ctrl,exp_ctrl_err, "SRL");
        // ************************************************************************
        // Test Case 9: testing for SRA control input
        // ************************************************************************
        #10
        tb_test_num += 1;
        tb_test_case = "Test Case 9: testing for SRA control input";
        $display("\n\n%s", tb_test_case);

        tb_opcode = 7'b0110011;
        tb_alu_op = 3'b101;
        tb_func7 = 7'b0100000;
        exp_ctrl = SRA;
        exp_ctrl_err = 1'b0;
        #10
        check_op_o(exp_ctrl,exp_ctrl_err, "SRA");
        // ************************************************************************
        // Test Case 10: testing for invalid control input (r-type func3)
        // ************************************************************************
        #10
        tb_test_num += 1;
        tb_test_case = "Test Case 10: testing for ERR control input";
        $display("\n\n%s", tb_test_case);

        tb_opcode = 7'b0110011;
        tb_alu_op = 3'b101; //err
        tb_func7 = 7'b0110000;
        exp_ctrl = ERR;
        exp_ctrl_err = 1'b1;
        #10
        check_op_o(exp_ctrl,exp_ctrl_err, "ERR");
        // ************************************************************************
        // Test Case 11: testing for OR control input 
        // ************************************************************************
        #10
        tb_test_num += 1;
        tb_test_case = "Test Case 11: testing for OR control input";
        $display("\n\n%s", tb_test_case);

        tb_opcode = 7'b0110011;
        tb_alu_op = 3'b110; //err
        exp_ctrl = OR;
        exp_ctrl_err = 1'b0;
        #10
        check_op_o(exp_ctrl,exp_ctrl_err, "OR");
        // ************************************************************************
        // Test Case 12: testing for AND control input 
        // ************************************************************************
        #10
        tb_test_num += 1;
        tb_test_case = "Test Case 12: testing for AND control input";
        $display("\n\n%s", tb_test_case);

        tb_opcode = 7'b0110011;
        tb_alu_op = 3'b111; 
        exp_ctrl = AND;
        exp_ctrl_err = 1'b0;
        #10
        check_op_o(exp_ctrl,exp_ctrl_err, "AND");
        // ************************************************************************
        // Test Case 13: testing for BEQ control input 
        // ************************************************************************
        #10
        tb_test_num += 1;
        tb_test_case = "Test Case 13: testing for BEQ control input";
        $display("\n\n%s", tb_test_case);

        tb_opcode = 7'b1100011;
        tb_alu_op = 3'b000; 
        exp_ctrl = BEQ;
        exp_ctrl_err = 1'b0;
        #10
        check_op_o(exp_ctrl,exp_ctrl_err, "BEQ");
        // ************************************************************************
        // Test Case 14: testing for BNE control input 
        // ************************************************************************
        #10
        tb_test_num += 1;
        tb_test_case = "Test Case 14: testing for BNE control input";
        $display("\n\n%s", tb_test_case);

        tb_opcode = 7'b1100011;
        tb_alu_op = 3'b001; 
        exp_ctrl = BNE;
        exp_ctrl_err = 1'b0;
        #10
        check_op_o(exp_ctrl,exp_ctrl_err, "BNE");
        // ************************************************************************
        // Test Case 14: testing for BLT control input 
        // ************************************************************************
        #10
        tb_test_num += 1;
        tb_test_case = "Test Case 14: testing for BLT control input";
        $display("\n\n%s", tb_test_case);

        tb_opcode = 7'b1100011;
        tb_alu_op = 3'b100; 
        exp_ctrl = BLT;
        exp_ctrl_err = 1'b0;
        #10
        check_op_o(exp_ctrl,exp_ctrl_err, "BLT");
        // ************************************************************************
        // Test Case 15: testing for BGE control input 
        // ************************************************************************
        #10
        tb_test_num += 1;
        tb_test_case = "Test Case 15: testing for BGE control input";
        $display("\n\n%s", tb_test_case);

        tb_opcode = 7'b1100011;
        tb_alu_op = 3'b101; 
        exp_ctrl = BGE;
        exp_ctrl_err = 1'b0;
        #10
        check_op_o(exp_ctrl,exp_ctrl_err, "BGE");
        // ************************************************************************
        // Test Case 16: testing for BLTU control input 
        // ************************************************************************
        #10
        tb_test_num += 1;
        tb_test_case = "Test Case 16: testing for BLTU control input";
        $display("\n\n%s", tb_test_case);

        tb_opcode = 7'b1100011;
        tb_alu_op = 3'b110; 
        exp_ctrl = BLTU;
        exp_ctrl_err = 1'b0;
        #10
        check_op_o(exp_ctrl,exp_ctrl_err, "BLTU");
        // ************************************************************************
        // Test Case 17: testing for BGEU control input 
        // ************************************************************************
        #10
        tb_test_num += 1;
        tb_test_case = "Test Case 17: testing for BGEU control input";
        $display("\n\n%s", tb_test_case);

        tb_opcode = 7'b1100011;
        tb_alu_op = 3'b111; 
        exp_ctrl = BGEU;
        exp_ctrl_err = 1'b0;
        #10
        check_op_o(exp_ctrl,exp_ctrl_err, "BGEU");
        // ************************************************************************
        // Test Case 18: testing for invalid control input (func3 i-type)
        // ************************************************************************
        #10
        tb_test_num += 1;
        tb_test_case = "Test Case 18: testing for ERR control input";
        $display("\n\n%s", tb_test_case);

        tb_opcode = 7'b1100011;
        tb_alu_op = 3'b010; //err
        exp_ctrl = ERR;
        exp_ctrl_err = 1'b1;
        #10
        check_op_o(exp_ctrl,exp_ctrl_err, "ERR");
        // ************************************************************************
        // Test Case 19: testing for STORE control input 
        // ************************************************************************
        #10
        tb_test_num += 1;
        tb_test_case = "Test Case 19: testing for STORE control input";
        $display("\n\n%s", tb_test_case);

        tb_opcode = 7'b0100011;
        exp_ctrl = ADD;
        exp_ctrl_err = 1'b0;
        #10
        check_op_o(exp_ctrl,exp_ctrl_err, "ADD");
        // ************************************************************************
        // Test Case 19: testing for LOAD control input 
        // ************************************************************************
        #10
        tb_test_num += 1;
        tb_test_case = "Test Case 19: testing for LOAD control input";
        $display("\n\n%s", tb_test_case);

        tb_opcode = 7'b0000011;
        exp_ctrl = ADD;
        exp_ctrl_err = 1'b0;
        #10
        check_op_o(exp_ctrl,exp_ctrl_err, "ADD");
        // ************************************************************************
        // Test Case 20: testing for invalid control input (func7)
        // ************************************************************************
        #10
        tb_test_num += 1;
        tb_test_case = "Test Case 20: testing for invalid control input";
        $display("\n\n%s", tb_test_case);

        tb_opcode = 7'b0000111;
        exp_ctrl = ERR;
        exp_ctrl_err = 1'b1;
        #10
        check_op_o(exp_ctrl,exp_ctrl_err, "ERR");
        
        


    $finish;
    end
endmodule
