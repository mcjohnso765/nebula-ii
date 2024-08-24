// This is just the sample project right now
// When testing your design, please replace it with your design's instance

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
    output [2:0] irq,
    
    input en
    //input [31:0] start_addr
);
    
    // Number of teams (only sample project for now)
    // Replace sample project with your design for testing
    localparam NUM_TEAMS = 12;

    // LA outputs from all designs
    wire [127:0] designs_la_data_out [NUM_TEAMS:0];

    // GPIO outputs from all designs
    wire [37:0] designs_gpio_out [NUM_TEAMS:0]; // Breakout Board Pins
    wire [37:0] designs_gpio_oeb [NUM_TEAMS:0]; // Active Low Output Enable

    // IRQ from all designs
    // (not used unless a team wants to)
    // wire [2:0] designs_irq [NUM_TEAMS:0];
    assign irq = 3'b0; // Default of 0

    //Project Manager Arbitrator Signals
    wire [31:0] arbitrator_dat_i [NUM_TEAMS:0];
    wire [31:0] arbitrator_adr_i [NUM_TEAMS:0];
    reg [31:0] arbitrator_dat_o [NUM_TEAMS:0];
    wire [3:0] arbitrator_sel_i [NUM_TEAMS:0];
    wire [NUM_TEAMS:0] arbitrator_ack_o;
    wire [NUM_TEAMS:0] arbitrator_we_i;
    wire [NUM_TEAMS:0] arbitrator_stb_i;
    wire [NUM_TEAMS:0] arbitrator_cyc_i;

    //to arbitrator
    wire        wbs_ack_o_m;
    wire [31:0] wbs_dat_o_m;
    //from arbitrator
    wire        wbs_cyc_i_m;
    wire        wbs_stb_i_m;
    wire        wbs_we_i_m;
    wire [31:0] wbs_adr_i_m;
    wire [31:0] wbs_dat_i_m;
    wire [3:0]  wbs_sel_i_m;


    wire [NUM_TEAMS:0]  wbs_ack_i_projects;
    wire                wbs_ack_i_gpio, wbs_ack_i_la, wbs_ack_i_sram;
    
    wire [31:0]         wbs_dat_i_projects [NUM_TEAMS:0];
    wire [31:0]         wbs_dat_i_gpio, wbs_dat_i_la, wbs_dat_i_sram;

    wire [NUM_TEAMS:0]  wbs_cyc_o_projects;
    wire                wbs_cyc_o_gpio, wbs_cyc_o_la, wbs_cyc_o_sram;

    wire [NUM_TEAMS:0]  wbs_stb_o_projects;
    wire                wbs_stb_o_gpio, wbs_stb_o_la, wbs_stb_o_sram;
    
    wire [NUM_TEAMS:0]  wbs_we_o_projects;
    wire                wbs_we_o_gpio, wbs_we_o_la, wbs_we_o_sram;
    
    reg [31:0]         wbs_adr_o_projects [NUM_TEAMS:0];
    wire [31:0]         wbs_adr_o_gpio, wbs_adr_o_la, wbs_adr_o_sram;
    
    reg [31:0]         wbs_dat_o_projects [NUM_TEAMS:0];
    wire [31:0]         wbs_dat_o_gpio, wbs_dat_o_la, wbs_dat_o_sram;
    
    reg [3:0]          wbs_sel_o_projects [NUM_TEAMS:0];
    wire [3:0]          wbs_sel_o_gpio, wbs_sel_o_la, wbs_sel_o_sram;


    //Team 2 Outputs
    assign wbs_ack_i_projects[2]  = 1'b0;
    assign wbs_dat_i_projects[2]  = 32'b0;
    assign designs_la_data_out[2] = 128'b0;
    assign designs_gpio_out[2]    = 38'b0;
    assign designs_gpio_oeb[2]    = 38'h3FFFFFFFFF;
    assign arbitrator_adr_i[2]    = 32'b0;
    assign arbitrator_dat_i[2]    = 32'b0;
    assign arbitrator_sel_i[2]    = 4'b0;
    assign arbitrator_we_i[2]     = 1'b0;
    assign arbitrator_stb_i[2]    = 1'b0;
    assign arbitrator_cyc_i[2]    = 1'b0;    

    // Sample Project Instance
    sample_team_proj_Wrapper sample_team_proj_Wrapper (
    `ifdef USE_POWER_PINS
            .vccd1(vccd1),	// User area 1 1.8V power
            .vssd1(vssd1),	// User area 1 digital ground
    `endif
        //Wishbone Slave and user clk, rst
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),
        .wbs_stb_i(wbs_stb_o_projects[0]),
        .wbs_cyc_i(wbs_cyc_o_projects[0]),
        .wbs_we_i(wbs_we_o_projects[0]),
        .wbs_sel_i(wbs_sel_o_projects[0]),
        .wbs_dat_i(wbs_dat_o_projects[0]),
        .wbs_adr_i(wbs_adr_o_projects[0]),
        .wbs_ack_o(wbs_ack_i_projects[0]),
        .wbs_dat_o(wbs_dat_i_projects[0]),

        // Logic Analyzer
        .la_data_in(la_data_in),
        .la_data_out(designs_la_data_out[0]),
        .la_oenb(la_oenb),

        // GPIOs
        .gpio_in(io_in), // Breakout Board Pins
        .gpio_out(designs_gpio_out[0]), // Breakout Board Pins
        .gpio_oeb(designs_gpio_oeb[0]), // Active Low Output Enable

        .DAT_I(arbitrator_dat_o[0]),
        .ACK_I(arbitrator_ack_o[0]),
        .ADR_O(arbitrator_adr_i[0]),
        .DAT_O(arbitrator_dat_i[0]),
        .SEL_O(arbitrator_sel_i[0]),
        .WE_O  (arbitrator_we_i[0]),
        .STB_O(arbitrator_stb_i[0]),
        .CYC_O(arbitrator_cyc_i[0])
    );

    // Team_01 Project Instance
    team_01_Wrapper team_01_Wrapper (
    `ifdef USE_POWER_PINS
            .vccd1(vccd1),	// User area 1 1.8V power
            .vssd1(vssd1),	// User area 1 digital ground
    `endif
        //Wishbone Slave and user clk, rst
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),
        .wbs_stb_i(wbs_stb_o_projects[1]),
        .wbs_cyc_i(wbs_cyc_o_projects[1]),
        .wbs_we_i(wbs_we_o_projects[1]),
        .wbs_sel_i(wbs_sel_o_projects[1]),
        .wbs_dat_i(wbs_dat_o_projects[1]),
        .wbs_adr_i(wbs_adr_o_projects[1]),
        .wbs_ack_o(wbs_ack_i_projects[1]),
        .wbs_dat_o(wbs_dat_i_projects[1]),

        // Logic Analyzer
        .la_data_in(la_data_in),
        .la_data_out(designs_la_data_out[1]),
        .la_oenb(la_oenb),

        // GPIOs
        .gpio_in(io_in), // Breakout Board Pins
        .gpio_out(designs_gpio_out[1]), // Breakout Board Pins
        .gpio_oeb(designs_gpio_oeb[1]), // Active Low Output Enable

        .DAT_I(arbitrator_dat_o[1]),
        .ACK_I(arbitrator_ack_o[1]),
        .ADR_O(arbitrator_adr_i[1]),
        .DAT_O(arbitrator_dat_i[1]),
        .SEL_O(arbitrator_sel_i[1]),
        .WE_O  (arbitrator_we_i[1]),
        .STB_O(arbitrator_stb_i[1]),
        .CYC_O(arbitrator_cyc_i[1])
    );

		// Team_02 Project Instance
    team_02_Wrapper team_02_Wrapper (
    `ifdef USE_POWER_PINS
            .vccd1(vccd1),	// User area 1 1.8V power
            .vssd1(vssd1),	// User area 1 digital ground
    `endif
        //Wishbone Slave and user clk, rst
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),
        .wbs_stb_i(wbs_stb_o_projects[2]),
        .wbs_cyc_i(wbs_cyc_o_projects[2]),
        .wbs_we_i(wbs_we_o_projects[2]),
        .wbs_sel_i(wbs_sel_o_projects[2]),
        .wbs_dat_i(wbs_dat_o_projects[2]),
        .wbs_adr_i(wbs_adr_o_projects[2]),
        .wbs_ack_o(wbs_ack_i_projects[2]),
        .wbs_dat_o(wbs_dat_i_projects[2]),

        // Logic Analyzer
        .la_data_in(la_data_in),
        .la_data_out(designs_la_data_out[2]),
        .la_oenb(la_oenb),

        // GPIOs
        .gpio_in(io_in), // Breakout Board Pins
        .gpio_out(designs_gpio_out[2]), // Breakout Board Pins
        .gpio_oeb(designs_gpio_oeb[2]), // Active Low Output Enable

        .DAT_I(arbitrator_dat_o[2]),
        .ACK_I(arbitrator_ack_o[2]),
        .ADR_O(arbitrator_adr_i[2]),
        .DAT_O(arbitrator_dat_i[2]),
        .SEL_O(arbitrator_sel_i[2]),
        .WE_O  (arbitrator_we_i[2]),
        .STB_O(arbitrator_stb_i[2]),
        .CYC_O(arbitrator_cyc_i[2])
    );


    // Team_03 Project Instance
    team_03_Wrapper team_03_Wrapper (
    `ifdef USE_POWER_PINS
            .vccd1(vccd1),	// User area 1 1.8V power
            .vssd1(vssd1),	// User area 1 digital ground
    `endif
        //Wishbone Slave and user clk, rst
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),
        .wbs_stb_i(wbs_stb_o_projects[3]),
        .wbs_cyc_i(wbs_cyc_o_projects[3]),
        .wbs_we_i(wbs_we_o_projects[3]),
        .wbs_sel_i(wbs_sel_o_projects[3]),
        .wbs_dat_i(wbs_dat_o_projects[3]),
        .wbs_adr_i(wbs_adr_o_projects[3]),
        .wbs_ack_o(wbs_ack_i_projects[3]),
        .wbs_dat_o(wbs_dat_i_projects[3]),

        // Logic Analyzer
        .la_data_in(la_data_in),
        .la_data_out(designs_la_data_out[3]),
        .la_oenb(la_oenb),

        // GPIOs
        .gpio_in(io_in), // Breakout Board Pins
        .gpio_out(designs_gpio_out[3]), // Breakout Board Pins
        .gpio_oeb(designs_gpio_oeb[3]), // Active Low Output Enable

        .DAT_I(arbitrator_dat_o[3]),
        .ACK_I(arbitrator_ack_o[3]),
        .ADR_O(arbitrator_adr_i[3]),
        .DAT_O(arbitrator_dat_i[3]),
        .SEL_O(arbitrator_sel_i[3]),
        .WE_O  (arbitrator_we_i[3]),
        .STB_O(arbitrator_stb_i[3]),
        .CYC_O(arbitrator_cyc_i[3])
    );

    // Team_04 Project Instance
    team_04_Wrapper team_04_Wrapper (
    `ifdef USE_POWER_PINS
            .vccd1(vccd1),	// User area 1 1.8V power
            .vssd1(vssd1),	// User area 1 digital ground
    `endif
        //Wishbone Slave and user clk, rst
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),
        .wbs_stb_i(wbs_stb_o_projects[4]),
        .wbs_cyc_i(wbs_cyc_o_projects[4]),
        .wbs_we_i(wbs_we_o_projects[4]),
        .wbs_sel_i(wbs_sel_o_projects[4]),
        .wbs_dat_i(wbs_dat_o_projects[4]),
        .wbs_adr_i(wbs_adr_o_projects[4]),
        .wbs_ack_o(wbs_ack_i_projects[4]),
        .wbs_dat_o(wbs_dat_i_projects[4]),

        // Logic Analyzer
        .la_data_in(la_data_in),
        .la_data_out(designs_la_data_out[4]),
        .la_oenb(la_oenb),

        // GPIOs
        .gpio_in(io_in), // Breakout Board Pins
        .gpio_out(designs_gpio_out[4]), // Breakout Board Pins
        .gpio_oeb(designs_gpio_oeb[4]), // Active Low Output Enable

        .DAT_I(arbitrator_dat_o[4]),
        .ACK_I(arbitrator_ack_o[4]),
        .ADR_O(arbitrator_adr_i[4]),
        .DAT_O(arbitrator_dat_i[4]),
        .SEL_O(arbitrator_sel_i[4]),
        .WE_O  (arbitrator_we_i[4]),
        .STB_O(arbitrator_stb_i[4]),
        .CYC_O(arbitrator_cyc_i[4])
    );

    // Team_05 Project Instance
    team_05_Wrapper team_05_Wrapper (
    `ifdef USE_POWER_PINS
            .vccd1(vccd1),	// User area 1 1.8V power
            .vssd1(vssd1),	// User area 1 digital ground
    `endif
        //Wishbone Slave and user clk, rst
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),
        .wbs_stb_i(wbs_stb_o_projects[5]),
        .wbs_cyc_i(wbs_cyc_o_projects[5]),
        .wbs_we_i(wbs_we_o_projects[5]),
        .wbs_sel_i(wbs_sel_o_projects[5]),
        .wbs_dat_i(wbs_dat_o_projects[5]),
        .wbs_adr_i(wbs_adr_o_projects[5]),
        .wbs_ack_o(wbs_ack_i_projects[5]),
        .wbs_dat_o(wbs_dat_i_projects[5]),

        // Logic Analyzer
        .la_data_in(la_data_in),
        .la_data_out(designs_la_data_out[5]),
        .la_oenb(la_oenb),

        // GPIOs
        .gpio_in(io_in), // Breakout Board Pins
        .gpio_out(designs_gpio_out[5]), // Breakout Board Pins
        .gpio_oeb(designs_gpio_oeb[5]), // Active Low Output Enable

        .DAT_I(arbitrator_dat_o[5]),
        .ACK_I(arbitrator_ack_o[5]),
        .ADR_O(arbitrator_adr_i[5]),
        .DAT_O(arbitrator_dat_i[5]),
        .SEL_O(arbitrator_sel_i[5]),
        .WE_O  (arbitrator_we_i[5]),
        .STB_O(arbitrator_stb_i[5]),
        .CYC_O(arbitrator_cyc_i[5])
    );
    
    // Team_06 Project Instance
    team_01_Wrapper team_06_Wrapper (
    `ifdef USE_POWER_PINS
            .vccd1(vccd1),	// User area 1 1.8V power
            .vssd1(vssd1),	// User area 1 digital ground
    `endif
        //Wishbone Slave and user clk, rst
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),
        .wbs_stb_i(wbs_stb_o_projects[6]),
        .wbs_cyc_i(wbs_cyc_o_projects[6]),
        .wbs_we_i(wbs_we_o_projects[6]),
        .wbs_sel_i(wbs_sel_o_projects[6]),
        .wbs_dat_i(wbs_dat_o_projects[6]),
        .wbs_adr_i(wbs_adr_o_projects[6]),
        .wbs_ack_o(wbs_ack_i_projects[6]),
        .wbs_dat_o(wbs_dat_i_projects[6]),

        // Logic Analyzer
        .la_data_in(la_data_in),
        .la_data_out(designs_la_data_out[6]),
        .la_oenb(la_oenb),

        // GPIOs
        .gpio_in(io_in), // Breakout Board Pins
        .gpio_out(designs_gpio_out[6]), // Breakout Board Pins
        .gpio_oeb(designs_gpio_oeb[6]), // Active Low Output Enable

        .DAT_I(arbitrator_dat_o[6]),
        .ACK_I(arbitrator_ack_o[6]),
        .ADR_O(arbitrator_adr_i[6]),
        .DAT_O(arbitrator_dat_i[6]),
        .SEL_O(arbitrator_sel_i[6]),
        .WE_O  (arbitrator_we_i[6]),
        .STB_O(arbitrator_stb_i[6]),
        .CYC_O(arbitrator_cyc_i[6])
    );
    
    // Team_07 Project Instance
    team_07_Wrapper team_07_Wrapper (
    `ifdef USE_POWER_PINS
            .vccd1(vccd1),	// User area 1 1.8V power
            .vssd1(vssd1),	// User area 1 digital ground
    `endif
        //Wishbone Slave and user clk, rst
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),
        .wbs_stb_i(wbs_stb_o_projects[7]),
        .wbs_cyc_i(wbs_cyc_o_projects[7]),
        .wbs_we_i(wbs_we_o_projects[7]),
        .wbs_sel_i(wbs_sel_o_projects[7]),
        .wbs_dat_i(wbs_dat_o_projects[7]),
        .wbs_adr_i(wbs_adr_o_projects[7]),
        .wbs_ack_o(wbs_ack_i_projects[7]),
        .wbs_dat_o(wbs_dat_i_projects[7]),

        // Logic Analyzer
        .la_data_in(la_data_in),
        .la_data_out(designs_la_data_out[7]),
        .la_oenb(la_oenb),

        // GPIOs
        .gpio_in(io_in), // Breakout Board Pins
        .gpio_out(designs_gpio_out[7]), // Breakout Board Pins
        .gpio_oeb(designs_gpio_oeb[7]), // Active Low Output Enable

        .DAT_I(arbitrator_dat_o[7]),
        .ACK_I(arbitrator_ack_o[7]),
        .ADR_O(arbitrator_adr_i[7]),
        .DAT_O(arbitrator_dat_i[7]),
        .SEL_O(arbitrator_sel_i[7]),
        .WE_O  (arbitrator_we_i[7]),
        .STB_O(arbitrator_stb_i[7]),
        .CYC_O(arbitrator_cyc_i[7])
    );

    // Team_08 Project Instance
    team_08_Wrapper team_08_Wrapper (
    `ifdef USE_POWER_PINS
            .vccd1(vccd1),	// User area 1 1.8V power
            .vssd1(vssd1),	// User area 1 digital ground
    `endif
        //Wishbone Slave and user clk, rst
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),
        .wbs_stb_i(wbs_stb_o_projects[8]),
        .wbs_cyc_i(wbs_cyc_o_projects[8]),
        .wbs_we_i(wbs_we_o_projects[8]),
        .wbs_sel_i(wbs_sel_o_projects[8]),
        .wbs_dat_i(wbs_dat_o_projects[8]),
        .wbs_adr_i(wbs_adr_o_projects[8]),
        .wbs_ack_o(wbs_ack_i_projects[8]),
        .wbs_dat_o(wbs_dat_i_projects[8]),

        // Logic Analyzer
        .la_data_in(la_data_in),
        .la_data_out(designs_la_data_out[8]),
        .la_oenb(la_oenb),

        // GPIOs
        .gpio_in(io_in), // Breakout Board Pins
        .gpio_out(designs_gpio_out[8]), // Breakout Board Pins
        .gpio_oeb(designs_gpio_oeb[8]), // Active Low Output Enable

        .DAT_I(arbitrator_dat_o[8]),
        .ACK_I(arbitrator_ack_o[8]),
        .ADR_O(arbitrator_adr_i[8]),
        .DAT_O(arbitrator_dat_i[8]),
        .SEL_O(arbitrator_sel_i[8]),
        .WE_O  (arbitrator_we_i[8]),
        .STB_O(arbitrator_stb_i[8]),
        .CYC_O(arbitrator_cyc_i[8])
    );

    // Team_09 Project Instance
    team_09_Wrapper team_09_Wrapper (
    `ifdef USE_POWER_PINS
            .vccd1(vccd1),	// User area 1 1.8V power
            .vssd1(vssd1),	// User area 1 digital ground
    `endif
        //Wishbone Slave and user clk, rst
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),
        .wbs_stb_i(wbs_stb_o_projects[9]),
        .wbs_cyc_i(wbs_cyc_o_projects[9]),
        .wbs_we_i(wbs_we_o_projects[9]),
        .wbs_sel_i(wbs_sel_o_projects[9]),
        .wbs_dat_i(wbs_dat_o_projects[9]),
        .wbs_adr_i(wbs_adr_o_projects[9]),
        .wbs_ack_o(wbs_ack_i_projects[9]),
        .wbs_dat_o(wbs_dat_i_projects[9]),

        // Logic Analyzer
        .la_data_in(la_data_in),
        .la_data_out(designs_la_data_out[9]),
        .la_oenb(la_oenb),

        // GPIOs
        .gpio_in(io_in), // Breakout Board Pins
        .gpio_out(designs_gpio_out[9]), // Breakout Board Pins
        .gpio_oeb(designs_gpio_oeb[9]), // Active Low Output Enable

        .DAT_I(arbitrator_dat_o[9]),
        .ACK_I(arbitrator_ack_o[9]),
        .ADR_O(arbitrator_adr_i[9]),
        .DAT_O(arbitrator_dat_i[9]),
        .SEL_O(arbitrator_sel_i[9]),
        .WE_O  (arbitrator_we_i[9]),
        .STB_O(arbitrator_stb_i[9]),
        .CYC_O(arbitrator_cyc_i[9])
    );

    // Team_10 Project Instance
    team_10_Wrapper team_10_Wrapper (
    `ifdef USE_POWER_PINS
            .vccd1(vccd1),	// User area 1 1.8V power
            .vssd1(vssd1),	// User area 1 digital ground
    `endif
        //Wishbone Slave and user clk, rst
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),
        .wbs_stb_i(wbs_stb_o_projects[10]),
        .wbs_cyc_i(wbs_cyc_o_projects[10]),
        .wbs_we_i(wbs_we_o_projects[10]),
        .wbs_sel_i(wbs_sel_o_projects[10]),
        .wbs_dat_i(wbs_dat_o_projects[10]),
        .wbs_adr_i(wbs_adr_o_projects[10]),
        .wbs_ack_o(wbs_ack_i_projects[10]),
        .wbs_dat_o(wbs_dat_i_projects[10]),

        // Logic Analyzer
        .la_data_in(la_data_in),
        .la_data_out(designs_la_data_out[10]),
        .la_oenb(la_oenb),

        // GPIOs
        .gpio_in(io_in), // Breakout Board Pins
        .gpio_out(designs_gpio_out[10]), // Breakout Board Pins
        .gpio_oeb(designs_gpio_oeb[10]), // Active Low Output Enable

        .DAT_I(arbitrator_dat_o[10]),
        .ACK_I(arbitrator_ack_o[10]),
        .ADR_O(arbitrator_adr_i[10]),
        .DAT_O(arbitrator_dat_i[10]),
        .SEL_O(arbitrator_sel_i[10]),
        .WE_O  (arbitrator_we_i[10]),
        .STB_O(arbitrator_stb_i[10]),
        .CYC_O(arbitrator_cyc_i[10])
    );

    // Team_11 Project Instance
    // (this one is different - much smaller design)
    team_11_Wrapper team_11_Wrapper (
    `ifdef USE_POWER_PINS
            .vccd1(vccd1),	// User area 1 1.8V power
            .vssd1(vssd1),	// User area 1 digital ground
    `endif
        //Wishbone Slave and user clk, rst
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),
        .wbs_stb_i(wbs_stb_o_projects[11]),
        .wbs_cyc_i(wbs_cyc_o_projects[11]),
        .wbs_we_i(wbs_we_o_projects[11]),
        .wbs_sel_i(wbs_sel_o_projects[11]),
        .wbs_dat_i(wbs_dat_o_projects[11]),
        .wbs_adr_i(wbs_adr_o_projects[11]),
        .wbs_ack_o(wbs_ack_i_projects[11]),
        .wbs_dat_o(wbs_dat_i_projects[11]),

        // Logic Analyzer
        .la_data_in(la_data_in),
        .la_data_out(designs_la_data_out[11]),
        .la_oenb(la_oenb),

        // GPIOs
        .gpio_in(io_in), // Breakout Board Pins
        .gpio_out(designs_gpio_out[11]), // Breakout Board Pins
        .gpio_oeb(designs_gpio_oeb[11]), // Active Low Output Enable

        .DAT_I(arbitrator_dat_o[11]),
        .ACK_I(arbitrator_ack_o[11]),
        .ADR_O(arbitrator_adr_i[11]),
        .DAT_O(arbitrator_dat_i[11]),
        .SEL_O(arbitrator_sel_i[11]),
        .WE_O  (arbitrator_we_i[11]),
        .STB_O(arbitrator_stb_i[11]),
        .CYC_O(arbitrator_cyc_i[11])
    );

    // Team_12 Project Instance
    team_12_Wrapper team_12_Wrapper (
    `ifdef USE_POWER_PINS
            .vccd1(vccd1),	// User area 1 1.8V power
            .vssd1(vssd1),	// User area 1 digital ground
    `endif
        //Wishbone Slave and user clk, rst
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),
        .wbs_stb_i(wbs_stb_o_projects[12]),
        .wbs_cyc_i(wbs_cyc_o_projects[12]),
        .wbs_we_i(wbs_we_o_projects[12]),
        .wbs_sel_i(wbs_sel_o_projects[12]),
        .wbs_dat_i(wbs_dat_o_projects[12]),
        .wbs_adr_i(wbs_adr_o_projects[12]),
        .wbs_ack_o(wbs_ack_i_projects[12]),
        .wbs_dat_o(wbs_dat_i_projects[12]),

        // Logic Analyzer
        .la_data_in(la_data_in),
        .la_data_out(designs_la_data_out[12]),
        .la_oenb(la_oenb),

        // GPIOs
        .gpio_in(io_in), // Breakout Board Pins
        .gpio_out(designs_gpio_out[12]), // Breakout Board Pins
        .gpio_oeb(designs_gpio_oeb[12]), // Active Low Output Enable

        .DAT_I(arbitrator_dat_o[12]),
        .ACK_I(arbitrator_ack_o[12]),
        .ADR_O(arbitrator_adr_i[12]),
        .DAT_O(arbitrator_dat_i[12]),
        .SEL_O(arbitrator_sel_i[12]),
        .WE_O  (arbitrator_we_i[12]),
        .STB_O(arbitrator_stb_i[12]),
        .CYC_O(arbitrator_cyc_i[12])
    );
    

    // Flattened GPIO outputs
    reg [38*(NUM_TEAMS+1)-1:0] designs_gpio_out_flat;
    reg [38*(NUM_TEAMS+1)-1:0] designs_gpio_oeb_flat;

    // Flattening of GPIO outputs
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
        .wbs_stb_i(wbs_stb_o_gpio),
        .wbs_cyc_i(wbs_cyc_o_gpio),
        .wbs_we_i(wbs_we_o_gpio),
        .wbs_sel_i(wbs_sel_o_gpio),
        .wbs_dat_i(wbs_dat_o_gpio),
        .wbs_adr_i(wbs_adr_o_gpio),
        .wbs_ack_o(wbs_ack_i_gpio),
        .wbs_dat_o(wbs_dat_i_gpio),
        
        // GPIOs
        .designs_gpio_out_flat(designs_gpio_out_flat),
        .designs_gpio_oeb_flat(designs_gpio_oeb_flat),
        .gpio_out(io_out),
        .gpio_oeb(io_oeb)
    );

    // Flattened LA outputs
    reg [128*(NUM_TEAMS+1)-1:0] designs_la_data_out_flat;

    // Flattening of LA outputs
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
    `ifdef USE_POWER_PINS
            .vccd1(vccd1),	// User area 1 1.8V power
            .vssd1(vssd1),	// User area 1 digital ground
    `endif
        // Wishbone Slave ports (WB MI A)
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),
        .wbs_stb_i(wbs_stb_o_la),
        .wbs_cyc_i(wbs_cyc_o_la),
        .wbs_we_i(wbs_we_o_la),
        .wbs_sel_i(wbs_sel_o_la),
        .wbs_dat_i(wbs_dat_o_la),
        .wbs_adr_i(wbs_adr_o_la),
        .wbs_ack_o(wbs_ack_i_la),
        .wbs_dat_o(wbs_dat_i_la),
        
        // LA
        .designs_la_data_out_flat(designs_la_data_out_flat),
        .la_data_out(la_data_out)
    );

    // Flattened wbs_dat_i_projects
    reg [32*(NUM_TEAMS+1)-1:0] wbs_dat_i_projects_flat;

    wire [32*(NUM_TEAMS+1)-1:0] wbs_adr_o_projects_flat;
    wire [32*(NUM_TEAMS+1)-1:0] wbs_dat_o_projects_flat;
    wire [4*(NUM_TEAMS+1)-1:0] wbs_sel_o_projects_flat;

    // Flattening of wbs_dat_i_projects
    integer i3;
    always @* begin
        for (i3 = 0; i3 <= NUM_TEAMS; i3 = i3 + 1) begin
            wbs_dat_i_projects_flat[i3*32 +: 32] = wbs_dat_i_projects[i3];//[38i:38(i+1)-1]

            wbs_adr_o_projects[i3] = wbs_adr_o_projects_flat[i3*32 +: 32];//[38i:38(i+1)-1]
            wbs_dat_o_projects[i3] = wbs_dat_o_projects_flat[i3*32 +: 32];//[38i:38(i+1)-1]
            wbs_sel_o_projects[i3] = wbs_sel_o_projects_flat[i3*4 +: 4];//[38i:38(i+1)-1]
        end
    end

    //Flattening of arbitrator signals
    reg [32*(NUM_TEAMS+1)-1:0] arbitrator_dat_i_flat;
    reg [32*(NUM_TEAMS+1)-1:0] arbitrator_adr_i_flat;
    wire [32*(NUM_TEAMS+1)-1:0] arbitrator_dat_o_flat;
    reg [4*(NUM_TEAMS+1)-1:0] arbitrator_sel_i_flat;
    
    integer i4;
    always @* begin
        for (i4 = 0; i4 <= NUM_TEAMS; i4 = i4 + 1) begin
            arbitrator_dat_i_flat[i4*32 +: 32] = arbitrator_dat_i[i4];
            arbitrator_adr_i_flat[i4*32 +: 32] = arbitrator_adr_i[i4];
            arbitrator_sel_i_flat[i4* 4 +:  4] = arbitrator_sel_i[i4];

            arbitrator_dat_o[i4] = arbitrator_dat_o_flat[i4*32 +: 32];
        end
    end

    // Wishbone Arbitrator
    // everywhere with squigly brackets is where more manager signals can be concatinated!!!
    wishbone_arbitrator #(
        .NUM_MANAGERS(NUM_TEAMS+2)//+2 for caravel core processor and sample project
    ) wb_arbitrator (
        
    `ifdef USE_POWER_PINS
        .vccd1(vccd1),	// User area 1 1.8V power
        .vssd1(vssd1),	// User area 1 digital ground
    `endif

        .CLK(wb_clk_i),
        .nRST(~wb_rst_i),

        //manager to arbitrator, input
        .A_ADR_I({arbitrator_adr_i_flat, wbs_adr_i}),
        .A_DAT_I({arbitrator_dat_i_flat, wbs_dat_i}),
        .A_SEL_I({arbitrator_sel_i_flat, wbs_sel_i}),
        .A_WE_I({arbitrator_we_i, wbs_we_i}),
        .A_STB_I({arbitrator_stb_i, wbs_stb_i}),
        .A_CYC_I({arbitrator_cyc_i, wbs_cyc_i}),

        //arbitrator to manager, output
        .A_DAT_O({arbitrator_dat_o_flat, wbs_dat_o}),
        .A_ACK_O({arbitrator_ack_o, wbs_ack_o}),

        //arbitrator to peripheral, input
        .DAT_I(wbs_dat_o_m),
        .ACK_I(wbs_ack_o_m),

        //arbitrator to peripheral, output
        .ADR_O(wbs_adr_i_m),
        .DAT_O(wbs_dat_i_m),
        .SEL_O(wbs_sel_i_m),
        .WE_O(wbs_we_i_m),
        .STB_O(wbs_stb_i_m),
        .CYC_O(wbs_cyc_i_m)
    );

    wishbone_decoder #(
        .NUM_TEAMS(NUM_TEAMS)
    ) wb_decoder (

    `ifdef USE_POWER_PINS
        .vccd1(vccd1),	// User area 1 1.8V power
        .vssd1(vssd1),	// User area 1 digital ground
    `endif

        .CLK(wb_clk_i),
        .nRST(~wb_rst_i),

        //muxxing signals that go to manager
        .wbs_ack_i_periph({wbs_ack_i_projects, wbs_ack_i_la, wbs_ack_i_gpio, wbs_ack_i_sram}),
        .wbs_dat_i_periph({wbs_dat_i_projects_flat, wbs_dat_i_la, wbs_dat_i_gpio, wbs_dat_i_sram}),

        .wbs_ack_o_m(wbs_ack_o_m),
        .wbs_dat_o_m(wbs_dat_o_m),

        //muxxing signals that come from manager
        .wbs_cyc_i_m(wbs_cyc_i_m),
        .wbs_stb_i_m(wbs_stb_i_m),
        .wbs_we_i_m(wbs_we_i_m),
        .wbs_adr_i_m(wbs_adr_i_m),
        .wbs_dat_i_m(wbs_dat_i_m),
        .wbs_sel_i_m(wbs_sel_i_m),

        .wbs_cyc_o_periph({wbs_cyc_o_projects, wbs_cyc_o_la, wbs_cyc_o_gpio, wbs_cyc_o_sram}),
        .wbs_stb_o_periph({wbs_stb_o_projects, wbs_stb_o_la, wbs_stb_o_gpio, wbs_stb_o_sram}),
        .wbs_we_o_periph({wbs_we_o_projects, wbs_we_o_la, wbs_we_o_gpio, wbs_we_o_sram}),
        .wbs_adr_o_periph({wbs_adr_o_projects_flat, wbs_adr_o_la, wbs_adr_o_gpio, wbs_adr_o_sram}),
        .wbs_dat_o_periph({wbs_dat_o_projects_flat, wbs_dat_o_la, wbs_dat_o_gpio, wbs_dat_o_sram}),
        .wbs_sel_o_periph({wbs_sel_o_projects_flat, wbs_sel_o_la, wbs_sel_o_gpio, wbs_sel_o_sram})
    );

    // SRAM
    SRAM_1024x32_wb_wrapper sram (
    `ifdef USE_POWER_PINS
        .VPWR(vccd1),	// User area 1 1.8V power
        .VGND(vssd1),	// User area 1 digital ground
    `endif

        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),

        // MGMT SoC Wishbone Slave

        .wbs_stb_i(wbs_stb_o_sram),
        .wbs_cyc_i(wbs_cyc_o_sram),
        .wbs_we_i(wbs_we_o_sram),
        .wbs_sel_i(wbs_sel_o_sram),
        .wbs_dat_i(wbs_dat_o_sram),
        .wbs_adr_i(wbs_adr_o_sram),
        .wbs_ack_o(wbs_ack_i_sram),
        .wbs_dat_o(wbs_dat_i_sram)
    );
endmodule

`default_nettype wire
