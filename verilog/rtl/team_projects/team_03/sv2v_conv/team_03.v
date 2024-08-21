`default_nettype none
module team_03 (
	clk,
	nrst,
	en,
	la_data_in,
	la_data_out,
	la_oenb,
	gpio_in,
	gpio_out,
	gpio_oeb,
	ADR_O,
	DAT_O,
	SEL_O,
	WE_O,
	STB_O,
	CYC_O,
	DAT_I,
	ACK_I
);
	input wire clk;
	input wire nrst;
	input wire en;
	input wire [127:0] la_data_in;
	output wire [127:0] la_data_out;
	input wire [127:0] la_oenb;
	input wire [33:0] gpio_in;
	output wire [33:0] gpio_out;
	output wire [33:0] gpio_oeb;
	output wire [31:0] ADR_O;
	output wire [31:0] DAT_O;
	output wire [3:0] SEL_O;
	output wire WE_O;
	output wire STB_O;
	output wire CYC_O;
	input wire [31:0] DAT_I;
	input wire ACK_I;
	assign la_data_out = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
	wire WRITE_I;
	wire READ_I;
	wire BUSY_O;
	wire [31:0] CPU_DAT_O;
	wire [31:0] CPU_DAT_I;
	wire [31:0] ADR_I;
	wire [3:0] SEL_I;
	core core(
		.clock(clk),
		.reset(!nrst),
		.en(en),
		.CPU_DAT_O(CPU_DAT_O),
		.BUSY_O(BUSY_O),
		.CPU_DAT_I(CPU_DAT_I),
		.ADR_I(ADR_I),
		.SEL_I(SEL_I),
		.WRITE_I(WRITE_I),
		.READ_I(READ_I),
		.gpio_in(gpio_in),
		.gpio_out(gpio_out),
		.gpio_oeb(gpio_oeb)
	);
	wishbone_manager wb(
		.CLK(clk),
		.nRST(nrst),
		.DAT_I(DAT_I),
		.ACK_I(ACK_I),
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
		.BUSY_O(BUSY_O)
	);
endmodule
