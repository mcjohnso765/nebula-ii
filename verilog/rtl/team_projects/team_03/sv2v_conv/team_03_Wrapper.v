module team_03_Wrapper (
	ncs,
	wb_clk_i,
	wb_rst_i,
	wbs_stb_i,
	wbs_cyc_i,
	wbs_we_i,
	wbs_sel_i,
	wbs_dat_i,
	wbs_adr_i,
	wbs_ack_o,
	wbs_dat_o,
	la_data_in,
	la_data_out,
	la_oenb,
	gpio_in,
	gpio_out,
	gpio_oeb,
	irq,
	ADR_O,
	DAT_O,
	SEL_O,
	WE_O,
	STB_O,
	CYC_O,
	DAT_I,
	ACK_I
);
	input wire ncs;
	input wire wb_clk_i;
	input wire wb_rst_i;
	input wire wbs_stb_i;
	input wire wbs_cyc_i;
	input wire wbs_we_i;
	input wire [3:0] wbs_sel_i;
	input wire [31:0] wbs_dat_i;
	input wire [31:0] wbs_adr_i;
	output wire wbs_ack_o;
	output wire [31:0] wbs_dat_o;
	input wire [127:0] la_data_in;
	output wire [127:0] la_data_out;
	input wire [127:0] la_oenb;
	input wire [37:0] gpio_in;
	output wire [37:0] gpio_out;
	output wire [37:0] gpio_oeb;
	output wire [2:0] irq;
	output wire [31:0] ADR_O;
	output wire [31:0] DAT_O;
	output wire [3:0] SEL_O;
	output wire WE_O;
	output wire STB_O;
	output wire CYC_O;
	input wire [31:0] DAT_I;
	input wire ACK_I;
	assign irq = 3'b000;
	assign gpio_oeb[4:1] = 4'b1111;
	assign gpio_out[4:1] = 4'b0000;
	team_03_WB team_03_WB(
		.ext_clk(wb_clk_i),
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
		.la_data_in(la_data_in),
		.la_data_out(la_data_out),
		.la_oenb(la_oenb),
		.gpio_in({gpio_in[37:5], gpio_in[0]}),
		.gpio_out({gpio_out[37:5], gpio_out[0]}),
		.gpio_oeb({gpio_oeb[37:5], gpio_oeb[0]}),
		.DAT_I(DAT_I),
		.ACK_I(ACK_I),
		.ADR_O(ADR_O),
		.DAT_O(DAT_O),
		.SEL_O(SEL_O),
		.WE_O(WE_O),
		.STB_O(STB_O),
		.CYC_O(CYC_O)
	);
endmodule
