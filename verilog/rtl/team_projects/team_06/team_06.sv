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
    // assign gpio_out = 34'b0; //Inputs, but set low anyways

    //o is output 
    //1 is input
    always_comb begin
        gpio_oeb = '1;
        if (en == 1'b1) begin
            gpio_oeb [17:6] = '0;//Snake Game Display, Score Display, and sound output pins all are output pins here
            gpio_out[33:18] = '0;
        end
    end
    /*
    * Place code and sub-module instantiations here.
    */
    // Top level module

  assembly game (.clk(clk), .nrst(~nrst), .enable(en), .rs(gpio_out[18]), .rw(gpio_out[19]), .en(gpio_out[20]), .lcd8(gpio_out[28:21]), .keyenc(gpio_in[0]), .button_right_in(gpio_in[1]), .button_left_in(gpio_in[2]), .button_up_in(gpio_in[3]), .button_down_in(gpio_in[4]),
                     .button_start_pause_in(gpio_in[5]), .d(gpio_out[13:6]), .wr(gpio_out[14]), .dcx(gpio_out[15]), .song(gpio_out[16]), .rert(gpio_out[17]));

endmodule
