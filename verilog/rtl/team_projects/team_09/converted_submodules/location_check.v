module t09_location_check (
	coordinate,
	body,
	curr_length,
	clk,
	nrst,
	snakeBody,
	snakeHead
);
	reg _sv2v_0;
	parameter MAX_LENGTH = 50;
	input wire [7:0] coordinate;
	input wire [(MAX_LENGTH * 8) - 1:0] body;
	input wire [7:0] curr_length;
	input wire clk;
	input wire nrst;
	output wire snakeBody;
	output wire snakeHead;
	reg snake_head;
	reg snake_body;
	reg next_snake_head;
	reg next_snake_body;
	wire [7:0] adjusted_coordinate;
	always @(posedge clk or negedge nrst)
		if (~nrst) begin
			snake_head <= 1'b0;
			snake_body <= 1'b0;
		end
		else begin
			snake_head <= next_snake_head;
			snake_body <= next_snake_body;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		next_snake_head = 1'b0;
		next_snake_body = 1'b0;
		begin : sv2v_autoblock_1
			integer i;
			for (i = 0; i < MAX_LENGTH; i = i + 1)
				if (i == 0) begin
					if (body[0+:8] == coordinate)
						next_snake_head = 1'b1;
				end
				else if (i <= curr_length) begin
					if (body[i * 8+:8] == coordinate)
						next_snake_body = 1'b1;
				end
		end
	end
	assign {snakeHead, snakeBody} = {next_snake_head, next_snake_body};
	initial _sv2v_0 = 0;
endmodule
