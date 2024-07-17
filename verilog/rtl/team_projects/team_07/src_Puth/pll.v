module t07_pll
(
    input in_clk, // 12 MHz, 0 deg
    output lcd_clk, // 48 MHz, 0 deg
    // output clk_10kHz, // 10 kHz, 0 deg
    output locked
);
    // PLL instance
    wire BYPASS = 0;
    wire RESETB = 1;

    SB_PLL40_CORE #(
        .FEEDBACK_PATH("PHASE_AND_DELAY"),
        .DELAY_ADJUSTMENT_MODE_FEEDBACK("FIXED"),
        .DELAY_ADJUSTMENT_MODE_RELATIVE("FIXED"),
        .PLLOUT_SELECT("SHIFTREG_0deg"),  // 0 degrees
        .SHIFTREG_DIV_MODE(1'b1), // 0 => div-by-4; 1 => div-by-7
        .FDA_FEEDBACK(4'b0000),
        .FDA_RELATIVE(4'b0000),
        .DIVR(4'd5),        // 0
        .DIVF(7'd4),     // 3
        .DIVQ(3'd0),         // 0
        .FILTER_RANGE(3'd1), // 1
    ) pll (
        .REFERENCECLK (in_clk),
        .PLLOUTCORE   (lcd_clk),
        .BYPASS       (BYPASS),
        .RESETB       (RESETB),
        .LOCK (locked)
    );
endmodule