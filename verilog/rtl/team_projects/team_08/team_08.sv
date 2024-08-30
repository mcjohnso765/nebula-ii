// $Id: $
// File name:   team_08.sv
// Created:     07/04/2024
// Author:      <Creighton Bennett>
// Description: <Module Description>

`default_nettype none

module team_08 (
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
    input  wire [33:0] gpio_in, // Breakout Board Pins
    output wire [33:0] gpio_out, // Breakout Board Pins
    output wire [33:0] gpio_oeb // Active Low Output Enable
    
);

    // All outputs must have a value even if not used
    // assign gpio_out = 34'b0; //Inputs, but set low anyways
    /*
    * Place code and sub-module instantiations here.
    */
    // Only two pins are inputs, the reset and jump button are the inputs 

    assign gpio_oeb[2:0] = '1;
    assign gpio_oeb[30:3] = '0;
    assign gpio_oeb[33:31] = '1;

    team_08_GPIOPins allocation(.in(gpio_in), .out(gpio_out), .clk(clk), .reset(en & nrst));



endmodule