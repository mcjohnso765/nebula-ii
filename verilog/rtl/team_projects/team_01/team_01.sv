// $Id: $
// File name:   team_01.sv
// Created:     MM/DD/YYYY
// Author:      <Full Name>
// Description: <Module Description>

`default_nettype none

module team_01 (
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

    //input from wishbone interconnect
    input logic [31:0] DAT_I,
    input logic        ACK_I,

    output logic [31:0] ADR_O,
    output logic [31:0] DAT_O,
    output logic [3:0]  SEL_O,
    output logic        WE_O,
    output logic        STB_O,
    output logic        CYC_O
    
    /*
    * Add other I/O ports that you wish to interface with the
    * Wishbone bus to the management core. For examples you can 
    * add registers that can be written to with the Wishbone bus
    */
);


    

    // All outputs must have a value even if not used
    assign la_data_out = 128'b0;
    // assign gpio_out = 34'b0; //Inputs, but set low anyways
    // assign gpio_oeb = '1;//All 1's inputs

    /*
    * Place code and sub-module instantiations here.
    */
    logic [31:0] cpu_dat_i, adr_i;
    logic [3:0] sel_i;
    logic write_i, read_i;
    logic [31:0] cpu_dat_o;
    logic busy_o;

    wishbone_manager a1(
     .CLK(clk),    
    .nRST(nrst),
    //INPUT FROM WISHBONE INTERCONNECT
    .DAT_I(DAT_I),
    .ACK_I(ACK_I),
    //INPUT FROM USER INTERCONNECT
    .CPU_DAT_I(cpu_dat_i),
    .ADR_I(adr_i),
    .SEL_I(sel_i),
    .WRITE_I(write_i),
    .READ_I(read_i),
    //OUTPUT FROM WISHBONE INERCONNECT
    .ADR_O(ADR_O),
    .DAT_O(DAT_O),
    .SEL_O(SEL_O),
    .WE_O(WE_O),
    .STB_O(STB_O),
    .CYC_O(CYC_O),
    //OUTPUT TO USER DESIGN
    .CPU_DAT_O(cpu_dat_o),
    .BUSY_O(busy_o));
    
    //

    team_01_cpu cpu(
   .clk(clk), 
   .nRST(nrst), 
   .busy_o(busy_o),
   .cpu_dat_o(cpu_dat_o),
   .cpu_dat_i(cpu_dat_i),
   .adr_i(adr_i),
   .sel_i(sel_i),
   .write_i(write_i),
   .read_i(read_i),
   //lcd outputs
   .lcd_en(gpio_out[5]), 
   .lcd_rs(gpio_out[6]),
   .lcd_rw(gpio_out[7]),
   .lcd_data(gpio_out[15:8]),
   .rows(gpio_in[19:16]),  //in
   .cols(gpio_out[23:20])
   );

    assign gpio_oeb [5] = '0;
    assign gpio_oeb [6] = '0;
    assign gpio_oeb [7] = '0;
    assign gpio_oeb [15:8] = '0;
    assign gpio_oeb [19:16] = 4'b1111;
    assign gpio_oeb [23:20] = '0;

    assign gpio_oeb [4:0] = '0;
    assign gpio_out [4:0] = '0;
    assign gpio_oeb[33:24] = 0;
    assign gpio_out[33:24] = 0;


endmodule