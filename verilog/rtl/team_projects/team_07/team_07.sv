// $Id: $
// File name:   team_07.sv
// Created:     MM/DD/YYYY
// Author:      <Full Name>
// Description: <Module Description>

`default_nettype none

module team_07 (
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
    output wire [33:0] gpio_oeb // Active Low Output Enable
    
    /*
    * Add other I/O ports that you wish to interface with the
    * Wishbone bus to the management core. For examples you can 
    * add registers that can be written to with the Wishbone bus
    */
);

    // All outputs must have a value even if not used
    assign la_data_out = 128'b0;
   // assign gpio_out = 34'b0; //Inputs, but set low anyways
    assign gpio_oeb = 34'h3FFFC003F;///34'b1111111111111111000000000000111111;//All 1's inputs
    assign gpio_out[33:18] = '0;
    assign gpio_out[5:0] = '0;
    /*
    * Place code and sub-module instantiations here.
    */
    logic [5:0] button;  // input: button
    logic ssdec_sdi;  // output: ssdec lines
    logic ssdec_ss;
    logic ssdec_sck;
    logic tft_sck;
    logic tft_sdi;
    logic tft_dc;
    logic tft_rst;
    logic tft_cs;
    logic [2:0] tft_state;
    logic audio;

    assign button = gpio_in[5:0];
    assign gpio_out[6] = ssdec_sdi;
    assign gpio_out[7] = ssdec_ss;
    assign gpio_out[8]= ssdec_sck;
    assign gpio_out[9] = tft_sck;
    assign gpio_out[10] = tft_sdi;
    assign gpio_out[11] = tft_dc;
    assign gpio_out[12] = tft_rst;
    assign gpio_out[13] = tft_cs;
    assign gpio_out[16:14] = tft_state;
    assign gpio_out[17] = audio;

    bomb_game team_07(
    .nrst(nrst),
    .clk(clk),
    .button(button),   // input: button
    .ssdec_sdi(ssdec_sdi),     // output: ssdec lines
    .ssdec_ss(ssdec_ss),
    .ssdec_sck(ssdec_sck),
    .tft_sck(tft_sck),
    .tft_sdi(tft_sdi),
    .tft_dc(tft_dc), 
    .tft_rst(tft_rst),
    .tft_cs(tft_cs),
    .tft_state(tft_state),
    .audio(audio)

); 

endmodule