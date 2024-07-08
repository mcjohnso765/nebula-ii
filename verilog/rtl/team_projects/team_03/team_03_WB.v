/*
	Copyright 24 Purdue University

	Author: JERRY_CHEN (chen4419@purdue.edu)

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

`define				WB_AW		16

// `include			"wb_wrapper.vh"

module team_03_WB (
`ifdef USE_POWER_PINS
	inout VPWR,
	inout VGND,
`endif
	`WB_SLAVE_PORTS,
	input	wire	[128-1:0]	la_data_in,
	output	wire	[128-1:0]	la_data_out,
	input	wire	[128-1:0]	la_oenb,
	input	wire	[34-1:0]	gpio_in,
	output	wire	[34-1:0]	gpio_out,
	output	wire	[34-1:0]	gpio_oeb,
	input	wire	[32-1:0]	DAT_I,
	input	wire	[1-1:0]	ACK_I,
	output	wire	[32-1:0]	ADR_O,
	output	wire	[32-1:0]	DAT_O,
	output	wire	[4-1:0]	SEL_O,
	output	wire	[1-1:0]	WE_O,
	output	wire	[1-1:0]	STB_O,
	output	wire	[1-1:0]	CYC_O
);

	assign IRQ = 0;

	localparam	EN_VAL_REG_OFFSET = `WB_AW'h0000;

        wire clk_g;
        wire clk_gated_en = GCLK_REG[0];

    (* keep *) sky130_fd_sc_hd__dlclkp_4 clk_gate(
    `ifdef USE_POWER_PINS 
        .VPWR(VPWR), 
        .VGND(VGND), 
        .VNB(VGND),
		.VPB(VPWR),
    `endif 
        .GCLK(clk_g), 
        .GATE(clk_gated_en), 
        .CLK(clk_i)
        );
        
	wire		clk = clk_g;
	wire		nrst = (~rst_i);


	`WB_CTRL_SIGNALS

	wire [1-1:0]	en;

	// Register Definitions
	reg [0:0]	EN_VAL_REG;
	assign	en = EN_VAL_REG;
	`WB_REG(EN_VAL_REG, 0, 1)

	localparam	GCLK_REG_OFFSET = `WB_AW'hFF10;
	reg [0:0] GCLK_REG;
	`WB_REG(GCLK_REG, 0, 1)

	team_03 instance_to_wrap (
		.clk(clk),
		.nrst(nrst),
		.en(en),
		.la_data_in(la_data_in),
		.la_data_out(la_data_out),
		.la_oenb(la_oenb),
		.gpio_in(gpio_in),
		.gpio_out(gpio_out),
		.gpio_oeb(gpio_oeb),
		.DAT_I(DAT_I),
		.ACK_I(ACK_I),
		.ADR_O(ADR_O),
		.DAT_O(DAT_O),
		.SEL_O(SEL_O),
		.WE_O(WE_O),
		.STB_O(STB_O),
		.CYC_O(CYC_O)
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
