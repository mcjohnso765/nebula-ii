module t03_control_logic_unit (
	i_type,
	instruction,
	alu_op,
	branch_type,
	reg_write_en,
	alu_mux_en,
	store_byte,
	mem_to_reg,
	pc_add_write_value,
	load_byte,
	read_next_pc,
	write_mem,
	read_mem,
	slt,
	u
);
	reg _sv2v_0;
	input wire [2:0] i_type;
	input wire [16:0] instruction;
	output reg [3:0] alu_op;
	output reg [2:0] branch_type;
	output reg reg_write_en;
	output reg alu_mux_en;
	output reg store_byte;
	output reg mem_to_reg;
	output reg pc_add_write_value;
	output reg load_byte;
	output reg read_next_pc;
	output reg write_mem;
	output reg read_mem;
	output reg slt;
	output reg u;
	always @(*) begin
		if (_sv2v_0)
			;
		u = 1'b0;
		case (instruction)
			17'b00000000000110011: begin
				alu_op = FOP_ADD;
				branch_type = 3'd0;
				read_mem = 1'b0;
				mem_to_reg = 1'b0;
				write_mem = 1'b0;
				alu_mux_en = 1'b0;
				reg_write_en = 1'b1;
				store_byte = 1'b0;
				load_byte = 1'b0;
				pc_add_write_value = 1'b0;
				read_next_pc = 1'b0;
				slt = 1'b0;
			end
			17'b01000000000110011: begin
				alu_op = FOP_SUB;
				branch_type = 3'd0;
				read_mem = 1'b0;
				mem_to_reg = 1'b0;
				write_mem = 1'b0;
				alu_mux_en = 1'b0;
				reg_write_en = 1'b1;
				store_byte = 1'b0;
				load_byte = 1'b0;
				pc_add_write_value = 1'b0;
				read_next_pc = 1'b0;
				slt = 1'b0;
			end
			17'b00000001000110011: begin
				alu_op = FOP_XOR;
				branch_type = 3'd0;
				read_mem = 1'b0;
				mem_to_reg = 1'b0;
				write_mem = 1'b0;
				alu_mux_en = 1'b0;
				reg_write_en = 1'b1;
				store_byte = 1'b0;
				load_byte = 1'b0;
				pc_add_write_value = 1'b0;
				read_next_pc = 1'b0;
				slt = 1'b0;
			end
			17'b00000001100110011: begin
				alu_op = FOP_OR;
				branch_type = 3'd0;
				read_mem = 1'b0;
				mem_to_reg = 1'b0;
				write_mem = 1'b0;
				alu_mux_en = 1'b0;
				reg_write_en = 1'b1;
				store_byte = 1'b0;
				load_byte = 1'b0;
				pc_add_write_value = 1'b0;
				read_next_pc = 1'b0;
				slt = 1'b0;
			end
			17'b00000001110110011: begin
				alu_op = FOP_AND;
				branch_type = 3'd0;
				read_mem = 1'b0;
				mem_to_reg = 1'b0;
				write_mem = 1'b0;
				alu_mux_en = 1'b0;
				reg_write_en = 1'b1;
				store_byte = 1'b0;
				load_byte = 1'b0;
				pc_add_write_value = 1'b0;
				read_next_pc = 1'b0;
				slt = 1'b0;
			end
			17'b00000000010110011: begin
				alu_op = FOP_SLL;
				branch_type = 3'd0;
				read_mem = 1'b0;
				mem_to_reg = 1'b0;
				write_mem = 1'b0;
				alu_mux_en = 1'b0;
				reg_write_en = 1'b1;
				store_byte = 1'b0;
				load_byte = 1'b0;
				pc_add_write_value = 1'b0;
				read_next_pc = 1'b0;
				slt = 1'b0;
			end
			17'b00000001010110011: begin
				alu_op = FOP_SRL;
				branch_type = 3'd0;
				read_mem = 1'b0;
				mem_to_reg = 1'b0;
				write_mem = 1'b0;
				alu_mux_en = 1'b0;
				reg_write_en = 1'b1;
				store_byte = 1'b0;
				load_byte = 1'b0;
				pc_add_write_value = 1'b0;
				read_next_pc = 1'b0;
				slt = 1'b0;
			end
			17'b01000001010110011: begin
				alu_op = FOP_SRA;
				branch_type = 3'd0;
				read_mem = 1'b0;
				mem_to_reg = 1'b0;
				write_mem = 1'b0;
				alu_mux_en = 1'b0;
				reg_write_en = 1'b1;
				store_byte = 1'b0;
				load_byte = 1'b0;
				pc_add_write_value = 1'b0;
				read_next_pc = 1'b0;
				slt = 1'b0;
			end
			17'b00000000100110011: begin
				alu_op = FOP_SUB;
				branch_type = 3'd0;
				read_mem = 1'b0;
				mem_to_reg = 1'b0;
				write_mem = 1'b0;
				alu_mux_en = 1'b0;
				reg_write_en = 1'b1;
				store_byte = 1'b0;
				load_byte = 1'b0;
				pc_add_write_value = 1'b0;
				read_next_pc = 1'b0;
				slt = 1'b1;
			end
			17'b00000000110110011: begin
				alu_op = FOP_SUB;
				branch_type = 3'd0;
				read_mem = 1'b0;
				mem_to_reg = 1'b0;
				write_mem = 1'b0;
				alu_mux_en = 1'b0;
				reg_write_en = 1'b1;
				store_byte = 1'b0;
				load_byte = 1'b0;
				pc_add_write_value = 1'b0;
				read_next_pc = 1'b0;
				slt = 1'b1;
				u = 1'b1;
			end
			17'b00000000000000011: begin
				branch_type = 3'd0;
				read_mem = 1'b1;
				mem_to_reg = 1'b1;
				alu_op = FOP_ADD;
				write_mem = 1'b0;
				alu_mux_en = 1'b1;
				reg_write_en = 1'b1;
				read_next_pc = 1'b0;
				pc_add_write_value = 1'b0;
				store_byte = 1'b0;
				load_byte = 1'b1;
				slt = 1'b0;
			end
			17'b00000000100000011: begin
				branch_type = 3'd0;
				read_mem = 1'b1;
				mem_to_reg = 1'b1;
				alu_op = FOP_ADD;
				write_mem = 1'b0;
				alu_mux_en = 1'b1;
				reg_write_en = 1'b1;
				read_next_pc = 1'b0;
				pc_add_write_value = 1'b0;
				store_byte = 1'b0;
				load_byte = 1'b0;
				slt = 1'b0;
			end
			17'b00000000000010011: begin
				branch_type = 3'd0;
				read_mem = 1'b0;
				mem_to_reg = 1'b0;
				alu_op = FOP_ADD;
				write_mem = 1'b0;
				alu_mux_en = 1'b1;
				reg_write_en = 1'b1;
				read_next_pc = 1'b0;
				pc_add_write_value = 1'b0;
				store_byte = 1'b0;
				load_byte = 1'b0;
				slt = 1'b0;
			end
			17'b00000000010010011: begin
				branch_type = 3'd0;
				read_mem = 1'b0;
				mem_to_reg = 1'b0;
				alu_op = FOP_SLL;
				write_mem = 1'b0;
				alu_mux_en = 1'b1;
				reg_write_en = 1'b1;
				read_next_pc = 1'b0;
				pc_add_write_value = 1'b0;
				store_byte = 1'b0;
				load_byte = 1'b0;
				slt = 1'b0;
			end
			17'b00000000100010011: begin
				branch_type = 3'd0;
				read_mem = 1'b0;
				mem_to_reg = 1'b0;
				alu_op = FOP_SUB;
				write_mem = 1'b0;
				alu_mux_en = 1'b1;
				reg_write_en = 1'b1;
				read_next_pc = 1'b0;
				pc_add_write_value = 1'b0;
				store_byte = 1'b0;
				load_byte = 1'b0;
				slt = 1'b1;
			end
			17'b00000000110010011: begin
				branch_type = 3'd0;
				read_mem = 1'b0;
				mem_to_reg = 1'b0;
				alu_op = FOP_SUB;
				write_mem = 1'b0;
				alu_mux_en = 1'b1;
				reg_write_en = 1'b1;
				read_next_pc = 1'b0;
				pc_add_write_value = 1'b0;
				store_byte = 1'b0;
				load_byte = 1'b0;
				slt = 1'b1;
				u = 1'b1;
			end
			17'b00000001000010011: begin
				branch_type = 3'd0;
				read_mem = 1'b0;
				mem_to_reg = 1'b0;
				alu_op = FOP_XOR;
				write_mem = 1'b0;
				alu_mux_en = 1'b1;
				reg_write_en = 1'b1;
				read_next_pc = 1'b0;
				pc_add_write_value = 1'b0;
				store_byte = 1'b0;
				load_byte = 1'b0;
				slt = 1'b0;
			end
			17'b00000001010010011: begin
				branch_type = 3'd0;
				read_mem = 1'b0;
				mem_to_reg = 1'b0;
				alu_op = FOP_SRL;
				write_mem = 1'b0;
				alu_mux_en = 1'b1;
				reg_write_en = 1'b1;
				read_next_pc = 1'b0;
				pc_add_write_value = 1'b0;
				store_byte = 1'b0;
				load_byte = 1'b0;
				slt = 1'b0;
			end
			17'b01000001010010011: begin
				branch_type = 3'd0;
				read_mem = 1'b0;
				mem_to_reg = 1'b0;
				alu_op = FOP_SRA;
				write_mem = 1'b0;
				alu_mux_en = 1'b1;
				reg_write_en = 1'b1;
				read_next_pc = 1'b0;
				pc_add_write_value = 1'b0;
				store_byte = 1'b0;
				load_byte = 1'b0;
				slt = 1'b0;
			end
			17'b00000001100010011: begin
				branch_type = 3'd0;
				read_mem = 1'b0;
				mem_to_reg = 1'b0;
				alu_op = FOP_OR;
				write_mem = 1'b0;
				alu_mux_en = 1'b1;
				reg_write_en = 1'b1;
				read_next_pc = 1'b0;
				pc_add_write_value = 1'b0;
				store_byte = 1'b0;
				load_byte = 1'b0;
				slt = 1'b0;
			end
			17'b00000001110010011: begin
				branch_type = 3'd0;
				read_mem = 1'b0;
				mem_to_reg = 1'b0;
				alu_op = FOP_AND;
				write_mem = 1'b0;
				alu_mux_en = 1'b1;
				reg_write_en = 1'b1;
				read_next_pc = 1'b0;
				pc_add_write_value = 1'b0;
				store_byte = 1'b0;
				load_byte = 1'b0;
				slt = 1'b0;
			end
			17'b00000000000100011: begin
				branch_type = 3'd0;
				read_mem = 1'b0;
				mem_to_reg = 1'b0;
				alu_op = FOP_ADD;
				write_mem = 1'b1;
				alu_mux_en = 1'b1;
				reg_write_en = 1'b1;
				read_next_pc = 1'b0;
				pc_add_write_value = 1'b0;
				store_byte = 1'b1;
				load_byte = 1'b0;
				slt = 1'b0;
			end
			17'b00000000100100011: begin
				branch_type = 3'd0;
				read_mem = 1'b0;
				mem_to_reg = 1'b0;
				alu_op = FOP_ADD;
				write_mem = 1'b1;
				alu_mux_en = 1'b1;
				reg_write_en = 1'b1;
				read_next_pc = 1'b0;
				pc_add_write_value = 1'b0;
				store_byte = 1'b0;
				load_byte = 1'b0;
				slt = 1'b0;
			end
			17'b00000000000110111: begin
				branch_type = 3'd0;
				read_mem = 1'b0;
				mem_to_reg = 1'b0;
				alu_op = FOP_IMM;
				write_mem = 1'b0;
				alu_mux_en = 1'b1;
				reg_write_en = 1'b1;
				read_next_pc = 1'b0;
				pc_add_write_value = 1'b0;
				store_byte = 1'b0;
				load_byte = 1'b0;
				slt = 1'b0;
			end
			17'b00000000000010111: begin
				branch_type = 3'd0;
				read_mem = 1'b0;
				mem_to_reg = 1'b0;
				alu_op = FOP_ADD;
				write_mem = 1'b0;
				alu_mux_en = 1'b1;
				reg_write_en = 1'b1;
				read_next_pc = 1'b1;
				pc_add_write_value = 1'b1;
				store_byte = 1'b0;
				load_byte = 1'b0;
				slt = 1'b0;
			end
			17'b00000000001100011: begin
				branch_type = BEQ;
				read_mem = 1'b0;
				mem_to_reg = 1'b0;
				alu_op = FOP_SUB;
				write_mem = 1'b0;
				alu_mux_en = 1'b0;
				reg_write_en = 1'b0;
				read_next_pc = 1'b0;
				pc_add_write_value = 1'b0;
				store_byte = 1'b0;
				load_byte = 1'b0;
				slt = 1'b0;
			end
			17'b00000000011100011: begin
				branch_type = BNE;
				read_mem = 1'b0;
				mem_to_reg = 1'b0;
				alu_op = FOP_SUB;
				write_mem = 1'b0;
				alu_mux_en = 1'b0;
				reg_write_en = 1'b0;
				read_next_pc = 1'b0;
				pc_add_write_value = 1'b0;
				store_byte = 1'b0;
				load_byte = 1'b0;
				slt = 1'b0;
			end
			17'b00000001001100011: begin
				branch_type = BLT;
				read_mem = 1'b0;
				mem_to_reg = 1'b0;
				alu_op = FOP_SUB;
				write_mem = 1'b0;
				alu_mux_en = 1'b0;
				reg_write_en = 1'b0;
				read_next_pc = 1'b0;
				pc_add_write_value = 1'b0;
				store_byte = 1'b0;
				load_byte = 1'b0;
				slt = 1'b0;
			end
			17'b00000001011100011: begin
				branch_type = BGE;
				read_mem = 1'b0;
				mem_to_reg = 1'b0;
				alu_op = FOP_SUB;
				write_mem = 1'b0;
				alu_mux_en = 1'b0;
				reg_write_en = 1'b0;
				read_next_pc = 1'b0;
				pc_add_write_value = 1'b0;
				store_byte = 1'b0;
				load_byte = 1'b0;
				slt = 1'b0;
			end
			17'b00000001101100011: begin
				branch_type = BLTU;
				read_mem = 1'b0;
				mem_to_reg = 1'b0;
				alu_op = FOP_SUB;
				write_mem = 1'b0;
				alu_mux_en = 1'b0;
				reg_write_en = 1'b0;
				read_next_pc = 1'b0;
				pc_add_write_value = 1'b0;
				store_byte = 1'b0;
				load_byte = 1'b0;
				slt = 1'b0;
				u = 1'b1;
			end
			17'b00000001111100011: begin
				branch_type = BGEU;
				read_mem = 1'b0;
				mem_to_reg = 1'b0;
				alu_op = FOP_SUB;
				write_mem = 1'b0;
				alu_mux_en = 1'b0;
				reg_write_en = 1'b0;
				read_next_pc = 1'b0;
				pc_add_write_value = 1'b0;
				store_byte = 1'b0;
				load_byte = 1'b0;
				slt = 1'b0;
				u = 1'b1;
			end
			17'b00000000001100111: begin
				branch_type = JMP;
				read_mem = 1'b0;
				mem_to_reg = 1'b0;
				alu_op = FOP_ADD;
				write_mem = 1'b0;
				alu_mux_en = 1'b0;
				reg_write_en = 1'b1;
				read_next_pc = 1'b1;
				pc_add_write_value = 1'b1;
				store_byte = 1'b0;
				load_byte = 1'b0;
				slt = 1'b0;
			end
			17'b00000000001101111: begin
				branch_type = JMP;
				read_mem = 1'b0;
				mem_to_reg = 1'b0;
				alu_op = FOP_ADD;
				write_mem = 1'b0;
				alu_mux_en = 1'b0;
				reg_write_en = 1'b1;
				read_next_pc = 1'b1;
				pc_add_write_value = 1'b0;
				store_byte = 1'b0;
				load_byte = 1'b0;
				slt = 1'b0;
			end
			default: begin
				branch_type = 3'd0;
				read_mem = 1'b0;
				mem_to_reg = 1'b0;
				alu_op = FOP_ADD;
				write_mem = 1'b0;
				alu_mux_en = 1'b0;
				reg_write_en = 1'b0;
				read_next_pc = 1'b0;
				pc_add_write_value = 1'b0;
				store_byte = 1'b0;
				load_byte = 1'b0;
				slt = 1'b0;
			end
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
