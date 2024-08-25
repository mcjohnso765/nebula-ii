// $Id: $
// File name:   decoder_for_GPIO_tb.sv
// Created:     05/25/2024
// Author:      Abdulloh Abdubaev
// Description: Testbench For Decoder

`timescale 1ns / 10ps

module decoder_for_GPIO_tb();
    // Test Bench Signals
    logic [5:0] tb_in;
    logic [33:0] tb_out;
    logic [33:0] expected_out;
    integer tb_test_num;
    integer tb_passed;
    logic [5:0] i;

    // Check output task
    task check_output (
        input logic [33:0] expected_out
    );
    begin
        if (expected_out == tb_out) begin // Check passed
            $info("Correct GPIO output during test case %1d", tb_test_num);
            tb_passed++;
        end
        else begin // Check failed
            $error("Incorrect GPIO out during test case %1d", tb_test_num);
        end
    end
    endtask

    // Instantiate DUT
    decoder_for_GPIO DUT(.in(tb_in), .out(tb_out));

    // Signal Dump
    initial begin
        $dumpfile ("decoder_for_GPIO.vcd");
        $dumpvars;
    end

    // Main test bench process
    initial
    begin
        tb_test_num = 0;
        tb_passed = 0;
        expected_out = '0;

        //// Functional TEST CASES
        for (i = 1; i <= 34; i++) begin
            tb_test_num++;
            tb_in = i;
            #10  // Wait 10 ns
            if(i == 1) begin
            expected_out = 34'b1;
            check_output(expected_out);
            end
            else begin
                expected_out = expected_out << 1; /// Move one index left
                check_output(expected_out);
            end
        end


        //// Out of bound test cases
        // in is 0
        tb_test_num++;
        tb_in = 0;
        expected_out = 0;
        #10
        check_output(expected_out);

        // in is 40
        tb_test_num++;
        tb_in = 40;
        expected_out = 0;
        #10
        check_output(expected_out);

        // Finish simulation
        $display("\nTest cases passed: %1d/%1d\n", tb_passed, tb_test_num);
        $finish;
    end
endmodule