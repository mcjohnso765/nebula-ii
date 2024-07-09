// $Id: $
// File name:   team_08.sv
// Created:     07/04/2024
// Author:      <Creighton Bennett>
// Description: <Module Description>

`default_nettype none

module team_08 (
    // HW
    input logic clk, nrst,
    
    input logic en, //This signal is an enable signal for your chip. Your design should disable if this is low.

    // Logic Analyzer - Grant access to all 128 LA
    input wire [127:0] la_data_in,
    output wire [127:0] la_data_out,
    input wire [127:0] la_oenb,

    // 34 out of 38 GPIOs (Note: if you need up to 38 GPIO, discuss with a TA)
    input  wire [33:0] gpio_in, // Breakout Board Pins
    output wire [33:0] gpio_out, // Breakout Board Pins
    output wire [33:0] gpio_oeb, // Active Low Output Enable
    
);

    // All outputs must have a value even if not used
    assign la_data_out = 128'b0;
    // assign gpio_out = 34'b0; //Inputs, but set low anyways
    /*
    * Place code and sub-module instantiations here.
    */
    // Only two pins are inputs, the reset and jump button are the inputs 

    assign gpio_oeb[21:19] = {3{1'b1}};
    assign gpio_oeb[18:0] = 19'b0;
     assign gpio_oeb[33:22] = 12'b0;

    team_08_GPIOPins allocation(.in(gpio_in), .out(gpio_out), .clk(clk), .reset(nrst));



endmodule