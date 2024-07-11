`default_nettype none
module alu_control_unit (
	opcode,
	alu_op,
	func7,
	ctrl_err,
	alu_control_input
);
	reg _sv2v_0;
	input wire [6:0] opcode;
	input wire [2:0] alu_op;
	input wire [6:0] func7;
	output reg ctrl_err;
	output reg [3:0] alu_control_input;
	always @(*) begin
		if (_sv2v_0)
			;
		alu_control_input = 4'bxxxx;
		ctrl_err = 1'b0;
		if (opcode == 7'b0110011) begin
			if (alu_op == 3'b000) begin
				if (func7 == 7'b0000000)
					alu_control_input = 4'd0;
				else if (func7 == 7'b0100000)
					alu_control_input = 4'd1;
				else begin
					alu_control_input = 4'bxxxx;
					ctrl_err = 1'b1;
				end
			end
			else if (alu_op == 3'b001)
				alu_control_input = 4'd2;
			else if (alu_op == 3'b010)
				alu_control_input = 4'd3;
			else if (alu_op == 3'b011)
				alu_control_input = 4'd4;
			else if (alu_op == 3'b100)
				alu_control_input = 4'd5;
			else if (alu_op == 3'b101) begin
				if (func7 == 7'b0000000)
					alu_control_input = 4'd6;
				else if (func7 == 7'b0100000)
					alu_control_input = 4'd7;
				else begin
					alu_control_input = 4'bxxxx;
					ctrl_err = 1'b1;
				end
			end
			else if (alu_op == 3'b110)
				alu_control_input = 4'd8;
			else if (alu_op == 3'b111)
				alu_control_input = 4'd9;
			else begin
				alu_control_input = 4'bxxxx;
				ctrl_err = 1'b1;
			end
		end
		else if (opcode == 7'b0010011) begin
			if (alu_op == 3'b000)
				alu_control_input = 4'd0;
			else if (alu_op == 3'b010)
				alu_control_input = 4'd3;
			else if (alu_op == 3'b011)
				alu_control_input = 4'd4;
			else if (alu_op == 3'b100)
				alu_control_input = 4'd5;
			else if (alu_op == 3'b110)
				alu_control_input = 4'd8;
			else if (alu_op == 3'b111)
				alu_control_input = 4'd9;
			else if (alu_op == 3'b001)
				alu_control_input = 4'd2;
			else if (alu_op == 3'b101) begin
				if (func7 == 7'b0000000)
					alu_control_input = 4'd6;
				else if (func7 == 7'b0100000)
					alu_control_input = 4'd7;
				else begin
					alu_control_input = 4'bxxxx;
					ctrl_err = 1'b1;
				end
			end
			else begin
				alu_control_input = 4'bxxxx;
				ctrl_err = 1'b1;
			end
		end
		else if (opcode == 7'b1100011) begin
			if (alu_op == 3'b000)
				alu_control_input = 4'd10;
			else if (alu_op == 3'b001)
				alu_control_input = 4'd11;
			else if (alu_op == 3'b100)
				alu_control_input = 4'd12;
			else if (alu_op == 3'b101)
				alu_control_input = 4'd13;
			else if (alu_op == 3'b110)
				alu_control_input = 4'd14;
			else if (alu_op == 3'b111)
				alu_control_input = 4'd15;
			else begin
				alu_control_input = 4'bxxxx;
				ctrl_err = 1'b1;
			end
		end
		else if (opcode == 7'b0100011)
			alu_control_input = 4'd0;
		else if (opcode == 7'b0000011)
			alu_control_input = 4'd0;
		else begin
			alu_control_input = 4'bxxxx;
			ctrl_err = 1'b1;
		end
	end
	initial _sv2v_0 = 0;
endmodule
