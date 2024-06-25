
`default_nettype none
/*
    Module Name: tb_program_counter
    Description: Test bench for program_counter module
*/

`timescale 1ms / 100us

module tb_program_counter ();

    // Testbench parameters
    localparam CLK_PERIOD = 10; // 100 Hz clk
    logic tb_checking_outputs; //whenever checking output asserted
    integer tb_test_num;
    string tb_test_case;

    // DUT ports
    logic tb_clk, tb_nRst, tb_enable;
    logic [31:0] tb_immJumpValue, tb_regJumpValue;
    logic tb_condJumpValue; //FIXME does this need to be 32 bits?
    logic tb_doForceJump, tb_doCondJump, tb_doRegJump, tb_sendLink;
    logic [31:0] tb_instructionAddress, tb_linkAddress;
    logic tb_next;
    logic [31:0] expected_pc;
    logic [31:0] expected_la;

    
    // Reset DUT Task
    task reset_dut;
        @(posedge tb_clk);
        tb_nRst = 1'b0; 
        @(posedge tb_clk);
        @(posedge tb_clk);
        tb_nRst = 1'b1;
        @(posedge tb_clk);
    endtask

   
    // Task to check mode output
    task check_pc;
      input logic [31:0] expected_pc;
      input logic [31:0] expected_la;
      input string str_test_cond;
        
    begin
        //@(posedge tb_clk); 
        tb_checking_outputs = 1'b1; 
        if(tb_instructionAddress == expected_pc)
          $info("Condition: %s. Correct pc: %h. ", str_test_cond,  tb_instructionAddress);
        else
          $error("Condition: %s. Incorrect pc. Expected: %h. Actual: %h.", str_test_cond, expected_pc, tb_instructionAddress); 

        
        if(tb_linkAddress == expected_la)
            $info("Condition: %s. Correct la: %h. ", str_test_cond,  tb_linkAddress);
        else
            $error("Condition: %s. Incorrect la. Expected: %h. Actual: %h.", str_test_cond, expected_la, tb_linkAddress); 

        #(1);
        tb_checking_outputs = 1'b0;  
    end
    endtask

    // Clock generation block
    always begin
        tb_clk = 1'b0; 
        #(CLK_PERIOD / 2.0);
        tb_clk = 1'b1; 
        #(CLK_PERIOD / 2.0); 
    end

    // DUT Portmap
    program_counter DUT(.clk(tb_clk),
                .nRst(tb_nRst),
                .enable(tb_enable),
                .immJumpValue(tb_immJumpValue),
                .regJumpValue(tb_regJumpValue),
                .doForceJump(tb_doForceJump),
                .doCondJump(tb_doCondJump),
                .condJumpValue(tb_condJumpValue),
                .doRegJump(tb_doRegJump),
                .sendLink(tb_sendLink),
                .instructionAddress(tb_instructionAddress),
                .linkAddress(tb_linkAddress),
                .next(tb_next)); 

    // Main Test Bench Process
    initial begin
        // Signal dump
        $dumpfile("dump.vcd");
        $dumpvars; 

        // Initialize test bench signals
        reset_dut();
        tb_checking_outputs = 1'b0;
        tb_test_num = 0;
        tb_test_case = "Initializing";

        tb_immJumpValue = 32'b0;
        tb_regJumpValue = 32'b0;
        tb_condJumpValue = 1'b0; //FIXME does this need to be 32 bits?
        tb_doForceJump = 1'b0;
        tb_doCondJump = 1'b0;
        tb_doRegJump = 1'b0;
        tb_sendLink = 1'b0;

        // Wait some time before starting first test case
        #(0.1);

        // ************************************************************************
        // Test Case 1: Power-on-Reset of the DUT
        // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 1: Power-on-Reset of the DUT";
        $display("\n\n%s", tb_test_case);

        tb_nRst = 1'b0;  // activate reset

        // Wait for a bit before checking for correct functionality
        #(2);
        expected_pc = 32'h0;
        expected_la = 32'h0;
        check_pc(expected_pc, expected_la,"RESET");

        // Check that the reset value is maintained during a clock cycle
        @(posedge tb_clk);
        expected_pc = 32'h0;
        expected_la = 32'h0;
        check_pc(expected_pc, expected_la,"RESET1");

        // Release the reset away from a clock edge
        @(posedge tb_clk);
        tb_nRst  = 1'b1;   // Deactivate the chip reset
        // Check that internal state was correctly keep after reset release
        expected_pc = 32'h0;
        expected_la = 32'h0;
        check_pc(expected_pc,expected_la, "POST-RESET");

        // ************************************************************************
        // Test Case 2: Normal Instruction Fetch
        // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 2: Normal Instruction Fetch";
        $display("\n\n%s", tb_test_case);

        tb_enable = 1'b1;
        
        //chk for first instruction
        #(CLK_PERIOD * 1);
        expected_pc = 32'h04;
        expected_la = 32'h0;
        check_pc(expected_pc,expected_la, "inst 0");

        //chk for 6th instruction
        #(CLK_PERIOD * 5);
        expected_pc = 32'h18;
        expected_la = 32'h0;
        check_pc(expected_pc,expected_la, "inst 6");
        // ************************************************************************
        // Test Case 3: RegJump (and forceJump indirectly )
        // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 3: RegJump";
        $display("\n\n%s", tb_test_case);

        tb_enable = 1'b1;
        
        #(CLK_PERIOD * 1);
        
        tb_doForceJump = 1'b1; //condition for regJump to work
        tb_doRegJump = 1'b1;  // " " "
        tb_doCondJump = 1'b0; //explicitly stating
        tb_condJumpValue = 1'b0; // " " "
        
        tb_regJumpValue = 32'hA000;
        tb_immJumpValue = 32'h10;
        expected_pc = 32'hA010;
        expected_la = 32'h0;
        #(CLK_PERIOD * 1); //line 13 in pc module (wait for a clk cycle)
        check_pc(expected_pc,expected_la, "inst 0xA010");
        // ************************************************************************
        // Test Case 4: CondJump
        // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 4: CondJump";
        $display("\n\n%s", tb_test_case);

        tb_enable = 1'b1;
   
        //chk for first instruction
        #(CLK_PERIOD * 1);

        tb_doForceJump = 1'b0; //explicitly stating
        tb_doRegJump = 1'b0;  // " " "
        tb_doCondJump = 1'b1; // condition for do CondJump to work
        tb_condJumpValue = 1'b1; // " " "
        
        tb_immJumpValue = 32'h020;
        expected_pc = tb_instructionAddress + tb_immJumpValue;  //=0xA030?
        expected_la = 32'h0;
        #(CLK_PERIOD * 1);
        check_pc(expected_pc,expected_la, "inst 0xA030");

        // ************************************************************************
        // Test Case 5: LinkAddress
        // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 5: LinkAddress";
        $display("\n\n%s", tb_test_case);

        tb_enable = 1'b1;
   
        //chk for first instruction
        #(CLK_PERIOD * 1);

        tb_doForceJump = 1'b1; //condition for do CondJump to work
        tb_sendLink = 1'b1; // " " "
        tb_doRegJump = 1'b0;  // explicitly stating 
        tb_doCondJump = 1'b0; // " " "
        tb_condJumpValue = 1'b0; // " " "
        
        tb_immJumpValue = 32'h020;
        expected_pc = tb_instructionAddress + tb_immJumpValue; 
        expected_la = tb_instructionAddress + 32'h4;
        #(CLK_PERIOD * 1);
        check_pc(expected_pc,expected_la, "inst 0xA050");

        $finish; 
    end

endmodule 
