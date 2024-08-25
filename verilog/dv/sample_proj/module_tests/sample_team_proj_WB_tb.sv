// $Id: $
// File name:   sample_team_proj_WB_tb.sv
// Created:     6/18/2024
// Author:      Miguel Isrrael Teran
// Description: Test bench for Sample Team Project Wishbone Wrapper

`timescale 1ns / 1ps

`define WB_AW 16

module sample_team_proj_WB_tb;
	// Define parameters
    parameter CLK_PERIOD = 100;  // Clock period is 100 ns

    // DUT inputs and outputs
    `TB_WB_SIG
	reg clk_i;
	reg rst_i;
	reg [127:0] la_data_in;
    reg [127:0] la_oenb;
    reg [33:0] gpio_in;
	wire [127:0] la_data_out;
    wire [33:0] gpio_out;
    wire [33:0] gpio_oeb;

	// Address Offset Parameters
	localparam	EN_VAL_REG_OFFSET = `WB_AW'h0000;
	localparam	PRESCALER_VAL_REG_OFFSET = `WB_AW'h0004;
	localparam	IM_REG_OFFSET = `WB_AW'hFF00;
	localparam	MIS_REG_OFFSET = `WB_AW'hFF04;
	localparam	RIS_REG_OFFSET = `WB_AW'hFF08;
	localparam	IC_REG_OFFSET = `WB_AW'hFF0C;

	// Test bench signals
	integer tb_test_case_num;
    integer tb_sub_checks;
    integer tb_total_checks;
    integer tb_passed;
    integer i;
	logic [33:0] tb_expected_gpio;
	logic [31:0] tb_expected_data;

	// Clock generation block
	always begin
        clk_i = 1'b0;
        #(CLK_PERIOD / 2.0);
        clk_i = 1'b1;
        #(CLK_PERIOD / 2.0);
    end

    // Signal Dump
    initial begin
        $dumpfile ("sample_team_proj_WB.vcd");
        $dumpvars(0, sample_team_proj_WB_tb);
    end

	// DUT Instance
	sample_team_proj_WB DUT (
		`TB_WB_SLAVE_CONN,
		.la_data_in(la_data_in),
        .la_data_out(la_data_out),
        .la_oenb(la_oenb),
        .gpio_in(gpio_in),
        .gpio_out(gpio_out),
        .gpio_oeb(gpio_oeb)
	);

	// Reset DUT Task
    task reset_dut;
    begin
        // Activate the reset
        rst_i = 1'b1;

        // Maintain the reset for more than one cycle
        @(posedge clk_i);
        @(posedge clk_i);

        // Wait until safely away from rising edge of the clock before releasing
        @(negedge clk_i);
        rst_i = 1'b0;

        // Leave out of reset for a couple cycles before allowing other stimulus
        // Wait for negative clock edges, 
        // since inputs to DUT should normally be applied away from rising clock edges
        @(negedge clk_i);
        @(negedge clk_i);
    end
    endtask

	// WB Write Task
	task WB_W_WRITE(input [31:0] addr, input [31:0] data);
    begin : task_body
        @(posedge clk_i);
        #1;
        cyc_i   = 1;
        stb_i   = 1;
        we_i    = 1;
        adr_i   = addr;
        dat_i   = data;
        sel_i   = 4'hF;
        wait (ack_o == 1);
        @(posedge clk_i);
        cyc_i   = 0;
        stb_i   = 0;
    end
	endtask

	// WB Read Task
	task WB_W_READ(input [31:0] addr, output [31:0] data);
    begin : task_body
        @(posedge clk_i);
        #1;
        cyc_i   = 1;
        stb_i   = 1;
        we_i    = 0;
        adr_i   = addr;
        dat_i   = 0;
        sel_i   = 4'hF;
        wait (ack_o == 1);
        #1;
        data    = dat_o;
        @(posedge clk_i);
        cyc_i   = 0;
        stb_i   = 0;
    end
	endtask

	// Acknowledge Interrupt Block
	always @(IRQ) begin
		if (IRQ == 1'b1) 
			@(negedge clk_i) ack_irq(IC_REG_OFFSET);
	end
	
	// Task that acknowledges interrupt
	task ack_irq(input [15:0] ic_offset);
		la_data_in[1] = 1'b1;
		WB_W_WRITE({16'b0, ic_offset}, 1); // acknowledge interrupt
	endtask

	// Task to check outputs
	task check_outputs (
        input logic [33:0] expected_gpio,
        input logic expected_irq
    );
    begin
        logic gpio_correct;
        logic done_correct;
        // NOTE: Make sure you check away from the positive edge!!!
        gpio_correct = 1'b0;
        done_correct = 1'b0;
        tb_total_checks += 1;
        tb_sub_checks += 1;

        // Check GPIO
        if(expected_gpio == gpio_out) begin // Check passed
            $info("Correct GPIO output during Test Case #%1d, check #%1d", tb_test_case_num, tb_sub_checks);
            gpio_correct = 1'b1;
        end
        else begin // Check failed
            $error("Correct GPIO output during Test Case #%1d, check #%1d Expected: 0x%1h, Actual: 0x%1h.", tb_test_case_num, tb_sub_checks,
                    expected_gpio, gpio_out);
        end

        // Check done
        if(expected_irq == IRQ) begin // Check passed
            $info("Correct IRQ output during Test Case #%1d, check #%1d", tb_test_case_num, tb_sub_checks);
            done_correct = 1'b1;
        end
        else begin // Check failed
            $error("Correct IRQ output during Test Case #%1d, check #%1d Expected: %1d, Actual: %1d.", tb_test_case_num, tb_sub_checks,
                    expected_irq, IRQ);
        end

        // Conditional increment of tb_passed
        if (gpio_correct & done_correct) tb_passed += 1;
    end
    endtask

	// Task to cycle through and check all 34 GPIO pin outputs
	task cycle_all_gpio (
		input [13:0] prescaler_value,
		output [33:0] tb_expected_gpio,
		input is_interrupt
	);
	begin
		// Cycle and check until end of sequence (GPIO[0] to GPIO[33] should go high)
		integer i;
		for (i = 0; i <= 34; i++) begin
			// Wait "prescaler" ms (10000 * prescaler * clock periods ns)
			#(10000 * prescaler_value * CLK_PERIOD);

			// Wait one more clock cycle (for first period only)
			if (i == 0) #(100);

			// Define expected value
			if (i == 0) tb_expected_gpio = 34'd1;
			else tb_expected_gpio = tb_expected_gpio << 1;
			if (i == 34) #(100);  // Wait 1 more clock cycle for IRQ

			// Check
			check_outputs(tb_expected_gpio, (i == 34 && is_interrupt));
		end
	end
	endtask

	// Main Test Bench Process
	initial begin
		// Initialize all signals
        tb_test_case_num = -1;
        tb_sub_checks = 0;
        tb_total_checks = 0;
		tb_expected_data = '0;
        tb_passed = 0;
        la_oenb = '1;
        la_data_in = '0;
        gpio_in = '1;
        rst_i = 1'b0;  // initially inactive

        // Get away from time = 0
        #(0.2);

		// **************************************************************************
        // Test Case #0: Basic Power on Reset
        // **************************************************************************
        tb_test_case_num += 1;
        tb_sub_checks = 0;

        // DUT Reset
        reset_dut;

        // Check #1
        check_outputs('0, 1'b0);

		// **************************************************************************
        // Test Case #1: Testing when design is not enabled
        // **************************************************************************
        tb_test_case_num += 1;
        tb_sub_checks = 0;
        reset_dut;

		// Write 1 to prescaler register
		WB_W_WRITE(PRESCALER_VAL_REG_OFFSET, 1);
        
		// Enable the sequence
		@(negedge clk_i) la_oenb[0] = 1'b0;
        la_data_in[0] = 1'b1;

        // Wait some time before checking
        #(35 * 10000 * 1 * CLK_PERIOD);

        // Check that outputs remained at 0
        check_outputs('0, 1'b0);

		// Disable the sequence
		la_oenb[0] = 1'b1;
        la_data_in[0] = 1'b0;

		// **************************************************************************
        // Test Case #2: Enable design
        // **************************************************************************
        tb_test_case_num += 1;
        tb_sub_checks = 0;

		// Enable design
		WB_W_WRITE(EN_VAL_REG_OFFSET, 32'd1);

		// Read from enable register
		WB_W_READ(EN_VAL_REG_OFFSET, tb_expected_data);

		// **************************************************************************
        // Test Case #3: Testing la_data_in[0] when la_oenb[0] is high
        // **************************************************************************
		tb_test_case_num += 1;
        tb_sub_checks = 0;

		// Set enable high
		@(negedge clk_i) la_data_in[0] = 1'b1;
		#(2 * 10000 * CLK_PERIOD)
		check_outputs('0, 1'b0);

		// **************************************************************************
        // Test Case #4: Test period of 1 ms (interrupt NOT enabled)
        // **************************************************************************
		tb_test_case_num += 1;
        tb_sub_checks = 0;

		// Enable counting
		la_oenb = '0;

		// Test and check GPIO outputs
		cycle_all_gpio(14'd1, tb_expected_gpio, 0);
		cycle_all_gpio(14'd1, tb_expected_gpio, 0);
		la_oenb = '1;

		// **************************************************************************
        // Test Case #5: Test period of 1 ms (interrupt enabled)
        // **************************************************************************
		tb_test_case_num += 1;
        tb_sub_checks = 0;

		// Enable interrupt
		WB_W_WRITE(IM_REG_OFFSET, 1);
		
		// Since interrupt was enabled long ago, acknowledge it
		@(negedge clk_i) la_oenb = '0;
		#(500)
		la_data_in[1] = 1'b0;

		// Test and check GPIO outputs, while acknowledging interrupts
		cycle_all_gpio(14'd1, tb_expected_gpio, 1);
		#(500)
		la_data_in[1] = 1'b0;
		cycle_all_gpio(14'd1, tb_expected_gpio, 1);
		#(500)
		la_data_in = '0;
		la_oenb = '1;

		// Finish Simulation
		$display("\nTest cases passed: %1d/%1d\n", tb_passed, tb_total_checks);
        $finish;
	end

endmodule