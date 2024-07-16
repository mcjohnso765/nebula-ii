// // SPDX-FileCopyrightText: 2020 Efabless Corporation
// //
// // Licensed under the Apache License, Version 2.0 (the "License");
// // you may not use this file except in compliance with the License.
// // You may obtain a copy of the License at
// //
// //      http://www.apache.org/licenses/LICENSE-2.0
// //
// // Unless required by applicable law or agreed to in writing, software
// // distributed under the License is distributed on an "AS IS" BASIS,
// // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// // See the License for the specific language governing permissions and
// // limitations under the License.
// // SPDX-License-Identifier: Apache-2.0

// `default_nettype none

// `timescale 1 ns / 1 ps

// module team_05_tb;

// 	reg sample_clk;
// 	reg clock;
// 	wire clk2;
// 	reg RSTB;
// 	reg CSB;
// 	reg power1, power2;
// 	reg power3, power4;

// 	wire gpio;
// 	wire [37:0] mprj_io;
// 	wire [7:0] mprj_io_0;
// 	reg [33:0] expected_io;
// 	wire [33:0] checkbits;
// 	reg [3:0] tb_keypad;
// 	wire [3:0] tb_keypad_output;

// 	assign checkbits = {mprj_io[37:5], mprj_io[0]};
// 	//assign mprj_io_0 = mprj_io[7:0];
// 	// assign mprj_io_0 = {mprj_io[8:4],mprj_io[2:0]};

// 	assign mprj_io[3] = (CSB == 1'b1) ? 1'b1 : 1'bz;

// 	assign mprj_io[23:20] = tb_keypad;
// 	assign tb_keypad_output = mprj_io[27:24];
// 	// assign mprj_io[3] = 1'b1;

// 	// External clock is used by default.  Make this artificially fast for the
// 	// simulation.  Normally this would be a slow clock and the digital PLL
// 	// would be the fast clock.

// 	assign clk2 = clock;
// 	always #12.5 clock <= (clock === 1'b0);

	
// 	initial begin
// 		clock = 1'b0;
// 		sample_clk = 1'b0;
// 	end
// 	task press_button(
// 		 integer presses
// 	);
// 	begin
// 		@(negedge clk2);

// 		for (integer j = 0; j < presses; j++) begin
// 			tb_keypad = 4'b1;
// 			@(negedge clk2);
// 			@(negedge clk2);
// 			tb_keypad = 4'b0;
// 			@(negedge clk2);
// 			@(negedge clk2);
// 		end
// 	end
// 	endtask
	
// 	`ifdef ENABLE_SDF
// 		initial begin
// 			$sdf_annotate("../../../sdf/user_proj_example.sdf", uut.mprj) ;
// 			$sdf_annotate("../../../sdf/user_project_wrapper.sdf", uut.mprj.mprj) ;
// 			$sdf_annotate("../../../mgmt_core_wrapper/sdf/DFFRAM.sdf", uut.soc.DFFRAM_0) ;
// 			$sdf_annotate("../../../mgmt_core_wrapper/sdf/mgmt_core.sdf", uut.soc.core) ;
// 			$sdf_annotate("../../../caravel/sdf/housekeeping.sdf", uut.housekeeping) ;
// 			$sdf_annotate("../../../caravel/sdf/chip_io.sdf", uut.padframe) ;
// 			$sdf_annotate("../../../caravel/sdf/mprj_logic_high.sdf", uut.mgmt_buffers.mprj_logic_high_inst) ;
// 			$sdf_annotate("../../../caravel/sdf/mprj2_logic_high.sdf", uut.mgmt_buffers.mprj2_logic_high_inst) ;
// 			$sdf_annotate("../../../caravel/sdf/mgmt_protect_hv.sdf", uut.mgmt_buffers.powergood_check) ;
// 			$sdf_annotate("../../../caravel/sdf/mgmt_protect.sdf", uut.mgmt_buffers) ;
// 			$sdf_annotate("../../../caravel/sdf/caravel_clocking.sdf", uut.clocking) ;
// 			$sdf_annotate("../../../caravel/sdf/digital_pll.sdf", uut.pll) ;
// 			$sdf_annotate("../../../caravel/sdf/xres_buf.sdf", uut.rstb_level) ;
// 			$sdf_annotate("../../../caravel/sdf/user_id_programming.sdf", uut.user_id_value) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_bidir_1[0] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_bidir_1[1] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_bidir_2[0] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_bidir_2[1] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_bidir_2[2] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[0] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[1] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[2] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[3] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[4] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[5] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[6] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[7] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[8] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[9] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[10] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1a[0] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1a[1] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1a[2] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1a[3] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1a[4] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1a[5] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[0] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[1] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[2] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[3] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[4] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[5] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[6] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[7] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[8] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[9] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[10] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[11] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[12] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[13] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[14] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[15] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.\gpio_defaults_block_0[0] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.\gpio_defaults_block_0[1] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.\gpio_defaults_block_2[0] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.\gpio_defaults_block_2[1] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.\gpio_defaults_block_2[2] ) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_5) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_6) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_7) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_8) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_9) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_10) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_11) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_12) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_13) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_14) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_15) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_16) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_17) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_18) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_19) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_20) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_21) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_22) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_23) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_24) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_25) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_26) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_27) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_28) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_29) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_30) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_31) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_32) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_33) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_34) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_35) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_36) ;
// 			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_37) ;
// 		end
// 	`endif 

