/*
* This is a template for your top level test bench!
* You are responsible for having a test bench for your top
* level design. Otherwise, your design will not be part
* of the tape-out.
*
* Please also include test benches for your team_12_WB
* and team_12_Wrapper modules, if needed to verify
* interfacing with the Wishbone Bus.
*
* The command to run this test bench is:
* make tbsim-source-team_12-team_12
*/

`timescale 1 ns / 1 ps

module team_12_tb();

    ///////////////////////////////////
    // Write your test bench code here!
    ///////////////////////////////////
    team_12_Wrapper lol (
        //Wishbone Slave and user clk, rst
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),
        .wbs_stb_i(designs_stb[1]),
        .wbs_cyc_i(wbs_cyc_i),
        .wbs_we_i(wbs_we_i),
        .wbs_sel_i(wbs_sel_i),
        .wbs_dat_i(wbs_dat_i),
        .wbs_adr_i(adr_truncated),
        .wbs_ack_o(designs_wbs_ack_o[1]),
        .wbs_dat_o(designs_wbs_dat_o[1]),

        // Logic Analyzer - 2 pins used here
        .la_data_in(la_data_in),
        .la_data_out(designs_la_data_out[1]),
        .la_oenb(la_oenb),

        // GPIOs
        .gpio_in(io_in), // Breakout Board Pins
        .gpio_out(designs_gpio_out[1]), // Breakout Board Pins
        .gpio_oeb(designs_gpio_oeb[1]), // Active Low Output Enable

        // IRQ signal
        .irq(designs_irq[1])
    );
endmodule