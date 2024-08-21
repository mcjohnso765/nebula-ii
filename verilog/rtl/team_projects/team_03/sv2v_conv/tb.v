module tb;
	reg clock = 0;
	reg reset = 0;
	reg en = 1;
	wire [2:0] i_type;
	wire [16:0] instruction;
	wire [3:0] alu_op;
	wire [2:0] branch_type;
	wire reg_write_en;
	wire alu_mux_en;
	wire store_byte;
	wire mem_to_reg;
	wire pc_add_write_value;
	wire load_byte;
	wire read_next_pc;
	wire write_mem;
	wire read_mem;
	reg [31:0] inst;
	wire [31:0] imm_gen;
	wire [4:0] regA;
	wire [4:0] regB;
	wire [4:0] rd;
	wire [31:0] register_write_data;
	wire [31:0] regA_data;
	wire [31:0] regB_data;
	wire [31:0] program_counter;
	wire [31:0] program_counter_out;
	wire branch_choice;
	wire [31:0] result;
	wire Z;
	wire N;
	wire C;
	wire V;
	wire b_out;
	wire [31:0] data_to_write;
	wire [31:0] data_read;
	wire [31:0] data_to_IO;
	wire pc_en;
	wire slt;
	wire u;
	reg i_hit = 1'b1;
	t03_decoder decoder(
		.inst(inst),
		.rs1(regA),
		.rs2(regB),
		.rd(rd),
		.type_out(i_type),
		.control_out(instruction)
	);
	t03_control_logic_unit control_logic(
		.i_type(i_type),
		.instruction(instruction),
		.alu_op(alu_op),
		.branch_type(branch_type),
		.reg_write_en(reg_write_en),
		.alu_mux_en(alu_mux_en),
		.store_byte(store_byte),
		.mem_to_reg(mem_to_reg),
		.pc_add_write_value(pc_add_write_value),
		.load_byte(load_byte),
		.read_next_pc(read_next_pc),
		.write_mem(write_mem),
		.read_mem(read_mem),
		.slt(slt),
		.u(u)
	);
	t03_branch_logic branch_logic(
		.branch_type(branch_type),
		.ALU_neg_flag(N),
		.ALU_overflow_flag(V),
		.ALU_zero_flag(Z),
		.b_out(branch_choice)
	);
	t03_pc pc(
		.en(en),
		.pc_out(program_counter),
		.pc_add_out(program_counter_out),
		.generated_immediate(imm_gen),
		.branch_decision(branch_choice),
		.pc_write_value(regA_data),
		.pc_add_write_value(pc_add_write_value),
		.in_en(i_hit),
		.auipc_in(alu_mux_en),
		.clock(clock),
		.reset(reset)
	);
	t03_register_file register_file(
		.en(en),
		.clk(clock),
		.rst(reset),
		.regA_address(regA),
		.regB_address(regB),
		.rd_address(rd),
		.register_write_en(reg_write_en),
		.register_write_data(register_write_data),
		.regA_data(regA_data),
		.regB_data(regB_data)
	);
	t03_writeback writeback(
		.memory_value(data_read),
		.ALU_value(result),
		.pc_4_value(program_counter_out),
		.mem_to_reg(mem_to_reg),
		.load_byte(load_byte),
		.read_pc_4(1'b0),
		.register_write(register_write_data),
		.slt(slt),
		.ALU_neg_flag(N),
		.ALU_overflow_flag(V)
	);
	t03_byte_demux byte_demux(
		.reg_b(regB_data),
		.store_byte_en(store_byte),
		.b_out(data_to_write)
	);
	t03_ALU ALU(
		.srda(regA_data),
		.fop(alu_op),
		.result(result),
		.Z(Z),
		.N(N),
		.V(V),
		.imm_gen(imm_gen),
		.srdb(regB_data),
		.alu_mux_en(alu_mux_en),
		.rda_u(regA_data),
		.rdb_u(regB_data),
		.u(u)
	);
	t03_imm_generator imm_generator(
		.inst(inst),
		.type_i(i_type),
		.imm_gen(imm_gen)
	);
	string check_type;
	integer exp_val;
	task reset_module;
		begin
			reset = 1;
			#(3)
				;
			reset = 0;
			#(3)
				;
		end
	endtask
	always begin
		clock = 0;
		#(3)
			;
		clock = 1;
		#(3)
			;
	end
	task check_out;
		input reg [31:0] exp_val;
		input reg [31:0] actual_val;
		input string check_type;
		if (exp_val == actual_val)
			$info("Correct reg output. test: %s", check_type);
		else
			$error("Incorrect reg output. test: %s", check_type);
	endtask
	initial begin
		$dumpfile("sim.vcd");
		$dumpvars(0, tb);
		reset_module;
		#(6)
			;
		check_type = "addi";
		inst = 32'h00700093;
		exp_val = 7;
		#(6)
			;
		check_out(exp_val, register_write_data);
		#(6)
			;
		check_type = "xori";
		inst = 32'h0040c413;
		exp_val = 3;
		#(6)
			;
		check_out(exp_val, register_write_data);
		#(6)
			;
		check_type = "ori";
		inst = 32'h0040e413;
		exp_val = 7;
		#(6)
			;
		check_out(exp_val, register_write_data);
		#(6)
			;
		check_type = "andi";
		inst = 32'h0040f413;
		exp_val = 4;
		#(6)
			;
		check_out(exp_val, register_write_data);
		#(6)
			;
		check_type = "slli";
		inst = 32'h00209413;
		exp_val = 28;
		#(6)
			;
		check_out(exp_val, register_write_data);
		#(6)
			;
		check_type = "srli";
		inst = 32'h0020d413;
		exp_val = 1;
		#(6)
			;
		check_out(exp_val, register_write_data);
		#(6)
			;
		check_type = "srai";
		inst = 32'h4010d413;
		exp_val = 3;
		#(6)
			;
		check_out(exp_val, register_write_data);
		#(6)
			;
		check_type = "slti";
		inst = 32'h0080a413;
		exp_val = 32'b00000000000000000000000000000001;
		#(6)
			;
		check_out(exp_val, register_write_data);
		#(6)
			;
		check_type = "sltiu";
		inst = 32'h0080b413;
		exp_val = 32'b00000000000000000000000000000001;
		#(6)
			;
		check_out(exp_val, register_write_data);
		#(6)
			;
		check_type = "xori";
		inst = 32'h00500193;
		exp_val = 7;
		#(6)
			;
		check_out(exp_val, register_write_data);
		#(6)
			;
		#(1)
			$finish;
	end
endmodule
