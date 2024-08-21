module t03_ram (
	clk,
	rst,
	data_address,
	instruction_address,
	dm_read_en,
	dm_write_en,
	data_to_write,
	instruction_read,
	data_read,
	pc_enable
);
	reg _sv2v_0;
	input wire clk;
	input wire rst;
	input wire [31:0] data_address;
	input wire [31:0] instruction_address;
	input wire dm_read_en;
	input wire dm_write_en;
	input wire [31:0] data_to_write;
	output reg [31:0] instruction_read;
	output reg [31:0] data_read;
	output reg pc_enable;
	reg [31:0] memory [4095:0];
	initial $readmemh("cpu.mem", memory);
	reg state;
	reg next_state;
	always @(posedge clk or posedge rst)
		if (rst)
			state <= 1'd0;
		else
			state <= next_state;
	always @(*) begin
		if (_sv2v_0)
			;
		pc_enable = 1'b1;
		next_state = state;
		case (state)
			1'd0:
				if (dm_read_en | dm_write_en) begin
					pc_enable = 1'b0;
					next_state = 1'd1;
				end
			1'd1: next_state = 1'd0;
		endcase
	end
	always @(negedge clk) begin
		if (dm_write_en)
			memory[{4'b0000, data_address[7:0]}] <= data_to_write;
		data_read <= memory[{4'b0000, data_address[7:0]}];
		instruction_read <= memory[{4'b0000, instruction_address[9:2]}];
	end
	initial _sv2v_0 = 0;
endmodule
