// $Id: $
// File name:   team_03.sv
// Created:     MM/DD/YYYY
// Author:      <Full Name>
// Description: <Module Description>

`default_nettype none

module team_03 (
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

    output  logic [31:0] ADR_O,
    output  logic [31:0] DAT_O,
    output  logic [3:0]  SEL_O,
    output  logic        WE_O,
    output  logic        STB_O,
    output  logic        CYC_O,

    input logic [31:0] DAT_I,
    input logic ACK_I

    /*
    * Add other I/O ports that you wish to interface with the
    * Wishbone bus to the management core. For examples you can 
    * add registers that can be written to with the Wishbone bus
    */
);

    // All outputs must have a value even if not used
    assign la_data_out = 128'b0;
    // assign gpio_out[33:32] = '0; //Inputs, but set low anyways
    // assign gpio_oeb[33:32] = '1;//All 1's inputs

    logic WRITE_I, READ_I, BUSY_O;
    
    logic [31:0] CPU_DAT_O;

    logic [31:0] CPU_DAT_I, ADR_I;

    logic [3:0] SEL_I;


    t03_core core(.clock(clk), .reset(!nrst), .en(en), .CPU_DAT_O(CPU_DAT_O), .BUSY_O(BUSY_O), .CPU_DAT_I(CPU_DAT_I), .ADR_I(ADR_I), .SEL_I(SEL_I), .WRITE_I(WRITE_I), .READ_I(READ_I), .gpio_in(gpio_in), .gpio_out(gpio_out), .gpio_oeb(gpio_oeb));
    
    wishbone_manager wb(.CLK(clk), .nRST(nrst), .DAT_I(DAT_I), .ACK_I(ACK_I), .CPU_DAT_I(CPU_DAT_I), .ADR_I(ADR_I), .SEL_I(SEL_I), .WRITE_I(WRITE_I), .READ_I(READ_I), .ADR_O(ADR_O), .DAT_O(DAT_O), .SEL_O(SEL_O), .WE_O(WE_O), .STB_O(STB_O), .CYC_O(CYC_O), .CPU_DAT_O(CPU_DAT_O), .BUSY_O(BUSY_O));

    /*
    * Place code and sub-module instantiations here.
    */

endmodule