// $Id: $
// File name:   team_11.sv

`default_nettype none

module team_11 (
    // HW
    input logic clk, nrst,
    
    input logic en, //This signal is an enable signal for your chip. Your design should disable if this is low.

    // Logic Analyzer - Grant access to all 128 LA
    input wire [31:0] la_data_in,
    output wire [31:0] la_data_out,
    input wire [31:0] la_oenb,

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

    // Assign LA data out to 0
    assign la_data_out = 32'b0;
    
    // Assign outputs of input pins to 0
    assign gpio_out[33:30] = '0;
    assign gpio_out[13:0] = '0;

    // Assign OEBs
    assign gpio_oeb = {{4{1'b1}}, 16'b0, {14{1'b1}}};

    /*
    * Place code and sub-module instantiations here.
    */
    keypad_control kp (.readrow(gpio_in[33:30]), .clk(clk), .nrst(en & nrst), .scancol(gpio_out[29:26]), .msg_tx_ctrl(gpio_out[25]), 
    .msg_1(msg_1));

    lcd1602 sending(.clk(clk), .nrst(en & nrst), .row_1("                "), .row_2(msg_1),.lcd_en(gpio_out[24]), .lcd_rw(gpio_out[23]), 
        .lcd_rs(gpio_out[22]), .lcd_data(gpio_out[21:14]));


logic [127:0] msg_1;


endmodule

`default_nettype none

module ssdec (
    input logic [3:0] in,
    input logic enable,
    output logic [6:0] out
 );
    assign out = {enable, in} == 5'b10000 ? 7'b0111111:
    {enable, in} == 5'b10001 ? 7'b0000110: //1
    {enable, in} == 5'b10010 ? 7'b1011011: //2
    {enable, in} == 5'b10011 ? 7'b1001111: //3
    {enable, in} == 5'b10100 ? 7'b1100110: //4
    {enable, in} == 5'b10101 ? 7'b1101101: //5
    {enable, in} == 5'b10110 ? 7'b1111101: //6
    {enable, in} == 5'b10111 ? 7'b0000111: //7
    {enable, in} == 5'b11000 ? 7'b1111111: //8
    {enable, in} == 5'b11001 ? 7'b1100111: //9
    {enable, in} == 5'b11010 ? 7'b1110111: //A or 10
    {enable, in} == 5'b11011 ? 7'b1111100: //b
    {enable, in} == 5'b11100 ? 7'b0111001: //C
    {enable, in} == 5'b11101 ? 7'b1011110: //d
    {enable, in} == 5'b11110 ? 7'b1111001: //E
    {enable, in} == 5'b11111 ? 7'b1110001: //F
    7'b0000000;
endmodule