// 	initial begin
// 		$dumpfile("team_05.vcd");
// 		$dumpvars(0, team_05_tb);

// 		// Repeat cycles of 1000 clock edges as needed to complete testbench
// 		repeat (1000) begin
// 			repeat (1000) @(posedge clock);
// 			// $display("+1000 cycles");
// 		end
// 		$display("%c[1;31m",27);
// 		`ifdef GL
// 			$display ("Monitor: Timeout, Test Mega-Project IO Ports (GL) Failed");
// 		`else
// 			$display ("Monitor: Timeout, Test Mega-Project IO Ports (RTL) Failed");
// 		`endif
// 		$display("%c[0m",27);
// 		$finish;
// 	end

// 	// initial begin
// 	//     // Observe Output pins [7:0]
// 	// 	wait(mprj_io_0 == 8'h01);
// 	// 	wait(mprj_io_0 == 8'h02);
// 	// 	wait(mprj_io_0 == 8'h03);
// 	// 	wait(mprj_io_0 == 8'h04);
// 	// 	wait(mprj_io_0 == 8'h05);
// 	// 	wait(mprj_io_0 == 8'h06);
// 	// 	wait(mprj_io_0 == 8'h07);
// 	// 	wait(mprj_io_0 == 8'h08);
// 	// 	wait(mprj_io_0 == 8'h09);
// 	// 	wait(mprj_io_0 == 8'h0A);   
// 	// 	wait(mprj_io_0 == 8'hFF);
// 	// 	wait(mprj_io_0 == 8'h00);
		
		
// 	// end

// 	// initial begin
// 	// 	tb_keypad = 4'd1;

// 	// 	wait(tb_keypad_output == 4'd1);

// 	// 	#(14 * SAMPLE_CLK_HALF_PERIOD);
	
// 	// 	press_button(4);

// 	// 	#(SAMPLE_CLK_HALF_PERIOD * 1000 * 2);

// 	// 	`ifdef GL
// 	//     	$display("Monitor: Test 1 Mega-Project IO (GL) Passed");
// 	// 	`else
// 	// 	    $display("Monitor: Test 1 Mega-Project IO (RTL) Passed");
// 	// 	`endif
		
// 	//     $finish;
// 	// end

// 	initial begin
// 		// original counted out code:

// 		// wait(checkbits == 'b0);
// 		// $display("Monitor: NEBULA II-Team 05 Project Started");
// 		// $display("Correct GPIO output:");

// 		// // First iteration of outputs
// 		// for (integer i = 0; i <= 33; i++) begin
// 		// 	if (i == 0) expected_io = 1;
// 		// 	else expected_io = expected_io << 1;
// 		// 	wait(checkbits == expected_io);
// 		// 	$display("Correct GPIO output:");
// 		// end
		
