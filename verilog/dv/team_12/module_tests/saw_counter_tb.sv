/*
	Module name: tb_saw_counter.sv
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
  localparam MAX_TEST = 5;

	// Testbench Signals
	integer tb_test_num;
	string tb_test_name;

	// DUT Inputs
	logic MHz10;

	logic tb_nrst;
	logic tb_enable;
  logic tb_clear;

  logic [19:0] tb_new_max;
  logic tb_start_note, tb_end_note;

  // DUT Outputs
  logic tb_availible;
	logic [19:0] tb_current_count, tb_current_max;

//expected values
logic [19:0] current_count_exp;




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
		input logic [19:0] current_count; 
		input logic [19:0] current_count_exp;
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
	saw_counter saw_counter(
		.MHz10(MHz10),
    .clear(tb_clear),
    .enable(tb_enable),
		.nrst(tb_nrst),
    .start_note(tb_start_note),
    .end_note(tb_end_note),
    .new_max(tb_new_max),
    .current_max(tb_current_max),
    .current_count(tb_current_count),
    .availible(tb_availible)

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
    tb_enable = 1;
    tb_new_max = MAX_TEST[19:0];
    tb_end_note = 0;
    tb_start_note = 0;
    current_count_exp = 0;
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

    #(CLK_PERIOD * 2); // Wait 2 clock periods before proceeding

		// Check outputs again
		// tb_count_exp = 1;  // because enable is high
		
		// check_outputs(dataOut_exp);

    /////////////////////////////////
		// Test 1: Setting A Max Count //
		/////////////////////////////////

		tb_test_num+=1;
		tb_test_name = "Setting A Max Count";
    tb_start_note = 1;

    #(CLK_PERIOD * 1); // Wait 1 clock periods before proceeding

    tb_start_note = 0;

    /////////////////////////////////
		// Test 2: Continuous Counting //
		/////////////////////////////////

		tb_test_num+=1;
		tb_test_name = "Continuous Counting";

    for (integer i = 0; i <= MAX_TEST + 3; i++) begin
      current_count_exp = i[19:0] % (MAX_TEST[19:0] + 1);
      check_outputs(current_count_exp, tb_current_count);
    end

    current_count_exp++;
    
    ////////////////////////////////
		// Test 3: Disable Count Test //
		////////////////////////////////

    tb_test_num+=1;
		tb_test_name = "Disable Count Test";

    tb_enable = 0;

    #(CLK_PERIOD * 2); // Wait 2 clock periods before proceeding

    tb_enable = 1;

    #(CLK_PERIOD * 1); // Wait 1 clock periods before proceeding

    current_count_exp++;

    /////////////////////////////////
		// Test 4: Mismatched End Note //
		/////////////////////////////////
    tb_test_num+=1;
		tb_test_name = "Mismatched End Note";

    tb_new_max = 20'hA;
    tb_end_note = 1;
    
    check_outputs(20'h5,tb_current_max);

    #(CLK_PERIOD * 1); // Wait 1 clock periods before proceeding

    tb_end_note = 0;

    current_count_exp++;

    #(CLK_PERIOD * 1); // Wait 1 clock periods before proceeding

    current_count_exp = 0;


    //////////////////////////////
		// Test 5: Correct End Note //
		//////////////////////////////
    tb_test_num+=1;
		tb_test_name = "Correct End Note";

    tb_end_note = 1;
    tb_new_max = 20'h5;

    check_outputs(20'h0,tb_current_max);

    #(CLK_PERIOD * 1); // Wait 1 clock periods before proceeding

    tb_end_note = 0;
    current_count_exp = 0;

    #(CLK_PERIOD * 3); // Wait 1 clock periods before proceeding

  $finish;
	end

endmodule
