/*
	Copyright 2024 Purdue University

	Author: Aidan Jacobsen (jacobse7@purdue.edu)

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

//`timescale			1ns/1ps
`default_nettype	none

`define				WB_AW		32

// `include			"wb_wrapper.vh"

module gpio_control_WB #(
    parameter NUM_TEAMS = 12
)
(
	`WB_SLAVE_PORTS,
	input	wire	[38*(NUM_TEAMS+1)-1:0] designs_gpio_oeb_flat,
	input	wire	[38*(NUM_TEAMS+1)-1:0] designs_gpio_out_flat,
	output	wire	[38-1:0]	muxxed_io_oeb,
	output	wire	[38-1:0]	muxxed_io_out
);

	localparam	PIN_0TO7_SEL_VAL_REG_OFFSET = `WB_AW'h32000000;
	localparam	PIN_8TO15_SEL_VAL_REG_OFFSET = `WB_AW'h32000004;
	localparam	PIN_16TO23_SEL_VAL_REG_OFFSET = `WB_AW'h32000008;
	localparam	PIN_24TO731_SEL_VAL_REG_OFFSET = `WB_AW'h3200000C;
	localparam	PIN_32TO37_SEL_VAL_REG_OFFSET = `WB_AW'h32000010;
	wire		clk = clk_i;
	wire		nrst = (~rst_i);


	`WB_CTRL_SIGNALS

	wire [32-1:0]	pin_0to7_sel;
	wire [32-1:0]	pin_8to15_sel;
	wire [32-1:0]	pin_16to23_sel;
	wire [32-1:0]	pin_24to31_sel;
	wire [24-1:0]	pin_32to37_sel;

	// Register Definitions
	reg [31:0]	PIN_0TO7_SEL_VAL_REG;
	assign	pin_0to7_sel = PIN_0TO7_SEL_VAL_REG;
	`WB_REG(PIN_0TO7_SEL_VAL_REG, 0, 32)

	reg [31:0]	PIN_8TO15_SEL_VAL_REG;
	assign	pin_8to15_sel = PIN_8TO15_SEL_VAL_REG;
	`WB_REG(PIN_8TO15_SEL_VAL_REG, 0, 32)

	reg [31:0]	PIN_16TO23_SEL_VAL_REG;
	assign	pin_16to23_sel = PIN_16TO23_SEL_VAL_REG;
	`WB_REG(PIN_16TO23_SEL_VAL_REG, 0, 32)

	reg [31:0]	PIN_24TO731_SEL_VAL_REG;
	assign	pin_24to31_sel = PIN_24TO731_SEL_VAL_REG;
	`WB_REG(PIN_24TO731_SEL_VAL_REG, 0, 32)

	reg [23:0]	PIN_32TO37_SEL_VAL_REG;
	assign	pin_32to37_sel = PIN_32TO37_SEL_VAL_REG;
	`WB_REG(PIN_32TO37_SEL_VAL_REG, 0, 24)

	gpio_control #(
        .NUM_TEAMS(NUM_TEAMS)
    ) instance_to_wrap (
		.clk(clk),
		.nrst(nrst),
		.pin_0to7_sel(pin_0to7_sel),
		.pin_8to15_sel(pin_8to15_sel),
		.pin_16to23_sel(pin_16to23_sel),
		.pin_24to31_sel(pin_24to31_sel),
		.pin_32to37_sel(pin_32to37_sel),
		.designs_gpio_oeb_flat(designs_gpio_oeb_flat),
		.designs_gpio_out_flat(designs_gpio_out_flat),
		.muxxed_io_oeb(muxxed_io_oeb),
		.muxxed_io_out(muxxed_io_out)
	);

	assign	dat_o = 
			(adr_i[`WB_AW-1:0] == PIN_0TO7_SEL_VAL_REG_OFFSET)	? PIN_0TO7_SEL_VAL_REG :
			(adr_i[`WB_AW-1:0] == PIN_8TO15_SEL_VAL_REG_OFFSET)	? PIN_8TO15_SEL_VAL_REG :
			(adr_i[`WB_AW-1:0] == PIN_16TO23_SEL_VAL_REG_OFFSET)	? PIN_16TO23_SEL_VAL_REG :
			(adr_i[`WB_AW-1:0] == PIN_24TO731_SEL_VAL_REG_OFFSET)	? PIN_24TO731_SEL_VAL_REG :
			(adr_i[`WB_AW-1:0] == PIN_32TO37_SEL_VAL_REG_OFFSET)	? PIN_32TO37_SEL_VAL_REG :
			32'hDEADBEEF;

	always @ (posedge clk_i or posedge rst_i)
		if(rst_i)
			ack_o <= 1'b0;
		else if(wb_valid & ~ack_o)
			ack_o <= 1'b1;
		else
			ack_o <= 1'b0;
endmodule
