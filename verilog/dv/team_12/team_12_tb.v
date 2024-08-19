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

`timescale 1 ns / 1 ns

module team_12_tb;

	localparam CLK_PERIOD = 25;
	localparam SAMPLE_CLK_HALF_PERIOD = 100*227/2;
	localparam BAUD_PERIOD = CLK_PERIOD * 320;

	reg sample_clk;
	reg clock;
	wire clk2;
	reg RSTB;
	reg CSB;
	reg power1, power2;
	reg power3, power4;

	wire gpio;
	wire [37:0] mprj_io;
	wire [7:0] mprj_io_0;

	reg tb_serIn_reg;
	reg tb_wave_mode_pb_reg;
	reg tb_clear_reg;

	wire [15:0] tb_latch_output;

	reg finish_monitor;
	integer fd;
	integer volume;

	assign mprj_io_0 = mprj_io[7:0];
	// assign mprj_io_0 = {mprj_io[8:4],mprj_io[2:0]};

	assign mprj_io[0] = tb_serIn_reg;
	assign mprj_io[5] = tb_clear_reg; 
	assign mprj_io[6] = tb_wave_mode_pb_reg;  
	assign mprj_io[3] = (CSB == 1'b1) ? 1'b1 : 1'bz;
	// assign mprj_io[3] = 1'b1;

	// External clock is used by default.  Make this artificially fast for the
	// simulation.  Normally this would be a slow clock and the digital PLL
	// would be the fast clock.
	assign tb_latch_output = mprj_io[22:7];
	assign clk2 = clock;
	always #12.5 clock <= (clock === 1'b0);
	always #SAMPLE_CLK_HALF_PERIOD sample_clk <= (sample_clk === 1'b0);

	initial begin
		clock = 1'b0;
		sample_clk = 1'b0;
	end

	task press_mode(
		 integer presses
	);
	begin
		@(negedge clk2);

		for (integer j = 0; j < presses; j++) begin
			tb_wave_mode_pb_reg = 1'b1;
			@(negedge clk2);
			@(negedge clk2);
			tb_wave_mode_pb_reg = 1'b0;
			@(negedge clk2);
			@(negedge clk2);
		end
	end
	endtask

	task send_MIDI(
		input integer midi_byte);
	begin
		@(negedge clk2);

		#(BAUD_PERIOD);
		tb_serIn_reg = 0; // start bit
		for (integer i = 0; i < 8; i++) begin
			#(BAUD_PERIOD);
			tb_serIn_reg = midi_byte[i];
		end
		#(BAUD_PERIOD);
		tb_serIn_reg = 1; // stop bit

		@(posedge clk2);
	end
	endtask

	// `ifdef ENABLE_SDF
	// 	initial begin
	// 		$sdf_annotate("../../../sdf/user_proj_example.sdf", uut.mprj) ;
	// 		$sdf_annotate("../../../sdf/user_project_wrapper.sdf", uut.mprj.mprj) ;
	// 		$sdf_annotate("../../../mgmt_core_wrapper/sdf/DFFRAM.sdf", uut.soc.DFFRAM_0) ;
	// 		$sdf_annotate("../../../mgmt_core_wrapper/sdf/mgmt_core.sdf", uut.soc.core) ;
	// 		$sdf_annotate("../../../caravel/sdf/housekeeping.sdf", uut.housekeeping) ;
	// 		$sdf_annotate("../../../caravel/sdf/chip_io.sdf", uut.padframe) ;
	// 		$sdf_annotate("../../../caravel/sdf/mprj_logic_high.sdf", uut.mgmt_buffers.mprj_logic_high_inst) ;
	// 		$sdf_annotate("../../../caravel/sdf/mprj2_logic_high.sdf", uut.mgmt_buffers.mprj2_logic_high_inst) ;
	// 		$sdf_annotate("../../../caravel/sdf/mgmt_protect_hv.sdf", uut.mgmt_buffers.powergood_check) ;
	// 		$sdf_annotate("../../../caravel/sdf/mgmt_protect.sdf", uut.mgmt_buffers) ;
	// 		$sdf_annotate("../../../caravel/sdf/caravel_clocking.sdf", uut.clocking) ;
	// 		$sdf_annotate("../../../caravel/sdf/digital_pll.sdf", uut.pll) ;
	// 		$sdf_annotate("../../../caravel/sdf/xres_buf.sdf", uut.rstb_level) ;
	// 		$sdf_annotate("../../../caravel/sdf/user_id_programming.sdf", uut.user_id_value) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_bidir_1[0] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_bidir_1[1] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_bidir_2[0] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_bidir_2[1] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_bidir_2[2] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[0] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[1] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[2] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[3] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[4] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[5] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[6] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[7] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[8] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[9] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1[10] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1a[0] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1a[1] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1a[2] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1a[3] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1a[4] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_1a[5] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[0] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[1] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[2] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[3] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[4] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[5] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[6] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[7] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[8] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[9] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[10] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[11] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[12] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[13] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[14] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_control_block.sdf", uut.\gpio_control_in_2[15] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.\gpio_defaults_block_0[0] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.\gpio_defaults_block_0[1] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.\gpio_defaults_block_2[0] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.\gpio_defaults_block_2[1] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.\gpio_defaults_block_2[2] ) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_5) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_6) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_7) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_8) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_9) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_10) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_11) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_12) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_13) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_14) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_15) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_16) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_17) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_18) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_19) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_20) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_21) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_22) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_23) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_24) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_25) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_26) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_27) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_28) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_29) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_30) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_31) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_32) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_33) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_34) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_35) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_36) ;
	// 		$sdf_annotate("../../../caravel/sdf/gpio_defaults_block.sdf", uut.gpio_defaults_block_37) ;
	// 	end
	// `endif 

	always @(posedge sample_clk) begin
		if(!finish_monitor) begin
			$fwrite(fd, "%0d\n", tb_latch_output);
			// $fwrite(fd, "%0d,%0d\n", tb_latch_output, tb_test_num);
		end
	end

	initial begin
		$dumpfile("team_12.vcd");
		$dumpvars(0, team_12_tb);

		// Repeat cycles of 1000 clock edges as needed to complete testbench
		repeat (1000) begin
			repeat (2000) @(posedge clock);
			// $display("+1000 cycles");
		end
		$display("%c[1;31m",27);
		`ifdef GL
			$display ("Monitor: Timeout, Test Mega-Project IO Ports (GL) Failed");
		`else
			$display ("Monitor: Timeout, Test Mega-Project IO Ports (RTL) Failed");
		`endif
		$display("%c[0m",27);
		$finish;
	end

	initial begin
		fd = $fopen("latch_monitor.txt", "w");
		// while (!finish_monitor) begin
		// 	// #(SAMP_PERIOD);
		// 	$fdisplay(fd, tb_latch_output);
		// end
		if (finish_monitor) begin
			$fclose(fd);
			$finish;
		end
	end

	initial begin
		finish_monitor = 1'b0;
		tb_serIn_reg = 1'b1;
		tb_clear_reg = 1'b0;
		tb_wave_mode_pb_reg = 1'b0;

	    // Observe Output pins [18:7]
		wait(tb_latch_output == 16'h0000);

		#(14 * SAMPLE_CLK_HALF_PERIOD);
	
		press_mode(4);

		volume = 127;
		for(integer i = 108; i > 108- 75; i++) begin

			send_MIDI(144); // start note
			send_MIDI(i); // note C8
			send_MIDI(volume); // velocity 64
			// if(vol == 0) begin vol = 35 end;0
			#(SAMPLE_CLK_HALF_PERIOD * 20 * 2);
		end

		#(SAMPLE_CLK_HALF_PERIOD * 10000 * 2);

		`ifdef GL
	    	$display("Monitor: Test 1 Mega-Project IO (GL) Passed");
		`else
		    $display("Monitor: Test 1 Mega-Project IO (RTL) Passed");
		`endif
		finish_monitor = 1'b1;
	    $finish;
	end

	always @(tb_latch_output) begin
		if(tb_latch_output >= '0)
		#1 $display("Latch Output state = %b ", tb_latch_output);
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
		#200;
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
		.clock    (clk2),
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
		.FILENAME("team_12.hex")
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
