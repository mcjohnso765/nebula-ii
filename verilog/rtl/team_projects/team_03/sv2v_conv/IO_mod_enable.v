module t03_IO_mod_enable (
	clk,
	rst,
	write_mem,
	read_mem,
	data_from_mem,
	data_address,
	data_to_write,
	data_read,
	IO_out,
	IO_enable,
	IO_in
);
	reg _sv2v_0;
	input wire clk;
	input wire rst;
	input wire write_mem;
	input wire read_mem;
	input wire [31:0] data_from_mem;
	input wire [31:0] data_address;
	input wire [31:0] data_to_write;
	output reg [31:0] data_read;
	output reg [31:0] IO_out;
	output reg [31:0] IO_enable;
	input wire [31:0] IO_in;
	wire [31:0] output_reg;
	reg [31:0] input_reg;
	wire [31:0] enable_reg;
	reg [31:0] next_output_reg;
	wire [31:0] next_input_reg;
	reg [31:0] next_enable_reg;
	always @(posedge clk or posedge rst)
		if (rst) begin
			IO_out <= 1'sb0;
			input_reg <= 1'sb0;
			IO_enable <= 1'sb0;
		end
		else begin
			IO_out <= next_output_reg;
			input_reg <= IO_in;
			IO_enable <= next_enable_reg;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		next_output_reg = IO_out;
		next_enable_reg = IO_enable;
		data_read = data_from_mem;
		case (data_address)
			32'hffffffff: next_output_reg = (write_mem ? data_to_write : IO_out);
			32'hfffffffd: next_enable_reg = (write_mem ? data_to_write : IO_enable);
			32'hfffffffc: data_read = (read_mem ? input_reg : data_from_mem);
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
