/*
	Copyright 2222 Purdue University

	Author: lol (lol)

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

`timescale			1ns/1ps
`default_nettype	none

`define				WB_AW		32

// `include			"wb_wrapper.vh"

module team_05_WB (
	`WB_SLAVE_PORTS,
	input	wire	[128-1:0]	la_data_in,
	output	wire	[128-1:0]	la_data_out,
	input	wire	[128-1:0]	la_oenb,
	input	wire	[34-1:0]	gpio_in,
	output	wire	[34-1:0]	gpio_out,
	output	wire	[34-1:0]	gpio_oeb,
	output	wire	[32-1:0]	ADR_O,
	output	wire	[32-1:0]	A_ADR_I,
	output	wire	[32-1:0]	A_DAT_I,
	output	wire	[4-1:0]	A_SEL_I,
	output	wire	[1-1:0]	A_WE_I,
	output	wire	[1-1:0]	A_STB_I,
	output	wire	[1-1:0]	A_CYC_I
);

	localparam	EN_VAL_REG_OFFSET = `WB_AW'h30050000;
	wire		clk = clk_i;
	wire		nrst = (~rst_i);


	`WB_CTRL_SIGNALS

	wire [1-1:0]	en;

	// Register Definitions
	reg [0:0]	EN_VAL_REG;
	assign	en = EN_VAL_REG;
	`WB_REG(EN_VAL_REG, 0, 1)

	team_05 instance_to_wrap (
		.clk(clk),
		.nrst(nrst),
		.en(en),
		.la_data_in(la_data_in),
		.la_data_out(la_data_out),
		.la_oenb(la_oenb),
		.gpio_in(gpio_in),
		.gpio_out(gpio_out),
		.gpio_oeb(gpio_oeb),
		.ADR_O(ADR_O),
		.A_ADR_I(A_ADR_I),
		.A_DAT_I(A_DAT_I),
		.A_SEL_I(A_SEL_I),
		.A_WE_I(A_WE_I),
		.A_STB_I(A_STB_I),
		.A_CYC_I(A_CYC_I)
	);

	assign	dat_o = 
			(adr_i[`WB_AW-1:0] == EN_VAL_REG_OFFSET)	? EN_VAL_REG :
			32'hDEADBEEF;

	always @ (posedge clk_i or posedge rst_i)
		if(rst_i)
			ack_o <= 1'b0;
		else if(wb_valid & ~ack_o)
			ack_o <= 1'b1;
		else
			ack_o <= 1'b0;
endmodule
