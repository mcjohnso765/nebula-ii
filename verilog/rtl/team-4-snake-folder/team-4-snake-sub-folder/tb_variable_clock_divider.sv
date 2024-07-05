/*
    Module Name: tb_stop_watch
    Description: Test bench for stop_watch module
*/

`timescale 1ns/1ps

module tb_variable_clock_divider ();

    // Testbench parameters
    localparam CLK_PERIOD = 100; // 10 MHz clk

    // DUT ports
    logic tb_clk, tb_nRst_i;
    logic tb_button_i, tb_adjusted_clk;

    // Reset DUT Task
    task reset_dut;
        @(negedge tb_clk);
        tb_nRst_i = 1'b0; 
        @(negedge tb_clk);
        @(negedge tb_clk);
        tb_nRst_i = 1'b1;
        @(posedge tb_clk);
    endtask
    
    // Task that presses the button once
    task single_button_press;
    begin
        @(negedge tb_clk);
        tb_button_i = 1'b1; 
        @(negedge tb_clk);
        tb_button_i = 1'b0; 
        @(posedge tb_clk);  // Task ends in rising edge of clock: remember this!
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
     variable_clock_divider DUT(.clk(tb_clk),
                .nrst(tb_nRst_i),
                .button(tb_button_i),
                .adjusted_clk(tb_adjusted_clk)); 

    // Main Test Bench Process
    initial begin
        // Signal dump
        $dumpfile("dump.vcd");
        $dumpvars; 

        // Initialize test bench signals
        tb_button_i = 1'b0; 
        tb_nRst_i = 1'b1;

        // Wait some time before starting first test case
        #(0.1);


        // ************************************************************************
        // Test Case 1: Clock divider in slow mode, then fast mode, then back to slow mode
        // ************************************************************************
        reset_dut;
 
        #(CLK_PERIOD * 10000000); 

        // Press button (CLEAR->RUNNING)
        single_button_press(); 
        #(CLK_PERIOD * 10000000);

        single_button_press(); 
        #(CLK_PERIOD * 10000000);

        $finish; 
    end

endmodule 