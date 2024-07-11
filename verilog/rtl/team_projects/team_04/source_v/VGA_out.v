`default_nettype none
module VGA_out (
	SRAM_data_in,
	SRAM_busy,
	clk,
	nrst,
	data_en,
	h_out,
	v_out,
	pixel_data,
	word_address_dest,
	byte_select,
	VGA_state,
	h_count,
	v_count,
	h_state,
	v_state
);
	reg _sv2v_0;
	input wire [31:0] SRAM_data_in;
	input wire SRAM_busy;
	input wire clk;
	input wire nrst;
	output reg data_en;
	output reg h_out;
	output reg v_out;
	output reg pixel_data;
	output wire [31:0] word_address_dest;
	output wire [3:0] byte_select;
	output reg [1:0] VGA_state;
	output reg [9:0] h_count;
	output reg [8:0] v_count;
	output reg [1:0] h_state;
	output reg [1:0] v_state;
	wire [31:0] word_address_base;
	reg [8:0] word_address_offset;
	wire change_state_h;
	wire change_state_v;
	reg v_count_toggle;
	reg [9:0] h_next_count;
	reg [8:0] v_next_count;
	reg [8:0] h_offset;
	reg [8:0] v_offset;
	wire [4:0] x_coord;
	wire [31:0] current_word;
	wire [31:0] next_word;
	assign word_address_base = 32'h00000000;
	reg [1:0] h_current_state;
	reg [1:0] h_next_state;
	always @(posedge clk or negedge nrst)
		if (~nrst) begin
			h_current_state <= 2'b00;
			h_count <= 0;
		end
		else begin
			h_current_state <= h_next_state;
			h_count <= h_next_count;
		end
	reg [1:0] v_current_state;
	reg [1:0] v_next_state;
	always @(posedge clk or negedge nrst)
		if (~nrst) begin
			v_current_state <= 2'b00;
			v_count <= 0;
		end
		else begin
			v_current_state <= v_next_state;
			v_count <= v_next_count;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		if ((v_current_state == 2'b10) & (v_count < 384))
			VGA_state = 2'b10;
		else if ((v_current_state == 2'b01) & (v_count > 9'd31))
			VGA_state = 2'b01;
		else
			VGA_state = 2'b00;
	end
	always @(*) begin
		if (_sv2v_0)
			;
		h_next_count = h_count;
		case (h_current_state)
			2'b00: begin
				h_state = 2'b00;
				v_count_toggle = 0;
				if (h_count < 37) begin
					h_next_count = h_next_count + 1'b1;
					h_out = 0;
					h_next_state = 2'b00;
				end
				else begin
					h_next_count = 0;
					h_out = 1;
					h_next_state = 2'b01;
				end
			end
			2'b01: begin
				h_state = 2'b01;
				h_out = 1;
				v_count_toggle = 0;
				if (h_count < 18) begin
					h_next_count = h_next_count + 1'b1;
					h_next_state = 2'b01;
				end
				else begin
					h_next_count = 0;
					h_next_state = 2'b10;
				end
			end
			2'b10: begin
				h_state = 2'b10;
				h_out = 1;
				v_count_toggle = 0;
				if (h_count < 256) begin
					h_next_count = h_next_count + 1'b1;
					h_next_state = 2'b10;
				end
				else begin
					h_next_count = 0;
					h_next_state = 2'b11;
				end
			end
			2'b11: begin
				h_state = 2'b11;
				h_out = 1;
				if (h_count < 5) begin
					h_next_count = h_next_count + 1'b1;
					h_next_state = 2'b11;
					v_count_toggle = 0;
				end
				else begin
					h_next_count = 0;
					h_next_state = 2'b00;
					v_count_toggle = 1;
				end
			end
		endcase
	end
	always @(*) begin
		if (_sv2v_0)
			;
		v_next_count = v_count;
		if (v_count_toggle)
			v_next_count = v_next_count + 1'b1;
		case (v_current_state)
			2'b00: begin
				v_state = 2'b00;
				if (v_count < 2) begin
					v_out = 0;
					v_next_state = 2'b00;
				end
				else begin
					v_next_count = 0;
					v_out = 1;
					v_next_state = 2'b01;
				end
			end
			2'b01: begin
				v_state = 2'b01;
				v_out = 1;
				if (v_count < 33)
					v_next_state = 2'b01;
				else begin
					v_next_count = 0;
					v_next_state = 2'b10;
				end
			end
			2'b10: begin
				v_state = 2'b10;
				v_out = 1;
				if (v_count < 480)
					v_next_state = 2'b10;
				else begin
					v_next_count = 0;
					v_next_state = 2'b11;
				end
			end
			2'b11: begin
				v_state = 2'b11;
				v_out = 1;
				if (v_count < 10)
					v_next_state = 2'b11;
				else begin
					v_next_count = 0;
					v_next_state = 2'b00;
				end
			end
		endcase
	end
	always @(*) begin
		if (_sv2v_0)
			;
		if (~SRAM_busy & data_en)
			pixel_data = SRAM_data_in[x_coord];
		else
			pixel_data = 0;
	end
	always @(*) begin
		if (_sv2v_0)
			;
		if ((((h_current_state == 2'b10) & (v_current_state == 2'b10)) & (h_count < 256)) & (v_count < 480))
			data_en = 1;
		else
			data_en = 0;
	end
	assign byte_select = {data_en, data_en, data_en, data_en};
	always @(*) begin
		if (_sv2v_0)
			;
		h_offset = {7'b0000000, h_count[7:6]};
		v_offset = 7'd4 * (v_count / 9'd5);
		word_address_offset = h_offset + v_offset;
	end
	assign word_address_dest = word_address_base + {23'b00000000000000000000000, word_address_offset};
	assign x_coord = 5'b11111 - h_count[5:1];
	initial _sv2v_0 = 0;
endmodule
