/*
	Module name: tb_start_arbitrator
	Description: A testbench for the start arbitrator module
*/

`timescale 1ns/1ps

module tb_start_arbitrator();

	/////////////////////
	// Testbench Setup //
	/////////////////////
	
	// Define local parameters
	localparam CLK_PERIOD = 10; // 100 MHz 
	localparam RESET_ACTIVE = 0;
	localparam RESET_INACTIVE = 1;
	localparam NUM_OSCILLATORS = 64;

	// Testbench Signals
	integer tb_test_num;
	string tb_test_name; 

	// DUT Inputs
	logic tb_clk;
	logic tb_nrst;
	logic tb_start_in;
	logic [NUM_OSCILLATORS-1:0] tb_avail;

	// DUT Outputs
	logic [NUM_OSCILLATORS-1:0] tb_start_out;

	// Expected values for checks
	logic [NUM_OSCILLATORS-1:0] tb_start_out_exp;
	logic [15:0] [5:0] tb_recent, tb_recent_exp;  

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
		// @(negedge tb_clk); // synchronize to negedge edge so there are not hold or setup time violations
		
		// Activate reset
		tb_nrst = RESET_ACTIVE;

		// Wait 2 clock cycles
		tb_start_out_exp = 0; 
		check_outputs(tb_start_out_exp);
		@(negedge tb_clk);

		// Deactivate reset
		tb_nrst = RESET_INACTIVE; 
	end
	endtask

	// Check output values against expected values
	task check_outputs;
		input logic [NUM_OSCILLATORS-1:0] exp_start_out; 
	begin
		@(negedge tb_clk);  // Check away from the clock edge!
		if(exp_start_out == tb_start_out_exp)
			$info("Correct tb_start_out value.");  
		else
			$error("Incorrect tb_start_out value. Actual: %0d, Expected: %0d.", tb_start_out, exp_start_out);

	end
	endtask 
	task check_recent;
		input logic [NUM_OSCILLATORS-1:0] exp_recent; 
	begin
		@(negedge tb_clk);  // Check away from the clock edge!
		if(exp_recent == tb_recent_exp)
			$info("Correct tb_recent value.");  
		else
			$error("Incorrect tb_recent value. Actual: %0d, Expected: %0d.", tb_recent, exp_recent);
	end
	endtask

	//////////
	// DUT //
	//////////

	// DUT Instance
	start_arbitrator DUT (
		.MHz10(tb_clk),
		.nrst(tb_nrst),
		.start_in(tb_start_in),
		.avail(tb_avail),
		.start_out(tb_start_out),
		.recent(tb_recent)
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
		tb_start_in = 0;
		tb_avail = 0;
		// Wait some time before starting first test case
		#(0.5);

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
		tb_start_out_exp = 0; 
		check_outputs(tb_start_out_exp);
		tb_recent_exp = 0;
		check_recent(tb_recent_exp);

		// Deactivate Reset
		tb_nrst = RESET_INACTIVE;

		//////////////////////////
		// Test 1: Start_in Off //
		//////////////////////////

		tb_test_num += 1; 
		tb_test_name = "Start_in off";
		tb_start_in = 0;
		tb_avail = 64'hffff;
		tb_start_out_exp = 0; 
		check_outputs(tb_start_out_exp);

		//////////////////////////////////////////
		// Test 2: Check for correct oscillator //
		//////////////////////////////////////////
		
		// tb_test_num += 1;
		// tb_test_name = "Check for correct oscillator";
		// tb_start_in = 1;
		// tb_avail = 4'b1101;
		// tb_start_out_exp = 4'b0001;
		// check_outputs(tb_start_out_exp);
		// tb_avail = 4'b1100;
		// tb_start_out_exp = 4'b0100;
		// check_outputs(tb_start_out_exp);
		// tb_avail = 4'b1000;
		// tb_start_out_exp = 4'b1000;
		// check_outputs(tb_start_out_exp);

		//////////////////////////
		// Test 3: Check recent //
		//////////////////////////

		tb_test_num += 1;
		tb_test_name = "Check recent";
		tb_start_in = 1;
		tb_avail = 64'b1111111111111111111111111111111111111111111111111111111111111111;
		tb_recent_exp = {6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0};
		check_recent(tb_recent_exp);
		tb_avail = 64'b1111111111111111111111111111111111111111111111111111111111111110;
		tb_recent_exp = {6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd1, 6'd0};
		check_recent(tb_recent_exp);
		tb_avail = 64'b1111111111111111111111111111111111111111111111111111111111111100;
		tb_recent_exp = {6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd2, 6'd1, 6'd0};
		check_recent(tb_recent_exp);
		tb_avail = 64'b1111111111111111111111111111111111111111111111111111111111111000;
		tb_recent_exp = {6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd3, 6'd2, 6'd1, 6'd0};
		check_recent(tb_recent_exp);
		tb_avail = 64'b1111111111111111111111111111111111111111111111111111111111110000;
		tb_recent_exp = {6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd4, 6'd3, 6'd2, 6'd1, 6'd0};
		check_recent(tb_recent_exp);
		tb_avail = 64'b1111111111111111111111111111111111111111111111111111111111100000;
		tb_recent_exp = {6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd5, 6'd4, 6'd3, 6'd2, 6'd1, 6'd0};
		check_recent(tb_recent_exp);
		tb_avail = 64'b1111111111111111111111111111111111111111111111111111111111000000;
		tb_recent_exp = {6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd6, 6'd5, 6'd4, 6'd3, 6'd2, 6'd1, 6'd0};
		check_recent(tb_recent_exp);
		tb_avail = 64'b1111111111111111111111111111111111111111111111111111111110000000;
		tb_recent_exp = {6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd7, 6'd6, 6'd5, 6'd4, 6'd3, 6'd2, 6'd1, 6'd0};
		check_recent(tb_recent_exp);
		tb_avail = 64'b1111111111111111111111111111111111111111111111111111111100000000;
		tb_recent_exp = {6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd8, 6'd7, 6'd6, 6'd5, 6'd4, 6'd3, 6'd2, 6'd1, 6'd0};
		check_recent(tb_recent_exp);
		tb_avail = 64'b1111111111111111111111111111111111111111111111111111111000000000;
		tb_recent_exp = {6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd9, 6'd8, 6'd7, 6'd6, 6'd5, 6'd4, 6'd3, 6'd2, 6'd1, 6'd0};
		check_recent(tb_recent_exp);
		tb_avail = 64'b1111111111111111111111111111111111111111111111111111110000000000;
		tb_recent_exp = {6'd0, 6'd0, 6'd0, 6'd0, 6'd0, 6'd10, 6'd9, 6'd8, 6'd7, 6'd6, 6'd5, 6'd4, 6'd3, 6'd2, 6'd1, 6'd0};
		check_recent(tb_recent_exp);
		tb_avail = 64'b1111111111111111111111111111111111111111111111111111100000000000;
		tb_recent_exp = {6'd0, 6'd0, 6'd0, 6'd0, 6'd11, 6'd10, 6'd9, 6'd8, 6'd7, 6'd6, 6'd5, 6'd4, 6'd3, 6'd2, 6'd1, 6'd0};
		check_recent(tb_recent_exp);
		tb_avail = 64'b1111111111111111111111111111111111111111111111111111000000000000;
		tb_recent_exp = {6'd0, 6'd0, 6'd0, 6'd12, 6'd11, 6'd10, 6'd9, 6'd8, 6'd7, 6'd6, 6'd5, 6'd4, 6'd3, 6'd2, 6'd1, 6'd0};
		check_recent(tb_recent_exp);
		tb_avail = 64'b1111111111111111111111111111111111111111111111111110000000000000;
		tb_recent_exp = {6'd0, 6'd0, 6'd13, 6'd12, 6'd11, 6'd10, 6'd9, 6'd8, 6'd7, 6'd6, 6'd5, 6'd4, 6'd3, 6'd2, 6'd1, 6'd0};
		check_recent(tb_recent_exp);
		tb_avail = 64'b1111111111111111111111111111111111111111111111111100000000000000;
		tb_recent_exp = {6'd0, 6'd14, 6'd13, 6'd12, 6'd11, 6'd10, 6'd9, 6'd8, 6'd7, 6'd6, 6'd5, 6'd4, 6'd3, 6'd2, 6'd1, 6'd0};
		check_recent(tb_recent_exp);
		tb_avail = 64'b0000000000000000000000000000000000000000000000000000000000000000;
		tb_recent_exp = {6'd15, 6'd14, 6'd13, 6'd12, 6'd11, 6'd10, 6'd9, 6'd8, 6'd7, 6'd6, 6'd5, 6'd4, 6'd3, 6'd2, 6'd1, 6'd0};
		check_recent(tb_recent_exp);
		tb_avail = 64'b0000000000000000000000000000000000000000000000000000000000000000;
		tb_recent_exp = {6'd15, 6'd14, 6'd13, 6'd12, 6'd11, 6'd10, 6'd9, 6'd8, 6'd7, 6'd6, 6'd5, 6'd4, 6'd3, 6'd2, 6'd1, 6'd16};
		check_recent(tb_recent_exp);


		$finish;
	end


endmodule
