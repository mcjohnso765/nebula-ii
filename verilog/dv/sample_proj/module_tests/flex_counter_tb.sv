// $Id: $
// File name:   flex_counter_tb.sv
// Created:     5/25/2024
// Author:      Miguel Isrrael Teran
// Description: Test bench for flexible counter

`timescale 1ns / 10ps

module flex_counter_tb();

    // Define local parameters used by the test bench
    localparam  CLK_PERIOD = 10;
    localparam  NUM_BITS = 4;

    localparam  INACTIVE_VALUE = 1'b0;
    localparam  RESET_OUTPUT_VALUE = INACTIVE_VALUE;
    
    // Declare DUT portmap signals
    logic tb_clk;
    logic tb_nrst;
    logic tb_clear;
    logic tb_count_enable;
    logic [NUM_BITS-1:0] tb_rollover_val;
    logic [NUM_BITS-1:0] tb_count_out;
    logic tb_rollover_flag;
    
    // Declare test bench signals
    integer tb_test_num;
    integer tb_passed;
    string tb_test_case;
    
    // Task for standard DUT reset procedure
    task reset_dut;
    begin
        // Activate the reset
        tb_nrst = 1'b0;

        // Maintain the reset for more than one cycle
        @(posedge tb_clk);
        @(posedge tb_clk);

        // Wait until safely away from rising edge of the clock before releasing
        @(negedge tb_clk);
        tb_nrst = 1'b1;

        // Leave out of reset for a couple cycles before allowing other stimulus
        // Wait for negative clock edges, 
        // since inputs to DUT should normally be applied away from rising clock edges
        @(negedge tb_clk);
        @(negedge tb_clk);
    end
    endtask

    // Actuate clear input
    task clear;
    begin
        @(negedge tb_clk)
        // Activate the reset
        tb_clear = 1'b1;

        // Wait two clock cycles
        @(negedge tb_clk);
        @(negedge tb_clk);
    end
    endtask

    // Task to cleanly and consistently check DUT output values
    task check_outputs(
        input logic [NUM_BITS-1:0] expected_count_out,
        input logic expected_rollover_flag,
        input string check_tag
    );
        logic count_correct;
        logic flag_correct;
    begin

        // NOTE: Make sure you check away from the positive edge!!!
        count_correct = 1'b0;
        flag_correct = 1'b0;
        tb_test_num = tb_test_num + 1;

        // Check count_out
        if(expected_count_out == tb_count_out) begin // Check passed
            $info("Correct count output %s during %s test case", check_tag, tb_test_case);
            count_correct = 1'b1;
        end
        else begin // Check failed
            $error("Incorrect count output %s during %s test case. Expected: %d, Actual: %d", check_tag, tb_test_case,
                    expected_count_out, tb_count_out);
        end

        // Check flag
        if(expected_rollover_flag == tb_rollover_flag) begin // Check passed
            $info("Correct rollover_flag output %s during %s test case", check_tag, tb_test_case);
            flag_correct = 1'b1;
        end
        else begin // Check failed
            $error("Incorrect rollover_flag output %s during %s test case. Expected: %d, Actual: %d", check_tag, tb_test_case,
                    expected_rollover_flag, tb_rollover_flag);
        end

        // Conditional increment of tb_passed
        if (count_correct & flag_correct) tb_passed += 1;
    end
    endtask

    // Clock generation block
    always
    begin
        // Start with clock low to avoid false rising edge events at t=0
        tb_clk = 1'b0;
        // Wait half of the clock period before toggling clock value (maintain 50% duty cycle)
        #(CLK_PERIOD/2.0);
        tb_clk = 1'b1;
        // Wait half of the clock period before toggling clock value via rerunning the block (maintain 50% duty cycle)
        #(CLK_PERIOD/2.0);
    end
    
    // Signal Dump
    initial begin
        $dumpfile ("flex_counter.vcd");
        $dumpvars;
    end
    
    // DUT Port map
    flex_counter DUT(.clk(tb_clk), .nrst(tb_nrst), .clear(tb_clear), .count_enable(tb_count_enable), .rollover_val(tb_rollover_val),
                        .count_out(tb_count_out), .rollover_flag(tb_rollover_flag));
    
    // Test bench main process
    initial
    begin
        // Initialize all of the test inputs
        tb_nrst  = 1'b1;              // Initialize to be inactive
        tb_clear = 1'b0; // Initialize inputs to inactive values
        tb_count_enable = 1'b0;
        tb_rollover_val = '0;
        tb_test_num = 0;               // Initialize test case counter
        tb_passed = 0;
        tb_test_case = "Test bench initializaton";
        // Wait some time before starting first test case
        #(0.1);
        
        // ************************************************************************
        // Test Case 1: Power-on Reset of the DUT
        // ************************************************************************
        tb_test_case = "Power on Reset";
        // Note: Do not use reset task during reset test case since we need to specifically check behavior during reset
        // Wait some time before applying test case stimulus
        #(0.1);
        // Apply test case initial stimulus
        tb_clear = 1'b0; // Set to be the the non-reset values
        tb_count_enable = 1'b1;
        tb_rollover_val = '1;
        tb_nrst  = 1'b0;    // Activate reset
        
        // Wait for a bit before checking for correct functionality
        #(CLK_PERIOD * 0.5);

        // Check that internal state was correctly reset
        check_outputs({4{RESET_OUTPUT_VALUE}}, RESET_OUTPUT_VALUE, "after reset applied");
        
        // Check that the reset value is maintained during a clock cycle
        #(CLK_PERIOD);
        check_outputs({4{RESET_OUTPUT_VALUE}}, RESET_OUTPUT_VALUE,
                    "after clock cycle while in reset");
        
        // Release the reset away from a clock edge
        @(negedge tb_clk);
        tb_nrst  = 1'b1;   // Deactivate the chip reset
        // Check that internal state was correctly keep after reset release
        check_outputs({4{RESET_OUTPUT_VALUE}}, RESET_OUTPUT_VALUE,
                    "after reset was released");
        

        // ************************************************************************
        // Test Case 2: Continuous counting
        // ************************************************************************    
        tb_test_case = "Continuous counting";
        // Start out with inactive values and reset the DUT to isolate from prior tests
        tb_clear = INACTIVE_VALUE;
        tb_count_enable = INACTIVE_VALUE;
        tb_rollover_val = {4{INACTIVE_VALUE}};
        reset_dut();

        // Assign test case stimulus
        tb_count_enable = 1'b1;
        tb_rollover_val = NUM_BITS'('d13);

        // Wait 10 clock cycles
        #(10 * CLK_PERIOD);

        // Check results
        check_outputs( NUM_BITS'('d10), INACTIVE_VALUE,
                    "after counting to 10");
        

        // ************************************************************************
        // Test Case 3: Reaching Rollover
        // ************************************************************************
        tb_test_case = "Reaching Rollover";
        // Start out with inactive values and reset the DUT to isolate from prior tests
        tb_clear = INACTIVE_VALUE;
        tb_count_enable = INACTIVE_VALUE;
        tb_rollover_val = {4{INACTIVE_VALUE}};
        reset_dut();

        // Assign test case stimulus
        tb_count_enable = 1'b1;
        tb_rollover_val = NUM_BITS'('d11);

        // Wait until reaching rollover (11 clock cycles)
        #(11 * CLK_PERIOD);

        // Check results
        check_outputs( NUM_BITS'('d11), 1'b1,
                    "when reaching rollover");

        // Check results (past rollover)
        #(CLK_PERIOD);
        check_outputs(NUM_BITS'('d1), INACTIVE_VALUE,
                    "after hitting rollover");
        

        // ************************************************************************
        // Test Case 4: Toggling clear and count_enable
        // ************************************************************************
        tb_test_case = "Toggling clear and count_enable";
        // Start out with inactive values and reset the DUT to isolate from prior tests
        tb_clear = INACTIVE_VALUE;
        tb_count_enable = INACTIVE_VALUE;
        tb_rollover_val = {4{INACTIVE_VALUE}};
        reset_dut();

        // Assign test case stimulus
        tb_count_enable = 1'b1;
        tb_rollover_val = NUM_BITS'('d9);

        // Wait 7 positive edges
        #(7 * CLK_PERIOD);

        // Check results
        check_outputs(NUM_BITS'('d7), INACTIVE_VALUE,
                    "after counting to 7");
        
        clear();  // clear counter
        check_outputs({4{INACTIVE_VALUE}}, INACTIVE_VALUE,
                    "after clearing counter");
        
        // Deassert clear
        tb_clear = INACTIVE_VALUE;
        
        // Wait until rollover (9 clock cycles)
        # (9 * CLK_PERIOD)

        // Check results
        check_outputs(NUM_BITS'('d9), 1'b1,
                    "when reaching rollover");
        
        // Deactivate enable
        tb_count_enable = INACTIVE_VALUE;

        // Wait 5 clock cycles
        #(5 * CLK_PERIOD);

        // Check results
        check_outputs(NUM_BITS'('d9), 1'b1,
                    "after deactivating enable at rollover value");

        // Finish simulation
        $display("\nTest cases passed: %1d/%1d\n", tb_passed, tb_test_num);
        $finish;

    end

endmodule