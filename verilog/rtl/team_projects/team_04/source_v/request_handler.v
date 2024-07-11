`default_nettype none
module request_handler (
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
