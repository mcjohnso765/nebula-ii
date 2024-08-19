/*
	Module name: tb_poly_ctrl
	Description: A testbench for the polyphony controller module
*/

`timescale 1ns/1ps

// typedef enum logic [1:0] {START_DIV = 0, DONE_DIV = 1, HOLD_SAMP = 2} state_t;

module tb_poly_ctrl ();

	/////////////////////
	// Testbench Setup //
	/////////////////////
	
	// Define local parameters
	localparam CLK_PERIOD = 100; // 10 MHz 
	localparam RESET_ACTIVE = 0;
	localparam RESET_INACTIVE = 1;
	localparam N = 10; // number of oscillators per controller

	// Typedef enum
	localparam START_DIV = 0;
	localparam DONE_DIV = 1;
	localparam HOLD_SAMP = 2;

	// Testbench Signals
	integer tb_test_num;
	string tb_test_name; 

	// DUT Inputs
	logic tb_clk, tb_nrst, tb_ready, tb_samp_enable;

	// DUT Outputs
	logic tb_start, tb_acc, tb_store_samp, tb_clr;
	logic [5:0] tb_osc_num;
 
	// Expected Outputs
	logic tb_start_exp, tb_acc_exp, tb_store_samp_exp, tb_clr_exp;
	logic [5:0] tb_osc_num_exp;
	logic [1:0] tb_state_exp;

	// Operations
	logic checking;

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
		@(negedge tb_clk); // synchronize to negedge edge so there are not hold or setup time violations
		
		// Activate reset
		tb_nrst = RESET_ACTIVE;

		// Wait 2 clock cycles
		@(negedge tb_clk);
		@(negedge tb_clk);

		// Deactivate reset
		tb_nrst = RESET_INACTIVE; 
	end
	endtask

	// Check output values against expected values
	task check_outputs;
		input logic exp_start, exp_acc, exp_store_samp, exp_clr; 
		input logic [5:0] exp_osc_num;
	begin
		@(negedge tb_clk);  // Check away from the clock edge!
		checking = 1'b1;

		if(exp_start == tb_start)
			$info("Correct tb_start value.");  
		else
			$error("Incorrect tb_start value. Actual: %0d, Expected: %0d.", tb_start, exp_start);

		if(exp_acc == tb_acc)
			$info("Correct tb_acc value.");  
		else
			$error("Incorrect tb_acc value. Actual: %0d, Expected: %0d.", tb_acc, exp_acc);

		if(exp_store_samp == tb_store_samp)
			$info("Correct tb_store_samp value.");  
		else
			$error("Incorrect tb_store_samp value. Actual: %0d, Expected: %0d.", tb_store_samp, exp_store_samp);

		if(exp_clr == tb_clr)
			$info("Correct tb_clr value.");  
		else
			$error("Incorrect tb_clr value. Actual: %0d, Expected: %0d.", tb_clr, exp_clr);
		
		if(exp_osc_num == tb_osc_num)
			$info("Correct tb_osc_num value.");  
		else
			$error("Incorrect tb_osc_num value. Actual: %0d, Expected: %0d.", tb_osc_num, exp_osc_num);

		@(posedge tb_clk);
		checking = 1'b0;
	end
	endtask 

	//////////
	// DUT //
	//////////

	// DUT Instance
	poly_ctrl #(.N(N)) DUT (
		.clk(tb_clk),
		.nrst(tb_nrst),
		.ready(tb_ready),
		.samp_enable(tb_samp_enable),
		.start(tb_start),
		.acc(tb_acc),
		.store_samp(tb_store_samp),
		.clr(tb_clr),
		.osc_num(tb_osc_num)
	);

	// Clock generation block
	always begin
		tb_clk = 0; // set clock initially to be 0 so that they are no time violations at the rising edge 
		#(CLK_PERIOD / 2);
		tb_clk = 1;
		#(CLK_PERIOD / 2);
	end

	initial begin

		// Initialize all test inputs
		tb_test_num = -1;  // We haven't started testing yet
		tb_test_name = "Test Bench Initialization";
		tb_nrst = RESET_INACTIVE;
		tb_ready = 0;
		tb_samp_enable = 0;
		tb_start_exp = 1;
		tb_acc_exp = 0;
		tb_store_samp_exp = 0;
		tb_clr_exp = 0;
		tb_osc_num_exp = 0;
		tb_state_exp = START_DIV;
		checking = 0;

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
		tb_start_exp = 1;
		tb_acc_exp = 0;
		tb_store_samp_exp = 0;
		tb_clr_exp = 0;
		tb_osc_num_exp = 0;
		check_outputs(tb_start_exp, tb_acc_exp, tb_store_samp_exp, tb_clr_exp, tb_osc_num_exp);

		// Deactivate Reset
		tb_nrst = RESET_INACTIVE;

		// Check outputs again
		tb_start_exp = 1;
		tb_acc_exp = 0;
		tb_store_samp_exp = 0;
		tb_clr_exp = 0;
		tb_osc_num_exp = 0;
		check_outputs(tb_start_exp, tb_acc_exp, tb_store_samp_exp, tb_clr_exp, tb_osc_num_exp);

		///////////////////////
		// Test 1: Operation //
		///////////////////////

		tb_test_num += 1; 
		tb_test_name = "Test 1: Operation";
		reset_dut();

		@(posedge tb_clk);

		// START_DIV
		tb_state_exp = START_DIV;
		tb_start_exp = 1;
		tb_acc_exp = 0;
		tb_store_samp_exp = 0;
		tb_clr_exp = 0;
		check_outputs(tb_start_exp, tb_acc_exp, tb_store_samp_exp, tb_clr_exp, tb_osc_num_exp);
		tb_osc_num_exp = tb_osc_num_exp;

		// stay at START_DIV
		tb_state_exp = START_DIV;
		tb_start_exp = 1;
		tb_acc_exp = 0;
		tb_store_samp_exp = 0;
		tb_clr_exp = 0;
		check_outputs(tb_start_exp, tb_acc_exp, tb_store_samp_exp, tb_clr_exp, tb_osc_num_exp);
		tb_osc_num_exp = tb_osc_num_exp;

		// START_DIV to DONE_DIV to START_DIV loop
		tb_ready = 1;
		while (tb_osc_num_exp < N) begin
			// START_DIV
			tb_state_exp = START_DIV;
			tb_start_exp = 1;
			tb_acc_exp = 0;
			tb_store_samp_exp = 0;
			tb_clr_exp = 0;
			check_outputs(tb_start_exp, tb_acc_exp, tb_store_samp_exp, tb_clr_exp, tb_osc_num_exp);
			tb_osc_num_exp = tb_osc_num_exp;
		
			// DONE_DIV
			tb_state_exp = DONE_DIV;
			tb_start_exp = 0;
			tb_acc_exp = 1;
			tb_store_samp_exp = 0;
			tb_clr_exp = 0;
			check_outputs(tb_start_exp, tb_acc_exp, tb_store_samp_exp, tb_clr_exp, tb_osc_num_exp);
			tb_osc_num_exp = tb_osc_num_exp + 1;
		end

		// to HOLD_SAMP
		tb_state_exp = HOLD_SAMP;
		tb_samp_enable = 0;
		tb_start_exp = 0;
		tb_acc_exp = 0;
		tb_store_samp_exp = 0;
		tb_clr_exp = 0;
		check_outputs(tb_start_exp, tb_acc_exp, tb_store_samp_exp, tb_clr_exp, tb_osc_num_exp);
		tb_osc_num_exp = tb_osc_num_exp;

		// stay at HOLD_SAMP
		tb_state_exp = HOLD_SAMP;
		tb_start_exp = 0;
		tb_acc_exp = 0;
		tb_store_samp_exp = 0;
		tb_clr_exp = 0;
		check_outputs(tb_start_exp, tb_acc_exp, tb_store_samp_exp, tb_clr_exp, tb_osc_num_exp);
		tb_osc_num_exp = tb_osc_num_exp;

		// activate sample storage and clear. next is START_DIV
		tb_samp_enable = 1;
		tb_state_exp = HOLD_SAMP;
		tb_start_exp = 0;
		tb_acc_exp = 0;
		tb_store_samp_exp = 1;
		tb_clr_exp = 1;
		check_outputs(tb_start_exp, tb_acc_exp, tb_store_samp_exp, tb_clr_exp, tb_osc_num_exp);
		tb_osc_num_exp = 0;

		// to START_DIV and stay
		tb_ready = 0;
		tb_state_exp = START_DIV;
		tb_start_exp = 1;
		tb_acc_exp = 0;
		tb_store_samp_exp = 0;
		tb_clr_exp = 0;
		check_outputs(tb_start_exp, tb_acc_exp, tb_store_samp_exp, tb_clr_exp, tb_osc_num_exp);

		$finish;
	end

endmodule
