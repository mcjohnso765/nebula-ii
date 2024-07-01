/*
	Module name: tb_sample_register.sv
	Description: A testbench for the uart interface module
*/

`timescale 1ns/1ps

module tb_sample_register ();

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

  logic [11:0] tb_samp_acc;
  logic tb_store_samp;

  // DUT Outputs
  logic [11:0] tb_samp_out;
	

  //expected values
  logic [11:0] samp_out_exp;




	// Signal Dump
	initial begin
		$dumpfile ("dump.vcd");
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
	task check_outputs;
		input logic [11:0] samp_out; 
		input logic [11:0] samp_out_exp;
	begin
		@(negedge MHz10);  // Check away from the clock edge!
		if(samp_out_exp == samp_out)
			$info("Correct samp_out value.");  
		else
			$error("Incorrect samp_out value. Actual: %0d, Expected: %0d.", samp_out, samp_out_exp);


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
	sample_register saw_counter(
		.MHz10(MHz10),
    .clear(tb_clear),
		.nrst(tb_nrst),
    .samp_acc(tb_samp_acc),
    .store_samp(tb_store_samp),
    .samp_out(tb_samp_out)

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
    tb_samp_acc = 0;
    tb_store_samp = 0;
    samp_out_exp = 0;
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

		check_outputs(tb_samp_out, samp_out_exp);

		// Deactivate Reset
		tb_nrst = RESET_INACTIVE;

    #(CLK_PERIOD * 2); // Wait 2 clock periods before proceeding

		// Check outputs again
		// tb_count_exp = 1;  // because enable is high
		
		// check_outputs(dataOut_exp);

    ////////////////////////////////////
		// Test 1: Test Input Without Set //
		////////////////////////////////////

		tb_test_num+=1;
		tb_test_name = "Input Without Set";

    tb_samp_acc = 12'h1A2;

    check_outputs(tb_samp_out, 0);

    #(CLK_PERIOD * 2); // Wait 2 clock periods before proceeding

    /////////////////////////////////
		// Test 2: Test Input With Set //
		/////////////////////////////////

		tb_test_num+=1;
		tb_test_name = "Input With Set";

    tb_samp_acc = 12'hFDE;
    tb_store_samp = 1;
    samp_out_exp = 12'hFDE;

    check_outputs(tb_samp_out, 0);

    #(CLK_PERIOD * 1); // Wait 1 clock periods before proceeding

    tb_store_samp = 0;

    //////////////////////////////
		// Test 3: Test Output Hold //
		//////////////////////////////

		tb_test_num+=1;
		tb_test_name = "Output Hold";

    tb_samp_acc = 12'hABC;

    check_outputs(tb_samp_out, samp_out_exp);

    #(CLK_PERIOD * 1); // Wait 1 clock periods before proceeding

    tb_samp_acc = 12'h324;

    check_outputs(tb_samp_out, samp_out_exp);

    #(CLK_PERIOD * 1); // Wait 1 clock periods before proceeding

    /////////////////////////////////////////////
		// Test 4: Store Sample With Register Full //
		/////////////////////////////////////////////

		tb_test_num+=1;
		tb_test_name = "New Sample Without Clear";

    tb_store_samp = 1;
    samp_out_exp = 12'h324;

    #(CLK_PERIOD * 1); // Wait 1 clock periods before proceeding

    tb_store_samp = 0;

    ////////////////////////////////////
		// Test 5: Test Synchronous Clear //
		////////////////////////////////////

		tb_test_num+=1;
		tb_test_name = "Synchronous Clear";

    tb_clear = 1;
    samp_out_exp = 0;

    #(CLK_PERIOD * 1); // Wait 1 clock periods before proceeding

    tb_clear = 0;

    check_outputs(tb_samp_out, samp_out_exp);

    #(CLK_PERIOD * 3); // Wait 3 clock periods before proceeding

  $finish;
	end

endmodule
