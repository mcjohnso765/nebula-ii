// The purpose of this module is to allow the wishbone bus to control which design
// is writing to the GPIO.  Each GPIO Pin will be able to be configured separately
// this will allow for one design to control some GPIO and another design to control
// other gpio

module gpio_control_Wrapper #(
    parameter NUM_TEAMS = 12
)
(
    
    // Wishbone Slave ports (WB MI A)
    input wire wb_clk_i,
    input wire wb_rst_i,
    input wire wbs_stb_i,
    input wire wbs_cyc_i,
    input wire wbs_we_i,
    input wire [3:0] wbs_sel_i,
    input wire [31:0] wbs_dat_i,
    input wire [31:0] wbs_adr_i,
    output wire wbs_ack_o,
    output wire [31:0] wbs_dat_o,
    
    // GPIOs
    input wire [37:0] designs_gpio_out[NUM_TEAMS:0], // Breakout Board Pins
    input wire [37:0] designs_gpio_oeb[NUM_TEAMS:0], // Active Low Output Enable

    output wire [37:0] gpio_out,
    output wire [37:0] gpio_oeb
);

    gpio_control_WB #(
        .NUM_TEAMS(NUM_TEAMS)
    ) gpio_control_WB (
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
        .IRQ(),
        .io_oeb(designs_gpio_oeb),
        .io_out(designs_gpio_out),
        .muxxed_io_oeb(gpio_oeb),
        .muxxed_io_out(gpio_out)
    );
    
endmodule