/*
	Copyright 2024 Purdue University

	Author: None (None)

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

	    http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.

*/

/* THIS FILE IS GENERATED, DO NOT EDIT */

// `timescale			1ns/1ps
`default_nettype	none

`define				WB_AW		32

// `include			"wb_wrapper.vh"

module team_04_WB (
	`ifdef USE_POWER_PINS
		inout vccd1,	// User area 1 1.8V supply
		inout vssd1,	// User area 1 digital ground
	`endif
	`WB_SLAVE_PORTS,
	// input	wire	[32-1:0]	la_data_in,
	// output	wire	[32-1:0]	la_data_out,
	// input	wire	[32-1:0]	la_oenb,
	input	wire	[34-1:0]	gpio_in,
	output	wire	[34-1:0]	gpio_out,
	output	wire	[34-1:0]	gpio_oeb,
	output	wire	[32-1:0]	ADR_O,
	output	wire	[32-1:0]	DAT_O,
	output	wire	[4-1:0]	SEL_O,
	output	wire	[1-1:0]	WE_O,
	output	wire	[1-1:0]	STB_O,
	output	wire	[1-1:0]	CYC_O,
	input	wire	[32-1:0]	DAT_I,
	input	wire	[1-1:0]	ACK_I,
	input   wire                nrst
);

	localparam	EN_VAL_REG_OFFSET = `WB_AW'h30040000;
	localparam	ADDR_START_VAL_REG_OFFSET = `WB_AW'h30040004;
	localparam	MEM_SIZE_REG_REG_OFFSET = `WB_AW'h30040008;
	wire		clk = clk_i;


	`WB_CTRL_SIGNALS

	wire [1-1:0]	en;
	wire [32-1:0]	mem_adr_start;
	wire [32-1:0]	memory_size;

	assign IRQ = 0;

	// Register Definitions
	reg [0:0]	EN_VAL_REG;
	assign	en = EN_VAL_REG;
	`WB_REG(EN_VAL_REG, 0, 1)

	reg [31:0]	ADDR_START_VAL_REG;
	assign	mem_adr_start = ADDR_START_VAL_REG;
	`WB_REG(ADDR_START_VAL_REG, 0, 32)

	reg [31:0]	MEM_SIZE_REG_REG;
	assign	memory_size = MEM_SIZE_REG_REG;
	`WB_REG(MEM_SIZE_REG_REG, 0, 32)

	team_04 instance_to_wrap (
		`ifdef USE_POWER_PINS
                .vccd1(vccd1),	// User area 1 1.8V power
                .vssd1(vssd1),	// User area 1 digital ground
        `endif
		.clk(clk),
		.nrst(nrst),
		.en(en),
		.mem_adr_start(mem_adr_start),
		.memory_size(memory_size),
		// .la_data_in(la_data_in),
		// .la_data_out(la_data_out),
		// .la_oenb(la_oenb),
		.gpio_in(gpio_in),
		.gpio_out(gpio_out),
		.gpio_oeb(gpio_oeb),
		.ADR_O(ADR_O),
		.DAT_O(DAT_O),
		.SEL_O(SEL_O),
		.WE_O(WE_O),
		.STB_O(STB_O),
		.CYC_O(CYC_O),
		.DAT_I(DAT_I),
		.ACK_I(ACK_I)
	);

	assign	dat_o = 
			(adr_i[`WB_AW-1:0] == EN_VAL_REG_OFFSET)	? EN_VAL_REG :
			(adr_i[`WB_AW-1:0] == ADDR_START_VAL_REG_OFFSET)	? ADDR_START_VAL_REG :
			(adr_i[`WB_AW-1:0] == MEM_SIZE_REG_REG_OFFSET)	? MEM_SIZE_REG_REG :
			32'hDEADBEEF;

	always @ (posedge clk_i or posedge rst_i)
		if(rst_i)
			ack_o <= 1'b0;
		else if(wb_valid & ~ack_o)
			ack_o <= 1'b1;
		else
			ack_o <= 1'b0;
endmodule
