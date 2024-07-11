module CPU (
	instruction,
	clk,
	nrst,
	data_from_mem,
	alu_result,
	reg_window,
	err_flag,
	addr_to_mem,
	data_to_mem,
	nextInstruction,
	MemWrite,
	MemRead,
	select,
	enable
);
	input wire [31:0] instruction;
	input wire clk;
	input wire nrst;
	input wire [31:0] data_from_mem;
	output wire [31:0] alu_result;
	output reg [1023:0] reg_window;
	output wire err_flag;
	output wire [31:0] addr_to_mem;
	output wire [31:0] data_to_mem;
	output wire [31:0] nextInstruction;
	output wire MemWrite;
	output wire MemRead;
	output wire [3:0] select;
	input wire enable;
	wire [4:0] rs1;
	wire [4:0] rs2;
	wire [4:0] rd;
	wire [6:0] opcode;
	wire [6:0] func7;
	wire [2:0] func3;
	wire [31:0] imm;
	wire [1:0] RegWriteSrc;
	wire ALUSrc;
	wire RegWrite;
	wire Jump;
	wire Branch;
	wire Error;
	wire [31:0] opB;
	wire [31:0] alu_result_wire;
	wire condJumpValue;
	wire [31:0] DataWrite;
	wire [31:0] regA;
	wire [31:0] regB;
	wire [31:0] MemData;
	wire [31:0] PCData;
	decode decoder(
		.instruction(instruction),
		.rs1(rs1),
		.rs2(rs2),
		.rd(rd),
		.opcode(opcode),
		.ALUOp(func3),
		.func7(func7)
	);
	imm_gen make_imm(
		.instruction(instruction),
		.imm(imm),
		.flag()
	);
	control_unit cntrl(
		.opcode(opcode),
		.RegWriteSource(RegWriteSrc),
		.ALUSrc(ALUSrc),
		.RegWrite(RegWrite),
		.Jump(Jump),
		.Branch(Branch),
		.MemWrite(MemWrite),
		.MemRead(MemRead),
		.Error(Error)
	);
	aluop_mux ALUOpB(
		.regB(regB),
		.imm(imm),
		.alu_src(ALUSrc),
		.opB(opB)
	);
	alu ALU(
		.opcode(opcode),
		.alu_op(func3),
		.func7(func7),
		.opB(opB),
		.opA(regA),
		.alu_result(alu_result_wire),
		.zero_flag(),
		.err_flag(err_flag),
		.condJumpValue(condJumpValue)
	);
	assign alu_result = alu_result_wire;
	reg_write_mux reg_write_control(
		.immData(imm),
		.ALUData(alu_result_wire),
		.MemData(MemData),
		.PCData(PCData),
		.DataWrite(DataWrite),
		.RegWriteSrc(RegWriteSrc)
	);
	wire [1024:1] sv2v_tmp_regs_reg_file;
	always @(*) reg_window = sv2v_tmp_regs_reg_file;
	register_file regs(
		.read_addr_1(rs1),
		.read_addr_2(rs2),
		.write_addr(rd),
		.reg_enable_write(RegWrite),
		.read_data_1(regA),
		.read_data_2(regB),
		.write_data(DataWrite),
		.clk(clk),
		.nrst(nrst),
		.reg_file(sv2v_tmp_regs_reg_file),
		.enable(enable)
	);
	memory_handler mem(
		.addr(alu_result_wire),
		.read_data_2(regB),
		.data_from_mem(data_from_mem),
		.en_read(MemRead),
		.en_write(MemWrite),
		.size(func3),
		.select(select),
		.data_to_reg(MemData),
		.addr_to_mem(addr_to_mem),
		.data_to_mem(data_to_mem),
		.mem_read(),
		.mem_write()
	);
	program_counter PC(
		.nRst(nrst),
		.enable(enable),
		.clk(clk),
		.immJumpValue(imm),
		.regJumpValue(regA),
		.doForceJump(Jump),
		.doCondJump(Branch),
		.condJumpValue(condJumpValue),
		.doRegJump(~opcode[3]),
		.instructionAddress(nextInstruction),
		.linkAddress(PCData)
	);
endmodule
