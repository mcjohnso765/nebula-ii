/*
	Module name: tb_accumulator.sv
	Description: A testbench for the uart interface module
*/

`timescale 1ns/1ps

module tb_MidiRx ();

	/////////////////////
	// Testbench Setup //
	/////////////////////
	
	// Define local parameters
	localparam CLK_PERIOD = 100; // 10 MHz 
	localparam RESET_ACTIVE = 0;
	localparam RESET_INACTIVE = 1;

	// Testbench Signals
	integer tb_test_num;
	string tb_test_name;

	// DUT Inputs
	logic MHz10;

	logic tb_nrst;
  logic tb_clear;

  logic [8:0] tb_samp_mono;
  logic tb_accumulate;

  // DUT Outputs
  logic [11:0] tb_current_sum;

//expected values
logic [11:0] current_sum_exp;




	// Signal Dump
	initial begin
		$dumpfile ("accumulator.vcd");
		$dumpvars;
	end

	////////////////////////
	// Testbenching tasks //
	////////////////////////

	// Quick reset for 2 clock cycles
	task reset_dut;
	begin
		@(negedge MHz10); // synchronize to negedge edge so there are not hold or setup time violations
		
		// Activate reset
		tb_nrst = RESET_ACTIVE;

		// Wait 2 clock cycles
		@(negedge MHz10);
		@(negedge MHz10);

		// Deactivate reset
		tb_nrst = RESET_INACTIVE; 
	end
	endtask

	// Check output values against expected values
	task check_outputs (
		input logic [19:0] current_count,
		input logic [19:0] current_count_exp
	);
	begin
		@(negedge MHz10);  // Check away from the clock edge!
		if(current_count_exp == current_count)
			$info("Correct tb_count value.");  
		else
			$error("Incorrect tb_current_count value. Actual: %0d, Expected: %0d.", current_count, current_count_exp);


		// if(exp_at_max == tb_at_max)
		// 	$info("Correct tb_at_max value.");  
		// else
		// 	$error("Incorrect tb_at_max value. Actual: %0d, Expected: %0d.", tb_at_max, exp_at_max);
		
		// if(exp_buffer_note_in == tb_buffer_note_in)
		// 	$info("Correct tb_buffer_note_in value.");
		// else
		// 	$error("Incorrect tb_buffer_note_in value. Actual: %0d, Expected: %0d.", tb_buffer_note_in, exp_buffer_note_in);



	end
	endtask 

	//////////
	// DUT //
	//////////

	// DUT Instance
	accumulator accumulator(
		.MHz10(MHz10),
    .clear(tb_clear),
		.nrst(tb_nrst),
    .sample_mono(tb_samp_mono),
    .accumulate(tb_accumulate),
    .current_sum(tb_current_sum)

	);

	// Clock generation block
	always begin
		MHz10 = 0; // set clock initially to be 0 so that they are no time violations at the rising edge 
		#(CLK_PERIOD / 2);
		MHz10 = 1;
		#(CLK_PERIOD / 2);
	end

	initial begin

		// Initialize all test inputs
		tb_test_num = -1;  // We haven't started testing yet
		tb_test_name = "Test Bench Initialization";
		tb_nrst = RESET_INACTIVE;
    tb_clear = 0;
    tb_accumulate = 0;
    tb_samp_mono = 0;
    current_sum_exp = 0;
		// tb_serIn = 1;
		// dataOut_exp = 0;

		#(0.5); //wait before starting first test case

		////////////////////////////
		// Test 0: Power on reset //
		////////////////////////////

		// NOTE: Do not use reset task during reset test case 
		tb_test_num+=1;
		tb_test_name = "Power on Reset";
		// Set inputs to non-reset values

		// Activate Reset
		tb_nrst = RESET_ACTIVE;

		#(CLK_PERIOD * 2); // Wait 2 clock periods before proceeding
		
		// Check outputs are reset
		// tb_count_exp = 0; 

		// check_outputs(dataOut_exp);

		// Deactivate Reset
		tb_nrst = RESET_INACTIVE;

    #(CLK_PERIOD * 1); // Wait 2 clock periods before proceeding

		// Check outputs again
		// tb_count_exp = 1;  // because enable is high
		
		// check_outputs(dataOut_exp);

    //////////////////////////////////////////////////
		// Test 1: Setting an Input Without Accumulating//
		//////////////////////////////////////////////////

		tb_test_num+=1;
		tb_test_name = "Setting an Input Without Accumulating";

    tb_samp_mono = 9'hFA;
    #(CLK_PERIOD * 1); // Wait 1 clock periods before proceeding
    tb_samp_mono = 9'hAB;
    #(CLK_PERIOD * 1); // Wait 1 clock periods before proceeding

    ///////////////////////////////////////////////
		// Test 2: Setting an Input With Accumulating//
		///////////////////////////////////////////////

    tb_test_num+=1;
		tb_test_name = "Setting an Input Without Accumulating";

    tb_accumulate = 1;
    current_sum_exp = 12'hAB;
    #(CLK_PERIOD * 1); // Wait 1 clock periods before proceeding
    tb_accumulate = 0;
    #(CLK_PERIOD * 2); // Wait 2 clock periods before proceeding
    tb_samp_mono = 9'h41;
    current_sum_exp = 12'hAB + 12'h41;
    tb_accumulate = 1;
    #(CLK_PERIOD * 1); // Wait 1 clock periods before proceeding
    tb_accumulate = 0;
    #(CLK_PERIOD * 2); // Wait 2 clock periods before proceeding
    tb_samp_mono = 9'h19;
    current_sum_exp = 12'hAB + 12'h41 + 12'h19;
    tb_accumulate = 1;
    #(CLK_PERIOD * 1); // Wait 1 clock periods before proceeding
    tb_accumulate = 0;
    #(CLK_PERIOD * 2); // Wait 2 clock periods before proceeding
    tb_samp_mono = 9'hCD;
    current_sum_exp = 12'hAB + 12'h41 + 12'h19 + 12'hCD;
    tb_accumulate = 1;
    #(CLK_PERIOD * 1); // Wait 1 clock periods before proceeding
    tb_accumulate = 0;
    #(CLK_PERIOD * 2); // Wait 2 clock periods before proceeding

    ///////////////////////////////////////////////
		// Test 3: Clearing Accumulator//
		///////////////////////////////////////////////

    tb_test_num+=1;
		tb_test_name = "Clearing Accumulator";

    tb_clear = 1;
    current_sum_exp = 0;
    #(CLK_PERIOD * 1); // Wait 1 clock periods before proceeding
    tb_clear = 0;
    #(CLK_PERIOD * 3); // Wait 1 clock periods before proceeding
  $finish;
	end

endmodule