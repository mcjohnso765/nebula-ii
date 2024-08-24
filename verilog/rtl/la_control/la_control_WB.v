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

// `timescale			1ns/1ps
`default_nettype	none

`define				WB_AW		32

//`include			"wb_wrapper.vh"

module la_control_WB #(
    parameter NUM_TEAMS = 12
)
(
	`WB_SLAVE_PORTS,
	input	wire	[32*(NUM_TEAMS+1)-1:0] designs_la_data_out_flat,
	output	wire	[32-1:0]	muxxed_la_dat
);

	localparam	LA_SEL_VAL_REG_OFFSET = `WB_AW'h31000000;
	wire		clk = clk_i;
	wire		nrst = (~rst_i);


	`WB_CTRL_SIGNALS

	wire [4-1:0]	la_sel;

	// Register Definitions
	reg [3:0]	LA_SEL_VAL_REG;
	assign	la_sel = LA_SEL_VAL_REG;
	`WB_REG(LA_SEL_VAL_REG, 0, 4)

	la_control #(
        .NUM_TEAMS(NUM_TEAMS)
    ) instance_to_wrap (
		.clk(clk),
		.nrst(nrst),
		.la_sel(la_sel),
		.designs_la_data_out_flat(designs_la_data_out_flat),
		.muxxed_la_dat(muxxed_la_dat)
	);

	assign	dat_o = 
			(adr_i[`WB_AW-1:0] == LA_SEL_VAL_REG_OFFSET)	? LA_SEL_VAL_REG :
			32'hDEADBEEF;

	always @ (posedge clk_i or posedge rst_i)
		if(rst_i)
			ack_o <= 1'b0;
		else if(wb_valid & ~ack_o)
			ack_o <= 1'b1;
		else
			ack_o <= 1'b0;
endmodule
