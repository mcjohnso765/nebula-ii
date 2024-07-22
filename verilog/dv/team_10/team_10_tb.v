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

module team_10_tb;
	reg clock;
	wire tb_clk;

	reg RSTB;
	reg CSB;
	reg power1, power2;
	reg power3, power4;

	wire gpio;
	wire [37:0] mprj_io;
	wire [33:0] checkbits;

	assign checkbits = {mprj_io[37:5], mprj_io[0]};

	assign mprj_io[3] = (CSB == 1'b1) ? 1'b1 : 1'bz;
	// assign mprj_io[3] = 1'b1;

	// reg tb_mode;
	// reg [3:0] read_row;
	// assign mprj_io[37] = tb_mode;
	// assign mprj_io[28:25] = read_row;

	// External clock is used by default.  Make this artificially fast for the
	// simulation.  Normally this would be a slow clock and the digital PLL
	// would be the fast clock.
	assign tb_clk = clock;
	always #12.5 clock <= (clock === 1'b0);

	// initial begin
	// 	clock = 0;

	// 	tb_mode = 1'b1;
	// 	@(negedge clock);
	// 	read_row = 4'b1000;
	// 	@(negedge clock);

	// end

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
	//logic [3:0]tb_readrow;
	initial begin
		$dumpfile("team_10.vcd");
		$dumpvars(0, team_10_tb);

		// Repeat cycles of 1000 clock edges as needed to complete testbench
		repeat (5000000) begin //from 100
			repeat (1000) @(posedge clock);
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

	// initial begin
	//     // Observe Output pins [7:0]
	// 	wait(mprj_io_0 == 8'h01);
	// 	wait(mprj_io_0 == 8'h02);
	// 	wait(mprj_io_0 == 8'h03);
	// 	wait(mprj_io_0 == 8'h04);
	// 	wait(mprj_io_0 == 8'h05);
	// 	wait(mprj_io_0 == 8'h06);
	// 	wait(mprj_io_0 == 8'h07);
	// 	wait(mprj_io_0 == 8'h08);
	// 	wait(mprj_io_0 == 8'h09);
	// 	wait(mprj_io_0 == 8'h0A);   
	// 	wait(mprj_io_0 == 8'hFF);
	// 	wait(mprj_io_0 == 8'h00);
		
	// 	`ifdef GL
	//     	$display("Monitor: Test 1 Mega-Project IO (GL) Passed");
	// 	`else
	// 	    $display("Monitor: Test 1 Mega-Project IO (RTL) Passed");
	// 	`endif
	//     $finish;
	// end

	initial begin
		RSTB <= 1'b0;
		CSB  <= 1'b1;		// Force CSB high
		#2000;
		RSTB <= 1'b1;	    	// Release reset
		#2000;
		CSB = 1'b0;		// CSB can be released
	end

	initial begin		// Power-up sequence
		power1 <= 1'b0;
		power2 <= 1'b0;
		power3 <= 1'b0;
		power4 <= 1'b0;
		#100;
		power1 <= 1'b1;
		#100;
		power2 <= 1'b1;
		#100;
		power3 <= 1'b1;
		#100;
		power4 <= 1'b1;
	end

	always @(mprj_io) begin
		#1 $display("{GPIO[37:5], GPIO[0]} = 34'h%h ", checkbits);
	end

	wire flash_csb;
	wire flash_clk;
	wire flash_io0;
	wire flash_io1;

	wire VDD3V3;
	wire VDD1V8;
	wire VSS;
	
	assign VDD3V3 = power1;
	assign VDD1V8 = power2;
	assign VSS = 1'b0;

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
		.clock    (clock),
		.gpio     (gpio),
		.mprj_io  (mprj_io),
		.flash_csb(flash_csb),
		.flash_clk(flash_clk),
		.flash_io0(flash_io0),
		.flash_io1(flash_io1),
		.resetb	  (RSTB)
	);

	spiflash #(
		.FILENAME("team_10.hex")
	) spiflash (
		.csb(flash_csb),
		.clk(flash_clk),
		.io0(flash_io0),
		.io1(flash_io1),
		.io2(),			// not used
		.io3()			// not used
	);

	// initial begin 
	// 	mprj_io[37] = 1'b1;



	// end

// Testbench ports
//localparam CLK_PERIOD = 100; // 100 Hz clk
//logic tb_nRst, 
reg tb_role_switch, tb_role_switch1, tb_red, tb_green, tb_blue, tb_error; // Input
reg tb_msg_sent;
reg [3:0] tb_scan_col;
reg [7:0] lcd_data; // Final output
reg [127:0] tb_play_row1, tb_play_row2, tb_host_row1, tb_host_row2;
reg [3:0] tb_input_row, tb_input_row1;

