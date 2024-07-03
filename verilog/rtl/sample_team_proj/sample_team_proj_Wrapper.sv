// STARS STUDENTS: DO NOT MODIFY!

// $Id: $
// File name:   sample_team_proj_Wrapper.sv
// Created:     05/26/2024
// Author:      Abdulloh Abdubaev
// Description: Sample Team Project Wrapper

// Change Log:
// Aidan Jacobsen, 06/15/2024, integrated with automated bus wrapping, moved ports internal so teams don't have to modify

module sample_team_proj_Wrapper (
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif
    // Wishbone Slave ports (WB MI A)
    input wire wb_clk_i,
    input wire wb_rst_i, // Active high reset!
    input wire wbs_stb_i,
    input wire wbs_cyc_i,
    input wire wbs_we_i,
    input wire [3:0] wbs_sel_i,
    input wire [31:0] wbs_dat_i,
    input wire [31:0] wbs_adr_i,
    output wire wbs_ack_o,
    output wire [31:0] wbs_dat_o,

    // Logic Analyzer - 2 pins used for this design
    input wire [127:0] la_data_in,
    output wire [127:0] la_data_out,
    input wire [127:0] la_oenb,

    // GPIOs
    input  wire [37:0] gpio_in, // Breakout Board Pins
    output wire [37:0] gpio_out, // Breakout Board Pins
    output wire [37:0] gpio_oeb, // Active Low Output Enable

    // IRQ signal
    output wire [2:0] irq
);
    
    assign irq[2:1] = 2'b0;  // Unused
    assign gpio_oeb[4:1] = 4'b1111;  // Set all to inputs
    assign gpio_out[4:1] = 4'b0;  // Doesn't matter since inputs

    sample_team_proj_WB sample_team_proj_WB (
        .clk_i(wb_clk_i),
        .rst_i(wb_rst_i),
        .adr_i(wbs_adr_i),
        .dat_i(wbs_dat_i),
        .dat_o(wbs_dat_o),
        .sel_i(wbs_sel_i),
        .cyc_i(wbs_cyc_i),
        .stb_i(wbs_stb_i),
        .ack_o(wbs_ack_o),
        .we_i(wbs_we_i),
        .IRQ(irq[0]),
        .la_data_in(la_data_in),
        .la_data_out(la_data_out),
        .la_oenb(la_oenb),
        .gpio_in({gpio_in[37:5], gpio_in[0]}), //In general, GPIO 4:1 should not be used but can be. Ask a TA if needed
        .gpio_out({gpio_out[37:5], gpio_out[0]}), //In general, GPIO 4:1 should not be used but can be. Ask a TA if needed
        .gpio_oeb({gpio_oeb[37:5], gpio_oeb[0]}) //In general, GPIO 4:1 should not be used but can be. Ask a TA if needed
    );

endmodule