// $Id: $
// File name:   sample_team_proj_tb.sv
// Created:     5/26/2024
// Author:      Miguel Isrrael Teran
// Description: Test bench for Sample Team Project

`timescale 100 ns / 1 ns

module sample_team_proj_tb();
    // Define parameters
    parameter CLK_PERIOD = 1;  // 1 clock period is 100 ns

    // DUT inputs
    reg tb_clk;
    reg tb_nrst;
    reg tb_en;
    reg [13:0] tb_prescaler;
    reg [127:0] tb_la_data_in;
    reg [127:0] tb_la_oenb;
    reg [33:0] tb_gpio_in;

    // DUT outputs
    wire tb_done;
    wire [127:0] tb_la_data_out;
    wire [33:0] tb_gpio_out;
    wire [33:0] tb_gpio_oeb;

    // Test bench signals
    integer tb_test_case_num;
    integer tb_sub_checks;
    integer tb_total_checks;
    integer tb_passed;
    integer i;

    // Clock generation block
    always begin
        tb_clk = 1'b0;
        #(CLK_PERIOD / 2.0);
        tb_clk = 1'b1;
        #(CLK_PERIOD / 2.0);
    end

    // Signal Dump
    initial begin
        $dumpfile ("sample_team_proj.vcd");
        $dumpvars;
    end

    // DUT Portmap
    sample_team_proj DUT (
        .clk(tb_clk),
        .nrst(tb_nrst),
        .en(tb_en),
        .prescaler(tb_prescaler),
        .done(tb_done),
        .la_data_in(tb_la_data_in),
        .la_data_out(tb_la_data_out),
        .la_oenb(tb_la_oenb),
        .gpio_in(tb_gpio_in),
        .gpio_out(tb_gpio_out),
        .gpio_oeb(tb_gpio_oeb)
    );

    // Reset DUT
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

    // Check Outputs Task
    task check_outputs (
        input logic [33:0] expected_gpio,
        input logic expected_done
    );
    begin
        logic gpio_correct;
        logic done_correct;
        // NOTE: Make sure you check away from the positive edge!!!
        gpio_correct = 1'b0;
        done_correct = 1'b0;
        tb_total_checks += 1;
        tb_sub_checks += 1;

        // Check GPIO
        if(expected_gpio == tb_gpio_out) begin // Check passed
            $info("Correct GPIO output during Test Case #%1d, check #%1d", tb_test_case_num, tb_sub_checks);
            gpio_correct = 1'b1;
        end
        else begin // Check failed
            $error("Correct GPIO output during Test Case #%1d, check #%1d Expected: 0x%1h, Actual: 0x%1h.", tb_test_case_num, tb_sub_checks,
                    expected_gpio, tb_gpio_out);
        end

        // Check done
        if(expected_done == tb_done) begin // Check passed
            $info("Correct done output during Test Case #%1d, check #%1d", tb_test_case_num, tb_sub_checks);
            done_correct = 1'b1;
        end
        else begin // Check failed
            $error("Correct done output during Test Case #%1d, check #%1d Expected: %1d, Actual: %1d.", tb_test_case_num, tb_sub_checks,
                    expected_done, tb_done);
        end

        // Conditional increment of tb_passed
        if (gpio_correct & done_correct) tb_passed += 1;
    end
    endtask

    // Task to cycle through and check all 34 GPIO pin outputs
    task cycle_all_gpio (
        input logic [13:0] prescaler_value
    );
    begin
        logic [33:0] tb_expected_gpio;
        // Set prescaler
        tb_prescaler = prescaler_value;

        // Cycle and check until end of sequence (GPIO[0] to GPIO[33] should go high)
        for (i = 0; i <= 34; i++) begin
            // Wait "prescaler" ms (10000 * prescaler clock periods)
            #(10000 * prescaler_value * CLK_PERIOD);

            // Wait one more clock cycle (for first period only)
            if (i == 0) #(CLK_PERIOD);

            // Define expected value
            if (i == 0) tb_expected_gpio = 34'd1;
            else tb_expected_gpio = tb_expected_gpio << 1;

            // Check
            check_outputs(tb_expected_gpio, (i == 34));
        end
    end
    endtask
    
    // Standard Test Bench Process
    initial begin
        // Initialize all signals
        tb_test_case_num = -1;
        tb_sub_checks = 0;
        tb_total_checks = 0;
        tb_passed = 0;
        tb_en = 1'b0;
        tb_la_oenb = '0;
        tb_la_data_in = '0;
        tb_gpio_in = '1;
        tb_prescaler = '0;
        tb_nrst = 1'b1;  // initially inactive

        // Get away from time = 0
        #(0.2);
        
        // **************************************************************************
        // Test Case #0: Basic Power on Reset
        // **************************************************************************
        tb_test_case_num += 1;
        tb_sub_checks = 0;

        // DUT Reset
        reset_dut;

        // Check #1
        check_outputs('0, 1'b0);

        // **************************************************************************
        // Test Case #1: Testing when design is not enabled
        // **************************************************************************
        tb_test_case_num += 1;
        tb_sub_checks = 0;
        reset_dut;

        // Enable the sequence
        tb_prescaler = 14'd1;
        tb_la_data_in[0] = 1'b1;

        // Wait some time before checking
        #(35 * 10000 * tb_prescaler * CLK_PERIOD);

        // Check that outputs remained at 0
        check_outputs('0, 1'b0);

        // **************************************************************************
        // Test Case #2: Test period of 1 ms
        // **************************************************************************
        tb_test_case_num += 1;
        tb_sub_checks = 0;
        reset_dut;

        // Enable the design
        tb_en = 1'b1;

        // Enable the sequence
        tb_la_data_in[0] = 1'b1;

        // Test period of 1 ms (go through all GPIOs twice)
        cycle_all_gpio(14'd1);
        cycle_all_gpio(14'd1);

        // Stop sequence
        tb_la_data_in[1] = 1'b1;

        // Wait a few clock periods
        #(5 * CLK_PERIOD);

        // Check
        check_outputs('0, 1'b0);

        // **************************************************************************
        // Test Case #3: Test period of 10 ms
        // **************************************************************************
        tb_test_case_num += 1;
        tb_sub_checks = 0;
        tb_la_data_in = '0; // reset la_data_in
        reset_dut;

        // Enable the sequence
        tb_la_data_in[0] = 1'b1;

        // Test period of 10 ms (go through all GPIOs twice)
        cycle_all_gpio(14'd10);
        cycle_all_gpio(14'd10);

        // Stop sequence
        tb_la_data_in[1] = 1'b1;

        // Wait a few clock periods
        #(5 * CLK_PERIOD);

        // Check
        check_outputs('0, 1'b0);

        // Finish simulation
        $display("\nTest cases passed: %1d/%1d\n", tb_passed, tb_total_checks);
        $finish;

    end

endmodule