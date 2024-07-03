//This is just the sample project right now

module nebula_ii (
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

    // User clk, rst
    input wb_clk_i,
    input wb_rst_i,

    // Wishbone Slave ports (WB MI A)
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs, give all here, the wrapper will default 1:4 to unused (to make it easier for teams to change)
    input  [37:0] io_in,
    output [37:0] io_out,
    output [37:0] io_oeb,

    // IRQ
    output [2:0] irq
);
    
    // Number of teams (only sample project for now)
    localparam NUM_TEAMS = 1;
    
    assign irq = 3'b0; // TODO: use interrupt from sample project?

    // Truncated address for each internal block
    wire [31:0] adr_truncated;

    // WB slave stb_i inputs to all designs, GPIO control, LA control
    wire [NUM_TEAMS:0] designs_stb ;
    wire gpio_control_stb;
    wire la_control_stb;

    // WB slave outputs from all designs, GPIO control, LA control
    wire [NUM_TEAMS:0] designs_wbs_ack_o;
    wire [31:0] designs_wbs_dat_o[NUM_TEAMS:0];
    wire la_wbs_ack_o;
    wire [31:0] la_wbs_dat_o;
    wire gpio_wbs_ack_o;
    wire [31:0] gpio_wbs_dat_o;

    // LA outputs from all designs
    wire [127:0] designs_la_data_out[NUM_TEAMS:0];

    // GPIO outputs from all designs
    wire [37:0] designs_gpio_out[NUM_TEAMS:0]; // Breakout Board Pins
    wire [37:0] designs_gpio_oeb[NUM_TEAMS:0]; // Active Low Output Enable

    // IRQ from all designs
    wire [2:0] designs_irq[NUM_TEAMS:0];

    // Sample Project Instance
    sample_team_proj_Wrapper sample_team_proj_Wrapper (
    `ifdef USE_POWER_PINS
            .vccd1(vccd1),	// User area 1 1.8V power
            .vssd1(vssd1),	// User area 1 digital ground
    `endif
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

    reg [38*(NUM_TEAMS+1)-1:0] designs_gpio_out_flat;
    reg [38*(NUM_TEAMS+1)-1:0] designs_gpio_oeb_flat;

    integer i1;
    always @* begin
        for (i1 = 0; i1 <= NUM_TEAMS; i1 = i1 + 1) begin
            designs_gpio_out_flat[i1*38 +: 38] = designs_gpio_out[i1];//[38i:38(i+1)-1]
            designs_gpio_oeb_flat[i1*38 +: 38] = designs_gpio_oeb[i1];//[38i:38(i+1)-1]
        end
    end

    // GPIO Control
    gpio_control_Wrapper #(
        .NUM_TEAMS(NUM_TEAMS)
    ) gpio_control_wrapper (
        // Wishbone Slave ports (WB MI A)
    `ifdef USE_POWER_PINS
            .vccd1(vccd1),	// User area 1 1.8V power
            .vssd1(vssd1),	// User area 1 digital ground
    `endif
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),
        .wbs_stb_i(gpio_control_stb),
        .wbs_cyc_i(wbs_cyc_i),
        .wbs_we_i(wbs_we_i),
        .wbs_sel_i(wbs_sel_i),
        .wbs_dat_i(wbs_dat_i),
        .wbs_adr_i(adr_truncated),
        .wbs_ack_o(gpio_wbs_ack_o),
        .wbs_dat_o(gpio_wbs_dat_o),
        
        // GPIOs
        .designs_gpio_out_flat(designs_gpio_out_flat),
        .designs_gpio_oeb_flat(designs_gpio_oeb_flat),
        .gpio_out(io_out),
        .gpio_oeb(io_oeb)
    );

    reg [128*(NUM_TEAMS+1)-1:0] designs_la_data_out_flat;

    integer i2;
    always @* begin
        for (i2 = 0; i2 <= NUM_TEAMS; i2 = i2 + 1) begin
            designs_la_data_out_flat[i2*128 +: 128] = designs_la_data_out[i2];//[38i:38(i+1)-1]
        end
    end

    // LA Control
    la_control_Wrapper #(
        .NUM_TEAMS(NUM_TEAMS)
    ) la_control_wrapper (
        // Wishbone Slave ports (WB MI A)
    `ifdef USE_POWER_PINS
            .vccd1(vccd1),	// User area 1 1.8V power
            .vssd1(vssd1),	// User area 1 digital ground
    `endif
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),
        .wbs_stb_i(la_control_stb),
        .wbs_cyc_i(wbs_cyc_i),
        .wbs_we_i(wbs_we_i),
        .wbs_sel_i(wbs_sel_i),
        .wbs_dat_i(wbs_dat_i),
        .wbs_adr_i(adr_truncated),
        .wbs_ack_o(la_wbs_ack_o),
        .wbs_dat_o(la_wbs_dat_o),
        
        // LA
        .designs_la_data_out_flat(designs_la_data_out_flat),
        .la_data_out(la_data_out)
    );

    reg [32*(NUM_TEAMS+1)-1:0] designs_wbs_dat_o_flat;

    integer i3;
    always @* begin
        for (i3 = 0; i3 <= NUM_TEAMS; i3 = i3 + 1) begin
            designs_wbs_dat_o_flat[i3*32 +: 32] = designs_wbs_dat_o[i3];//[38i:38(i+1)-1]
        end
    end

    // WB Interconnect
    wb_interconnect #(
        .NUM_TEAMS(NUM_TEAMS)
    ) wb_interconnect (
    `ifdef USE_POWER_PINS
            .vccd1(vccd1),	// User area 1 1.8V power
            .vssd1(vssd1),	// User area 1 digital ground
    `endif
        // Wishbone Slave ports (only the ones we need)
        .wbs_stb_i(wbs_stb_i),
        .wbs_adr_i(wbs_adr_i),
        .wbs_ack_o(wbs_ack_o),
        .wbs_dat_o(wbs_dat_o),

        // Strobe Signals
        .designs_stb(designs_stb),
        .la_control_stb(la_control_stb),
        .gpio_control_stb(gpio_control_stb),

        // Truncated Address (use only last 16 bits)
        .adr_truncated(adr_truncated),

        // WB dat_o Signals
        .designs_wbs_dat_o_flat(designs_wbs_dat_o_flat),
        .la_control_dat_o(la_wbs_dat_o),
        .gpio_control_dat_o(gpio_wbs_dat_o),

        // WB ack_o Signals
        .designs_ack_o(designs_wbs_ack_o),
        .la_control_ack_o(la_wbs_ack_o),
        .gpio_control_ack_o(gpio_wbs_ack_o)
    );

endmodule

`default_nettype wire