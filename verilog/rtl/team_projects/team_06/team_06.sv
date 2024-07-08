// $Id: $
// File name:   team_06.sv
// Created:     07/08/2024
// Author:      Thomas Fang
// Description: This is the top wrapper that wraps the all the snake game modules stogether. It controls how many input pins goes into the chip and how many output pins goes out of the chip.

`default_nettype none

module team_06 (
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
    
    /*
    * Add other I/O ports that you wish to interface with the
    * Wishbone bus to the management core. For examples you can 
    * add registers that can be written to with the Wishbone bus
    */
);

    // All outputs must have a value even if not used
    assign la_data_out = 128'b0;
    assign gpio_out = 34'b0; //Inputs, but set low anyways

    always_comb begin

        if (en == 1'b1) begin
             gpio_oeb [5:0] = '1;//Push button pins as input pins
             gpio_oeb [27:0] = '0;//Snake Game Display, Score Display, and sound output pins all are output pins here
        end
        else begin
             gpio_oeb == '1;
        end
    /*
    * Place code and sub-module instantiations here.
    */

endmodule
