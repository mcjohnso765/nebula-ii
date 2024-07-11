`default_nettype none
module memory_handler (
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
