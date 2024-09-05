// FFRAM Wishbone Wrapper

module ffram_WB_Wrapper #(
	parameter WORD_NUM = 256,
	parameter WORD_W = 32,
	parameter AD_WIDTH = $clog2(WORD_NUM)
)
(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif
    // Wishbone slave ports
    input logic wb_clk_i,
    input logic wb_rst_i,
    input logic wbs_stb_i,
    input logic wbs_cyc_i,
    input logic wbs_we_i,
    input logic [3:0] wbs_sel_i,
    input logic [31:0] wbs_dat_i,
    input logic [31:0] wbs_adr_i,
    output logic  wbs_ack_o,
    output logic [31:0] wbs_dat_o
);
    // Declare signals to FFRAM
	logic [WORD_W-1:0] d_in, d_out, bit_en;
    logic [AD_WIDTH-1:0] addr;
	logic clk, rst, r_en, wb_en;

	// converting from byte address to word address
	logic [31:0] addr_shifted;
	assign addr_shifted = wbs_adr_i >> 2;
	
	// inputs to ffram
    assign wb_en = wbs_stb_i & wbs_cyc_i;
    assign r_en = ~wbs_we_i;
    assign addr = addr_shifted[AD_WIDTH-1:0];
	assign clk = wb_clk_i;
	assign rst = wb_rst_i;
    assign d_in = wbs_dat_i;
    assign bit_en = {{8{wbs_sel_i[3]}}, {8{wbs_sel_i[2]}}, {8{wbs_sel_i[1]}}, {8{wbs_sel_i[0]}}};

    // outputs from ffram
    assign wbs_dat_o = d_out;
    always_ff @(posedge wb_clk_i, posedge wb_rst_i) begin
        if (wb_rst_i)
            wbs_ack_o <= 0;

        else if (wb_en & ~wbs_ack_o)
            wbs_ack_o <= 1'b1;
        else
            wbs_ack_o <= 1'b0;
    end

	// FFRAM Instance
	ffram #(.WORD_NUM(WORD_NUM), .WORD_W(WORD_W))
    ffram_inst (
		.clk(clk),
		.rst(rst),
		.d_in(d_in),
		.d_out(d_out),
		.addr(addr),
		.wb_en(wb_en),
		.bit_en(bit_en),
		.r_en(r_en)
	);

endmodule