//assign RSTB = tb_nRst;

assign mprj_io[37] = tb_role_switch;
assign mprj_io[22] = tb_red;
assign mprj_io[21] = tb_green;
assign mprj_io[20] = tb_blue;
assign mprj_io[23] = tb_error;

//assign mprj_io[??] = tb_msg_sent;

assign mprj_io[28:25] = tb_input_row;

//assign mprj_io[36:33] = tb_scan_col;
//assign mprj_io[17:10] = lcd_data;

assign mprj_io[0] = 1'b0;
assign mprj_io[9:5] = 5'b0;
assign mprj_io[19:18] = 2'b0;
assign mprj_io[24] = mprj_io[29]; //rx to tx
//assign tb_role_switch = 1'b0;
//assign tb_input_row = 4'b0;
//assign tb_input_row = 4'b1000;

//assign tb_input_row1 = tb_input_row;

integer tb_test_num;

// Portmap
//main main0 (.clk(tb_clk), .nRst(tb_nRst), .role_switch(tb_role_switch), .red(tb_red), .green(tb_green), .blue(tb_blue), .error(tb_error), .play_row1(tb_play_row1), .play_row2(tb_play_row2), .host_row1(tb_host_row1), .host_row2(tb_host_row2), .input_row_player(tb_input_row), .input_row_host(tb_input_row), .msg_sent(tb_msg_sent));

initial begin 

	wait(uut.mprj.mprj.team_10_Wrapper.team_10_WB.instance_to_wrap.\en == 1);
	@(negedge clock);

	//tb_input_row1= tb_input_row;
	//tb_role_switch = tb_role_switch1;
tb_role_switch = 1'b0;
// tb_input_row = 4'b0000;
// 	#(30000000);
// 	tb_input_row = 4'b1000;
	

// 	#(300000);
	
				
    // ***********************************
    // Test Case 3: Host Side: Setting the word  MOORE 
    // ***********************************

    tb_test_num += 1;
    // // //game end
    // tb_input_row = 4'b0;

    //#(100000);

    // @(negedge tb_clk);
    // tb_input_row = 4'd0;
    // #(600000);
    // press A
    tb_input_row = 4'b1000; // R0 C1 -> 'A'

    #(10000000);

    @(negedge tb_clk);
    tb_input_row = 4'd0;

    @(posedge tb_clk);
    #(30000000); // R3 C0 (submit_letter_key)
    tb_input_row = 4'b0001;

    #(10000000);

    @(negedge tb_clk);
    tb_input_row = 4'd0;
    #(20000000);

    // START E

    tb_input_row = 4'b1000; //for E
    #(10000000);

    @(negedge tb_clk);
    tb_input_row = 4'd0;

    #(40000000);
    tb_input_row = 4'b1000; // 'E'
    #(100000);

    @(negedge tb_clk);
    tb_input_row = 4'd0;

    @(posedge tb_clk);
    #(20000000); // R3 C0 (submit_letter_key)
    tb_input_row = 4'b0001;

    #(10000000);

    @(negedge tb_clk);
    tb_input_row = 4'd0;
    #(50000000);

    // PRESS A

    tb_input_row = 4'b1000; // R0 C1 -> 'A'

    #(10000000);

    @(negedge tb_clk);
    tb_input_row = 4'd0;

    @(posedge tb_clk);
    #(30000000); // R3 C0 (submit_letter_key)
    tb_input_row = 4'b0001;

    #(10000000);

    @(negedge tb_clk);
    tb_input_row = 4'd0;
     #(10000000);

    // PRESS I
    #(30000000);
    tb_input_row = 4'b0100; // R1 C1 -> 'I'
    #(10000000);

    @(negedge tb_clk);
    tb_input_row = 4'd0;

    #(40000000);
    tb_input_row = 4'b0100; // R1 C1 -> 'I'
    #(10000000);

    @(negedge tb_clk);
    tb_input_row = 4'd0;

     #(40000000);
    tb_input_row = 4'b0100; // R1 C1 -> 'I'
    #(10000000);

    @(negedge tb_clk);
    tb_input_row = 4'd0;

     @(posedge tb_clk);
    #(50000000); // R3 C0 (clear_letter_key)
    tb_input_row = 4'b0001;

    #(10000000);

    @(negedge tb_clk);
    tb_input_row = 4'd0;
    #(30000000);

    // PRESS R

     tb_input_row = 4'b0010; // 'R'
    #(10000000);

    @(negedge tb_clk);
    tb_input_row = 4'd0;

    #(40000000);
    tb_input_row = 4'b0010; // 'R'
    #(10000000);

    @(negedge tb_clk);
    tb_input_row = 4'd0;

     #(40000000);
    tb_input_row = 4'b0010; // 'R'
    #(10000000);

    @(negedge tb_clk);
    tb_input_row = 4'd0;

     @(posedge tb_clk);
    #(40000000); // R3 C0 (submit_letter_key)
    tb_input_row = 4'b0001;

    #(10000000);

    @(negedge tb_clk);
    tb_input_row = 4'd0;
    #(10000000);

    // PRESS T

    tb_input_row = 4'b0010; // 'T'
    #(1000000);

    @(negedge tb_clk);
    tb_input_row = 4'd0;

     @(posedge tb_clk);
    #(30000000); // R3 C0 (submit_letter_key)
    tb_input_row = 4'b0001;

    #(10000000);

    @(negedge tb_clk);
    tb_input_row = 4'd0;
    #(40000000);

    //PRESS H


    tb_input_row = 4'b0100; //H 
    #(10000000);

    @(negedge tb_clk);
    tb_input_row = 4'd0;
     #(40000000);
    tb_input_row = 4'b0100; // R1 C1 -> 'H'
    #(10000000);

    @(negedge tb_clk);
    tb_input_row = 4'd0;

     @(posedge tb_clk);
    #(40000000); // R3 C0 (submit_letter_key)
    tb_input_row = 4'b0001;

    #(10000000);

    @(negedge tb_clk);
    tb_input_row = 4'd0;
    #(60000000);

    tb_input_row = 4'b0001; // (submit word key)
    #(10000000);
    @(negedge tb_clk);
    tb_input_row = 4'd0;
    #(30000000);


	$finish;

	end 