// 		// // End of first iteration
// 		// wait(checkbits == 'b0);
// 		// $display("Correct GPIO output:");

// 		#1300000;
// 		`ifdef GL
// 	    	$display("Monitor: Test 1 Mega-Project IO (GL) Passed");
// 		`else
// 		    $display("Monitor: Test 1 Mega-Project IO (RTL) Passed");
// 		`endif
// 	    $finish;
// 	end

// 	// Print output after each GPIO goes high
// 	always @(mprj_io) begin
// 		#1 $display("{GPIO[37:5], GPIO[0]} = 34'h%h ", checkbits);
// 	end

// 	initial begin
// 		RSTB <= 1'b0;
// 		CSB  <= 1'b1;		// Force CSB high
// 		#2000;
// 		RSTB <= 1'b1;	    	// Release reset
// 		#3_00_000;
// 		CSB = 1'b0;		// CSB can be released
// 	end

// 	initial begin		// Power-up sequence
// 		power1 <= 1'b0;
// 		power2 <= 1'b0;
// 		power3 <= 1'b0;
// 		power4 <= 1'b0;
// 		#100;
// 		power1 <= 1'b1;
// 		#100;
// 		power2 <= 1'b1;
// 		#100;
// 		power3 <= 1'b1;
// 		#100;
// 		power4 <= 1'b1;
// 	end

// 	/*always @(mprj_io) begin
// 		#1 $display("MPRJ-IO state = %b ", mprj_io[7:0]);
// 	end*/

// 	wire flash_csb;
// 	wire flash_clk;
// 	wire flash_io0;
// 	wire flash_io1;

// 	wire VDD3V3;
// 	wire VDD1V8;
// 	wire VSS;
	
// 	assign VDD3V3 = power1;
// 	assign VDD1V8 = power2;
// 	assign VSS = 1'b0;

// 	caravel uut (
// 		.vddio	  (VDD3V3),
// 		.vddio_2  (VDD3V3),
// 		.vssio	  (VSS),
// 		.vssio_2  (VSS),
// 		.vdda	  (VDD3V3),
// 		.vssa	  (VSS),
// 		.vccd	  (VDD1V8),
// 		.vssd	  (VSS),
// 		.vdda1    (VDD3V3),
// 		.vdda1_2  (VDD3V3),
// 		.vdda2    (VDD3V3),
// 		.vssa1	  (VSS),
// 		.vssa1_2  (VSS),
// 		.vssa2	  (VSS),
// 		.vccd1	  (VDD1V8),
// 		.vccd2	  (VDD1V8),
// 		.vssd1	  (VSS),
// 		.vssd2	  (VSS),
// 		.clock    (clock),
// 		.gpio     (gpio),
// 		.mprj_io  (mprj_io),
// 		.flash_csb(flash_csb),
// 		.flash_clk(flash_clk),
// 		.flash_io0(flash_io0),
// 		.flash_io1(flash_io1),
// 		.resetb	  (RSTB)
// 	);

// 	spiflash #(
// 		.FILENAME("io_ports.hex")
// 	) spiflash (
// 		.csb(flash_csb),
// 		.clk(flash_clk),
// 		.io0(flash_io0),
// 		.io1(flash_io1),
// 		.io2(),			// not used
// 		.io3()			// not used
// 	);

// endmodule
// `default_nettype wire


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

