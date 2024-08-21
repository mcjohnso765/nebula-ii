module t03_core (
	clock,
	reset,
	en,
	CPU_DAT_O,
	BUSY_O,
	CPU_DAT_I,
	ADR_I,
	SEL_I,
	WRITE_I,
	READ_I,
	gpio_in,
	gpio_out,
	gpio_oeb
);
	reg _sv2v_0;
	input wire clock;
	input wire reset;
	input wire en;
	input wire [31:0] CPU_DAT_O;
	input wire BUSY_O;
	output wire [31:0] CPU_DAT_I;
	output wire [31:0] ADR_I;
	output wire [3:0] SEL_I;
	output wire WRITE_I;
	output wire READ_I;
	input wire [33:0] gpio_in;
	output wire [33:0] gpio_out;
	assign gpio_out[33:32] = 2'b0;
	output wire [33:0] gpio_oeb;
	assign gpio_oeb[33:32] = 2'b0;
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
	wire [31:0] inst;
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
	wire d_hit;
	wire i_hit;
	wire i_request;
	t03_request_unit ru(
		.i_request(i_request),
		.en(en),
		.clk(clock),
		.rst(reset),
		.memread(read_mem),
		.memwrite(write_mem),
		.data_to_write(data_to_write),
		.instruction_address(program_counter),
		.data_address(result),
		.busy_o(BUSY_O),
		.cpu_dat_o(CPU_DAT_O),
		.read_i(READ_I),
		.write_i(WRITE_I),
		.cpu_dat_i(CPU_DAT_I),
		.instruction(inst),
		.adr_i(ADR_I),
		.data_read(data_to_IO),
		.sel_i(SEL_I),
		.i_hit(i_hit),
		.d_hit(d_hit)
	);
	wire cpu_clock;
	t03_instruction_check ic(
		.instruction(inst),
		.i_request(i_request)
	);
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
		.i_request(i_request),
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
	reg register_file_en;
	t03_register_file register_file(
		.en(en),
		.clk(clock),
		.rst(reset),
		.regA_address(regA),
		.regB_address(regB),
		.rd_address(rd),
		.register_write_en(register_file_en),
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
	t03_IO_mod_enable IO_mod(
		.clk(clock),
		.rst(reset),
		.write_mem(write_mem),
		.read_mem(read_mem),
		.data_from_mem(data_to_IO),
		.data_address(result),
		.data_to_write(data_to_write),
		.data_read(data_read),
		.IO_out(gpio_out[31:0]),
		.IO_enable(gpio_oeb[31:0]),
		.IO_in(gpio_in[31:0])
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
	always @(*) begin
		if (_sv2v_0)
			;
		register_file_en = 1'sb0;
		if (reg_write_en) begin
			if (read_mem)
				register_file_en = d_hit;
			else
				register_file_en = 1'b1;
		end
	end
	initial _sv2v_0 = 0;
endmodule