/*
//      // ***********************************
//     // Test Case 4: Player Side: losing ;-;
//     // ***********************************

//     tb_test_num += 1;
//     tb_input_row = 4'd0;
//     tb_input_row = 4'd0;
//     tb_role_switch = 1;

//     #(10000);

//     tb_input_row = 4'b0010; // R2 C0 -> 'P'

//     #(100000);

//     @(negedge tb_clk);
//     tb_input_row = 4'd0;

//     #(400000);

//     @(posedge tb_clk);
//     tb_input_row = 4'b0001;  // R3 C0 (submit_letter_key)

//     #(100000);

//     @(negedge tb_clk);
//     tb_input_row = 4'd0;
//     #(200000);
// //initial begin 

//      tb_input_row = 4'b1000; // R2 C0 -> 'D'

//     #(100000);

//     @(negedge tb_clk);
//     tb_input_row = 4'd0;

//     @(posedge tb_clk);
//     #(600000); // R3 C0 (submit_letter_key)
//     tb_input_row = 4'b0001;

//     #(100000);

//     @(negedge tb_clk);
//     tb_input_row = 4'd0;
//     #(100000);

//     tb_input_row = 4'b1000; //for B
//     #(100000);

//     @(negedge tb_clk);
//     tb_input_row = 4'd0;

//     #(400000);
//     tb_input_row = 4'b1000; // 'B'
//     #(100000);

//     @(negedge tb_clk);
//     tb_input_row = 4'd0;

//     @(posedge tb_clk);
//     #(300000); // R3 C0 (submit_letter_key)
//     tb_input_row = 4'b0001;

//     #(100000);

//     @(negedge tb_clk);
//     tb_input_row = 4'd0;
//     #(500000);

//     tb_input_row = 4'b0100; // R0 C1 -> 'J'

//     #(100000);

//     @(negedge tb_clk);
//     tb_input_row = 4'd0;

//     @(posedge tb_clk);
//     #(300000); // R3 C0 (submit_letter_key)
//     tb_input_row = 4'b0001;

//     #(100000);

//     @(negedge tb_clk);
//     tb_input_row = 4'd0;
//      #(200000);

//      tb_input_row = 4'b0100; // R0 C1 -> 'M'

//     #(100000);

//     @(negedge tb_clk);
//     tb_input_row = 4'd0;

//     @(posedge tb_clk);
//     #(200000); // R3 C0 (submit_letter_key)
//     tb_input_row = 4'b0001;

//     #(100000);

//     @(negedge tb_clk);
//     tb_input_row = 4'd0;
//      #(200000);

//      tb_input_row = 4'b0010; // R0 C1 -> 'W'

//     #(100000);

//     @(negedge tb_clk);
//     tb_input_row = 4'd0;

//     @(posedge tb_clk);
//     #(200000); // R3 C0 (submit_letter_key)
//     tb_input_row = 4'b0001;

//     #(100000);

//     @(negedge tb_clk);
//     tb_input_row = 4'd0;
//      #(300000);

    $finish;
end*/

endmodule
//`default_nettype wire