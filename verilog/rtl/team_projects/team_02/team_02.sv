// $Id: $
// File name:   team_02.sv
// Created:     07/03/2024
// Author:      Wayne Hsieh
// Description: <Module Description>

`default_nettype none

module team_02 (
    `ifdef USE_POWER_PINS
        inout vccd1,	// User area 1 1.8V supply
        inout vssd1,	// User area 1 digital ground
    `endif
    // HW
    input logic clk, nrst,
    
    input logic en, //This signal is an enable signal for your chip. Your design should disable if this is low.

    // Logic Analyzer - Grant access to all 128 LA
    // input wire [31:0] la_data_in,
    // output wire [31:0] la_data_out,
    // input wire [31:0] la_oenb,

    // 34 out of 38 GPIOs (Note: if you need up to 38 GPIO, discuss with a TA)
    input  wire [31:0] gpio_in, // Breakout Board Pins
    output wire [31:0] gpio_out, // Breakout Board Pins
    // output wire [31:0] gpio_oeb, // Active Low Output Enable

    output wire [31:0] ADR_O,
    output wire [31:0] DAT_O,
    output wire [3:0]  SEL_O,
    output wire        WE_O,
    output wire        STB_O,
    output wire        CYC_O,
    input wire [31:0]  DAT_I,
    input wire         ACK_I

    
    /*
    * Add other I/O ports that you wish to interface with the
    * Wishbone bus to the management core. For examples you can 
    * add registers that can be written to with the Wishbone bus
    */
);

    logic [3:0] sel_i;

    // All outputs must have a value even if not used
    //assign gpio_out = 32'b0; //Inputs, but set low anyways
    //assign gpio_oeb = '1;//All 1's inputs
    /*
    * Place code and sub-module instantiations here.
    cpu and wish bone manager
    */
    logic [31:0] ramstore, ramaddr, ramload;
    logic Ren, Wen, busy_o;
    t02_top top (.clk(clk), .nrst(nrst), .ramaddr(ramaddr), .ramstore(ramstore), 
    .Ren(Ren), .Wen(Wen), .ramload(ramload), .busy_o(busy_o), .enable(en), 
    .lcd_rs(gpio_out[0]), .lcd_rw(gpio_out[5]), .lcd_en(gpio_out[6]), .sel_i(sel_i), 
    .lcd_data(gpio_out[14:7]), .read_row(gpio_in[18:15]), .scan_col(gpio_out[22:19]));
    // add start_addr 
    // make sure all signals are connected
    t02_wishbone_manager wb(.CLK(clk), .nRST(nrst), 
    .CPU_DAT_I(ramstore), .ADR_I(ramaddr), .SEL_I(sel_i), .WRITE_I(Wen), .READ_I(Ren),
    .CPU_DAT_O(ramload), .BUSY_O(busy_o), 
    .ADR_O(ADR_O), .DAT_O(DAT_O), .SEL_O(SEL_O), .WE_O(WE_O), .STB_O(STB_O), .CYC_O(CYC_O),
    .DAT_I(DAT_I), .ACK_I(ACK_I));

    assign gpio_out[31:23] = '0;
    assign gpio_out[18:15] = '0;
    assign gpio_out[4:1] = '0;
endmodule