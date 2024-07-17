`default_nettype none
module t09_update_body (
	clk,
	nrst,
	pulse,
	sync,
	direction,
	curr_length,
	body,
	head
);
	reg _sv2v_0;
	parameter MAX_LENGTH = 50;
	input wire clk;
	input wire nrst;
	input wire pulse;
	input wire sync;
	input wire [2:0] direction;
	input wire [7:0] curr_length;
	output wire [(MAX_LENGTH * 8) - 1:0] body;
	output wire [7:0] head;
	reg [(MAX_LENGTH * 8) - 1:0] current;
	reg [(MAX_LENGTH * 8) - 1:0] next;
	reg [3:0] head_x;
	reg [3:0] head_y;
	genvar _gv_i_1;
	generate
		for (_gv_i_1 = 0; _gv_i_1 < MAX_LENGTH; _gv_i_1 = _gv_i_1 + 1) begin : genblk1
			localparam i = _gv_i_1;
			always @(posedge clk or negedge nrst)
				if (~nrst) begin
					if (i == 0)
						current[i * 8+:8] <= 8'h45;
					else
						current[i * 8+:8] <= 8'b00000000;
				end
				else
					current[i * 8+:8] <= next[i * 8+:8];
		end
	endgenerate
	always @(*) begin
		if (_sv2v_0)
			;
		head_x = current[7-:4];
		head_y = current[3-:4];
		case (direction)
			3'd0: begin
				head_x = current[7-:4] - 4'd1;
				head_y = current[3-:4];
			end
			3'd1: begin
				head_x = current[7-:4] + 4'd1;
				head_y = current[3-:4];
			end
			3'd3: begin
				head_y = current[3-:4] + 4'd1;
				head_x = current[7-:4];
			end
			3'd2: begin
				head_y = current[3-:4] - 4'd1;
				head_x = current[7-:4];
			end
			default: begin
				head_x = current[7-:4];
				head_y = current[3-:4];
			end
		endcase
		if (sync) begin : sv2v_autoblock_1
			integer i;
			for (i = 0; i < MAX_LENGTH; i = i + 1)
				if (i == 0)
					next[i * 8+:8] = 8'h45;
				else
					next[i * 8+:8] = 8'b00000000;
		end
		else if (pulse) begin : sv2v_autoblock_2
			integer i;
			for (i = MAX_LENGTH - 1; i >= 0; i = i - 1)
				if (i == 0)
					next[0+:8] = {head_x, head_y};
				else if (i <= curr_length)
					next[i * 8+:8] = current[(i - 1) * 8+:8];
				else
					next[i * 8+:8] = 8'b00000000;
		end
		else
			next = current;
	end
	assign body = current;
	assign head = {head_x, head_y};
	initial _sv2v_0 = 0;
endmodule
