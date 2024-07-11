`default_nettype none
module program_counter (
	nRst,
	enable,
	clk,
	immJumpValue,
	regJumpValue,
	doForceJump,
	doCondJump,
	condJumpValue,
	doRegJump,
	instructionAddress,
	linkAddress
);
	input wire nRst;
	input wire enable;
	input wire clk;
	input wire [31:0] immJumpValue;
	input wire [31:0] regJumpValue;
	input wire doForceJump;
	input wire doCondJump;
	input wire condJumpValue;
	input wire doRegJump;
	output reg [31:0] instructionAddress;
	output reg [31:0] linkAddress;
	always @(posedge clk or negedge nRst)
		if (~nRst) begin
			instructionAddress <= 32'd0;
			linkAddress <= 32'd0;
		end
		else if (enable) begin
			if (doForceJump)
				linkAddress <= instructionAddress + 32'd4;
			else
				linkAddress <= 32'd0;
			if (doForceJump | (doCondJump & condJumpValue)) begin
				if (doRegJump & !doCondJump)
					instructionAddress <= regJumpValue + immJumpValue;
				else
					instructionAddress <= instructionAddress + immJumpValue;
			end
			else
				instructionAddress <= instructionAddress + 32'd4;
		end
		else begin
			instructionAddress <= instructionAddress;
			linkAddress <= 32'd0;
		end
endmodule
