/*
	Module name: tb_osc_sel
	Description: A testbench for the oscillator selector module
*/

`timescale 1ns/1ps

module tb_poly_ctrl ();

	/////////////////////
	// Testbench Setup //
	/////////////////////
	
	// Define local parameters
	localparam CLK_PERIOD = 100; // 10 MHz 
	localparam RESET_ACTIVE = 0;
	localparam RESET_INACTIVE = 1;
	localparam N = 10; // number of oscillators per controller

	// Testbench Signals
	integer tb_test_num;
	string tb_test_name; 

	// DUT Inputs
	logic tb_clk, tb_nrst;
	logic [5:0] tb_osc_num;
	logic [N - 1:0] [19:0] tb_count, tb_max;

	// DUT Outputs
	logic [19:0] tb_count_sel, tb_max_sel;
 
	// Expected Outputs
	logic [19:0] tb_count_sel_exp, tb_max_sel_exp;

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
		input logic [19:0] exp_count_sel, exp_max_sel;
	begin
		@(negedge tb_clk);  // Check away from the clock edge!
		checking = 1'b1;

		if(exp_count_sel == tb_count_sel)
			$info("Correct tb_count_sel value.");  
		else
			$error("Incorrect tb_count_sel value. Actual: %0d, Expected: %0d.", tb_count_sel, exp_count_sel);

		if(exp_max_sel == tb_max_sel)
			$info("Correct tb_max_sel value.");  
		else
			$error("Incorrect tb_max_sel value. Actual: %0d, Expected: %0d.", tb_max_sel, exp_max_sel);

		@(posedge tb_clk);
		checking = 1'b0;
	end
	endtask 

	//////////
	// DUT //
	//////////

	// DUT Instance
	osc_sel #(.N(N)) DUT (
		.osc_num(tb_osc_num),
		.count(tb_count),
		.max(tb_max),
		.count_sel(tb_count_sel),
		.max_sel(tb_max_sel)
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
		tb_osc_num = 0;
		tb_count = 0;
		tb_max = 0;
		tb_count_sel_exp = 0;
		tb_max_sel_exp = 0;
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
		tb_count_sel_exp = 0;
		tb_max_sel_exp = 0;
		check_outputs(tb_count_sel_exp, tb_max_sel_exp);

		// Deactivate Reset
		tb_nrst = RESET_INACTIVE;

		// Check outputs again
		tb_count_sel_exp = 0;
		tb_max_sel_exp = 0;
		check_outputs(tb_count_sel_exp, tb_max_sel_exp);

		///////////////////////
		// Test 1: Operation //
		///////////////////////

		tb_test_num += 1; 
		tb_test_name = "Test 1: Operation";
		reset_dut();

		@(posedge tb_clk);

		for (integer i = 0; i < N; i++) begin
			tb_count[i] = i[19:0] * 16;
		end

		for (integer i = 0; i < N; i++) begin
			tb_max[i] = i[19:0] * 256;
		end

		for (tb_osc_num = 0; tb_osc_num < N; tb_osc_num++) begin
			tb_count_sel_exp = tb_count[tb_osc_num];
			tb_max_sel_exp = tb_max[tb_osc_num];
			check_outputs(tb_count_sel_exp, tb_max_sel_exp);
		end

		$finish;
	end

endmodule
