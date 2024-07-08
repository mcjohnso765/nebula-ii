module request_unit (
	clk,
	nRST,
	en,
	D_fetch,
	D_write,
	I_fetch,
	data_adr,
	instr_adr,
	writedata,
	i_done,
	d_done,
	instr,
	data,
	busy_o,
	cpu_dat_o,
	write_i,
	read_i,
	adr_i,
	cpu_dat_i,
	sel_i
);
	reg _sv2v_0;
	input wire clk;
	input wire nRST;
	input wire en;
	input wire D_fetch;
	input wire D_write;
	input wire I_fetch;
	input wire [31:0] data_adr;
	input wire [31:0] instr_adr;
	input wire [31:0] writedata;
	output reg i_done;
	output reg d_done;
	output reg [31:0] instr;
	output reg [31:0] data;
	input wire busy_o;
	input wire [31:0] cpu_dat_o;
	output reg write_i;
	output reg read_i;
	output reg [31:0] adr_i;
	output reg [31:0] cpu_dat_i;
	output wire [3:0] sel_i;
	assign sel_i = 4'b1111;
	reg [31:0] next_instr;
	reg [31:0] next_data;
	reg [31:0] next_adr;
	reg [31:0] next_data_w;
	reg [1:0] state;
	reg [1:0] next_state;
	always @(posedge clk or posedge nRST)
		if (nRST) begin
			state <= 2'd0;
			instr <= 32'b00000000000000000000000000000000;
			data <= 32'b00000000000000000000000000000000;
			adr_i <= 32'b00000000000000000000000000000000;
			cpu_dat_i <= 32'b00000000000000000000000000000000;
		end
		else if (en) begin
			state <= next_state;
			instr <= next_instr;
			data <= next_data;
			adr_i <= next_adr;
			cpu_dat_i <= next_data_w;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		read_i = 1'b0;
		write_i = 1'b0;
		i_done = 1'b0;
		d_done = 1'b0;
		next_state = state;
		next_data = data;
		next_instr = instr;
		next_adr = adr_i;
		next_data_w = cpu_dat_i;
		case (state)
			2'd0:
				if (D_fetch) begin
					read_i = 1'b1;
					write_i = 1'b0;
					next_adr = data_adr;
					next_state = 2'd1;
				end
				else if (D_write) begin
					read_i = 1'b0;
					write_i = 1'b1;
					next_adr = data_adr;
					next_data_w = writedata;
					next_state = 2'd3;
				end
				else if (I_fetch) begin
					read_i = 1'b1;
					write_i = 1'b0;
					next_adr = instr_adr;
					next_state = 2'd2;
				end
				else begin
					read_i = 1'b0;
					write_i = 1'b0;
					next_adr = 32'b00000000000000000000000000000000;
					next_data_w = 32'b00000000000000000000000000000000;
					next_state = 2'd0;
				end
			2'd2: begin
				read_i = 1'b0;
				if (busy_o)
					next_instr = cpu_dat_o;
				else begin
					next_adr = 32'b00000000000000000000000000000000;
					i_done = 1'b1;
					next_instr = 32'b00000000000000000000000000000000;
					next_state = 2'd0;
				end
			end
			2'd1: begin
				read_i = 1'b0;
				if (busy_o)
					next_data = cpu_dat_o;
				else begin
					next_adr = 32'b00000000000000000000000000000000;
					d_done = 1'b1;
					next_data = 32'b00000000000000000000000000000000;
					next_state = 2'd0;
				end
			end
			2'd3: begin
				write_i = 1'b0;
				if (!busy_o) begin
					next_adr = 32'b00000000000000000000000000000000;
					next_data_w = 32'b00000000000000000000000000000000;
					d_done = 1'b1;
					next_state = 2'd0;
				end
			end
			default:
				;
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
