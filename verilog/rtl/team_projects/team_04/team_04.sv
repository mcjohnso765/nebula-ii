// $Id: $
// File name:   team_04.sv
// Created:     07/05/2024
// Author:      Andy Hu
// Description: Team 04 project final integration
`default_nettype none

module team_04 (
    // HW
    input logic clk, nrst,
    
    input logic en, //This signal is an enable signal for your chip. Your design should disable if this is low.

    // Logic Analyzer - Grant access to all 128 LA
    input wire [31:0] la_data_in,
    output reg [31:0] la_data_out,
    input wire [31:0] la_oenb,

    // 34 out of 38 GPIOs (Note: if you need up to 38 GPIO, discuss with a TA)
    input  wire [33:0] gpio_in, // Breakout Board Pins
    output reg [33:0] gpio_out, // Breakout Board Pins
    output reg [33:0] gpio_oeb, // Active Low Output Enable
    
    /*
    * Add other I/O ports that you wish to interface with the
    * Wishbone bus to the management core. For examples you can 
    * add registers that can be written to with the Wishbone bus
    */

    // Wishbone Master signals
    output wire [31:0] ADR_O,
    output wire [31:0] DAT_O,
    output wire [3:0]  SEL_O,
    output wire        WE_O,
    output wire        STB_O,
    output wire        CYC_O,
    input  wire [31:0] DAT_I,
    input  wire        ACK_I,


    //memory location signals
    input logic [31:0] mem_adr_start, memory_size

);

   
    /*
    * Place code and sub-module instantiations here.
    */
    
    logic h_out, v_out, pixel_data; //wires to VGA from CPU
    logic opcode_error, alu_error;

    //input from wishbone interconnect
    
    //input from user design
    logic [31:0] CPU_DAT_I;
    logic [31:0] ADR_I;
    logic [3:0]  SEL_I;
    logic        WRITE_I;
    logic        READ_I;
    // //output to wishbone interconnect
    // logic [31:0] ADR_O;
    // logic [31:0] DAT_O;
    // logic [3:0]  SEL_O;
    // logic        WE_O;
    // logic        STB_O;
    // logic        CYC_O;
    //output to user design
    logic [31:0] CPU_DAT_O;
    logic        BUSY_O;

    logic [31:0] middle_mem_adr;
    assign ADR_I = middle_mem_adr + mem_adr_start;


    t04_tippy_top final_design (
        .clk(clk),
        .nRst(nrst),
        .button(),
        .Rx(gpio_in[5]),
        .h_out(h_out),
        .v_out(v_out),
        .pixel_data(pixel_data),
        .opcode_error(opcode_error),
        .alu_error(alu_error),
        .mem_busy(BUSY_O | !en),
        .mem_read(READ_I),
        .mem_write(WRITE_I),
        .adr_to_mem(middle_mem_adr),
        .data_to_mem(CPU_DAT_I),
        .sel_to_mem(SEL_I),
        .data_from_mem(CPU_DAT_O),

        .memory_size(memory_size)

    );

    //assign CPU_DAT_I = 32'h32;

    wishbone_manager wb_manage (
        .nRST(nrst),
        .CLK(clk),
        .DAT_I(DAT_I),
        .CPU_DAT_I(CPU_DAT_I),
        .ADR_I(ADR_I),
        .SEL_I(SEL_I),
        .WRITE_I(WRITE_I),
        .READ_I(READ_I),
        .ADR_O(ADR_O),
        .DAT_O(DAT_O),
        .SEL_O(SEL_O),
        .WE_O(WE_O),
        .STB_O(STB_O),
        .CYC_O(CYC_O),
        .CPU_DAT_O(CPU_DAT_O),
        .BUSY_O(BUSY_O),
        .ACK_I(ACK_I)
    );
    
    //enable handler
    always_comb begin 
         // All outputs must have a value even if not used
    la_data_out = 32'b0;
    gpio_out[33:5] = 29'b0; //Inputs, but set low anyways
    gpio_oeb[33:5] = 29'b1;//All 1's inputs

        // if(~en) begin
        //     gpio_out[4:0] = 0;
        // end else begin
            gpio_oeb[4:0] = '0;
            gpio_out[0] = h_out;
            gpio_out[1] = v_out;
            gpio_out[2] = pixel_data;
            gpio_out[3] = opcode_error;
            gpio_out[4] = alu_error;
        end
    // end


endmodule