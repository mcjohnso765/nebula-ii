module t03_register_file (
	clk,
	rst,
	en,
	regA_address,
	regB_address,
	rd_address,
	register_write_en,
	register_write_data,
	regA_data,
	regB_data
);
	reg _sv2v_0;
	input wire clk;
	input wire rst;
	input wire en;
	input wire [4:0] regA_address;
	input wire [4:0] regB_address;
	input wire [4:0] rd_address;
	input wire register_write_en;
	input wire [31:0] register_write_data;
	output reg [31:0] regA_data;
	output reg [31:0] regB_data;
	reg [1023:0] registers_state;
	reg [1023:0] next_registers_state;
	always @(*) begin
		if (_sv2v_0)
			;
		next_registers_state = registers_state;
		regA_data = registers_state[regA_address * 32+:32];
		regB_data = registers_state[regB_address * 32+:32];
		if ((((register_write_en && (rd_address != 5'b00000)) && (rd_address != 5'd29)) && (rd_address != 5'd30)) && (rd_address != 5'd31))
			next_registers_state[rd_address * 32+:32] = register_write_data;
	end
	always @(posedge clk or posedge rst)
		if (rst) begin
			registers_state <= 1'sb0;
			registers_state[928+:32] <= 32'hfffffffc;
			registers_state[960+:32] <= 32'hfffffffd;
			registers_state[992+:32] <= 32'hffffffff;
		end
		else if (en & register_write_en)
			registers_state <= next_registers_state;
	initial _sv2v_0 = 0;
endmodule
