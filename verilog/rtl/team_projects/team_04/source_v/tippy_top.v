module tippy_top (
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
	CPU cpu(
		.instruction(CPU_instructions),
		.clk(clk),
		.nrst(nRst),
		.data_from_mem(mem_data_to_CPU),
		.alu_result(),
		.reg_window(),
		.err_flag(),
		.addr_to_mem(CPU_adr_to_mem),
		.data_to_mem(CPU_data_to_mem),
		.nextInstruction(CPU_instr_adr),
		.MemWrite(CPU_write),
		.MemRead(CPU_read),
		.select(CPU_sel),
		.enable(CPU_enable)
	);
	VGA_data_controller VGA_data_control(
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
		.SRAM_address(VGA_adr)
	);
	VGA_out vga(
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
	UART_Receiver uart(
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
	request_handler reqhand(
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
	always @(posedge mem_write)
		#(10)
			$display("@ %t: Writing %h %h", $time, adr_to_mem, data_to_mem);
	always @(posedge mem_read)
		#(10)
			$display("@ %t: Reading %h %h", $time, adr_to_mem, data_to_mem);
endmodule
