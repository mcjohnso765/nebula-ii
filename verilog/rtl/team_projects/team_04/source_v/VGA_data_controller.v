`default_nettype none
module VGA_data_controller (
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
		end
		else begin
			state <= next_state;
			data_to_VGA <= next_data;
			SRAM_address <= next_address;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		next_data = data_to_VGA;
		next_address = SRAM_address;
		ready_data = data_from_SRAM;
		case (state)
			2'd0: begin
				next_data = data_from_SRAM;
				ready_data = data_from_SRAM;
				next_state = 2'd2;
				next_address = SRAM_address;
			end
			2'd2: begin
				next_data = ready_data;
				next_address = SRAM_address;
				next_state = 2'd1;
			end
			2'd1: begin
				if (~mem_busy)
					ready_data = data_from_SRAM;
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
