/*
	Module name: tb_buffer_controller
	Description: A testbench for the buffer controller module
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
	localparam TB_MAX = 10;
	localparam BAUDPER = 320 * CLK_PERIOD; //number of MHz100 cycles for each data bit

	// Testbench Signals
	integer tb_test_num;
	string tb_test_name; 

	// DUT Inputs
	logic MHz10;
	logic tb_nrst;
	logic tb_enable;
	logic tb_serIn;
	logic [7:0] tb_dataOut, dataOut_exp;

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
		// input logic [NUM_BITS-1:0] exp_count; 
		input logic [7:0] exp_dataOut;
	begin
		@(negedge MHz10);  // Check away from the clock edge!
		// if(exp_count == tb_count)
		// 	$info("Correct tb_count value.");  
		// else
		// 	$error("Incorrect tb_count value. Actual: %0d, Expected: %0d.", tb_count, exp_count);


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

	task automatic send_uart(input logic [7:0] dat);

		// Start bit
		tb_serIn = 0;
		#(BAUDPER);

		for (integer i = 0; i < 8; i++) begin
			tb_serIn = dat[i];
			#(BAUDPER);
		end

		// Stop bit
		tb_serIn = 1;
		#(BAUDPER);
		
	endtask //automatic

	task automatic send_midi(input logic [7:0] ctrl, note, volume);
		send_uart(ctrl);
		send_uart(note);
		send_uart(volume);
	endtask //automatic

	//////////
	// DUT //
	//////////

	// DUT Instance
	MidiRx midiRx(
		.MHz10(MHz10),
		.serIn(tb_serIn),
		.dataOut(tb_dataOut),
		.nrst(tb_nrst)

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
		tb_serIn = 1;
		dataOut_exp = 0;
		tb_enable = 1;

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

		#(BAUDPER * 2); // Wait 2 clock periods before proceeding
		
		// Check outputs are reset
		// tb_count_exp = 0; 

		check_outputs(dataOut_exp);

		// Deactivate Reset
		tb_nrst = RESET_INACTIVE;
		# (BAUDPER * 4);

		// Check outputs again
		// tb_count_exp = 1;  // because enable is high
		
		check_outputs(dataOut_exp);

		tb_serIn = 0;
		# BAUDPER;
		tb_serIn = 1;
		# (BAUDPER * 2);
		tb_serIn = 0;
		# (BAUDPER * 2);
		tb_serIn = 1;
		# BAUDPER;
		tb_serIn = 0;
		# BAUDPER;
		tb_serIn = 1;
		# BAUDPER;
		tb_serIn = 0;
		# BAUDPER;
		tb_serIn = 1;
		# (BAUDPER * 3);

		tb_serIn = 0;
		# BAUDPER;
		tb_serIn = 0;
		# (BAUDPER * 2);
		tb_serIn = 1;
		# (BAUDPER * 2);
		tb_serIn = 0;
		# BAUDPER;
		tb_serIn = 1;
		# BAUDPER;
		tb_serIn = 0;
		# BAUDPER;
		tb_serIn = 1;
		# BAUDPER;
		tb_serIn = 1;
		# (BAUDPER * 3);
		tb_nrst = RESET_ACTIVE;
		#(BAUDPER / 2);
		tb_nrst = RESET_INACTIVE;
		# (BAUDPER * 5);

		send_midi(8'hCA, 8'h4C, 8'hFF);
		#(BAUDPER * 10);
		$finish;
	end

endmodule
