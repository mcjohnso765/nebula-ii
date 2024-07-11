`default_nettype none
module register_file (
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
