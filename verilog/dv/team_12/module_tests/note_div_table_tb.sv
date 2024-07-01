/*
	Module Name: note_div_table
	Description: note clock division table
*/

`timescale 1ns/1ps

module tb_note_div_table ();

	// Testbench parameters
	localparam CLK_PERIOD = 10; // 100 MHz clk
	logic tb_checking_outputs;
	integer tb_test_num;
	string tb_test_case;

	// DUT ports
	logic tb_clk, tb_nRst_i;
	logic [6:0] tb_note_i; 
	logic [19:0] tb_max_o;

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
	input logic [19:0] tb_o, exp_o;
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
	note_div_table DUT(.note(tb_note_i),
		.max(tb_max_o));
	logic [19:0] exp_max_o;

	// Main Test Bench Process
	initial begin
		// Signal dump
		$dumpfile("dump.vcd");
		$dumpvars; 
		
		// Initialize test bench signals
		tb_note_i = 7'h00;
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

		for (tb_note_i = 7'h00; tb_note_i < 7'h7F; tb_note_i = tb_note_i + 1) begin
			case (tb_note_i)
				7'h00: exp_max_o = 20'h00000;
				7'h01: exp_max_o = 20'h954E9;
				7'h02: exp_max_o = 20'h8CED5;
				7'h03: exp_max_o = 20'h85047;
				7'h04: exp_max_o = 20'h7D8D3;
				7'h05: exp_max_o = 20'h76814;
				7'h06: exp_max_o = 20'h6FDA9;
				7'h07: exp_max_o = 20'h69937;
				7'h08: exp_max_o = 20'h63A68;
				7'h09: exp_max_o = 20'h5E0EB;
				7'h0A: exp_max_o = 20'h58C74;
				7'h0B: exp_max_o = 20'h53CBB;
				7'h0C: exp_max_o = 20'h4F17B;
				7'h0D: exp_max_o = 20'h4AA75;
				7'h0E: exp_max_o = 20'h4676A;
				7'h0F: exp_max_o = 20'h42823;
				7'h10: exp_max_o = 20'h3EC6A;
				7'h11: exp_max_o = 20'h3B40A;
				7'h12: exp_max_o = 20'h37ED5;
				7'h13: exp_max_o = 20'h34C9B;
				7'h14: exp_max_o = 20'h31D34;
				7'h15: exp_max_o = 20'h2F076;
				7'h16: exp_max_o = 20'h2C63A;
				7'h17: exp_max_o = 20'h29E5E;
				7'h18: exp_max_o = 20'h278BE;
				7'h19: exp_max_o = 20'h2553A;
				7'h1A: exp_max_o = 20'h233B5;
				7'h1B: exp_max_o = 20'h21412;
				7'h1C: exp_max_o = 20'h1F635;
				7'h1D: exp_max_o = 20'h1DA05;
				7'h1E: exp_max_o = 20'h1BF6A;
				7'h1F: exp_max_o = 20'h1A64E;
				7'h20: exp_max_o = 20'h18E9A;
				7'h21: exp_max_o = 20'h1783B;
				7'h22: exp_max_o = 20'h1631D;
				7'h23: exp_max_o = 20'h14F2F;
				7'h24: exp_max_o = 20'h13C5F;
				7'h25: exp_max_o = 20'h12A9D;
				7'h26: exp_max_o = 20'h119DB;
				7'h27: exp_max_o = 20'h10A09;
				7'h28: exp_max_o = 20'h0FB1A;
				7'h29: exp_max_o = 20'h0ED03;
				7'h2A: exp_max_o = 20'h0DFB5;
				7'h2B: exp_max_o = 20'h0D327;
				7'h2C: exp_max_o = 20'h0C74D;
				7'h2D: exp_max_o = 20'h0BC1D;
				7'h2E: exp_max_o = 20'h0B18F;
				7'h2F: exp_max_o = 20'h0A797;
				7'h30: exp_max_o = 20'h09E2F;
				7'h31: exp_max_o = 20'h0954F;
				7'h32: exp_max_o = 20'h08CED;
				7'h33: exp_max_o = 20'h08504;
				7'h34: exp_max_o = 20'h07D8D;
				7'h35: exp_max_o = 20'h07681;
				7'h36: exp_max_o = 20'h06FDB;
				7'h37: exp_max_o = 20'h06993;
				7'h38: exp_max_o = 20'h063A7;
				7'h39: exp_max_o = 20'h05E0F;
				7'h3A: exp_max_o = 20'h058C7;
				7'h3B: exp_max_o = 20'h053CC;
				7'h3C: exp_max_o = 20'h04F18;
				7'h3D: exp_max_o = 20'h04AA7;
				7'h3E: exp_max_o = 20'h04677;
				7'h3F: exp_max_o = 20'h04282;
				7'h40: exp_max_o = 20'h03EC7;
				7'h41: exp_max_o = 20'h03B41;
				7'h42: exp_max_o = 20'h037ED;
				7'h43: exp_max_o = 20'h034CA;
				7'h44: exp_max_o = 20'h031D3;
				7'h45: exp_max_o = 20'h02F07;
				7'h46: exp_max_o = 20'h02C64;
				7'h47: exp_max_o = 20'h029E6;
				7'h48: exp_max_o = 20'h0278C;
				7'h49: exp_max_o = 20'h02554;
				7'h4A: exp_max_o = 20'h0233B;
				7'h4B: exp_max_o = 20'h02141;
				7'h4C: exp_max_o = 20'h01F63;
				7'h4D: exp_max_o = 20'h01DA0;
				7'h4E: exp_max_o = 20'h01BF7;
				7'h4F: exp_max_o = 20'h01A65;
				7'h50: exp_max_o = 20'h018EA;
				7'h51: exp_max_o = 20'h01784;
				7'h52: exp_max_o = 20'h01632;
				7'h53: exp_max_o = 20'h014F3;
				7'h54: exp_max_o = 20'h013C6;
				7'h55: exp_max_o = 20'h012AA;
				7'h56: exp_max_o = 20'h0119E;
				7'h57: exp_max_o = 20'h010A1;
				7'h58: exp_max_o = 20'h00FB2;
				7'h59: exp_max_o = 20'h00ED0;
				7'h5A: exp_max_o = 20'h00DFB;
				7'h5B: exp_max_o = 20'h00D32;
				7'h5C: exp_max_o = 20'h00C75;
				7'h5D: exp_max_o = 20'h00BC2;
				7'h5E: exp_max_o = 20'h00B19;
				7'h5F: exp_max_o = 20'h00A79;
				7'h60: exp_max_o = 20'h009E3;
				7'h61: exp_max_o = 20'h00955;
				7'h62: exp_max_o = 20'h008CF;
				7'h63: exp_max_o = 20'h00850;
				7'h64: exp_max_o = 20'h007D9;
				7'h65: exp_max_o = 20'h00768;
				7'h66: exp_max_o = 20'h006FE;
				7'h67: exp_max_o = 20'h00699;
				7'h68: exp_max_o = 20'h0063A;
				7'h69: exp_max_o = 20'h005E1;
				7'h6A: exp_max_o = 20'h0058C;
				7'h6B: exp_max_o = 20'h0053D;
				7'h6C: exp_max_o = 20'h004F1;
				7'h6D: exp_max_o = 20'h004AA;
				7'h6E: exp_max_o = 20'h00467;
				7'h6F: exp_max_o = 20'h00428;
				7'h70: exp_max_o = 20'h003EC;
				7'h71: exp_max_o = 20'h003B4;
				7'h72: exp_max_o = 20'h0037F;
				7'h73: exp_max_o = 20'h0034D;
				7'h74: exp_max_o = 20'h0031D;
				7'h75: exp_max_o = 20'h002F0;
				7'h76: exp_max_o = 20'h002C6;
				7'h77: exp_max_o = 20'h0029E;
				7'h78: exp_max_o = 20'h00279;
				7'h79: exp_max_o = 20'h00255;
				7'h7A: exp_max_o = 20'h00234;
				7'h7B: exp_max_o = 20'h00214;
				7'h7C: exp_max_o = 20'h001F6;
				7'h7D: exp_max_o = 20'h001DA;
				7'h7E: exp_max_o = 20'h001BF;
				7'h7F: exp_max_o = 20'h001A6;
			endcase
			check_outputs(tb_max_o, exp_max_o);
		end

		$finish; 
	end

endmodule 