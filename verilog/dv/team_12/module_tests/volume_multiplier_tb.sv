/*
	Module name: tb_volume_multiplier
	Description: A testbench for the start arbitrator module
*/

`timescale 1ns/1ps

module volume_multiplier_tb();

// Define local parameters
	localparam CLK_PERIOD = 10; // 100 MHz 
	localparam RESET_ACTIVE = 0;
	localparam RESET_INACTIVE = 1;

//Inputs
logic tb_clk, tb_nrst, tb_start_vol;
logic [6:0] tb_velocity;
logic [8:0] tb_wave_table_output;

//Outputs
logic [15:0] tb_volume_output;
logic tb_vol_done;

//Expected
logic [15:0] volume_exp;

initial begin
    $dumpfile ("volume_multiplier.vcd");
    $dumpvars;
end

task reset_dut;
	begin
		// @(negedge tb_clk); // synchronize to negedge edge so there are not hold or setup time violations
		
		// Activate reset
		tb_nrst = RESET_ACTIVE;

		@(negedge tb_clk);

		// Deactivate reset
		tb_nrst = RESET_INACTIVE; 
	end
	endtask    
// endtask //
volume_multiplier DUT (
    .MHz10(tb_clk),
    .en(1'b1),
    .nrst(tb_nrst),
    .start_vol(tb_start_vol),
    .velocity(tb_velocity),
    .wave_table_output(tb_wave_table_output),
    .volume_output(tb_volume_output),
    .vol_done(tb_vol_done)
);

// Clock generation block
	always begin
		tb_clk = 0; // set clock initially to be 0 so that they are no time violations at the rising edge 
		#(CLK_PERIOD / 2);
		tb_clk = 1;
		#(CLK_PERIOD / 2);
	end

initial begin
    tb_start_vol = 0;
    tb_velocity = 0;
    tb_wave_table_output = 0;
    reset_dut();
    tb_start_vol = 1;
    tb_velocity = 7'd94;
    tb_wave_table_output = 9'd426;
    #(CLK_PERIOD);
    tb_start_vol = 0;
    volume_exp = 16'b1001110001101100;
    #(CLK_PERIOD * 17);
    tb_start_vol = 1;
    tb_velocity = 7'd56;
    tb_wave_table_output = 9'd85;
    #(CLK_PERIOD);
    tb_start_vol = 0;
    volume_exp = 16'b0001001010011000;
    #(CLK_PERIOD * 17);
    tb_start_vol = 1;
    tb_velocity = 7'b1111111;
    tb_wave_table_output = 9'b111111111;
    #(CLK_PERIOD);
    tb_start_vol = 0;
    volume_exp = 16'd64898;
    #(CLK_PERIOD * 17);
    tb_start_vol = 1;
    tb_velocity = 7'd0;
    tb_wave_table_output = 9'd0;
    #(CLK_PERIOD);
    tb_start_vol = 0;
    volume_exp = 16'd0;
    #(CLK_PERIOD * 17);
    tb_start_vol = 1;
    tb_velocity = 7'd1;
    tb_wave_table_output = 9'd0;
    #(CLK_PERIOD);
    tb_start_vol = 0;
    volume_exp = 16'd0;
    #(CLK_PERIOD * 17);
    tb_start_vol = 1;
    tb_velocity = 7'd0;
    tb_wave_table_output = 9'd1;
    #(CLK_PERIOD);
    tb_start_vol = 0;
    volume_exp = 16'd0;
    #(CLK_PERIOD * 17);
    $finish;
end

endmodule