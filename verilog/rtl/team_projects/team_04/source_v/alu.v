`default_nettype none
module alu (
	opcode,
	alu_op,
	func7,
	opA,
	opB,
	alu_result,
	zero_flag,
	err_flag,
	condJumpValue
);
	reg _sv2v_0;
	input wire [6:0] opcode;
	input wire [2:0] alu_op;
	input wire [6:0] func7;
	input wire [31:0] opA;
	input wire [31:0] opB;
	output reg [31:0] alu_result;
	output reg zero_flag;
	output reg err_flag;
	output reg condJumpValue;
	wire signed [31:0] opA_signed;
	wire signed [31:0] opB_signed;
	assign opA_signed = opA;
	assign opB_signed = opB;
	wire [3:0] alu_control_input;
	wire ctrl_err;
	alu_control_unit ex1(
		.opcode(opcode),
		.alu_op(alu_op),
		.func7(func7),
		.ctrl_err(ctrl_err),
		.alu_control_input(alu_control_input)
	);
	always @(*) begin
		if (_sv2v_0)
			;
		case (alu_control_input)
			4'd0: begin
				alu_result = opA + opB;
				err_flag = 1'b0;
				condJumpValue = 1'b0;
			end
			4'd1: begin
				alu_result = opA - opB;
				err_flag = 1'b0;
				condJumpValue = 1'b0;
			end
			4'd2: begin
				alu_result = opA << opB[4:0];
				err_flag = 1'b0;
				condJumpValue = 1'b0;
			end
			4'd3: begin
				alu_result = (opA_signed < opB_signed ? 32'b00000000000000000000000000000001 : 32'b00000000000000000000000000000000);
				err_flag = 1'b0;
				condJumpValue = 1'b0;
			end
			4'd4: begin
				alu_result = (opA < opB ? 32'b00000000000000000000000000000001 : 32'b00000000000000000000000000000000);
				err_flag = 1'b0;
				condJumpValue = 1'b0;
			end
			4'd5: begin
				alu_result = opA ^ opB;
				err_flag = 1'b0;
				condJumpValue = 1'b0;
			end
			4'd6: begin
				alu_result = opA >> opB[4:0];
				err_flag = 1'b0;
				condJumpValue = 1'b0;
			end
			4'd7: begin
				alu_result = opA_signed >>> opB[4:0];
				err_flag = 1'b0;
				condJumpValue = 1'b0;
			end
			4'd8: begin
				alu_result = opA | opB;
				err_flag = 1'b0;
				condJumpValue = 1'b0;
			end
			4'd9: begin
				alu_result = opA & opB;
				err_flag = 1'b0;
				condJumpValue = 1'b0;
			end
			4'd10: begin
				err_flag = 1'b0;
				alu_result = {32 {opA == opB}};
				condJumpValue = alu_result[0];
			end
			4'd11: begin
				err_flag = 1'b0;
				alu_result = 32'b00000000000000000000000000000000;
				condJumpValue = (opA != opB ? 1 : 0);
			end
			4'd12: begin
				err_flag = 1'b0;
				alu_result = 32'b00000000000000000000000000000000;
				condJumpValue = (opA_signed < opB_signed ? 1 : 0);
			end
			4'd13: begin
				err_flag = 1'b0;
				alu_result = 32'b00000000000000000000000000000000;
				condJumpValue = (opA_signed >= opB_signed ? 1 : 0);
			end
			4'd14: begin
				err_flag = 1'b0;
				alu_result = 32'b00000000000000000000000000000000;
				condJumpValue = (opA < opB ? 1 : 0);
			end
			4'd15: begin
				err_flag = 1'b0;
				alu_result = 32'b00000000000000000000000000000000;
				condJumpValue = (opA >= opB ? 1 : 0);
			end
			default: begin
				alu_result = 32'b00000000000000000000000000000000;
				err_flag = 1'b1;
				zero_flag = 1'b0;
				condJumpValue = 1'b0;
			end
		endcase
		zero_flag = (|alu_result == 'b1 ? 'b0 : 'b1);
	end
	initial _sv2v_0 = 0;
endmodule
