module t03_request_unit (
	en,
	clk,
	rst,
	memread,
	memwrite,
	data_to_write,
	instruction_address,
	data_address,
	busy_o,
	i_request,
	cpu_dat_o,
	read_i,
	write_i,
	cpu_dat_i,
	instruction,
	adr_i,
	data_read,
	sel_i,
	i_hit,
	d_hit
);
	reg _sv2v_0;
	input wire en;
	input wire clk;
	input wire rst;
	input wire memread;
	input wire memwrite;
	input wire [31:0] data_to_write;
	input wire [31:0] instruction_address;
	input wire [31:0] data_address;
	input wire busy_o;
	input wire i_request;
	input wire [31:0] cpu_dat_o;
	output reg read_i;
	output reg write_i;
	output reg [31:0] cpu_dat_i;
	output reg [31:0] instruction;
	output reg [31:0] adr_i;
	output reg [31:0] data_read;
	output reg [3:0] sel_i;
	output reg i_hit;
	output reg d_hit;
	reg [31:0] next_adr;
	reg [31:0] next_cpu_dat;
	reg [31:0] next_instruction;
	reg [2:0] state;
	reg [2:0] next_state;
	reg next_read_i;
	reg next_write_i;
	reg [31:0] next_data_read;
	wire request_type;
	wire next_request_type;
	reg next_i_hit;
	reg next_d_hit;
	reg prev_busy;
	always @(posedge clk or posedge rst)
		if (rst) begin
			state <= 3'd0;
			read_i <= 1'b0;
			write_i <= 1'b0;
			adr_i <= 32'b00000000000000000000000000000000;
			cpu_dat_i <= 32'b00000000000000000000000000000000;
			sel_i <= 4'b0000;
			instruction <= 32'b00000000000000000000000000000000;
			data_read <= 32'b00000000000000000000000000000000;
			i_hit <= 1'b0;
			d_hit <= 1'b0;
			prev_busy <= 1'b0;
		end
		else if (en) begin
			state <= next_state;
			read_i <= next_read_i;
			write_i <= next_write_i;
			adr_i <= next_adr;
			cpu_dat_i <= next_cpu_dat;
			sel_i <= 4'd15;
			instruction <= next_instruction;
			d_hit <= next_d_hit;
			state <= next_state;
			i_hit <= next_i_hit;
			prev_busy <= busy_o;
			data_read <= next_data_read;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		next_state = state;
		next_read_i = 1'b0;
		next_write_i = 1'b0;
		next_adr = adr_i;
		next_cpu_dat = cpu_dat_i;
		next_i_hit = 1'b0;
		next_d_hit = 1'b0;
		next_data_read = data_read;
		next_instruction = instruction;
		case (state)
			3'd0:
				if ((memwrite && !d_hit) && en) begin
					next_state = 3'd3;
					next_read_i = 1'b0;
					next_write_i = 1'b1;
					next_adr = data_address + 32'h33000000;
					next_cpu_dat = data_to_write;
					next_instruction = instruction;
				end
				else if ((memread && !d_hit) && en) begin
					next_state = 3'd2;
					next_read_i = 1'b1;
					next_write_i = 1'b0;
					next_adr = data_address + 32'h33000000;
					next_cpu_dat = 32'b00000000000000000000000000000000;
					next_instruction = instruction;
				end
				else if ((!i_hit && en) && i_request) begin
					next_state = 3'd4;
					next_read_i = 1'b1;
					next_write_i = 1'b0;
					next_adr = instruction_address + 32'h33000000;
				end
			3'd5: begin
				next_adr = adr_i;
				next_cpu_dat = cpu_dat_i;
				if (!busy_o) begin
					next_state = 3'd0;
					next_d_hit = 1'b1;
					next_cpu_dat = 32'b00000000000000000000000000000000;
					next_adr = 32'b00000000000000000000000000000000;
					next_write_i = 1'b0;
				end
			end
			3'd1: begin
				next_adr = adr_i;
				if (!busy_o) begin
					next_adr = 32'b00000000000000000000000000000000;
					next_data_read = cpu_dat_o;
					next_state = 3'd0;
					next_d_hit = 1'b1;
					next_read_i = 1'b0;
				end
			end
			3'd6: begin
				next_adr = adr_i;
				if (!busy_o && prev_busy) begin
					next_adr = 32'b00000000000000000000000000000000;
					next_instruction = cpu_dat_o;
					next_state = 3'd0;
					next_i_hit = 1'b1;
					next_read_i = 1'b0;
				end
			end
			3'd2: begin
				next_adr = adr_i;
				next_state = 3'd1;
			end
			3'd3: begin
				next_adr = adr_i;
				next_cpu_dat = cpu_dat_i;
				next_state = 3'd5;
			end
			3'd4: begin
				next_adr = adr_i;
				next_state = 3'd6;
			end
			default:
				;
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