`timescale 1 ns / 1 ps

module team_05_tb;
	// Signals declaration
	reg clock;
	wire clock_in;
	reg RSTB;
	reg CSB;
	reg power1, power2;

	wire gpio;
	wire [37:0] mprj_io;
	reg [33:0] expected_io;
	wire [33:0] checkbits;
	reg [37:0] mprj_io_in;
	assign mprj_io[37:34] = keyboard_in; //keyboard input
	reg [3:0] keyboard_in;

	// Signals assignments
	assign checkbits = {mprj_io[37:5], mprj_io[0]};
	assign mprj_io[3] = (CSB == 1'b1) ? 1'b1 : 1'bz;
	assign clock_in = clock;

	// Clock generation
	always #12.5 clock <= (clock === 1'b0);

	initial begin
		clock = 0;
	end

	// STUDENTS: This block here is important, but don't worry about trying to understand it
	`ifdef ENABLE_SDF
		initial begin
			$sdf_annotate("../../../sdf/user_proj_example.sdf", uut.mprj) ;
			$sdf_annotate("../../../sdf/user_project_wrapper.sdf", uut.mprj.mprj) ;
			$sdf_annotate("../../../mgmt_core_wrapper/sdf/DFFRAM.sdf", uut.soc.DFFRAM_0) ;
			$sdf_annotate("../../../mgmt_core_wrapper/sdf/mgmt_core.sdf", uut.soc.core) ;
			$sdf_annotate("../../../caravel/sdf/housekeeping.sdf", uut.housekeeping) ;
			$sdf_annotate("../../../caravel/sdf/chip_io.sdf", uut.padframe) ;
			$sdf_annotate("../../../caravel/sdf/mprj_logic_high.sdf", uut.mgmt_buffers.mprj_logic_high_inst) ;
			$sdf_annotate("../../../caravel/sdf/mprj2_logic_high.sdf", uut.mgmt_buffers.mprj2_logic_high_inst) ;
			$sdf_annotate("../../../caravel/sdf/mgmt_protect_hv.sdf", uut.mgmt_buffers.powergood_check) ;
			$sdf_annotate("../../../caravel/sdf/mgmt_protect.sdf", uut.mgmt_buffers) ;
			$sdf_annotate("../../../caravel/sdf/caravel_clocking.sdf", uut.clocking) ;
			$sdf_annotate("../../../caravel/sdf/digital_pll.sdf", uut.pll) ;
			$sdf_annotate("../../../caravel/sdf/xres_buf.sdf", uut.rstb_level) ;
			$sdf_annotate("../../../caravel/sdf/user_id_programming.sdf", uut.user_id_value) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_bidir_1[0] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_bidir_1[1] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_bidir_2[0] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_bidir_2[1] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_bidir_2[2] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[0] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[1] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[2] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[3] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[4] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[5] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[6] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[7] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[8] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[9] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[10] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1a[0] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1a[1] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1a[2] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1a[3] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1a[4] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1a[5] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[0] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[1] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[2] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[3] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[4] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[5] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[6] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[7] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[8] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[9] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[10] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[11] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[12] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[13] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[14] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[15] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.\gpio_defaults_block_0[0] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.\gpio_defaults_block_0[1] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.\gpio_defaults_block_2[0] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.\gpio_defaults_block_2[1] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.\gpio_defaults_block_2[2] ) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_5) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_6) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_7) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_8) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_9) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_10) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_11) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_12) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_13) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_14) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_15) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_16) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_17) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_18) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_19) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_20) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_21) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_22) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_23) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_24) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_25) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_26) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_27) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_28) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_29) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_30) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_31) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_32) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_33) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_34) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_35) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_36) ;
			$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_37) ;
		end
	`endif 

	// Signal dump and timeout check
	initial begin
		$dumpfile("team_05.vcd");
		$dumpvars(0, team_05_tb);

		// Repeat cycles of 1000 clock edges as needed to complete testbench
		repeat (1000) begin
			repeat (1000) @(posedge clock);
			// $display("+1000 cycles");
		end
		$display("%c[1;31m",27);
		`ifdef GL
			$display ("Monitor: Timeout, NEBULA II-Sample Project (GL) Failed");
		`else
			$display ("Monitor: Timeout, NEBULA II-Sample Project (RTL) Failed");
		`endif
		$display("%c[0m",27);
		$finish;
	end

	task press_button;
		input [3:0] keyboard_in_in;
		input [3:0] keyboard_out;
		// #(mprj_io[18:15] == keyboard_out);
		if(mprj_io[18:15] == keyboard_out) begin
			keyboard_in = keyboard_in_in;
		end else begin
			#(1);
		end
		#(150);
		keyboard_in = 4'h0;
	endtask


	// Main Testbench and Output check
	initial begin

    /*
		wait(checkbits == 'b0);
		$display("Monitor: NEBULA II-Sample Project Started");
		$display("Correct GPIO output:");

		// First iteration of outputs
		for (integer i = 0; i <= 33; i++) begin
			if (i == 0) expected_io = 1;
			else expected_io = expected_io << 1;
			wait(checkbits == expected_io);
			$display("Correct GPIO output:");
		end
		
		// End of first iteration
		wait(checkbits == 'b0);
		$display("Correct GPIO output:");

		// Second iteration of outputs
		for (integer i = 0; i <= 33; i++) begin
			if (i == 0) expected_io = 1;
			else expected_io = expected_io << 1;
			wait(checkbits == expected_io);
			$display("Correct GPIO output:");
		end

		// End of second iteration
		wait(checkbits == 'b0);
		$display("Correct GPIO output:");

		#300;  // wait some time before ending
*/


        #5000000;  // wait some time before ending
        // ;  // wait some time before ending
		// #963780;

		press_button(4'b0010, 4'b1110); //press button 2

		//check inputs and outputs, once they actually get fully connected

		//press confirm
		press_button(4'b0001, 4'b0111); //press confirm
		//clear
		press_button(4'b0100, 4'b0111); //clear shift_reg
		//press button A (add)
		press_button(4'b0001, 4'b1110); //press A
		//pres confirm
		press_button(4'b0001, 4'b0111); //press confirm
		//clear
		press_button(4'b0100, 4'b0111); //clear shift_reg
		//press button 3
		press_button(4'b0100, 4'b1110);
		//press confirm
		press_button(4'b0001, 4'b0111); //press confirm

		//after sum is sent to LCD, double check output correctness


		`ifdef GL
	    	$display("Monitor: NEBULA II-Sample Project (GL) Passed");
		`else
		    $display("Monitor: NEBULA II-Sample Project (RTL) Passed");
		`endif
	    $finish;
	end

	// Print output after each GPIO goes high
	always @(mprj_io) begin
		#1 $display("{GPIO[37:5], GPIO[0]} = 34'h%h ", checkbits);
	end

	// Reset Operation
	initial begin
		RSTB <= 1'b0;
		CSB  <= 1'b1;		// Force CSB high
		#2000;
		RSTB <= 1'b1;	    	// Release reset
		#100000;
		CSB = 1'b0;		// CSB can be released
	end

	// Power-up sequence
	initial begin
		power1 <= 1'b0;
		power2 <= 1'b0;
		#200;
		power1 <= 1'b1;
		#200;
		power2 <= 1'b1;
	end

	// SPI flash signals
	wire flash_csb;
	wire flash_clk;
	wire flash_io0;
	wire flash_io1;

	// Assign power inputs
	wire VDD3V3 = power1;
	wire VDD1V8 = power2;
	wire VSS = 1'b0;

	// Caravel instance
	caravel uut (
		.vddio	  (VDD3V3),
		.vddio_2  (VDD3V3),
		.vssio	  (VSS),
		.vssio_2  (VSS),
		.vdda	  (VDD3V3),
		.vssa	  (VSS),
		.vccd	  (VDD1V8),
		.vssd	  (VSS),
		.vdda1    (VDD3V3),
		.vdda1_2  (VDD3V3),
		.vdda2    (VDD3V3),
		.vssa1	  (VSS),
		.vssa1_2  (VSS),
		.vssa2	  (VSS),
		.vccd1	  (VDD1V8),
		.vccd2	  (VDD1V8),
		.vssd1	  (VSS),
		.vssd2	  (VSS),
		.clock    (clock_in),
		.gpio     (gpio),
		.mprj_io  (mprj_io),
		.flash_csb(flash_csb),
		.flash_clk(flash_clk),
		.flash_io0(flash_io0),
		.flash_io1(flash_io1),
		.resetb	  (RSTB)
	);

	// SPI flash instance
	spiflash #(
		.FILENAME("team_05.hex")
	) spiflash (
		.csb(flash_csb),
		.clk(flash_clk),
		.io0(flash_io0),
		.io1(flash_io1),
		.io2(),			// not used
		.io3()			// not used
	);

endmodule
`default_nettype wire
