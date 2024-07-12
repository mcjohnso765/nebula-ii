`default_nettype none
module team_05 (
	clk,
	nrst,
	en,
	la_data_in,
	la_data_out,
	la_oenb,
	gpio_in,
	gpio_out,
	gpio_oeb,
	DAT_I,
	ACK_I,
	ADR_O,
	DAT_O,
	SEL_O,
	WE_O,
	STB_O,
	CYC_O
);
	input wire clk;
	input wire nrst;
	input wire en;
	input wire [127:0] la_data_in;
	output wire [127:0] la_data_out;
	input wire [127:0] la_oenb;
	input wire [33:0] gpio_in;
	output wire [33:0] gpio_out;
	output wire [33:0] gpio_oeb;
	input wire [31:0] DAT_I;
	input wire ACK_I;
	output wire [31:0] ADR_O;
	output wire [31:0] DAT_O;
	output wire [3:0] SEL_O;
	output wire WE_O;
	output wire STB_O;
	output wire CYC_O;
	assign la_data_out = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
	wire [3:0] keypad_out;
	wire [7:0] lcd_data;
	wire lcd_en;
	wire lcd_rs;
	wire lcd_rw;
	assign gpio_out = {gpio_in[33:30], 15'b000000000000000, keypad_out, lcd_data, lcd_en, lcd_rs, lcd_rw};
	assign gpio_oeb = 1'sb1;
	wire [31:0] CPU_DAT_I;
	wire [31:0] ADR_I;
	wire [3:0] SEL_I;
	wire WRITE_I;
	wire READ_I;
	wire [31:0] CPU_DAT_O;
	wire BUSY_O;
	assign SEL_I = 4'b1111;
	wishbone_manager wishbone(
		.nRST(nrst),
		.CLK(clk),
		.DAT_I(DAT_I),
		.ACK_I(ACK_I),
		.CPU_DAT_I(CPU_DAT_I),
		.ADR_I(ADR_I),
		.SEL_I(SEL_I),
		.WRITE_I(WRITE_I),
		.READ_I(READ_I),
		.ADR_O(ADR_O),
		.DAT_O(DAT_O),
		.SEL_O(SEL_O),
		.WE_O(WE_O),
		.STB_O(STB_O),
		.CYC_O(CYC_O),
		.CPU_DAT_O(CPU_DAT_O),
		.BUSY_O(BUSY_O)
	);
	always @(WRITE_I or READ_I or ADR_I or CPU_DAT_I or SEL_I or CPU_DAT_O or BUSY_O)
		$monitor("[Manager Monitor] WRITE_I=%h, READ_I=%h, ADR_I=%h, CPU_DAT_I=%h, SEL_I=%h, CPU_DAT_O=%h, BUSY_O=%h", WRITE_I, READ_I, ADR_I, CPU_DAT_I, SEL_I, CPU_DAT_O, BUSY_O);
	t05_complete_design total_design(
		.data_in_BUS(CPU_DAT_O),
		.bus_full(BUSY_O),
		.en(en),
		.clk(clk),
		.rst(~nrst),
		.keypad_in(gpio_in[33:30]),
		.data_out_BUS(CPU_DAT_I),
		.address_out(ADR_I),
		.data_write(WRITE_I),
		.mem_read(READ_I),
		.keypad_out(keypad_out),
		.lcd_data(lcd_data),
		.lcd_en(lcd_en),
		.lcd_rs(lcd_rs),
		.lcd_rw(lcd_rw)
	);
endmodule
module t05_complete_design (
	data_in_BUS,
	bus_full,
	en,
	clk,
	rst,
	keypad_in,
	data_out_BUS,
	address_out,
	data_write,
	mem_read,
	keypad_out,
	lcd_data,
	lcd_en,
	lcd_rw,
	lcd_rs
);
	reg _sv2v_0;
	input wire [31:0] data_in_BUS;
	input wire bus_full;
	input wire en;
	input wire clk;
	input wire rst;
	input wire [3:0] keypad_in;
	output reg [31:0] data_out_BUS;
	output wire [31:0] address_out;
	output reg data_write;
	output reg mem_read;
	output reg [3:0] keypad_out;
	output reg [7:0] lcd_data;
	output reg lcd_en;
	output reg lcd_rw;
	output reg lcd_rs;
	wire [31:0] data_out_BUS_int;
	wire [3:0] keypad_out_int;
	wire [7:0] lcd_data_int;
	wire lcd_en_int;
	wire lcd_rs_int;
	wire lcd_rw_int;
	always @(*) begin
		if (_sv2v_0)
			;
		if (!en) begin
			data_out_BUS = 1'sb0;
			keypad_out = 1'sb0;
			lcd_data = 1'sb0;
			lcd_en = 1'sb0;
			lcd_rs = 1'sb0;
			lcd_rw = 1'sb0;
		end
		else begin
			data_out_BUS = data_out_BUS_int;
			keypad_out = keypad_out_int;
			lcd_data = lcd_data_int;
			lcd_en = lcd_en_int;
			lcd_rs = lcd_rs_int;
			lcd_rw = lcd_rw_int;
		end
	end
	wire [31:0] data_to_CPU;
	wire [31:0] data_from_CPU;
	wire [31:0] CPU_address;
	wire [31:0] data_from_keypad;
	wire [31:0] LCD_out;
	wire [31:0] data_to_LCD;
	wire [2:0] lcd_word;
	wire mem_access;
	wire CPU_data_write;
	wire CPU_mem_read;
	wire data_ready;
	wire key_confirm;
	reg key_data;
	reg next_key_data;
	wire comb_key_data;
	always @(*) begin
		if (_sv2v_0)
			;
		if (key_data & !key_confirm)
			next_key_data = 1'sb1;
		else
			next_key_data = comb_key_data;
	end
	always @(posedge clk) key_data <= next_key_data;
	assign data_ready = (key_data ? !key_confirm : bus_full);
	t05_cpu_core core(
		.data_in_BUS(data_to_CPU),
		.bus_full(data_ready),
		.en(en),
		.clk(clk),
		.rst(rst),
		.data_out_BUS(data_from_CPU),
		.address_out(CPU_address),
		.data_write(CPU_data_write),
		.mem_read(CPU_mem_read)
	);
	always @(*) begin
		if (_sv2v_0)
			;
		if (mem_access) begin
			data_write = CPU_data_write;
			mem_read = CPU_mem_read;
		end
		else begin
			data_write = 1'sb0;
			mem_read = 1'sb0;
		end
	end
	keypad_interface keypad0(
		.clk(clk),
		.rst(rst),
		.columns(keypad_in),
		.rows(keypad_out_int),
		.key_out_bin(data_from_keypad),
		.key_confirm(key_confirm)
	);
	bin_to_LCD bin2lcd(
		.binary_in(data_to_LCD),
		.LCD_out(LCD_out)
	);
	wire [255:0] lcd_storage;
	lcd_controller lcd_display(
		.clk(clk),
		.rst(rst),
		.row_1(lcd_storage[255:128]),
		.row_2(lcd_storage[127:0]),
		.lcd_en(lcd_en_int),
		.lcd_rw(lcd_rw_int),
		.lcd_rs(lcd_rs_int),
		.lcd_data(lcd_data_int)
	);
	memory_mapping map(
		.mem_address(CPU_address),
		.data_from_CPU(data_from_CPU),
		.data_from_keypad(data_from_keypad),
		.data_from_memory(data_in_BUS),
		.output_address(address_out),
		.data_to_CPU(data_to_CPU),
		.data_to_LCD(data_to_LCD),
		.data_to_memory(data_out_BUS_int),
		.lcd_word(lcd_word),
		.mem_access(mem_access),
		.key_data(comb_key_data)
	);
	reg [255:0] lcd_interim;
	assign lcd_storage = {lcd_interim[224+:32], lcd_interim[192+:32], lcd_interim[160+:32], lcd_interim[128+:32], lcd_interim[96+:32], lcd_interim[64+:32], lcd_interim[32+:32], lcd_interim[0+:32]};
	always @(posedge clk or posedge rst)
		if (rst) begin
			lcd_interim[224+:32] <= 1'sb0;
			lcd_interim[192+:32] <= 1'sb0;
			lcd_interim[160+:32] <= 1'sb0;
			lcd_interim[128+:32] <= 1'sb0;
			lcd_interim[96+:32] <= 1'sb0;
			lcd_interim[64+:32] <= 1'sb0;
			lcd_interim[32+:32] <= 1'sb0;
			lcd_interim[0+:32] <= 1'sb0;
		end
		else if (LCD_out != 32'hffffffff)
			lcd_interim[lcd_word * 32+:32] <= LCD_out;
		else
			lcd_interim <= lcd_interim;
	initial _sv2v_0 = 0;
endmodule
module memory_mapping (
	mem_address,
	data_from_CPU,
	data_from_keypad,
	data_from_memory,
	output_address,
	data_to_CPU,
	data_to_LCD,
	data_to_memory,
	lcd_word,
	mem_access,
	key_data
);
	reg _sv2v_0;
	input wire [31:0] mem_address;
	input wire [31:0] data_from_CPU;
	input wire [31:0] data_from_keypad;
	input wire [31:0] data_from_memory;
	output reg [31:0] output_address;
	output reg [31:0] data_to_CPU;
	output reg [31:0] data_to_LCD;
	output reg [31:0] data_to_memory;
	output reg [2:0] lcd_word;
	output reg mem_access;
	output reg key_data;
	always @(*) begin
		if (_sv2v_0)
			;
		if (mem_address == 32'h33000ffc) begin
			data_to_CPU = data_from_keypad;
			data_to_LCD = 1'sb1;
			data_to_memory = 1'sb0;
			output_address = 1'sb0;
			lcd_word = 1'sb0;
			mem_access = 1'sb0;
			key_data = 1'sb1;
		end
		else if ((mem_address < 32'h33000ffc) & (mem_address > 32'h33000fd8)) begin
			data_to_LCD = data_from_CPU;
			data_to_CPU = 1'sb0;
			data_to_memory = 1'sb0;
			output_address = 1'sb0;
			case (mem_address)
				32'h33000fdc: lcd_word = 3'b000;
				32'h33000fe0: lcd_word = 3'b001;
				32'h33000fe4: lcd_word = 3'b010;
				32'h33000fe8: lcd_word = 3'b011;
				32'h33000fec: lcd_word = 3'b100;
				32'h33000ff0: lcd_word = 3'b101;
				32'h33000ff4: lcd_word = 3'b110;
				32'h33000ff8: lcd_word = 3'b111;
				default: lcd_word = 3'b000;
			endcase
			mem_access = 1'sb0;
			key_data = 1'sb0;
		end
		else begin
			data_to_CPU = data_from_memory;
			data_to_memory = data_from_CPU;
			data_to_LCD = 1'sb1;
			output_address = mem_address;
			lcd_word = 1'sb0;
			mem_access = 1'sb1;
			key_data = 1'sb0;
		end
	end
	initial _sv2v_0 = 0;
endmodule
module t05_cpu_core (
	data_in_BUS,
	bus_full,
	en,
	clk,
	rst,
	data_out_BUS,
	address_out,
	data_write,
	mem_read
);
	reg _sv2v_0;
	input wire [31:0] data_in_BUS;
	input wire bus_full;
	input wire en;
	input wire clk;
	input wire rst;
	output reg [31:0] data_out_BUS;
	output reg [31:0] address_out;
	output reg data_write;
	output reg mem_read;
	wire [31:0] address_out_int;
	wire [31:0] data_out_BUS_int;
	wire data_write_int;
	reg mem_read_int;
	wire [2:0] next_state;
	always @(*) begin
		if (_sv2v_0)
			;
		if (!en) begin
			data_out_BUS = 32'b00000000000000000000000000000000;
			address_out = 32'b00000000000000000000000000000000;
			data_write = 1'b0;
			mem_read = 1'b0;
		end
		else begin
			data_out_BUS = data_out_BUS_int;
			address_out = address_out_int;
			data_write = data_write_int;
			mem_read = (next_state == 3'd4 ? 0 : mem_read_int);
		end
	end
	wire [31:0] instruction;
	wire [6:0] funct7;
	wire [6:0] opcode;
	wire [2:0] funct3;
	wire ALU_source;
	wire [31:0] imm_32;
	wire [31:0] pc_jump;
	wire [4:0] rs1;
	wire [4:0] rs2;
	wire [4:0] rd;
	wire memToReg;
	wire load_pc;
	wire [31:0] reg_write;
	wire reg_write_en;
	wire [31:0] reg1;
	wire [31:0] reg2;
	wire [31:0] read_address;
	wire [31:0] write_address;
	wire [31:0] result;
	wire branch;
	wire [31:0] address_in;
	wire [31:0] data_in_CPU;
	reg data_en;
	wire instr_en;
	wire memWrite;
	wire memRead;
	wire [2:0] state;
	reg [2:0] prev_state;
	wire [31:0] data_out_CPU;
	wire [31:0] data_out_INSTR;
	wire inc;
	wire [31:0] data_read_adr_i;
	wire [31:0] data_write_adr_i;
	wire [31:0] data_bus_i;
	reg data_good;
	wire bus_full_CPU;
	wire data_read;
	wire [31:0] data_adr_o;
	wire [31:0] data_bus_o;
	wire [31:0] data_cpu_o;
	wire [31:0] pc_val;
	reg [31:0] instruction_i;
	reg instr_fetch;
	wire next_instr_fetch;
	wire [31:0] instruction_adr_o;
	wire [31:0] mem_adr_i;
	reg branch_ff;
	reg instr_wait;
	reg next_instr_wait;
	reg memToReg_flipflop;
	assign mem_adr_i = (data_read | data_write_int ? data_adr_o : instruction_adr_o);
	always @(*) begin
		if (_sv2v_0)
			;
		data_en = data_read | data_write_int;
		mem_read_int = data_read | instr_fetch;
		next_instr_wait = ((read_address != 32'b00000000000000000000000000000000) | (write_address != 32'b00000000000000000000000000000000)) & ~data_good;
	end
	reg [31:0] load_data_flipflop;
	reg [31:0] reg_write_flipflop;
	reg [31:0] instruction_adr_i;
	wire disable_pc;
	reg disable_pc_reg;
	always @(posedge clk or posedge rst)
		if (rst) begin
			memToReg_flipflop <= 1'b0;
			reg_write_flipflop <= 1'sb0;
			load_data_flipflop <= 1'sb0;
			instr_wait <= 1'b0;
			instruction_adr_i <= 1'sb0;
			instruction_i <= 1'sb0;
			prev_state <= 3'd0;
			instr_fetch <= 1'sb0;
			disable_pc_reg <= 1'sb0;
		end
		else begin
			memToReg_flipflop <= memToReg;
			reg_write_flipflop <= reg_write;
			load_data_flipflop <= data_cpu_o;
			instr_wait <= next_instr_wait;
			instruction_adr_i <= pc_val;
			instruction_i <= data_out_INSTR;
			prev_state <= state;
			instr_fetch <= next_instr_fetch;
			disable_pc_reg <= disable_pc;
		end
	wire [31:0] ALU_val2;
	assign ALU_val2 = (ALU_source ? imm_32 : reg2);
	t05_instruction_memory instr_mem(
		.instruction_adr_i(instruction_adr_i),
		.instruction_i(instruction_i),
		.clk(clk),
		.data_good(!bus_full),
		.rst(rst),
		.state(prev_state),
		.instr_fetch(next_instr_fetch),
		.instruction_adr_o(instruction_adr_o),
		.instruction_o(instruction),
		.instr_wait(instr_wait)
	);
	t05_control_unit ctrl(
		.instruction(instruction),
		.opcode(opcode),
		.funct7(funct7),
		.funct3(funct3),
		.rs1(rs1),
		.rs2(rs2),
		.rd(rd),
		.imm_32(imm_32),
		.ALU_source(ALU_source),
		.memToReg(memToReg),
		.load(load_pc)
	);
	assign reg_write = (memToReg ? data_cpu_o : result);
	assign reg_write_en = (!instr_fetch ? 1'b1 : 1'b0);
	wire [31:0] register_out;
	t05_register_file regFile(
		.reg_write(reg_write),
		.clk(clk),
		.rst(rst),
		.write(reg_write_en),
		.rd(rd),
		.rs1(rs1),
		.rs2(rs2),
		.reg1(reg1),
		.reg2(reg2),
		.register_out(register_out)
	);
	wire branch_temp;
	t05_ALU math(
		.ALU_source(ALU_source),
		.opcode(opcode),
		.funct3(funct3),
		.funct7(funct7),
		.reg1(reg1),
		.val2(ALU_val2),
		.read_address(read_address),
		.write_address(write_address),
		.result(result),
		.branch(branch),
		.pc_data(pc_jump),
		.pc_val(pc_val)
	);
	always @(*) begin
		if (_sv2v_0)
			;
		data_good = !bus_full && (state == 3'd6);
	end
	reg [31:0] val2;
	wire data_access;
	always @(*) begin
		if (_sv2v_0)
			;
		val2 = reg2;
		branch_ff = ((((opcode == 7'b1100011) && (((((funct3 == 3'b000) && (reg1 == val2)) | ((funct3 == 3'b100) && (reg1 < val2))) | ((funct3 == 3'b001) && (reg1 != val2))) | ((funct3 == 3'b101) && (reg1 >= val2)))) | (opcode == 7'b1101111)) | (opcode == 7'b1100111) ? 1'b1 : 1'b0);
	end
	t05_data_memory data_mem(
		.data_read_adr_i(read_address),
		.data_write_adr_i(write_address),
		.data_cpu_i(reg2),
		.data_bus_i(data_out_CPU),
		.clk(clk),
		.rst(rst),
		.data_good(!bus_full),
		.state(prev_state),
		.data_read(data_read),
		.data_write(data_write_int),
		.data_adr_o(data_adr_o),
		.data_bus_o(data_bus_o),
		.data_cpu_o(data_cpu_o)
	);
	t05_memcontrol mem_ctrl(
		.address_in(mem_adr_i),
		.data_in_CPU(data_bus_o),
		.data_in_BUS(data_in_BUS),
		.data_en(data_en),
		.instr_en(instr_fetch),
		.bus_full(bus_full),
		.memWrite(data_write_int),
		.memRead(mem_read_int),
		.clk(clk),
		.rst(rst),
		.en(en),
		.state(state),
		.next_state(next_state),
		.address_out(address_out_int),
		.data_out_CPU(data_out_CPU),
		.data_out_BUS(data_out_BUS_int),
		.data_out_INSTR(data_out_INSTR),
		.bus_full_CPU(bus_full_CPU),
		.data_access(data_access)
	);
	wire [31:0] pc_input;
	assign disable_pc = instr_wait;
	t05_pc program_count(
		.clk(clk),
		.clr(rst),
		.load(load_pc),
		.inc((data_good & en) & !data_access),
		.ALU_out(branch_ff),
		.Disable(disable_pc_reg),
		.data(pc_jump),
		.imm_val(imm_32),
		.pc_val(pc_val)
	);
	initial _sv2v_0 = 0;
endmodule
module t05_ALU (
	ALU_source,
	opcode,
	funct3,
	funct7,
	reg1,
	val2,
	pc_val,
	read_address,
	write_address,
	result,
	pc_data,
	branch
);
	reg _sv2v_0;
	input wire ALU_source;
	input wire [6:0] opcode;
	input wire [2:0] funct3;
	input wire [6:0] funct7;
	input wire [31:0] reg1;
	input wire [31:0] val2;
	input wire [31:0] pc_val;
	output reg [31:0] read_address;
	output reg [31:0] write_address;
	output reg [31:0] result;
	output reg [31:0] pc_data;
	output reg branch;
	always @(*) begin
		if (_sv2v_0)
			;
		pc_data = 32'b00000000000000000000000000000000;
		read_address = 32'b00000000000000000000000000000000;
		write_address = 32'b00000000000000000000000000000000;
		result = 32'b00000000000000000000000000000000;
		branch = 1'b0;
		case (opcode)
			7'b0000011: read_address = reg1 + val2;
			7'b0100011: write_address = reg1 + val2;
			7'b0110011:
				case (funct3)
					3'b000:
						if (funct7 == 7'b0100000)
							result = reg1 - val2;
						else
							result = reg1 + val2;
					3'b010:
						if (funct7 == 7'b0100000)
							result = reg1 - val2;
						else
							result = reg1 + val2;
					3'b100: result = reg1 ^ val2;
					3'b110: result = reg1 | val2;
					3'b111: result = reg1 & val2;
					3'b001: result = reg1 << val2[4:0];
					3'b101: result = reg1 >> val2[4:0];
					default: begin
						result = 32'b00000000000000000000000000000000;
						read_address = 32'b00000000000000000000000000000000;
						write_address = 32'b00000000000000000000000000000000;
					end
				endcase
			7'b0010011:
				case (funct3)
					3'b000:
						if (funct7 == 7'b0100000)
							result = reg1 - val2;
						else
							result = reg1 + val2;
					3'b010:
						if (funct7 == 7'b0100000)
							result = reg1 - val2;
						else
							result = reg1 + val2;
					3'b100: result = reg1 ^ val2;
					3'b110: result = reg1 | val2;
					3'b111: result = reg1 & val2;
					3'b001: result = reg1 << val2[4:0];
					3'b101: result = reg1 >> val2[4:0];
					default: begin
						result = 32'b00000000000000000000000000000000;
						read_address = 32'b00000000000000000000000000000000;
						write_address = 32'b00000000000000000000000000000000;
					end
				endcase
			7'b1100011:
				case (funct3)
					3'b000:
						if (reg1 == val2)
							branch = 1'b1;
						else
							branch = 1'b0;
					3'b001:
						if (reg1 != val2)
							branch = 1'b1;
						else
							branch = 1'b0;
					3'b100:
						if (reg1 < val2)
							branch = 1'b1;
						else
							branch = 1'b0;
					3'b101:
						if (reg1 >= val2)
							branch = 1'b1;
						else
							branch = 1'b0;
					default: branch = 1'b0;
				endcase
			7'b1101111: begin
				branch = 1'b1;
				result = pc_val + 32'd4;
			end
			7'b1100111: begin
				branch = 1'b1;
				result = pc_val + 32'd4;
				pc_data = reg1 + val2;
			end
			7'b0110111: result = {val2[19:0], 12'b000000000000};
			default: begin
				read_address = 32'b00000000000000000000000000000000;
				write_address = 32'b00000000000000000000000000000000;
				result = 32'b00000000000000000000000000000000;
				branch = 1'b0;
			end
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
module t05_control_unit (
	instruction,
	opcode,
	funct7,
	funct3,
	rs1,
	rs2,
	rd,
	imm_32,
	ALU_source,
	memToReg,
	load
);
	reg _sv2v_0;
	input wire [31:0] instruction;
	output reg [6:0] opcode;
	output reg [6:0] funct7;
	output reg [2:0] funct3;
	output reg [4:0] rs1;
	output reg [4:0] rs2;
	output reg [4:0] rd;
	output reg [31:0] imm_32;
	output reg ALU_source;
	output reg memToReg;
	output reg load;
	always @(*) begin
		if (_sv2v_0)
			;
		opcode = instruction[6:0];
		rd = 5'b00000;
		imm_32 = 32'h00000000;
		rs1 = 5'b00000;
		rs2 = 5'b00000;
		funct3 = 3'b000;
		funct7 = 7'b0000000;
		ALU_source = 1'b0;
		memToReg = 1'b0;
		load = 1'b0;
		case (instruction[6:0])
			7'b0110011: begin
				funct3 = instruction[14:12];
				funct7 = instruction[31:25];
				rd = instruction[11:7];
				rs1 = instruction[19:15];
				rs2 = instruction[24:20];
				imm_32 = 32'b00000000000000000000000000000000;
				ALU_source = 1'b0;
				memToReg = 1'b0;
				load = 1'b0;
			end
			7'b0010011: begin
				funct3 = instruction[14:12];
				rd = instruction[11:7];
				rs1 = instruction[19:15];
				imm_32 = {{20 {instruction[31]}}, instruction[31:20]};
				funct7 = 7'b0000000;
				rs2 = 5'b00000;
				ALU_source = 1'b1;
				memToReg = 1'b0;
				load = 1'b0;
			end
			7'b0000011: begin
				funct3 = instruction[14:12];
				rd = instruction[11:7];
				rs1 = instruction[19:15];
				imm_32 = {{20 {instruction[31]}}, instruction[31:20]};
				funct7 = 7'b0000000;
				rs2 = 5'b00000;
				ALU_source = 1'b1;
				memToReg = 1'b1;
				load = 1'b0;
			end
			7'b1100111: begin
				funct3 = instruction[14:12];
				rd = instruction[11:7];
				rs1 = instruction[19:15];
				imm_32 = {{20 {instruction[31]}}, instruction[31:20]};
				funct7 = 7'b0000000;
				rs2 = 5'b00000;
				ALU_source = 1'b1;
				memToReg = 1'b0;
				load = 1'b1;
			end
			7'b0100011: begin
				funct3 = instruction[14:12];
				rs1 = instruction[19:15];
				rs2 = instruction[24:20];
				imm_32 = {{20 {instruction[31]}}, instruction[31:25], instruction[11:7]};
				funct7 = 7'b0000000;
				rd = 5'b00000;
				ALU_source = 1'b1;
				memToReg = 1'b0;
				load = 1'b0;
			end
			7'b1100011: begin
				funct3 = instruction[14:12];
				rs1 = instruction[19:15];
				rs2 = instruction[24:20];
				imm_32 = {{20 {instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8]} << 1;
				funct7 = 7'b0000000;
				rd = 5'b00000;
				ALU_source = 1'b1;
				memToReg = 1'b0;
				load = 1'b0;
			end
			7'b1101111: begin
				rd = instruction[11:7];
				imm_32 = ({{12 {instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21]} << 1) - 32'd4;
				rs1 = 5'b00000;
				rs2 = 5'b00000;
				funct3 = 3'b000;
				funct7 = 7'b0000000;
				ALU_source = 1'b1;
				memToReg = 1'b0;
				load = 1'b0;
			end
			7'b0110111: begin
				rd = instruction[11:7];
				imm_32 = {{12 {instruction[31]}}, instruction[31:12]};
				rs1 = 5'b00000;
				rs2 = 5'b00000;
				funct3 = 3'b000;
				funct7 = 7'b0000000;
				ALU_source = 1'b1;
				memToReg = 1'b0;
				load = 1'b0;
			end
			default: begin
				rd = 5'b00000;
				imm_32 = 32'b00000000000000000000000000000000;
				rs1 = 5'b00000;
				rs2 = 5'b00000;
				funct3 = 3'b000;
				funct7 = 7'b0000000;
				ALU_source = 1'b0;
				memToReg = 1'b0;
				load = 1'b0;
			end
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
module t05_data_memory (
	data_read_adr_i,
	data_write_adr_i,
	data_bus_i,
	data_cpu_i,
	clk,
	data_good,
	rst,
	state,
	data_read,
	data_write,
	data_adr_o,
	data_bus_o,
	data_cpu_o
);
	reg _sv2v_0;
	input wire [31:0] data_read_adr_i;
	input wire [31:0] data_write_adr_i;
	input wire [31:0] data_bus_i;
	input wire [31:0] data_cpu_i;
	input wire clk;
	input wire data_good;
	input wire rst;
	input wire [2:0] state;
	output reg data_read;
	output reg data_write;
	output reg [31:0] data_adr_o;
	output reg [31:0] data_bus_o;
	output reg [31:0] data_cpu_o;
	reg next_read;
	reg next_write;
	reg last_read;
	reg [31:0] stored_read_data;
	reg [31:0] stored_write_data;
	reg [31:0] stored_data_adr;
	reg [31:0] data_read_adr_reg;
	reg [31:0] data_write_adr_reg;
	reg [31:0] data_read_adr_reg2;
	reg [31:0] data_bus_i_reg;
	reg [31:0] data_cpu_i_reg;
	always @(*) begin
		if (_sv2v_0)
			;
		next_read = 1'b0;
		next_write = 1'b0;
		stored_read_data = 32'b00000000000000000000000000000000;
		stored_write_data = 32'b00000000000000000000000000000000;
		stored_data_adr = 1'sb0;
		if (state == 3'd6) begin
			next_read = 1'sb0;
			next_write = 1'sb0;
			stored_data_adr = 1'sb0;
			stored_read_data = 1'sb0;
			stored_write_data = 1'sb0;
		end
		else if ((data_read_adr_reg != 32'b00000000000000000000000000000000) & (state == 3'd1)) begin
			next_read = 1'sb1;
			next_write = 1'sb0;
			stored_data_adr = data_read_adr_reg;
			stored_read_data = 1'sb0;
			stored_write_data = 1'sb0;
		end
		else if ((data_write_adr_reg != 32'b00000000000000000000000000000000) & (state == 3'd1)) begin
			next_read = 1'sb0;
			next_write = 1'sb1;
			stored_data_adr = data_write_adr_reg;
			stored_read_data = 1'sb0;
			stored_write_data = 1'sb0;
		end
		else if ((data_read_adr_reg != 32'b00000000000000000000000000000000) & (state == 3'd4)) begin
			next_read = 1'sb0;
			next_write = 1'sb0;
			stored_data_adr = 1'sb0;
			stored_read_data = data_bus_i_reg;
			stored_write_data = 1'sb0;
		end
		else if ((data_write_adr_reg != 32'b00000000000000000000000000000000) & (state == 3'd5)) begin
			next_read = 1'sb0;
			next_write = 1'sb0;
			stored_data_adr = 1'sb0;
			stored_write_data = data_cpu_i_reg;
			stored_read_data = 1'sb0;
		end
		if ((last_read == 1'b0) & (data_read == 1'b1)) begin
			next_read = 1'sb1;
			stored_data_adr = data_read_adr_reg2;
		end
	end
	always @(posedge clk or posedge rst)
		if (rst) begin
			data_adr_o <= 32'b00000000000000000000000000000000;
			data_bus_o <= 32'b00000000000000000000000000000000;
			data_cpu_o <= 32'b00000000000000000000000000000000;
			data_read <= 1'b0;
			data_write <= 1'b0;
			data_read_adr_reg <= 1'sb0;
			data_write_adr_reg <= 1'sb0;
			data_bus_i_reg <= 1'sb0;
			data_cpu_i_reg <= 1'sb0;
			last_read <= 1'b0;
			data_read_adr_reg2 <= 1'sb0;
		end
		else begin
			data_read <= next_read;
			data_write <= next_write;
			data_adr_o <= stored_data_adr;
			data_read_adr_reg <= data_read_adr_i;
			data_write_adr_reg <= data_write_adr_i;
			data_cpu_o <= stored_read_data;
			data_bus_o <= stored_write_data;
			data_bus_i_reg <= data_bus_i;
			data_cpu_i_reg <= data_cpu_i;
			last_read <= data_read;
			data_read_adr_reg2 <= data_read_adr_reg;
		end
	initial _sv2v_0 = 0;
endmodule
module t05_instruction_memory (
	instruction_adr_i,
	instruction_i,
	clk,
	data_good,
	rst,
	instr_wait,
	state,
	instr_fetch,
	instruction_adr_o,
	instruction_o
);
	reg _sv2v_0;
	input wire [31:0] instruction_adr_i;
	input wire [31:0] instruction_i;
	input wire clk;
	input wire data_good;
	input wire rst;
	input wire instr_wait;
	input wire [2:0] state;
	output reg instr_fetch;
	output reg [31:0] instruction_adr_o;
	output reg [31:0] instruction_o;
	reg next_fetch;
	reg prev_fetch;
	reg prev_d_good;
	reg [31:0] stored_instr;
	reg [31:0] stored_instr_adr;
	reg [31:0] instruction_adr_stored;
	always @(*) begin
		if (_sv2v_0)
			;
		next_fetch = 1'b0;
		stored_instr_adr = 1'sb0;
		stored_instr = 1'sb0;
		if (state == 3'd6) begin
			next_fetch = 1'b0;
			stored_instr_adr = instruction_adr_i;
			stored_instr = 1'sb0;
		end
		else if (state == 3'd4) begin
			next_fetch = 1'b0;
			stored_instr_adr = instruction_adr_i;
			stored_instr = instruction_i;
		end
		else if (!instr_wait) begin
			next_fetch = 1'b1;
			stored_instr_adr = instruction_adr_i;
			stored_instr = 1'sb0;
		end
		if (instr_wait)
			instruction_adr_o = instruction_adr_stored;
		else
			instruction_adr_o = instruction_adr_i;
	end
	always @(posedge clk or posedge rst)
		if (rst) begin
			instruction_o <= 32'b00000000000000000000000000000000;
			instr_fetch <= 1'b0;
			prev_d_good <= 0;
			prev_fetch <= 0;
			instruction_adr_stored <= 0;
		end
		else if (instr_wait) begin
			instruction_o <= instruction_o;
			instr_fetch <= 1'b0;
			prev_fetch <= instr_fetch;
			prev_d_good <= data_good;
			instruction_adr_stored <= instruction_adr_o;
		end
		else begin
			instruction_o <= stored_instr;
			instr_fetch <= next_fetch;
			prev_fetch <= instr_fetch;
			prev_d_good <= data_good;
		end
	initial _sv2v_0 = 0;
endmodule
module t05_memcontrol (
	address_in,
	data_in_CPU,
	data_in_BUS,
	data_en,
	instr_en,
	bus_full,
	memWrite,
	memRead,
	clk,
	rst,
	en,
	next_state,
	state,
	bus_full_CPU,
	data_access,
	address_out,
	data_out_CPU,
	data_out_BUS,
	data_out_INSTR
);
	reg _sv2v_0;
	input wire [31:0] address_in;
	input wire [31:0] data_in_CPU;
	input wire [31:0] data_in_BUS;
	input wire data_en;
	input wire instr_en;
	input wire bus_full;
	input wire memWrite;
	input wire memRead;
	input wire clk;
	input wire rst;
	input wire en;
	output reg [2:0] next_state;
	output reg [2:0] state;
	output reg bus_full_CPU;
	output reg data_access;
	output reg [31:0] address_out;
	output reg [31:0] data_out_CPU;
	output reg [31:0] data_out_BUS;
	output reg [31:0] data_out_INSTR;
	always @(memRead or address_in or data_in_BUS)
		$display("[Read monitor] time=%0t, memRead=%h, address_in=%h, data_in_BUS=%h", $time, memRead, address_in, data_in_BUS);
	always @(memWrite or address_in or data_in_CPU)
		$display("[Write monitor] time=%0t, memWrite=%h, address_in=%h, data_in_CPU=%h", $time, memWrite, address_in, data_in_CPU);
	always @(address_in)
		if (address_in == 33000024)
			#(1)
				$stop;
	reg [2:0] prev_state;
	reg next_next_fetch;
	reg next_instr;
	reg next_data_read;
	reg next_next_data_read;
	reg next_data_access;
	always @(posedge clk or posedge rst) begin : startFSM
		if (rst) begin
			state <= 3'd0;
			next_next_fetch <= 0;
			next_next_data_read <= 0;
			data_access <= 0;
		end
		else begin
			state <= next_state;
			next_next_fetch <= next_instr;
			next_next_data_read <= next_data_read;
			data_access <= next_data_access;
		end
	end
	always @(*) begin : changeState
		if (_sv2v_0)
			;
		bus_full_CPU = bus_full;
		address_out = address_in;
		data_out_BUS = 32'h00000000;
		data_out_CPU = 32'h00000000;
		data_out_INSTR = 32'h00000000;
		next_state = state;
		prev_state = state;
		next_instr = next_next_fetch;
		next_data_read = next_next_data_read;
		next_data_access = data_access;
		case (state)
			3'd0:
				if (!rst & en)
					next_state = 3'd1;
				else
					next_state = 3'd0;
			3'd1:
				if (memRead) begin
					next_state = 3'd2;
					prev_state = 3'd2;
					next_data_access = 1'b1;
				end
				else if (memWrite) begin
					next_state = 3'd3;
					prev_state = 3'd3;
					next_data_access = 1'b1;
				end
				else begin
					prev_state = 3'd1;
					next_state = 3'd1;
					address_out = 32'b00000000000000000000000000000000;
				end
			3'd2: begin
				if (bus_full) begin
					next_state = 3'd6;
					prev_state = 3'd2;
				end
				else begin
					next_state = 3'd6;
					prev_state = 3'd2;
				end
				if (data_en)
					next_data_read = 1'b1;
				else begin
					next_instr = 1'b1;
					next_data_access = 1'b0;
				end
			end
			3'd3:
				if (bus_full)
					next_state = 3'd5;
				else
					next_state = 3'd5;
			3'd4: begin
				address_out = address_in;
				data_out_BUS = 32'b00000000000000000000000000000000;
				if (next_next_data_read) begin
					data_out_CPU = data_in_BUS;
					data_out_INSTR = 32'b00000000000000000000000000000000;
				end
				else if (next_next_fetch) begin
					data_out_CPU = 32'b00000000000000000000000000000000;
					data_out_INSTR = data_in_BUS;
				end
				next_state = 3'd1;
				next_instr = 1'b0;
				next_data_read = 1'b0;
				next_data_access = 1'b0;
			end
			3'd5: begin
				address_out = address_in;
				data_out_BUS = data_in_CPU;
				data_out_INSTR = 32'b00000000000000000000000000000000;
				data_out_CPU = 32'b00000000000000000000000000000000;
				next_state = 3'd1;
				next_data_access = 1'b0;
			end
			3'd6:
				if (!bus_full) begin
					if (memRead)
						next_state = 3'd4;
					else if (memWrite)
						next_state = 3'd5;
					else
						next_state = 3'd4;
				end
				else begin
					next_state = 3'd6;
					if (memRead)
						prev_state = 3'd2;
					else if (memWrite)
						prev_state = 3'd3;
				end
			default: next_state = 3'd1;
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
module t05_pc (
	clk,
	clr,
	load,
	inc,
	Disable,
	ALU_out,
	data,
	imm_val,
	pc_val
);
	reg _sv2v_0;
	input wire clk;
	input wire clr;
	input wire load;
	input wire inc;
	input wire Disable;
	input wire ALU_out;
	input wire [31:0] data;
	input wire [31:0] imm_val;
	output reg [31:0] pc_val;
	reg [31:0] next_line_ad;
	reg [31:0] jump_ad;
	reg [31:0] next_pc;
	wire branch_choice;
	reg [31:0] imm_val_reg;
	reg ALU_out_reg;
	always @(posedge clk or posedge clr)
		if (clr) begin
			pc_val <= 32'h33000000;
			imm_val_reg <= 1'sb0;
			ALU_out_reg <= 1'sb0;
		end
		else begin
			pc_val <= next_pc;
			imm_val_reg <= imm_val;
			ALU_out_reg <= ALU_out;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		next_pc = pc_val;
		next_line_ad = pc_val + 32'd4;
		jump_ad = pc_val;
		if (Disable)
			next_pc = pc_val;
		else if (load)
			next_pc = data;
		else if (ALU_out_reg)
			next_pc = pc_val + imm_val_reg;
		else if (inc)
			next_pc = pc_val + 32'd4;
	end
	initial _sv2v_0 = 0;
endmodule
module t05_register_file (
	reg_write,
	rd,
	rs1,
	rs2,
	clk,
	rst,
	write,
	reg1,
	reg2,
	register_out
);
	reg _sv2v_0;
	input wire [31:0] reg_write;
	input wire [4:0] rd;
	input wire [4:0] rs1;
	input wire [4:0] rs2;
	input wire clk;
	input wire rst;
	input wire write;
	output reg [31:0] reg1;
	output reg [31:0] reg2;
	output reg [31:0] register_out;
	reg [31:0] register [0:31];
	reg [31:0] write_data;
	always @(*) begin
		if (_sv2v_0)
			;
		write_data = reg_write;
		if (write) begin
			if (rd != 0)
				write_data = reg_write;
			else
				write_data = 32'b00000000000000000000000000000000;
		end
		reg1 = register[rs1];
		reg2 = register[rs2];
		register_out = register[5'd2];
	end
	always @(posedge clk or posedge rst)
		if (rst) begin
			register[0] <= 32'b00000000000000000000000000000000;
			register[1] <= 32'b00000000000000000000000000000000;
			register[2] <= 32'b00000000000000000000000000000000;
			register[3] <= 32'b00000000000000000000000000000000;
			register[4] <= 32'b00000000000000000000000000000000;
			register[5] <= 32'b00000000000000000000000000000000;
			register[6] <= 32'b00000000000000000000000000000000;
			register[7] <= 32'b00000000000000000000000000000000;
			register[8] <= 32'b00000000000000000000000000000000;
			register[9] <= 32'b00000000000000000000000000000000;
			register[10] <= 32'b00000000000000000000000000000000;
			register[11] <= 32'b00000000000000000000000000000000;
			register[12] <= 32'b00000000000000000000000000000000;
			register[13] <= 32'b00000000000000000000000000000000;
			register[14] <= 32'b00000000000000000000000000000000;
			register[15] <= 32'b00000000000000000000000000000000;
			register[16] <= 32'b00000000000000000000000000000000;
			register[17] <= 32'b00000000000000000000000000000000;
			register[18] <= 32'b00000000000000000000000000000000;
			register[19] <= 32'b00000000000000000000000000000000;
			register[20] <= 32'b00000000000000000000000000000000;
			register[21] <= 32'b00000000000000000000000000000000;
			register[22] <= 32'b00000000000000000000000000000000;
			register[23] <= 32'b00000000000000000000000000000000;
			register[24] <= 32'b00000000000000000000000000000000;
			register[25] <= 32'b00000000000000000000000000000000;
			register[26] <= 32'b00000000000000000000000000000000;
			register[27] <= 32'b00000000000000000000000000000000;
			register[28] <= 32'b00000000000000000000000000000000;
			register[29] <= 32'b00000000000000000000000000000000;
			register[30] <= 32'b00000000000000000000000000000000;
			register[31] <= 32'b00000000000000000000000000000000;
		end
		else if (write)
			register[rd] <= write_data;
	initial _sv2v_0 = 0;
endmodule
module wishbone_manager (
	nRST,
	CLK,
	DAT_I,
	ACK_I,
	CPU_DAT_I,
	ADR_I,
	SEL_I,
	WRITE_I,
	READ_I,
	ADR_O,
	DAT_O,
	SEL_O,
	WE_O,
	STB_O,
	CYC_O,
	CPU_DAT_O,
	BUSY_O
);
	reg _sv2v_0;
	input wire nRST;
	input wire CLK;
	input wire [31:0] DAT_I;
	input wire ACK_I;
	input wire [31:0] CPU_DAT_I;
	input wire [31:0] ADR_I;
	input wire [3:0] SEL_I;
	input wire WRITE_I;
	input wire READ_I;
	output reg [31:0] ADR_O;
	output reg [31:0] DAT_O;
	output reg [3:0] SEL_O;
	output reg WE_O;
	output reg STB_O;
	output reg CYC_O;
	output reg [31:0] CPU_DAT_O;
	output reg BUSY_O;
	reg [1:0] curr_state;
	reg [1:0] next_state;
	reg [31:0] next_ADR_O;
	reg [31:0] next_DAT_O;
	reg [3:0] next_SEL_O;
	reg next_WE_O;
	reg next_STB_O;
	reg next_CYC_O;
	reg [31:0] next_CPU_DAT_O;
	reg next_BUSY_O;
	always @(posedge CLK or negedge nRST) begin : All_ffs
		if (~nRST) begin
			curr_state <= 2'd0;
			CPU_DAT_O <= 1'sb0;
			BUSY_O <= 1'sb0;
			ADR_O <= 1'sb0;
			DAT_O <= 1'sb0;
			SEL_O <= 1'sb0;
			WE_O <= 1'sb0;
			STB_O <= 1'sb0;
			CYC_O <= 1'sb0;
		end
		else begin
			curr_state <= next_state;
			CPU_DAT_O <= next_CPU_DAT_O;
			BUSY_O <= next_BUSY_O;
			ADR_O <= next_ADR_O;
			DAT_O <= next_DAT_O;
			SEL_O <= next_SEL_O;
			WE_O <= next_WE_O;
			STB_O <= next_STB_O;
			CYC_O <= next_CYC_O;
		end
	end
	always @(*) begin
		if (_sv2v_0)
			;
		next_state = curr_state;
		next_ADR_O = ADR_O;
		next_DAT_O = DAT_O;
		next_SEL_O = SEL_O;
		next_WE_O = WE_O;
		next_STB_O = STB_O;
		next_CYC_O = CYC_O;
		next_BUSY_O = BUSY_O;
		case (curr_state)
			2'd0: begin
				if (WRITE_I && !READ_I) begin
					next_BUSY_O = 1'b1;
					next_state = 2'd1;
				end
				if (!WRITE_I && READ_I) begin
					next_BUSY_O = 1'b1;
					next_state = 2'd2;
				end
			end
			2'd1: begin
				next_ADR_O = ADR_I;
				next_DAT_O = CPU_DAT_I;
				next_SEL_O = SEL_I;
				next_WE_O = 1'b1;
				next_STB_O = 1'b1;
				next_CYC_O = 1'b1;
				next_BUSY_O = 1'b1;
				if (ACK_I) begin
					next_state = 2'd0;
					next_ADR_O = 1'sb0;
					next_DAT_O = 1'sb0;
					next_SEL_O = 1'sb0;
					next_WE_O = 1'sb0;
					next_STB_O = 1'sb0;
					next_CYC_O = 1'sb0;
					next_BUSY_O = 1'sb0;
				end
			end
			2'd2: begin
				next_ADR_O = ADR_I;
				next_DAT_O = 1'sb0;
				next_SEL_O = SEL_I;
				next_WE_O = 1'sb0;
				next_STB_O = 1'b1;
				next_CYC_O = 1'b1;
				next_BUSY_O = 1'b1;
				if (ACK_I) begin
					next_state = 2'd0;
					next_ADR_O = 1'sb0;
					next_DAT_O = 1'sb0;
					next_SEL_O = 1'sb0;
					next_WE_O = 1'sb0;
					next_STB_O = 1'sb0;
					next_CYC_O = 1'sb0;
					next_BUSY_O = 1'sb0;
				end
			end
			default: next_state = curr_state;
		endcase
	end
	reg prev_BUSY_O;
	wire BUSY_O_edge;
	always @(posedge CLK or negedge nRST) begin : BUSY_O_edge_detector
		if (!nRST)
			prev_BUSY_O <= 1'sb0;
		else
			prev_BUSY_O <= BUSY_O;
	end
	assign BUSY_O_edge = !BUSY_O && prev_BUSY_O;
	always @(*) begin
		if (_sv2v_0)
			;
		next_CPU_DAT_O = 32'hbad1bad1;
		if ((curr_state == 2'd2) && ACK_I)
			next_CPU_DAT_O = DAT_I;
		else if (BUSY_O_edge)
			next_CPU_DAT_O = CPU_DAT_O;
	end
	initial _sv2v_0 = 0;
endmodule
module keypad_interface (
	clk,
	rst,
	columns,
	rows,
	key_out_bin,
	key_confirm
);
	reg _sv2v_0;
	input wire clk;
	input wire rst;
	input wire [3:0] columns;
	output reg [3:0] rows;
	output wire [31:0] key_out_bin;
	output reg key_confirm;
	wire [3:0] out;
	reg [15:0] key_out;
	reg [15:0] next_out;
	reg next_confirm;
	wire key_confirm_hold;
	wire debounce;
	reg [7:0] code;
	reg [31:0] state;
	reg [31:0] next_state;
	reg [3:0] next_rows;
	reg [18:0] counter;
	reg key_clk;
	reg [3:0] key_counter;
	reg [3:0] next_key_counter;
	always @(*) begin
		if (_sv2v_0)
			;
		code = {columns, rows};
		next_rows = rows;
		next_out = key_out;
		next_confirm = 1'b0;
		next_key_counter = key_counter;
		case (rows)
			4'b1110: begin
				case (columns)
					4'b0001: begin
						next_confirm = 1'b0;
						if ((key_out[3:0] != 4'b0001) | ((key_out[3:0] == 4'b0001) & (key_counter == 15))) begin
							next_out = {key_out[11:0], 4'b0001};
							next_key_counter = 0;
						end
						else begin
							next_out = key_out;
							next_key_counter = key_counter + 1;
						end
					end
					4'b0010: begin
						next_out = {key_out[11:0], 4'b0010};
						next_confirm = 1'b0;
					end
					4'b0100: begin
						next_out = {key_out[11:0], 4'b0011};
						next_confirm = 1'b0;
					end
					4'b1000: begin
						next_out = {key_out[11:0], 4'b1010};
						next_confirm = 1'b0;
					end
					default: begin
						next_out = key_out;
						next_confirm = 1'b0;
					end
				endcase
				next_rows = 4'b1101;
				next_state = 32'd1;
			end
			4'b1101: begin
				case (columns)
					4'b0001: begin
						next_out = {key_out[11:0], 4'b0100};
						next_confirm = 1'b0;
					end
					4'b0010: begin
						next_out = {key_out[11:0], 4'b0101};
						next_confirm = 1'b0;
					end
					4'b0100: begin
						next_out = {key_out[11:0], 4'b0110};
						next_confirm = 1'b0;
					end
					4'b1000: begin
						next_out = {key_out[11:0], 4'b1011};
						next_confirm = 1'b0;
					end
					default: begin
						next_out = key_out;
						next_confirm = 1'b0;
					end
				endcase
				next_rows = 4'b1011;
				next_state = 32'd1;
			end
			4'b1011: begin
				case (columns)
					4'b0001: begin
						next_out = {key_out[11:0], 4'b0111};
						next_confirm = 1'b0;
					end
					4'b0010: begin
						next_out = {key_out[11:0], 4'b1000};
						next_confirm = 1'b0;
					end
					4'b0100: begin
						next_out = {key_out[11:0], 4'b1001};
						next_confirm = 1'b0;
					end
					4'b1000: begin
						next_out = {key_out[11:0], 4'b1100};
						next_confirm = 1'b0;
					end
					default: begin
						next_out = key_out;
						next_confirm = 1'b0;
					end
				endcase
				next_rows = 4'b0111;
				next_state = 32'd1;
			end
			4'b0111: begin
				case (columns)
					4'b0001: begin
						next_out = {key_out};
						next_confirm = 1'b1;
						next_key_counter = 0;
					end
					4'b0010: begin
						next_out = {key_out[11:0], 4'b0000};
						next_confirm = 1'b0;
					end
					4'b0100: begin
						next_out = 16'h0000;
						next_confirm = 1'b0;
					end
					4'b1000: begin
						next_out = {key_out[11:0], 4'b1101};
						next_confirm = 1'b0;
					end
					default: begin
						next_out = key_out;
						next_confirm = 1'b0;
					end
				endcase
				next_rows = 4'b1110;
				next_state = 32'd1;
			end
			default: begin
				next_state = 32'd1;
				next_rows = 4'b1110;
			end
		endcase
	end
	always @(posedge key_clk or posedge rst)
		if (rst) begin
			rows <= 4'b1110;
			state <= 32'd0;
			key_out <= 16'b0000000000000000;
		end
		else begin
			rows <= next_rows;
			state <= next_state;
			key_out <= next_out;
		end
	always @(posedge clk or posedge rst)
		if (rst) begin
			counter = 0;
			key_confirm <= 1'b0;
			key_counter <= 4'b0000;
		end
		else begin
			counter = counter + 1;
			key_clk = 0;
			if (counter == 150) begin
				counter = 0;
				key_clk = 1;
			end
			if (key_confirm)
				key_confirm <= 1'b0;
			else if (counter < 2)
				key_confirm <= next_confirm;
			else
				key_confirm <= 1'b0;
			key_counter <= next_key_counter;
		end
	bcd2bin partyyyyy(
		.bcd3(key_out[15:12]),
		.bcd2(key_out[11:8]),
		.bcd1(key_out[7:4]),
		.bcd0(key_out[3:0]),
		.bin(key_out_bin)
	);
	initial _sv2v_0 = 0;
endmodule
module lcd_controller (
	clk,
	rst,
	row_1,
	row_2,
	lcd_en,
	lcd_rw,
	lcd_rs,
	lcd_data
);
	reg _sv2v_0;
	parameter clk_div = 24;
	input clk;
	input rst;
	input [127:0] row_1;
	input [127:0] row_2;
	output wire lcd_en;
	output wire lcd_rw;
	output reg lcd_rs;
	output reg [7:0] lcd_data;
	wire lcd_ctrl;
	reg [7:0] currentState;
	reg [7:0] nextState;
	reg [17:0] cnt_20ms;
	reg [14:0] cnt_500hz;
	wire delay_done;
	localparam TIME_500HZ = clk_div;
	localparam TIME_20MS = TIME_500HZ * 10;
	localparam LCD_IDLE = 8'h00;
	localparam SET_FUNCTION = 8'h38;
	localparam DISP_OFF = 8'h03;
	localparam DISP_CLEAR = 8'h01;
	localparam ENTRY_MODE = 8'h06;
	localparam DISP_ON = 8'h07;
	localparam ROW1_ADDR = 8'h05;
	localparam ROW1_0 = 8'h04;
	localparam ROW1_1 = 8'h0c;
	localparam ROW1_2 = 8'h0d;
	localparam ROW1_3 = 8'h0f;
	localparam ROW1_4 = 8'h0e;
	localparam ROW1_5 = 8'h0a;
	localparam ROW1_6 = 8'h0b;
	localparam ROW1_7 = 8'h09;
	localparam ROW1_8 = 8'h08;
	localparam ROW1_9 = 8'h18;
	localparam ROW1_A = 8'h19;
	localparam ROW1_B = 8'h1b;
	localparam ROW1_C = 8'h1a;
	localparam ROW1_D = 8'h1e;
	localparam ROW1_E = 8'h1f;
	localparam ROW1_F = 8'h1d;
	localparam ROW2_ADDR = 8'h1c;
	localparam ROW2_0 = 8'h14;
	localparam ROW2_1 = 8'h15;
	localparam ROW2_2 = 8'h17;
	localparam ROW2_3 = 8'h16;
	localparam ROW2_4 = 8'h12;
	localparam ROW2_5 = 8'h13;
	localparam ROW2_6 = 8'h11;
	localparam ROW2_7 = 8'h10;
	localparam ROW2_8 = 8'h30;
	localparam ROW2_9 = 8'h31;
	localparam ROW2_A = 8'h33;
	localparam ROW2_B = 8'h32;
	localparam ROW2_C = 8'h36;
	localparam ROW2_D = 8'h37;
	localparam ROW2_E = 8'h35;
	localparam ROW2_F = 8'h34;
	assign delay_done = (cnt_20ms == (TIME_20MS - 1) ? 1'b1 : 1'b0);
	always @(posedge clk or posedge rst)
		if (rst)
			cnt_20ms <= 0;
		else if (cnt_20ms == (TIME_20MS - 1))
			cnt_20ms <= cnt_20ms;
		else
			cnt_20ms <= cnt_20ms + 1;
	always @(posedge clk or posedge rst)
		if (rst)
			cnt_500hz <= 0;
		else if (delay_done) begin
			if (cnt_500hz == (TIME_500HZ - 1))
				cnt_500hz <= 0;
			else
				cnt_500hz <= cnt_500hz + 1;
		end
		else
			cnt_500hz <= 0;
	assign lcd_en = (cnt_500hz > ((TIME_500HZ - 1) / 2) ? 1'b0 : 1'b1);
	assign lcd_ctrl = (cnt_500hz == (TIME_500HZ - 1) ? 1'b1 : 1'b0);
	always @(posedge clk or posedge rst)
		if (rst)
			currentState <= LCD_IDLE;
		else if (lcd_ctrl)
			currentState <= nextState;
		else
			currentState <= currentState;
	always @(*) begin
		if (_sv2v_0)
			;
		case (currentState)
			LCD_IDLE: nextState = SET_FUNCTION;
			SET_FUNCTION: nextState = DISP_OFF;
			DISP_OFF: nextState = DISP_CLEAR;
			DISP_CLEAR: nextState = ENTRY_MODE;
			ENTRY_MODE: nextState = DISP_ON;
			DISP_ON: nextState = ROW1_ADDR;
			ROW1_ADDR: nextState = ROW1_0;
			ROW1_0: nextState = ROW1_1;
			ROW1_1: nextState = ROW1_2;
			ROW1_2: nextState = ROW1_3;
			ROW1_3: nextState = ROW1_4;
			ROW1_4: nextState = ROW1_5;
			ROW1_5: nextState = ROW1_6;
			ROW1_6: nextState = ROW1_7;
			ROW1_7: nextState = ROW1_8;
			ROW1_8: nextState = ROW1_9;
			ROW1_9: nextState = ROW1_A;
			ROW1_A: nextState = ROW1_B;
			ROW1_B: nextState = ROW1_C;
			ROW1_C: nextState = ROW1_D;
			ROW1_D: nextState = ROW1_E;
			ROW1_E: nextState = ROW1_F;
			ROW1_F: nextState = ROW2_ADDR;
			ROW2_ADDR: nextState = ROW2_0;
			ROW2_0: nextState = ROW2_1;
			ROW2_1: nextState = ROW2_2;
			ROW2_2: nextState = ROW2_3;
			ROW2_3: nextState = ROW2_4;
			ROW2_4: nextState = ROW2_5;
			ROW2_5: nextState = ROW2_6;
			ROW2_6: nextState = ROW2_7;
			ROW2_7: nextState = ROW2_8;
			ROW2_8: nextState = ROW2_9;
			ROW2_9: nextState = ROW2_A;
			ROW2_A: nextState = ROW2_B;
			ROW2_B: nextState = ROW2_C;
			ROW2_C: nextState = ROW2_D;
			ROW2_D: nextState = ROW2_E;
			ROW2_E: nextState = ROW2_F;
			ROW2_F: nextState = ROW1_ADDR;
			default: nextState = LCD_IDLE;
		endcase
	end
	assign lcd_rw = 1'b0;
	always @(posedge clk or posedge rst)
		if (rst)
			lcd_rs <= 1'b0;
		else if (lcd_ctrl) begin
			if (((((((nextState == SET_FUNCTION) || (nextState == DISP_OFF)) || (nextState == DISP_CLEAR)) || (nextState == ENTRY_MODE)) || (nextState == DISP_ON)) || (nextState == ROW1_ADDR)) || (nextState == ROW2_ADDR))
				lcd_rs <= 1'b0;
			else
				lcd_rs <= 1'b1;
		end
		else
			lcd_rs <= lcd_rs;
	always @(posedge clk or posedge rst)
		if (rst)
			lcd_data <= 8'h00;
		else if (lcd_ctrl)
			case (nextState)
				LCD_IDLE: lcd_data <= 8'hxx;
				SET_FUNCTION: lcd_data <= 8'h38;
				DISP_OFF: lcd_data <= 8'h08;
				DISP_CLEAR: lcd_data <= 8'h01;
				ENTRY_MODE: lcd_data <= 8'h06;
				DISP_ON: lcd_data <= 8'h0f;
				ROW1_ADDR: lcd_data <= 8'h80;
				ROW1_0: lcd_data <= row_1[127:120];
				ROW1_1: lcd_data <= row_1[119:112];
				ROW1_2: lcd_data <= row_1[111:104];
				ROW1_3: lcd_data <= row_1[103:96];
				ROW1_4: lcd_data <= row_1[95:88];
				ROW1_5: lcd_data <= row_1[87:80];
				ROW1_6: lcd_data <= row_1[79:72];
				ROW1_7: lcd_data <= row_1[71:64];
				ROW1_8: lcd_data <= row_1[63:56];
				ROW1_9: lcd_data <= row_1[55:48];
				ROW1_A: lcd_data <= row_1[47:40];
				ROW1_B: lcd_data <= row_1[39:32];
				ROW1_C: lcd_data <= row_1[31:24];
				ROW1_D: lcd_data <= row_1[23:16];
				ROW1_E: lcd_data <= row_1[15:8];
				ROW1_F: lcd_data <= row_1[7:0];
				ROW2_ADDR: lcd_data <= 8'hc0;
				ROW2_0: lcd_data <= row_2[127:120];
				ROW2_1: lcd_data <= row_2[119:112];
				ROW2_2: lcd_data <= row_2[111:104];
				ROW2_3: lcd_data <= row_2[103:96];
				ROW2_4: lcd_data <= row_2[95:88];
				ROW2_5: lcd_data <= row_2[87:80];
				ROW2_6: lcd_data <= row_2[79:72];
				ROW2_7: lcd_data <= row_2[71:64];
				ROW2_8: lcd_data <= row_2[63:56];
				ROW2_9: lcd_data <= row_2[55:48];
				ROW2_A: lcd_data <= row_2[47:40];
				ROW2_B: lcd_data <= row_2[39:32];
				ROW2_C: lcd_data <= row_2[31:24];
				ROW2_D: lcd_data <= row_2[23:16];
				ROW2_E: lcd_data <= row_2[15:8];
				ROW2_F: lcd_data <= row_2[7:0];
				default: lcd_data <= 8'hxx;
			endcase
		else
			lcd_data <= lcd_data;
	initial _sv2v_0 = 0;
endmodule
module bcd2bin (
	bcd3,
	bcd2,
	bcd1,
	bcd0,
	bin
);
	reg _sv2v_0;
	input wire [3:0] bcd3;
	input wire [3:0] bcd2;
	input wire [3:0] bcd1;
	input wire [3:0] bcd0;
	output reg [31:0] bin;
	always @(*) begin
		if (_sv2v_0)
			;
		if ((((bcd3 < 4'b1010) & (bcd2 < 4'b1010)) & (bcd1 < 4'b1010)) & (bcd0 < 4'b1010))
			bin = {16'h0000, (((bcd3 * 16'd1000) + (bcd2 * 7'd100)) + (bcd1 * 4'd10)) + (bcd0 * 1'd1)};
		else
			bin = {28'h000000f, bcd0};
	end
	initial _sv2v_0 = 0;
endmodule
module bin_to_LCD (
	binary_in,
	LCD_out
);
	reg _sv2v_0;
	input wire [31:0] binary_in;
	output reg [31:0] LCD_out;
	reg [15:0] BCD_interim;
	always @(*) begin
		if (_sv2v_0)
			;
		BCD_interim = 16'b0000000000000000;
		if (binary_in[31:4] == 28'h000000f)
			BCD_interim = {12'b000000000000, binary_in[3:0]};
		else if (binary_in[31:16] == 16'h0000) begin : sv2v_autoblock_1
			integer i;
			for (i = 0; i < 14; i = i + 1)
				begin
					if (BCD_interim[3:0] >= 5)
						BCD_interim[3:0] = BCD_interim[3:0] + 3;
					if (BCD_interim[7:4] >= 5)
						BCD_interim[7:4] = BCD_interim[7:4] + 3;
					if (BCD_interim[11:8] >= 5)
						BCD_interim[11:8] = BCD_interim[11:8] + 3;
					if (BCD_interim[15:12] >= 5)
						BCD_interim[15:12] = BCD_interim[15:12] + 3;
					BCD_interim = {BCD_interim[14:0], binary_in[13 - i]};
				end
		end
		if (binary_in[31:16] == 16'h0000) begin
			case (BCD_interim[15:12])
				4'b0000:
					if (BCD_interim[11:0] == 12'h000)
						LCD_out[31:24] = 8'b00110000;
					else
						LCD_out[31:24] = 8'h5f;
				4'b0001: LCD_out[31:24] = 8'b00110001;
				4'b0010: LCD_out[31:24] = 8'b00110010;
				4'b0011: LCD_out[31:24] = 8'b00110011;
				4'b0100: LCD_out[31:24] = 8'b00110100;
				4'b0101: LCD_out[31:24] = 8'b00110101;
				4'b0110: LCD_out[31:24] = 8'b00110110;
				4'b0111: LCD_out[31:24] = 8'b00110111;
				4'b1000: LCD_out[31:24] = 8'b00111000;
				4'b1001: LCD_out[31:24] = 8'b00111001;
				4'b1010: LCD_out[31:24] = 8'b00101011;
				4'b1011: LCD_out[31:24] = 8'b00101101;
				4'b1100: LCD_out[31:24] = 8'b00101010;
				4'b1101: LCD_out[31:24] = 8'b00101111;
				default: LCD_out[31:24] = 8'b01011111;
			endcase
			case (BCD_interim[11:8])
				4'b0000:
					if ((BCD_interim[7:0] == 8'h00) | (BCD_interim[15:12] != 4'h0))
						LCD_out[23:16] = 8'b00110000;
					else
						LCD_out[23:16] = 8'h5f;
				4'b0001: LCD_out[23:16] = 8'b00110001;
				4'b0010: LCD_out[23:16] = 8'b00110010;
				4'b0011: LCD_out[23:16] = 8'b00110011;
				4'b0100: LCD_out[23:16] = 8'b00110100;
				4'b0101: LCD_out[23:16] = 8'b00110101;
				4'b0110: LCD_out[23:16] = 8'b00110110;
				4'b0111: LCD_out[23:16] = 8'b00110111;
				4'b1000: LCD_out[23:16] = 8'b00111000;
				4'b1001: LCD_out[23:16] = 8'b00111001;
				4'b1010: LCD_out[23:16] = 8'b00101011;
				4'b1011: LCD_out[23:16] = 8'b00101101;
				4'b1100: LCD_out[23:16] = 8'b00101010;
				4'b1101: LCD_out[23:16] = 8'b00101111;
				default: LCD_out[23:16] = 8'b01011111;
			endcase
			case (BCD_interim[7:4])
				4'b0000:
					if ((BCD_interim[3:0] == 4'h0) | (BCD_interim[15:8] != 8'h00))
						LCD_out[15:8] = 8'b00110000;
					else
						LCD_out[15:8] = 8'h5f;
				4'b0001: LCD_out[15:8] = 8'b00110001;
				4'b0010: LCD_out[15:8] = 8'b00110010;
				4'b0011: LCD_out[15:8] = 8'b00110011;
				4'b0100: LCD_out[15:8] = 8'b00110100;
				4'b0101: LCD_out[15:8] = 8'b00110101;
				4'b0110: LCD_out[15:8] = 8'b00110110;
				4'b0111: LCD_out[15:8] = 8'b00110111;
				4'b1000: LCD_out[15:8] = 8'b00111000;
				4'b1001: LCD_out[15:8] = 8'b00111001;
				4'b1010: LCD_out[15:8] = 8'b00101011;
				4'b1011: LCD_out[15:8] = 8'b00101101;
				4'b1100: LCD_out[15:8] = 8'b00101010;
				4'b1101: LCD_out[15:8] = 8'b00101111;
				default: LCD_out[15:8] = 8'b01011111;
			endcase
			case (BCD_interim[3:0])
				4'b0000: LCD_out[7:0] = 8'b00110000;
				4'b0001: LCD_out[7:0] = 8'b00110001;
				4'b0010: LCD_out[7:0] = 8'b00110010;
				4'b0011: LCD_out[7:0] = 8'b00110011;
				4'b0100: LCD_out[7:0] = 8'b00110100;
				4'b0101: LCD_out[7:0] = 8'b00110101;
				4'b0110: LCD_out[7:0] = 8'b00110110;
				4'b0111: LCD_out[7:0] = 8'b00110111;
				4'b1000: LCD_out[7:0] = 8'b00111000;
				4'b1001: LCD_out[7:0] = 8'b00111001;
				4'b1010: LCD_out[7:0] = 8'b00101011;
				4'b1011: LCD_out[7:0] = 8'b00101101;
				4'b1100: LCD_out[7:0] = 8'b00101010;
				4'b1101: LCD_out[7:0] = 8'b00101111;
				default: LCD_out[7:0] = 8'b01011111;
			endcase
		end
		else
			LCD_out = binary_in;
	end
	initial _sv2v_0 = 0;
endmodule