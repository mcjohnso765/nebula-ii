/*
	Module name: tb_norm
	Description: A testbench for the normalizer module
*/

`timescale 1ns/1ps

module tb_norm ();

	/////////////////////
	// Testbench Setup //
	/////////////////////
	
	// Define local parameters
	localparam CLK_PERIOD = 100; // 10 MHz 
	localparam RESET_ACTIVE = 0;
	localparam RESET_INACTIVE = 1;
	localparam TEST_CYCLES = 256;
	localparam C = 20; // size of count and max, 20 by default
	localparam S = 8; // precision (significant figures), 8 by default

	// Testbench Signals
	integer tb_test_num;
	string tb_test_name; 

	// DUT Inputs
	logic tb_clk, tb_nrst, tb_start;
	logic [19:0] tb_count, tb_max;

	// DUT Outputs
	logic [7:0] tb_count_nm;
	logic tb_ready;
 
	// Expected Outputs
	logic [7:0] tb_count_nm_exp;
	// logic tb_ready_exp;

	// Operations
	logic [19:0] quotient;
	logic started;
	integer runtime;
	integer cycle;
	integer start_clks;
	integer tot_clks;
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
		input logic [7:0] exp_count_nm; 
		// input logic exp_ready;
	begin
		checking = 1'b1;
		@(negedge tb_clk);  // Check away from the clock edge!
		checking = 1'b0;

		if(exp_count_nm == tb_count_nm)
			$info("Correct tb_count_nm value.");  
		else
			$error("Incorrect tb_count_nm value. Actual: %0d, Expected: %0d.", tb_count_nm, exp_count_nm);

		// if(exp_ready == tb_ready)
		// 	$info("Correct tb_ready value.");  
		// else
		// 	$error("Incorrect tb_ready value. Actual: %0d, Expected: %0d.", tb_ready, exp_ready);
	end
	endtask 

	//////////
	// DUT //
	//////////

	// DUT Instance
	norm #(.S(S)) DUT (
		.clk(tb_clk),
		.nrst(tb_nrst),
		.start(tb_start),
		.count(tb_count),
		.max(tb_max),
		.count_nm(tb_count_nm),
		.ready(tb_ready)
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
		tb_start = 0;
		tb_count = 0;
		tb_max = 0;
		tb_count_nm_exp = 0;
		// tb_ready_exp = 0;
		quotient = 0;
		checking = 0;
		started = 0;
		runtime = 0;
		cycle = 0;
		start_clks = 0;
		tot_clks = 0;

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
		tb_count_nm_exp = 0;
		// tb_ready_exp = 0;
		check_outputs(tb_count_nm_exp);

		// Deactivate Reset
		tb_nrst = RESET_INACTIVE;

		// Check outputs again
		tb_count_nm_exp = 0;
		// tb_ready_exp = 0;
		check_outputs(tb_count_nm_exp);

		///////////////////////
		// Test 1: Operation //
		///////////////////////

		tb_test_num += 1; 
		tb_test_name = "Test 1: Operation";
		reset_dut();

		tb_count = 0;

		@(posedge tb_clk);
		while (cycle < TEST_CYCLES) begin // send start signal TEST_CYCLES times
			@(posedge tb_clk);
			
			// tb_count = 20'h00069 * cycle[19:0]; // check one set of inputs every cycle
			// saw counter simulator
			tb_count = tb_count + 1;
			if (tb_count >= tb_max)
				tb_count = 0;
			tb_max = 20'h0754E;
			tb_start = 0;

			start_clks++;

			if (started && !tb_ready) begin // count runtime
				runtime++;
			end
			
			if ((start_clks % (S+8 + 3)) == 0) begin
				cycle++;
				started = 0;
				runtime = 0;
				start_clks = 1;
			end
			
			if (!started && tb_ready) begin // set expectations and start
				tb_start = 1;
				started = 1;
				check_outputs(tb_count_nm_exp);
				quotient = (tb_count * 256) / tb_max;
				tb_count_nm_exp = quotient[7:0];
			end
		end

		#(CLK_PERIOD * 10);

		$finish;
	end

endmodule
