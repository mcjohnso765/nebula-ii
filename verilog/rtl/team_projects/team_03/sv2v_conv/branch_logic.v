module t03_branch_logic (
	branch_type,
	ALU_neg_flag,
	ALU_zero_flag,
	ALU_overflow_flag,
	b_out
);
	reg _sv2v_0;
	input wire [2:0] branch_type;
	input wire ALU_neg_flag;
	input wire ALU_zero_flag;
	input wire ALU_overflow_flag;
	output reg b_out;
	always @(*) begin
		if (_sv2v_0)
			;
		if (((branch_type == 3'd1) && ALU_zero_flag) && !ALU_overflow_flag)
			b_out = 1'b1;
		else if (((branch_type == 3'd2) && !ALU_zero_flag) && !ALU_overflow_flag)
			b_out = 1'b1;
		else if (((branch_type == 3'd3) && ALU_neg_flag) && !ALU_overflow_flag)
			b_out = 1'b1;
		else if (((branch_type == 3'd4) && !ALU_neg_flag) && !ALU_overflow_flag)
			b_out = 1'b1;
		else if (((branch_type == 3'd5) && ALU_neg_flag) && !ALU_overflow_flag)
			b_out = 1'b1;
		else if (((branch_type == 3'd6) && !ALU_neg_flag) && !ALU_overflow_flag)
			b_out = 1'b1;
		else if (branch_type == 3'd7)
			b_out = 1'b1;
		else if (branch_type == 3'd0)
			b_out = 1'b0;
		else
			b_out = 1'b0;
	end
	initial _sv2v_0 = 0;
endmodule
