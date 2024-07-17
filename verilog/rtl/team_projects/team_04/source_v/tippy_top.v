module t04_tippy_top (
	clk,
	nRst,
	button,
	mem_busy,
	data_from_mem,
	mem_read,
	mem_write,
	adr_to_mem,
	data_to_mem,
	sel_to_mem,
	Rx,
	h_out,
	v_out,
	pixel_data,
	opcode_error,
	alu_error,
	memory_size
);
	input wire clk;
	input wire nRst;
	input wire button;
	input wire mem_busy;
	input wire [31:0] data_from_mem;
	output wire mem_read;
	output wire mem_write;
	output wire [31:0] adr_to_mem;
	output wire [31:0] data_to_mem;
	output wire [3:0] sel_to_mem;
	input wire Rx;
	output wire h_out;
	output wire v_out;
	output wire pixel_data;
	output wire opcode_error;
	output wire alu_error;
	input [31:0] memory_size;
	wire [31:0] CPU_instructions;
	wire [31:0] mem_data_to_CPU;
	wire [31:0] CPU_adr_to_mem;
	wire [31:0] CPU_data_to_mem;
	wire [31:0] CPU_instr_adr;
	wire CPU_read;
	wire CPU_write;
	wire [3:0] CPU_sel;
	wire CPU_enable;
	wire [31:0] VGA_request_address;
	wire [31:0] mem_data_to_VGA;
	wire [9:0] h_count;
	wire [8:0] v_count;
	wire [1:0] VGA_state;
	wire data_en;
	wire VGA_read;
	wire [31:0] data_to_VGA;
	wire [31:0] VGA_adr;
	wire VGA_enable;
	t04_CPU cpu(
		.instruction(CPU_instructions),
		.clk(clk),
		.nrst(nRst),
		.data_from_mem(mem_data_to_CPU),
		.alu_result(),
		.reg_window(),
		.err_flag(alu_error),
		.Error(opcode_error),
		.addr_to_mem(CPU_adr_to_mem),
		.data_to_mem(CPU_data_to_mem),
		.nextInstruction(CPU_instr_adr),
		.MemWrite(CPU_write),
		.MemRead(CPU_read),
		.select(CPU_sel),
		.enable(CPU_enable)
	);
	t04_VGA_data_controller VGA_data_control(
		.clk(clk),
		.nrst(nRst),
		.VGA_request_address(VGA_request_address),
		.data_from_SRAM(mem_data_to_VGA),
		.h_count(h_count),
		.v_count(v_count),
		.VGA_state(VGA_state),
		.byte_select_out(),
		.read(VGA_read),
		.data_to_VGA(data_to_VGA),
		.SRAM_address(VGA_adr),
		.mem_busy(mem_busy)
	);
	t04_VGA_out vga(
		.SRAM_data_in(data_to_VGA),
		.SRAM_busy(1'b0),
		.clk(clk),
		.nrst(nRst),
		.data_en(data_en),
		.h_out(h_out),
		.v_out(v_out),
		.pixel_data(pixel_data),
		.word_address_dest(VGA_request_address),
		.byte_select(),
		.VGA_state(VGA_state),
		.h_count(h_count),
		.v_count(v_count),
		.h_state(),
		.v_state()
	);
	wire [7:0] uart_out;
	wire uart_data_ready;
	t04_UART_Receiver uart(
		.nRst(nRst),
		.clk(clk),
		.enable(1),
		.Rx(Rx),
		.data_out(uart_out),
		.data_ready(uart_data_ready),
		.working_data(),
		.bits_received(),
		.receiving(),
		.BAUD_counter(),
		.parity_error()
	);
	t04_request_handler reqhand(
		.clk(clk),
		.nRst(nRst),
		.mem_busy(mem_busy),
		.VGA_state(VGA_state),
		.CPU_enable(CPU_enable),
		.VGA_enable(VGA_enable),
		.VGA_read(VGA_read),
		.VGA_adr((memory_size - 32'd1536) + (VGA_adr * 4)),
		.data_to_VGA(mem_data_to_VGA),
		.data_from_UART({24'b000000000000000000000000, uart_out}),
		.CPU_instr_adr(CPU_instr_adr),
		.CPU_data_adr(CPU_adr_to_mem),
		.CPU_read(CPU_read),
		.CPU_write(CPU_write),
		.data_from_CPU(CPU_data_to_mem),
		.CPU_sel(CPU_sel),
		.instr_data_to_CPU(CPU_instructions),
		.data_to_CPU(mem_data_to_CPU),
		.data_from_mem(data_from_mem),
		.mem_read(mem_read),
		.mem_write(mem_write),
		.adr_to_mem(adr_to_mem),
		.data_to_mem(data_to_mem),
		.sel_to_mem(sel_to_mem),
		.uart_address(memory_size - 32'd1532)
	);
endmodule
module t04_CPU (
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
	Error,
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
	output wire Error;
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
	wire AUIlink;
	wire [31:0] opB;
	wire [31:0] alu_result_wire;
	wire condJumpValue;
	wire [31:0] DataWrite;
	wire [31:0] regA;
	wire [31:0] regB;
	wire [31:0] MemData;
	wire [31:0] PCData;
	t04_decode decoder(
		.instruction(instruction),
		.rs1(rs1),
		.rs2(rs2),
		.rd(rd),
		.opcode(opcode),
		.ALUOp(func3),
		.func7(func7)
	);
	t04_imm_gen make_imm(
		.instruction(instruction),
		.imm(imm),
		.flag()
	);
	t04_control_unit cntrl(
		.opcode(opcode),
		.RegWriteSource(RegWriteSrc),
		.ALUSrc(ALUSrc),
		.RegWrite(RegWrite),
		.Jump(Jump),
		.Branch(Branch),
		.MemWrite(MemWrite),
		.MemRead(MemRead),
		.Error(Error),
		.AUIlink(AUIlink)
	);
	t04_aluop_mux ALUOpB(
		.regB(regB),
		.imm(imm),
		.alu_src(ALUSrc),
		.opB(opB)
	);
	t04_alu ALU(
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
	t04_reg_write_mux reg_write_control(
		.immData(imm),
		.ALUData(alu_result_wire),
		.MemData(MemData),
		.PCData(PCData),
		.DataWrite(DataWrite),
		.RegWriteSrc(RegWriteSrc)
	);
	wire [1024:1] sv2v_tmp_regs_reg_file;
	always @(*) reg_window = sv2v_tmp_regs_reg_file;
	t04_register_file regs(
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
	t04_memory_handler mem(
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
	t04_program_counter PC(
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
		.linkAddress(PCData),
		.AUIlink(AUIlink)
	);
endmodule
module t04_decode (
	instruction,
	rs1,
	rs2,
	rd,
	opcode,
	ALUOp,
	func7
);
	input wire [31:0] instruction;
	output wire [4:0] rs1;
	output wire [4:0] rs2;
	output wire [4:0] rd;
	output wire [6:0] opcode;
	output wire [2:0] ALUOp;
	output wire [6:0] func7;
	assign opcode = instruction[6:0];
	assign rd = instruction[11:7];
	assign rs1 = instruction[19:15];
	assign rs2 = instruction[24:20];
	assign ALUOp = instruction[14:12];
	assign func7 = instruction[31:25];
endmodule
module t04_imm_gen (
	instruction,
	imm,
	flag
);
	reg _sv2v_0;
	input wire [31:0] instruction;
	output reg [31:0] imm;
	output reg flag;
	wire [31:0] imm_raw;
	reg fill;
	always @(*) begin
		if (_sv2v_0)
			;
		flag = 1'b0;
		fill = instruction[31];
		case (instruction[6:0])
			7'b0110111, 7'b0010111: begin
				imm[31:12] = {instruction[31:12]};
				imm[11:0] = 12'b000000000000;
			end
			7'b1101111: begin
				imm[0] = 0;
				imm[20:1] = {instruction[31], instruction[19:12], instruction[20], instruction[30:21]};
				imm[31:21] = {11 {fill}};
			end
			7'b1100111, 7'b0000011, 7'b0010011: begin
				imm[11:0] = instruction[31:20];
				imm[31:12] = {20 {fill}};
			end
			7'b0100011: begin
				imm[4:0] = instruction[11:7];
				imm[11:5] = instruction[31:25];
				imm[31:12] = {20 {fill}};
			end
			7'b1100011: begin
				imm[0] = 0;
				imm[4:1] = instruction[11:8];
				imm[10:5] = instruction[30:25];
				imm[11] = instruction[7];
				imm[12] = instruction[31];
				imm[31:13] = {19 {fill}};
			end
			default: begin
				imm = 32'b01010101010101010101010101010101;
				flag = 1'b1;
			end
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
module t04_control_unit (
	opcode,
	RegWriteSource,
	ALUSrc,
	RegWrite,
	Jump,
	Branch,
	MemWrite,
	MemRead,
	Error,
	AUIlink
);
	reg _sv2v_0;
	input wire [6:0] opcode;
	output reg [1:0] RegWriteSource;
	output reg ALUSrc;
	output reg RegWrite;
	output reg Jump;
	output reg Branch;
	output reg MemWrite;
	output reg MemRead;
	output reg Error;
	output reg AUIlink;
	always @(*) begin
		if (_sv2v_0)
			;
		case (opcode)
			7'b0110111: begin
				RegWrite = 1;
				ALUSrc = 0;
				RegWriteSource = 2'b10;
				MemWrite = 0;
				MemRead = 0;
				Jump = 0;
				Branch = 0;
				Error = 0;
				AUIlink = 0;
			end
			7'b0010111: begin
				RegWrite = 1;
				ALUSrc = 1;
				RegWriteSource = 2'b11;
				MemWrite = 0;
				MemRead = 0;
				Jump = 0;
				Branch = 0;
				Error = 0;
				AUIlink = 1;
			end
			7'b1101111: begin
				RegWrite = 1;
				ALUSrc = 1;
				RegWriteSource = 2'b11;
				MemWrite = 0;
				MemRead = 0;
				Jump = 1;
				Branch = 0;
				Error = 0;
				AUIlink = 0;
			end
			7'b1100111: begin
				RegWrite = 1;
				ALUSrc = 1;
				RegWriteSource = 2'b11;
				MemWrite = 0;
				MemRead = 0;
				Jump = 1;
				Branch = 0;
				Error = 0;
				AUIlink = 0;
			end
			7'b1100011: begin
				RegWrite = 0;
				ALUSrc = 0;
				RegWriteSource = 2'b00;
				MemWrite = 0;
				MemRead = 0;
				Jump = 0;
				Branch = 1;
				Error = 0;
				AUIlink = 0;
			end
			7'b0000011: begin
				RegWrite = 1;
				ALUSrc = 1;
				RegWriteSource = 2'b01;
				MemWrite = 0;
				MemRead = 1;
				Jump = 0;
				Branch = 0;
				Error = 0;
				AUIlink = 0;
			end
			7'b0100011: begin
				RegWrite = 0;
				ALUSrc = 1;
				RegWriteSource = 2'b00;
				MemWrite = 1;
				MemRead = 0;
				Jump = 0;
				Branch = 0;
				Error = 0;
				AUIlink = 0;
			end
			7'b0010011: begin
				RegWrite = 1;
				ALUSrc = 1;
				RegWriteSource = 2'b00;
				MemWrite = 0;
				MemRead = 0;
				Jump = 0;
				Branch = 0;
				Error = 0;
				AUIlink = 0;
			end
			7'b0110011: begin
				RegWrite = 1;
				ALUSrc = 0;
				RegWriteSource = 2'b00;
				MemWrite = 0;
				MemRead = 0;
				Jump = 0;
				Branch = 0;
				Error = 0;
				AUIlink = 0;
			end
			default: begin
				RegWrite = 0;
				ALUSrc = 0;
				RegWriteSource = 2'b00;
				MemWrite = 0;
				MemRead = 0;
				Jump = 0;
				Branch = 0;
				Error = 1;
				AUIlink = 0;
			end
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
`default_nettype none
module t04_aluop_mux (
	regB,
	imm,
	alu_src,
	opB
);
	reg _sv2v_0;
	input wire [31:0] regB;
	input wire [31:0] imm;
	input wire alu_src;
	output reg [31:0] opB;
	always @(*) begin
		if (_sv2v_0)
			;
		if (alu_src == 1)
			opB = imm;
		else
			opB = regB;
	end
	initial _sv2v_0 = 0;
endmodule
`default_nettype none
module t04_alu (
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
	t04_alu_control_unit ex1(
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
`default_nettype none
module t04_alu_control_unit (
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
`default_nettype none
module t04_reg_write_mux (
	immData,
	ALUData,
	MemData,
	PCData,
	RegWriteSrc,
	DataWrite
);
	reg _sv2v_0;
	input wire [31:0] immData;
	input wire [31:0] ALUData;
	input wire [31:0] MemData;
	input wire [31:0] PCData;
	input wire [1:0] RegWriteSrc;
	output reg [31:0] DataWrite;
	always @(*) begin
		if (_sv2v_0)
			;
		DataWrite = 0;
		if (RegWriteSrc == 0)
			DataWrite = ALUData;
		else if (RegWriteSrc == 2'b01)
			DataWrite = MemData;
		else if (RegWriteSrc == 2'b10)
			DataWrite = immData;
		else if (RegWriteSrc == 2'b11)
			DataWrite = PCData;
	end
	initial _sv2v_0 = 0;
endmodule
module t04_register_file (
	read_addr_1,
	read_addr_2,
	write_addr,
	clk,
	nrst,
	reg_enable_write,
	write_data,
	read_data_1,
	read_data_2,
	reg_file,
	enable
);
	reg _sv2v_0;
	input wire [4:0] read_addr_1;
	input wire [4:0] read_addr_2;
	input wire [4:0] write_addr;
	input wire clk;
	input wire nrst;
	input wire reg_enable_write;
	input wire [31:0] write_data;
	output reg [31:0] read_data_1;
	output reg [31:0] read_data_2;
	output reg [1023:0] reg_file;
	input enable;
	always @(posedge clk or negedge nrst)
		if (~nrst) begin : sv2v_autoblock_1
			integer i;
			for (i = 0; i < 32; i = i + 1)
				reg_file[i * 32+:32] <= 32'b00000000000000000000000000000000;
		end
		else if (((write_addr != 5'd0) && reg_enable_write) && enable)
			reg_file[write_addr * 32+:32] <= write_data;
	always @(*) begin
		if (_sv2v_0)
			;
		read_data_1 = reg_file[read_addr_1 * 32+:32];
		read_data_2 = reg_file[read_addr_2 * 32+:32];
	end
	initial _sv2v_0 = 0;
endmodule
module t04_memory_handler (
	addr,
	read_data_2,
	data_from_mem,
	en_read,
	en_write,
	size,
	data_to_reg,
	mem_write,
	mem_read,
	addr_to_mem,
	data_to_mem,
	select
);
	reg _sv2v_0;
	input wire [31:0] addr;
	input wire [31:0] read_data_2;
	input wire [31:0] data_from_mem;
	input wire en_read;
	input wire en_write;
	input wire [2:0] size;
	output reg [31:0] data_to_reg;
	output reg mem_write;
	output reg mem_read;
	output reg [31:0] addr_to_mem;
	output reg [31:0] data_to_mem;
	output reg [3:0] select;
	always @(*) begin
		if (_sv2v_0)
			;
		if (en_read) begin
			mem_read = 1;
			select = 4'b1111;
			addr_to_mem = addr;
			mem_write = 0;
			data_to_mem = 0;
			case (size)
				3'b100: data_to_reg = {24'b000000000000000000000000, data_from_mem[7:0]};
				3'b000: data_to_reg = {{24 {data_from_mem[7]}}, data_from_mem[7:0]};
				3'b101: data_to_reg = {16'b0000000000000000, data_from_mem[15:0]};
				3'b001: data_to_reg = {{16 {data_from_mem[16]}}, data_from_mem[15:0]};
				3'b010: data_to_reg = data_from_mem;
				default: data_to_reg = 0;
			endcase
		end
		else if (en_write) begin
			mem_read = 0;
			mem_write = 1;
			addr_to_mem = addr;
			data_to_mem = 0;
			data_to_reg = 0;
			case (size)
				3'b000: begin
					data_to_mem[7:0] = read_data_2[7:0];
					select = 4'b0001;
				end
				3'b001: begin
					data_to_mem[15:0] = read_data_2[15:0];
					select = 4'b0011;
				end
				3'b010: begin
					data_to_mem = read_data_2;
					select = 4'b1111;
				end
				default: begin
					data_to_mem = 0;
					select = 0;
				end
			endcase
		end
		else begin
			mem_read = 0;
			mem_write = 0;
			select = 0;
			data_to_mem = 0;
			data_to_reg = 0;
			addr_to_mem = 0;
		end
	end
	initial _sv2v_0 = 0;
endmodule
module t04_program_counter (
	nRst,
	enable,
	clk,
	immJumpValue,
	regJumpValue,
	doForceJump,
	doCondJump,
	condJumpValue,
	doRegJump,
	AUIlink,
	instructionAddress,
	linkAddress
);
	reg _sv2v_0;
	input wire nRst;
	input wire enable;
	input wire clk;
	input wire [31:0] immJumpValue;
	input wire [31:0] regJumpValue;
	input wire doForceJump;
	input wire doCondJump;
	input wire condJumpValue;
	input wire doRegJump;
	input wire AUIlink;
	output reg [31:0] instructionAddress;
	output reg [31:0] linkAddress;
	always @(*) begin
		if (_sv2v_0)
			;
		if (doForceJump)
			linkAddress = instructionAddress + 32'd4;
		else if (AUIlink)
			linkAddress = instructionAddress + immJumpValue;
		else
			linkAddress = 32'h00000000;
	end
	always @(negedge clk or negedge nRst)
		if (~nRst)
			instructionAddress <= 32'd0;
		else if (enable) begin
			if (doForceJump | (doCondJump & condJumpValue)) begin
				if (doRegJump & !doCondJump)
					instructionAddress <= regJumpValue + immJumpValue;
				else
					instructionAddress <= instructionAddress + immJumpValue;
			end
			else
				instructionAddress <= instructionAddress + 32'd4;
		end
		else
			instructionAddress <= instructionAddress;
	initial _sv2v_0 = 0;
endmodule
module t04_VGA_out (
	SRAM_data_in,
	SRAM_busy,
	clk,
	nrst,
	data_en,
	h_out,
	v_out,
	pixel_data,
	word_address_dest,
	byte_select,
	VGA_state,
	h_count,
	v_count,
	h_state,
	v_state
);
	reg _sv2v_0;
	input wire [31:0] SRAM_data_in;
	input wire SRAM_busy;
	input wire clk;
	input wire nrst;
	output reg data_en;
	output reg h_out;
	output reg v_out;
	output reg pixel_data;
	output wire [31:0] word_address_dest;
	output wire [3:0] byte_select;
	output reg [1:0] VGA_state;
	output reg [9:0] h_count;
	output reg [8:0] v_count;
	output reg [1:0] h_state;
	output reg [1:0] v_state;
	wire [31:0] word_address_base;
	reg [8:0] word_address_offset;
	wire change_state_h;
	wire change_state_v;
	reg v_count_toggle;
	reg [9:0] h_next_count;
	reg [8:0] v_next_count;
	reg [8:0] h_offset;
	reg [8:0] v_offset;
	wire [4:0] x_coord;
	wire [31:0] current_word;
	wire [31:0] next_word;
	assign word_address_base = 32'h00000000;
	reg [1:0] h_current_state;
	reg [1:0] h_next_state;
	always @(posedge clk or negedge nrst)
		if (~nrst) begin
			h_current_state <= 2'b00;
			h_count <= 0;
		end
		else begin
			h_current_state <= h_next_state;
			h_count <= h_next_count;
		end
	reg [1:0] v_current_state;
	reg [1:0] v_next_state;
	always @(posedge clk or negedge nrst)
		if (~nrst) begin
			v_current_state <= 2'b00;
			v_count <= 0;
		end
		else begin
			v_current_state <= v_next_state;
			v_count <= v_next_count;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		if ((v_current_state == 2'b10) & (v_count < 384))
			VGA_state = 2'b10;
		else if ((v_current_state == 2'b01) & (v_count > 9'd31))
			VGA_state = 2'b01;
		else
			VGA_state = 2'b00;
	end
	always @(*) begin
		if (_sv2v_0)
			;
		h_next_count = h_count;
		case (h_current_state)
			2'b00: begin
				h_state = 2'b00;
				v_count_toggle = 0;
				if (h_count < 37) begin
					h_next_count = h_next_count + 1'b1;
					h_out = 0;
					h_next_state = 2'b00;
				end
				else begin
					h_next_count = 0;
					h_out = 1;
					h_next_state = 2'b01;
				end
			end
			2'b01: begin
				h_state = 2'b01;
				h_out = 1;
				v_count_toggle = 0;
				if (h_count < 18) begin
					h_next_count = h_next_count + 1'b1;
					h_next_state = 2'b01;
				end
				else begin
					h_next_count = 0;
					h_next_state = 2'b10;
				end
			end
			2'b10: begin
				h_state = 2'b10;
				h_out = 1;
				v_count_toggle = 0;
				if (h_count < 256) begin
					h_next_count = h_next_count + 1'b1;
					h_next_state = 2'b10;
				end
				else begin
					h_next_count = 0;
					h_next_state = 2'b11;
				end
			end
			2'b11: begin
				h_state = 2'b11;
				h_out = 1;
				if (h_count < 5) begin
					h_next_count = h_next_count + 1'b1;
					h_next_state = 2'b11;
					v_count_toggle = 0;
				end
				else begin
					h_next_count = 0;
					h_next_state = 2'b00;
					v_count_toggle = 1;
				end
			end
		endcase
	end
	always @(*) begin
		if (_sv2v_0)
			;
		v_next_count = v_count;
		if (v_count_toggle)
			v_next_count = v_next_count + 1'b1;
		case (v_current_state)
			2'b00: begin
				v_state = 2'b00;
				if (v_count < 2) begin
					v_out = 0;
					v_next_state = 2'b00;
				end
				else begin
					v_next_count = 0;
					v_out = 1;
					v_next_state = 2'b01;
				end
			end
			2'b01: begin
				v_state = 2'b01;
				v_out = 1;
				if (v_count < 33)
					v_next_state = 2'b01;
				else begin
					v_next_count = 0;
					v_next_state = 2'b10;
				end
			end
			2'b10: begin
				v_state = 2'b10;
				v_out = 1;
				if (v_count < 480)
					v_next_state = 2'b10;
				else begin
					v_next_count = 0;
					v_next_state = 2'b11;
				end
			end
			2'b11: begin
				v_state = 2'b11;
				v_out = 1;
				if (v_count < 10)
					v_next_state = 2'b11;
				else begin
					v_next_count = 0;
					v_next_state = 2'b00;
				end
			end
		endcase
	end
	always @(*) begin
		if (_sv2v_0)
			;
		if (~SRAM_busy & data_en)
			pixel_data = SRAM_data_in[x_coord];
		else
			pixel_data = 0;
	end
	always @(*) begin
		if (_sv2v_0)
			;
		if ((((h_current_state == 2'b10) & (v_current_state == 2'b10)) & (h_count < 256)) & (v_count < 480))
			data_en = 1;
		else
			data_en = 0;
	end
	assign byte_select = {data_en, data_en, data_en, data_en};
	always @(*) begin
		if (_sv2v_0)
			;
		h_offset = {7'b0000000, h_count[7:6]};
		v_offset = 7'd4 * (v_count / 9'd5);
		word_address_offset = h_offset + v_offset;
	end
	assign word_address_dest = word_address_base + {23'b00000000000000000000000, word_address_offset};
	assign x_coord = 5'b11111 - h_count[5:1];
	initial _sv2v_0 = 0;
endmodule
module t04_VGA_data_controller (
	clk,
	nrst,
	VGA_request_address,
	data_from_SRAM,
	h_count,
	v_count,
	VGA_state,
	mem_busy,
	byte_select_out,
	read,
	data_to_VGA,
	SRAM_address
);
	reg _sv2v_0;
	input wire clk;
	input wire nrst;
	input wire [31:0] VGA_request_address;
	input wire [31:0] data_from_SRAM;
	input wire [9:0] h_count;
	input wire [8:0] v_count;
	input wire [1:0] VGA_state;
	input wire mem_busy;
	output reg [3:0] byte_select_out;
	output reg read;
	output reg [31:0] data_to_VGA;
	output reg [31:0] SRAM_address;
	reg [31:0] next_data;
	reg [31:0] next_address;
	reg [31:0] ready_data;
	reg [31:0] next_ready;
	always @(*) begin
		if (_sv2v_0)
			;
		if (VGA_state > 0) begin
			read = 1'b1;
			byte_select_out = 4'b1111;
		end
		else begin
			read = 1'b0;
			byte_select_out = 4'b0000;
		end
	end
	reg [1:0] state;
	reg [1:0] next_state;
	always @(posedge clk or negedge nrst)
		if (~nrst) begin
			state <= 2'd0;
			data_to_VGA <= 32'b00000000000000000000000000000000;
			SRAM_address <= 32'b00000000000000000000000000000000;
			ready_data <= 32'b00000000000000000000000000000000;
		end
		else begin
			state <= next_state;
			data_to_VGA <= next_data;
			SRAM_address <= next_address;
			ready_data <= next_ready;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		next_data = data_to_VGA;
		next_address = SRAM_address;
		next_ready = ready_data;
		case (state)
			2'd0: begin
				next_data = data_from_SRAM;
				next_ready = data_from_SRAM;
				next_state = 2'd2;
				next_address = SRAM_address;
			end
			2'd2: begin
				next_ready = ready_data;
				next_data = ready_data;
				next_address = SRAM_address;
				next_state = 2'd1;
			end
			2'd1: begin
				if (~mem_busy)
					next_ready = data_from_SRAM;
				else
					next_ready = ready_data;
				if (VGA_state == 1) begin
					next_address = 32'h00000000;
					next_data = ready_data;
					next_state = 2'd2;
				end
				else if (h_count[5:0] == 62)
					next_state = 2'd2;
				else if ((h_count[7:6] == 3) & ((v_count % 5) != 4)) begin
					next_address = VGA_request_address - 3;
					next_data = data_to_VGA;
					next_state = 2'd1;
				end
				else begin
					next_address = VGA_request_address + 1;
					next_data = data_to_VGA;
					next_state = 2'd1;
				end
			end
			default: next_state = 2'd0;
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
module t04_UART_Receiver (
	nRst,
	clk,
	enable,
	Rx,
	data_out,
	data_ready,
	working_data,
	bits_received,
	receiving,
	BAUD_counter,
	parity_error
);
	parameter BAUD_RATE = 9600;
	parameter CLOCK_FREQ = 10000000;
	parameter CYCLES_PER_BIT = CLOCK_FREQ / BAUD_RATE;
	input wire nRst;
	input wire clk;
	input wire enable;
	input wire Rx;
	output reg [7:0] data_out;
	output reg data_ready;
	output reg [8:0] working_data;
	output reg [3:0] bits_received;
	output reg receiving;
	output reg [31:0] BAUD_counter;
	output wire parity_error;
	reg BAUD_counter_state;
	always @(posedge clk or negedge nRst)
		if (~nRst)
			BAUD_counter <= 0;
		else if ((BAUD_counter_state == 1'b0) | (BAUD_counter == CYCLES_PER_BIT))
			BAUD_counter <= 0;
		else
			BAUD_counter <= BAUD_counter + 1;
	assign parity_error = 0;
	always @(posedge clk or negedge nRst)
		if (~nRst) begin
			data_out <= 8'b00000000;
			working_data <= 9'b000000000;
			receiving <= 1'b0;
			bits_received <= 4'b0000;
			data_ready <= 1'b0;
			BAUD_counter_state <= 1'b0;
		end
		else if (enable) begin
			if (receiving) begin
				BAUD_counter_state <= 1'b1;
				if (BAUD_counter == CYCLES_PER_BIT) begin
					if (bits_received == 4'd9) begin
						if (~parity_error) begin
							data_out <= working_data[8:1];
							working_data <= working_data;
							receiving <= 1'b0;
							bits_received <= 4'b0000;
							data_ready <= 1'b1;
							BAUD_counter_state <= 1'b0;
						end
						else begin
							data_out <= data_out;
							working_data <= 9'b000000000;
							receiving <= 1'b0;
							bits_received <= 4'b0000;
							data_ready <= 1'b0;
							BAUD_counter_state <= 1'b0;
						end
					end
					else begin
						data_out <= data_out;
						working_data <= {Rx, working_data[8:1]};
						receiving <= 1'b1;
						bits_received <= bits_received + 1;
						data_ready <= 1'b0;
						BAUD_counter_state <= 1'b1;
					end
				end
				else if ((BAUD_counter == (CYCLES_PER_BIT / 2)) & (bits_received == 0)) begin
					data_out <= data_out;
					working_data <= working_data;
					receiving <= 1'b1;
					bits_received <= bits_received + 1;
					data_ready <= 1'b0;
					BAUD_counter_state <= 1'b0;
				end
			end
			else if (Rx == 1'b0) begin
				data_out <= data_out;
				working_data <= 9'b000000000;
				receiving <= 1'b1;
				bits_received <= 4'b0000;
				data_ready <= 1'b0;
				BAUD_counter_state <= 1'b1;
			end
			else begin
				data_out <= data_out;
				working_data <= 9'b000000000;
				receiving <= 1'b0;
				bits_received <= 4'b0000;
				data_ready <= 1'b0;
				BAUD_counter_state <= 1'b0;
			end
		end
		else begin
			data_out <= 8'b00000000;
			working_data <= 9'b000000000;
			receiving <= 1'b0;
			bits_received <= 4'b0000;
			data_ready <= 1'b0;
			BAUD_counter_state <= 1'b0;
		end
endmodule
module t04_request_handler (
	clk,
	nRst,
	mem_busy,
	VGA_state,
	CPU_enable,
	VGA_enable,
	VGA_read,
	VGA_adr,
	data_to_VGA,
	data_from_UART,
	CPU_instr_adr,
	CPU_data_adr,
	CPU_read,
	CPU_write,
	data_from_CPU,
	CPU_sel,
	instr_data_to_CPU,
	data_to_CPU,
	data_from_mem,
	mem_read,
	mem_write,
	adr_to_mem,
	data_to_mem,
	sel_to_mem,
	uart_address
);
	reg _sv2v_0;
	input wire clk;
	input wire nRst;
	input wire mem_busy;
	input wire [1:0] VGA_state;
	output reg CPU_enable;
	output reg VGA_enable;
	input wire VGA_read;
	input wire [31:0] VGA_adr;
	output reg [31:0] data_to_VGA;
	input wire [31:0] data_from_UART;
	input wire [31:0] CPU_instr_adr;
	input wire [31:0] CPU_data_adr;
	input wire CPU_read;
	input wire CPU_write;
	input wire [31:0] data_from_CPU;
	input wire [3:0] CPU_sel;
	output reg [31:0] instr_data_to_CPU;
	output reg [31:0] data_to_CPU;
	input wire [31:0] data_from_mem;
	output reg mem_read;
	output reg mem_write;
	output reg [31:0] adr_to_mem;
	output reg [31:0] data_to_mem;
	output reg [3:0] sel_to_mem;
	input wire [31:0] uart_address;
	reg prev_busy;
	wire busy_edge;
	reg [1:0] current_client;
	reg [1:0] next_client;
	reg [31:0] instruction;
	reg [31:0] next_instruction;
	always @(posedge clk or negedge nRst)
		if (~nRst) begin
			current_client <= 2'd0;
			instruction <= 32'b00000000000000000000000000000000;
		end
		else begin
			current_client <= next_client;
			instruction <= next_instruction;
		end
	always @(posedge clk or negedge nRst)
		if (!nRst)
			prev_busy <= 1'b0;
		else
			prev_busy <= mem_busy;
	assign busy_edge = prev_busy && !mem_busy;
	always @(*) begin
		if (_sv2v_0)
			;
		next_client = current_client;
		if (!mem_busy) begin
			if (current_client == 2'd0)
				next_client = 2'd2;
			else if (current_client == 2'd1) begin
				if ((VGA_state == 2'd2) | (VGA_state == 2'd1))
					next_client = 2'd1;
				else
					next_client = 2'd2;
			end
			else if (current_client == 2'd2)
				next_client = 2'd3;
			else if (VGA_state == 2'd0)
				next_client = 2'd2;
			else
				next_client = 2'd1;
		end
		if (mem_busy || (next_client == 2'd0)) begin
			mem_read = 1'b0;
			mem_write = 1'b0;
			adr_to_mem = 32'b00000000000000000000000000000000;
			data_to_mem = 32'b00000000000000000000000000000000;
			sel_to_mem = 4'b0000;
			if (current_client == 2'd1)
				adr_to_mem = VGA_adr;
			else if (current_client == 2'd2)
				adr_to_mem = CPU_instr_adr;
			else if (CPU_data_adr == uart_address)
				adr_to_mem = 32'h00000000;
			else begin
				adr_to_mem = CPU_data_adr;
				data_to_mem = data_from_CPU;
				sel_to_mem = CPU_sel;
				mem_write = CPU_write;
				mem_read = CPU_read;
			end
		end
		else if (next_client == 2'd1) begin
			mem_read = VGA_read;
			mem_write = 1'b0;
			adr_to_mem = VGA_adr;
			data_to_mem = 32'b00000000000000000000000000000000;
			sel_to_mem = 4'b1111;
		end
		else if (next_client == 2'd2) begin
			mem_read = 1'b1;
			mem_write = 1'b0;
			if (current_client == 2'd3)
				adr_to_mem = CPU_instr_adr + 32'd4;
			else
				adr_to_mem = CPU_instr_adr;
			data_to_mem = 32'b00000000000000000000000000000000;
			sel_to_mem = 4'b1111;
		end
		else if (CPU_data_adr == uart_address) begin
			mem_read = 1'b0;
			mem_write = 1'b0;
			adr_to_mem = 32'h00000000;
			data_to_mem = 32'h00000000;
			sel_to_mem = 4'b0000;
		end
		else begin
			if (~mem_busy)
				mem_write = CPU_write;
			else
				mem_write = 1'b0;
			mem_read = CPU_read;
			adr_to_mem = CPU_data_adr;
			data_to_mem = data_from_CPU;
			sel_to_mem = CPU_sel;
		end
		if (~mem_busy && (next_client == 2'd3))
			instr_data_to_CPU = data_from_mem;
		else
			instr_data_to_CPU = instruction;
		if (mem_busy | (current_client == 2'd0)) begin
			data_to_VGA = 32'b00000000000000000000000000000000;
			next_instruction = instruction;
			data_to_CPU = 32'b00000000000000000000000000000000;
		end
		else if (current_client == 2'd1) begin
			data_to_VGA = data_from_mem;
			next_instruction = 32'b00000000000000000000000000000000;
			data_to_CPU = 32'b00000000000000000000000000000000;
		end
		else if (current_client == 2'd2) begin
			data_to_VGA = 32'b00000000000000000000000000000000;
			next_instruction = data_from_mem;
			data_to_CPU = 32'b00000000000000000000000000000000;
		end
		else begin
			data_to_VGA = 32'b00000000000000000000000000000000;
			next_instruction = instruction;
			if (CPU_data_adr == uart_address)
				data_to_CPU = data_from_UART;
			else
				data_to_CPU = data_from_mem;
		end
		if (~mem_busy & (current_client == 2'd3))
			CPU_enable = 1'b1;
		else
			CPU_enable = 1'b0;
		if (~mem_busy & (current_client == 2'd1))
			VGA_enable = 1'b1;
		else
			VGA_enable = 1'b0;
	end
	initial _sv2v_0 = 0;
endmodule