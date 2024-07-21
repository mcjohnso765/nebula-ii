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
    output [2:0] irq
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

    //Team 3 Outputs
    assign wbs_ack_i_projects[3]  = 1'b0;
    assign wbs_dat_i_projects[3]  = 32'b0;
    assign designs_la_data_out[3] = 128'b0;
    assign designs_gpio_out[3]    = 38'b0;
    assign designs_gpio_oeb[3]    = 38'h3FFFFFFFFF;
    assign arbitrator_adr_i[3]    = 32'b0;
    assign arbitrator_dat_i[3]    = 32'b0;
    assign arbitrator_sel_i[3]    = 4'b0;
    assign arbitrator_we_i[3]     = 1'b0;
    assign arbitrator_stb_i[3]    = 1'b0;
    assign arbitrator_cyc_i[3]    = 1'b0;

    //Team 8 Outputs
    assign wbs_ack_i_projects[8]  = 1'b0;
    assign wbs_dat_i_projects[8]  = 32'b0;
    assign designs_la_data_out[8] = 128'b0;
    assign designs_gpio_out[8]    = 38'b0;
    assign designs_gpio_oeb[8]    = 38'h3FFFFFFFFF;
    assign arbitrator_adr_i[8]    = 32'b0;
    assign arbitrator_dat_i[8]    = 32'b0;
    assign arbitrator_sel_i[8]    = 4'b0;
    assign arbitrator_we_i[8]     = 1'b0;
    assign arbitrator_stb_i[8]    = 1'b0;
    assign arbitrator_cyc_i[8]    = 1'b0;

    //Team 11 Outputs
    assign wbs_ack_i_projects[11]  = 1'b0;
    assign wbs_dat_i_projects[11]  = 32'b0;
    assign designs_la_data_out[11] = 128'b0;
    assign designs_gpio_out[11]    = 38'b0;
    assign designs_gpio_oeb[11]    = 38'h3FFFFFFFFF;
    assign arbitrator_adr_i[11]    = 32'b0;
    assign arbitrator_dat_i[11]    = 32'b0;
    assign arbitrator_sel_i[11]    = 4'b0;
    assign arbitrator_we_i[11]     = 1'b0;
    assign arbitrator_stb_i[11]    = 1'b0;
    assign arbitrator_cyc_i[11]    = 1'b0;
    
    //Team 12 Outputs
    assign wbs_ack_i_projects[12]  = 1'b0;
    assign wbs_dat_i_projects[12]  = 32'b0;
    assign designs_la_data_out[12] = 128'b0;
    assign designs_gpio_out[12]    = 38'b0;
    assign designs_gpio_oeb[12]    = 38'h3FFFFFFFFF;
    assign arbitrator_adr_i[12]    = 32'b0;
    assign arbitrator_dat_i[12]    = 32'b0;
    assign arbitrator_sel_i[12]    = 4'b0;
    assign arbitrator_we_i[12]     = 1'b0;
    assign arbitrator_stb_i[12]    = 1'b0;
    assign arbitrator_cyc_i[12]    = 1'b0;

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
        .la_data_out(designs_la_data_out[8]),
        .la_oenb(la_oenb),

        // GPIOs
        .gpio_in(io_in), // Breakout Board Pins
        .gpio_out(designs_gpio_out[1]), // Breakout Board Pins
        .gpio_oeb(designs_gpio_oeb[1]) // Active Low Output Enable
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
    SRAM_1024x32 sram (
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
