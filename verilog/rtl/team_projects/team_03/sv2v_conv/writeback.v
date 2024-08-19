module t03_writeback (
	memory_value,
	ALU_value,
	pc_4_value,
	mem_to_reg,
	load_byte,
	read_pc_4,
	slt,
	ALU_neg_flag,
	ALU_overflow_flag,
	register_write
);
	reg _sv2v_0;
	input wire [31:0] memory_value;
	input wire [31:0] ALU_value;
	input wire [31:0] pc_4_value;
	input wire mem_to_reg;
	input wire load_byte;
	input wire read_pc_4;
	input wire slt;
	input wire ALU_neg_flag;
	input wire ALU_overflow_flag;
	output wire [31:0] register_write;
	reg [31:0] register_value;
	always @(*) begin
		if (_sv2v_0)
			;
		if (read_pc_4)
			register_value = pc_4_value;
		else if (load_byte)
			register_value = {24'b000000000000000000000000, memory_value[7:0]};
		else if (slt) begin
			if (ALU_neg_flag && !ALU_overflow_flag)
				register_value = 32'd1;
			else
				register_value = 32'b00000000000000000000000000000000;
		end
		else if (~mem_to_reg)
			register_value = ALU_value;
		else
			register_value = memory_value;
	end
	assign register_write = register_value;
	initial _sv2v_0 = 0;
endmodule
