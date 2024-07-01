/*
	Module Name: note_div_table
	Description: note clock division table
*/

`timescale 1ns/1ps

module tb_wave_shape_table ();

	// Testbench parameters
	localparam CLK_PERIOD = 10; // 100 MHz clk
	logic tb_checking_outputs;
	integer tb_test_num;
	string tb_test_case;

	// DUT ports
	logic tb_clk, tb_nRst_i;
	logic [8:0] tb_sample;
	logic [3:0] tb_mode;
	logic [8:0] tb_digital_out;

	// Reset DUT Task
	task reset_dut;
		@(negedge tb_clk);
		tb_nRst_i = 1'b0;
		@(negedge tb_clk);
		@(negedge tb_clk);
		tb_nRst_i = 1'b1;
		@(posedge tb_clk);
	endtask

	// Check outputs task
	task check_outputs;
	input logic [8:0] tb_o, exp_o;
	begin
		@(negedge tb_clk);
		tb_checking_outputs = 1'b1;
		if(tb_o == exp_o)
				$info("Correct output: %0d.", exp_o);
		else
				$error("Incorrect output. Expected: %0d. Actual: %0d.", exp_o, tb_o);
		
		#(1);
		tb_checking_outputs = 1'b0;
	end
	endtask

	// Clock generation block
	always begin
		tb_clk = 1'b0;
		#(CLK_PERIOD / 2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD / 2.0);
	end

	// DUT Portmap and expected outputs
	wave_shape_table DUT(.sample(tb_sample[7:0]),
		.mode(tb_mode[2:0]), .digital_out(tb_digital_out));
	logic [8:0] exp_digital_out;

	// Case function
	function [8:0] digital_out (input [7:0] sample, input [2:0] mode);
		logic [7:0] new_sample = 0;
		if (mode == 3'd0) begin //sawtooth
			digital_out = {sample, 1'b0};
		end
		else if (mode == 3'd1) begin //square
			if (sample > 127)
				digital_out = 9'b0;
			else
				digital_out = 9'b111111111;
		end
		else if (mode == 3'd2) begin //reverse sawtooth
			digital_out = {~sample, 1'b0};
		end
		else if (mode == 3'd3) begin //triangle
			if (sample > 127)
				digital_out = {~sample[6:0], 2'b0};
			else
				digital_out = {sample[6:0], 2'b0};
		end
		else if (mode == 3'd4) begin //sine
			if (sample >= 192)
				new_sample = 8'd255 - sample;
			else if (sample >= 128)
				new_sample = sample - 8'd128;
			else if (sample >= 64)
				new_sample = 8'd127 - sample;
			else
				new_sample = sample;
			case (new_sample)
				8'b00000000: digital_out = 9'b011111111;
				8'b00000001: digital_out = 9'b100000101;
				8'b00000010: digital_out = 9'b100001100;
				8'b00000011: digital_out = 9'b100010010;
				8'b00000100: digital_out = 9'b100011000;
				8'b00000101: digital_out = 9'b100011110;
				8'b00000110: digital_out = 9'b100100100;
				8'b00000111: digital_out = 9'b100101011;
				8'b00001000: digital_out = 9'b100110001;
				8'b00001001: digital_out = 9'b100110111;
				8'b00001010: digital_out = 9'b100111101;
				8'b00001011: digital_out = 9'b101000011;
				8'b00001100: digital_out = 9'b101001001;
				8'b00001101: digital_out = 9'b101001111;
				8'b00001110: digital_out = 9'b101010101;
				8'b00001111: digital_out = 9'b101011011;
				8'b00010000: digital_out = 9'b101100001;
				8'b00010001: digital_out = 9'b101100110;
				8'b00010010: digital_out = 9'b101101100;
				8'b00010011: digital_out = 9'b101110010;
				8'b00010100: digital_out = 9'b101110111;
				8'b00010101: digital_out = 9'b101111101;
				8'b00010110: digital_out = 9'b110000010;
				8'b00010111: digital_out = 9'b110000111;
				8'b00011000: digital_out = 9'b110001101;
				8'b00011001: digital_out = 9'b110010010;
				8'b00011010: digital_out = 9'b110010111;
				8'b00011011: digital_out = 9'b110011100;
				8'b00011100: digital_out = 9'b110100001;
				8'b00011101: digital_out = 9'b110100110;
				8'b00011110: digital_out = 9'b110101010;
				8'b00011111: digital_out = 9'b110101111;
				8'b00100000: digital_out = 9'b110110011;
				8'b00100001: digital_out = 9'b110111000;
				8'b00100010: digital_out = 9'b110111100;
				8'b00100011: digital_out = 9'b111000000;
				8'b00100100: digital_out = 9'b111000100;
				8'b00100101: digital_out = 9'b111001000;
				8'b00100110: digital_out = 9'b111001100;
				8'b00100111: digital_out = 9'b111001111;
				8'b00101000: digital_out = 9'b111010011;
				8'b00101001: digital_out = 9'b111010110;
				8'b00101010: digital_out = 9'b111011010;
				8'b00101011: digital_out = 9'b111011101;
				8'b00101100: digital_out = 9'b111100000;
				8'b00101101: digital_out = 9'b111100011;
				8'b00101110: digital_out = 9'b111100110;
				8'b00101111: digital_out = 9'b111101000;
				8'b00110000: digital_out = 9'b111101011;
				8'b00110001: digital_out = 9'b111101101;
				8'b00110010: digital_out = 9'b111101111;
				8'b00110011: digital_out = 9'b111110001;
				8'b00110100: digital_out = 9'b111110011;
				8'b00110101: digital_out = 9'b111110101;
				8'b00110110: digital_out = 9'b111110110;
				8'b00110111: digital_out = 9'b111111000;
				8'b00111000: digital_out = 9'b111111001;
				8'b00111001: digital_out = 9'b111111010;
				8'b00111010: digital_out = 9'b111111011;
				8'b00111011: digital_out = 9'b111111100;
				8'b00111100: digital_out = 9'b111111101;
				8'b00111101: digital_out = 9'b111111101;
				8'b00111110: digital_out = 9'b111111110;
				8'b00111111: digital_out = 9'b111111110;
				default: digital_out = 9'b0;
			endcase
			if (sample >= 128)
				digital_out = 9'd511 - digital_out;
			else
				digital_out = digital_out;
		end
		else if (mode == 3'd5) begin //trumpet
			if (sample >= 128)
					new_sample = 8'd255 - sample;
				else
					new_sample = sample;
				case (new_sample)
					8'b00000000: digital_out = 9'b100000000;
					8'b00000001: digital_out = 9'b100001110;
					8'b00000010: digital_out = 9'b100011100;
					8'b00000011: digital_out = 9'b100101010;
					8'b00000100: digital_out = 9'b100111010;
					8'b00000101: digital_out = 9'b101001000;
					8'b00000110: digital_out = 9'b101010110;
					8'b00000111: digital_out = 9'b101100100;
					8'b00001000: digital_out = 9'b101110000;
					8'b00001001: digital_out = 9'b101111110;
					8'b00001010: digital_out = 9'b110001010;
					8'b00001011: digital_out = 9'b110010110;
					8'b00001100: digital_out = 9'b110100010;
					8'b00001101: digital_out = 9'b110101100;
					8'b00001110: digital_out = 9'b110110110;
					8'b00001111: digital_out = 9'b111000000;
					8'b00010000: digital_out = 9'b111001010;
					8'b00010001: digital_out = 9'b111010010;
					8'b00010010: digital_out = 9'b111011010;
					8'b00010011: digital_out = 9'b111100000;
					8'b00010100: digital_out = 9'b111101000;
					8'b00010101: digital_out = 9'b111101100;
					8'b00010110: digital_out = 9'b111110010;
					8'b00010111: digital_out = 9'b111110110;
					8'b00011000: digital_out = 9'b111111000;
					8'b00011001: digital_out = 9'b111111100;
					8'b00011010: digital_out = 9'b111111100;
					8'b00011011: digital_out = 9'b111111110;
					8'b00011100: digital_out = 9'b111111110;
					8'b00011101: digital_out = 9'b111111110;
					8'b00011110: digital_out = 9'b111111100;
					8'b00011111: digital_out = 9'b111111010;
					8'b00100000: digital_out = 9'b111111000;
					8'b00100001: digital_out = 9'b111110100;
					8'b00100010: digital_out = 9'b111110000;
					8'b00100011: digital_out = 9'b111101100;
					8'b00100100: digital_out = 9'b111100110;
					8'b00100101: digital_out = 9'b111100000;
					8'b00100110: digital_out = 9'b111011010;
					8'b00100111: digital_out = 9'b111010100;
					8'b00101000: digital_out = 9'b111001100;
					8'b00101001: digital_out = 9'b111000100;
					8'b00101010: digital_out = 9'b110111100;
					8'b00101011: digital_out = 9'b110110100;
					8'b00101100: digital_out = 9'b110101010;
					8'b00101101: digital_out = 9'b110100010;
					8'b00101110: digital_out = 9'b110011000;
					8'b00101111: digital_out = 9'b110010000;
					8'b00110000: digital_out = 9'b110000110;
					8'b00110001: digital_out = 9'b101111100;
					8'b00110010: digital_out = 9'b101110100;
					8'b00110011: digital_out = 9'b101101010;
					8'b00110100: digital_out = 9'b101100000;
					8'b00110101: digital_out = 9'b101010110;
					8'b00110110: digital_out = 9'b101001110;
					8'b00110111: digital_out = 9'b101000100;
					8'b00111000: digital_out = 9'b100111100;
					8'b00111001: digital_out = 9'b100110010;
					8'b00111010: digital_out = 9'b100101010;
					8'b00111011: digital_out = 9'b100100010;
					8'b00111100: digital_out = 9'b100011010;
					8'b00111101: digital_out = 9'b100010100;
					8'b00111110: digital_out = 9'b100001100;
					8'b00111111: digital_out = 9'b100000110;
					8'b01000000: digital_out = 9'b100000000;
					8'b01000001: digital_out = 9'b011111010;
					8'b01000010: digital_out = 9'b011110100;
					8'b01000011: digital_out = 9'b011101110;
					8'b01000100: digital_out = 9'b011101010;
					8'b01000101: digital_out = 9'b011100110;
					8'b01000110: digital_out = 9'b011100010;
					8'b01000111: digital_out = 9'b011100000;
					8'b01001000: digital_out = 9'b011011100;
					8'b01001001: digital_out = 9'b011011010;
					8'b01001010: digital_out = 9'b011011000;
					8'b01001011: digital_out = 9'b011011000;
					8'b01001100: digital_out = 9'b011010110;
					8'b01001101: digital_out = 9'b011010110;
					8'b01001110: digital_out = 9'b011010110;
					8'b01001111: digital_out = 9'b011010110;
					8'b01010000: digital_out = 9'b011011000;
					8'b01010001: digital_out = 9'b011011000;
					8'b01010010: digital_out = 9'b011011010;
					8'b01010011: digital_out = 9'b011011100;
					8'b01010100: digital_out = 9'b011011110;
					8'b01010101: digital_out = 9'b011100000;
					8'b01010110: digital_out = 9'b011100010;
					8'b01010111: digital_out = 9'b011100100;
					8'b01011000: digital_out = 9'b011101000;
					8'b01011001: digital_out = 9'b011101010;
					8'b01011010: digital_out = 9'b011101110;
					8'b01011011: digital_out = 9'b011110000;
					8'b01011100: digital_out = 9'b011110100;
					8'b01011101: digital_out = 9'b011110110;
					8'b01011110: digital_out = 9'b011111010;
					8'b01011111: digital_out = 9'b011111110;
					8'b01100000: digital_out = 9'b100000000;
					8'b01100001: digital_out = 9'b100000100;
					8'b01100010: digital_out = 9'b100000110;
					8'b01100011: digital_out = 9'b100001000;
					8'b01100100: digital_out = 9'b100001100;
					8'b01100101: digital_out = 9'b100001110;
					8'b01100110: digital_out = 9'b100010000;
					8'b01100111: digital_out = 9'b100010010;
					8'b01101000: digital_out = 9'b100010100;
					8'b01101001: digital_out = 9'b100010110;
					8'b01101010: digital_out = 9'b100011000;
					8'b01101011: digital_out = 9'b100011000;
					8'b01101100: digital_out = 9'b100011010;
					8'b01101101: digital_out = 9'b100011010;
					8'b01101110: digital_out = 9'b100011010;
					8'b01101111: digital_out = 9'b100011100;
					8'b01110000: digital_out = 9'b100011010;
					8'b01110001: digital_out = 9'b100011010;
					8'b01110010: digital_out = 9'b100011010;
					8'b01110011: digital_out = 9'b100011010;
					8'b01110100: digital_out = 9'b100011000;
					8'b01110101: digital_out = 9'b100010110;
					8'b01110110: digital_out = 9'b100010110;
					8'b01110111: digital_out = 9'b100010100;
					8'b01111000: digital_out = 9'b100010010;
					8'b01111001: digital_out = 9'b100010000;
					8'b01111010: digital_out = 9'b100001110;
					8'b01111011: digital_out = 9'b100001100;
					8'b01111100: digital_out = 9'b100001010;
					8'b01111101: digital_out = 9'b100000110;
					8'b01111110: digital_out = 9'b100000100;
					8'b01111111: digital_out = 9'b100000010;
					default: digital_out = 9'b0;
				endcase
				if (sample >= 128)
					digital_out = 9'd511 - digital_out;
				else
					digital_out = digital_out;
			end
		else begin //if (mode == 6) begin // violin
			if (sample >= 128)
				new_sample = 8'd255 - sample;
			else
				new_sample = sample;
			case (new_sample)
				8'b00000000: digital_out = 9'b011111110;
				8'b00000001: digital_out = 9'b100101010;
				8'b00000010: digital_out = 9'b101010100;
				8'b00000011: digital_out = 9'b101111010;
				8'b00000100: digital_out = 9'b110011110;
				8'b00000101: digital_out = 9'b110111100;
				8'b00000110: digital_out = 9'b111010110;
				8'b00000111: digital_out = 9'b111101010;
				8'b00001000: digital_out = 9'b111110110;
				8'b00001001: digital_out = 9'b111111110;
				8'b00001010: digital_out = 9'b111111110;
				8'b00001011: digital_out = 9'b111111000;
				8'b00001100: digital_out = 9'b111101110;
				8'b00001101: digital_out = 9'b111100000;
				8'b00001110: digital_out = 9'b111001100;
				8'b00001111: digital_out = 9'b110111000;
				8'b00010000: digital_out = 9'b110100000;
				8'b00010001: digital_out = 9'b110001010;
				8'b00010010: digital_out = 9'b101110010;
				8'b00010011: digital_out = 9'b101011100;
				8'b00010100: digital_out = 9'b101001000;
				8'b00010101: digital_out = 9'b100111000;
				8'b00010110: digital_out = 9'b100101010;
				8'b00010111: digital_out = 9'b100011110;
				8'b00011000: digital_out = 9'b100011000;
				8'b00011001: digital_out = 9'b100010100;
				8'b00011010: digital_out = 9'b100010010;
				8'b00011011: digital_out = 9'b100010100;
				8'b00011100: digital_out = 9'b100011000;
				8'b00011101: digital_out = 9'b100011110;
				8'b00011110: digital_out = 9'b100100100;
				8'b00011111: digital_out = 9'b100101010;
				8'b00100000: digital_out = 9'b100110010;
				8'b00100001: digital_out = 9'b100111000;
				8'b00100010: digital_out = 9'b100111100;
				8'b00100011: digital_out = 9'b101000000;
				8'b00100100: digital_out = 9'b101000010;
				8'b00100101: digital_out = 9'b101000010;
				8'b00100110: digital_out = 9'b101000010;
				8'b00100111: digital_out = 9'b100111110;
				8'b00101000: digital_out = 9'b100111010;
				8'b00101001: digital_out = 9'b100110100;
				8'b00101010: digital_out = 9'b100101110;
				8'b00101011: digital_out = 9'b100101000;
				8'b00101100: digital_out = 9'b100100010;
				8'b00101101: digital_out = 9'b100011100;
				8'b00101110: digital_out = 9'b100011000;
				8'b00101111: digital_out = 9'b100010100;
				8'b00110000: digital_out = 9'b100010000;
				8'b00110001: digital_out = 9'b100010000;
				8'b00110010: digital_out = 9'b100001110;
				8'b00110011: digital_out = 9'b100010000;
				8'b00110100: digital_out = 9'b100010010;
				8'b00110101: digital_out = 9'b100010100;
				8'b00110110: digital_out = 9'b100010110;
				8'b00110111: digital_out = 9'b100011010;
				8'b00111000: digital_out = 9'b100011110;
				8'b00111001: digital_out = 9'b100100000;
				8'b00111010: digital_out = 9'b100100100;
				8'b00111011: digital_out = 9'b100100110;
				8'b00111100: digital_out = 9'b100100110;
				8'b00111101: digital_out = 9'b100100110;
				8'b00111110: digital_out = 9'b100100110;
				8'b00111111: digital_out = 9'b100100100;
				8'b01000000: digital_out = 9'b100100010;
				8'b01000001: digital_out = 9'b100100000;
				8'b01000010: digital_out = 9'b100011100;
				8'b01000011: digital_out = 9'b100011000;
				8'b01000100: digital_out = 9'b100010100;
				8'b01000101: digital_out = 9'b100010010;
				8'b01000110: digital_out = 9'b100001110;
				8'b01000111: digital_out = 9'b100001100;
				8'b01001000: digital_out = 9'b100001010;
				8'b01001001: digital_out = 9'b100001010;
				8'b01001010: digital_out = 9'b100001010;
				8'b01001011: digital_out = 9'b100001010;
				8'b01001100: digital_out = 9'b100001010;
				8'b01001101: digital_out = 9'b100001100;
				8'b01001110: digital_out = 9'b100001110;
				8'b01001111: digital_out = 9'b100010000;
				8'b01010000: digital_out = 9'b100010010;
				8'b01010001: digital_out = 9'b100010100;
				8'b01010010: digital_out = 9'b100010110;
				8'b01010011: digital_out = 9'b100011000;
				8'b01010100: digital_out = 9'b100011000;
				8'b01010101: digital_out = 9'b100010110;
				8'b01010110: digital_out = 9'b100010110;
				8'b01010111: digital_out = 9'b100010100;
				8'b01011000: digital_out = 9'b100010010;
				8'b01011001: digital_out = 9'b100010000;
				8'b01011010: digital_out = 9'b100001100;
				8'b01011011: digital_out = 9'b100001010;
				8'b01011100: digital_out = 9'b100001000;
				8'b01011101: digital_out = 9'b100000100;
				8'b01011110: digital_out = 9'b100000100;
				8'b01011111: digital_out = 9'b100000010;
				8'b01100000: digital_out = 9'b100000010;
				8'b01100001: digital_out = 9'b100000010;
				8'b01100010: digital_out = 9'b100000010;
				8'b01100011: digital_out = 9'b100000100;
				8'b01100100: digital_out = 9'b100000110;
				8'b01100101: digital_out = 9'b100001000;
				8'b01100110: digital_out = 9'b100001100;
				8'b01100111: digital_out = 9'b100001110;
				8'b01101000: digital_out = 9'b100010000;
				8'b01101001: digital_out = 9'b100010010;
				8'b01101010: digital_out = 9'b100010100;
				8'b01101011: digital_out = 9'b100010100;
				8'b01101100: digital_out = 9'b100010010;
				8'b01101101: digital_out = 9'b100010010;
				8'b01101110: digital_out = 9'b100001110;
				8'b01101111: digital_out = 9'b100001100;
				8'b01110000: digital_out = 9'b100001000;
				8'b01110001: digital_out = 9'b100000010;
				8'b01110010: digital_out = 9'b011111110;
				8'b01110011: digital_out = 9'b011111000;
				8'b01110100: digital_out = 9'b011110100;
				8'b01110101: digital_out = 9'b011110000;
				8'b01110110: digital_out = 9'b011101100;
				8'b01110111: digital_out = 9'b011101000;
				8'b01111000: digital_out = 9'b011100110;
				8'b01111001: digital_out = 9'b011100110;
				8'b01111010: digital_out = 9'b011100110;
				8'b01111011: digital_out = 9'b011101000;
				8'b01111100: digital_out = 9'b011101100;
				8'b01111101: digital_out = 9'b011110000;
				8'b01111110: digital_out = 9'b011110100;
				8'b01111111: digital_out = 9'b011111010;
				default: digital_out = 0;
			endcase
			if (sample >= 128)
				digital_out = 9'd511 - digital_out;
			else
				digital_out = digital_out;
		end
	endfunction

	// Main Test Bench Process
	initial begin
		// Signal dump
		$dumpfile("dump.vcd");
		$dumpvars; 
		
		// Initialize test bench signals
		tb_sample = 9'h00;
		tb_mode = 4'd0;
		tb_nRst_i = 1'b1;
		tb_checking_outputs = 1'b0;
		tb_test_num = -1;
		tb_test_case = "Initializing";

		// Wait some time before starting first test case
		#(0.1);

		// ************************************************************************
		// Test Case 1: Lookup table
		// ************************************************************************
		tb_test_num += 1;
		tb_test_case = "Test Case 1: Lookup table";
		$display("\n\n%s", tb_test_case);

		for (tb_mode = 4'd0; tb_mode <= 4'd6; tb_mode = tb_mode + 1) begin // test modes 0 through 6
			for (tb_sample = 9'h00; tb_sample < 9'hFF; tb_sample = tb_sample + 1) begin
				exp_digital_out = digital_out(tb_sample[7:0], tb_mode[2:0]);
				#(CLK_PERIOD / 2.0);
				check_outputs(tb_digital_out, exp_digital_out);
				#(CLK_PERIOD / 2.0);
			end
		end

		$finish; 
	end

endmodule 