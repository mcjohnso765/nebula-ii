`default_nettype none
module t06_rand_wall_mode (
	good_collision,
	system_clk,
	nreset,
	apple_luck,
	snake_head_x,
	snake_head_y,
	XMAX,
	XMIN,
	YMAX,
	YMIN,
	apple_possible,
	snakeArrayX,
	snakeArrayY,
	enable_in,
	apple_locations,
	enable
);
	reg _sv2v_0;
	input wire good_collision;
	input wire system_clk;
	input wire nreset;
	input wire [1:0] apple_luck;
	input [3:0] snake_head_x;
	input [3:0] snake_head_y;
	input [3:0] XMAX;
	input [3:0] XMIN;
	input [3:0] YMAX;
	input [3:0] YMIN;
	input wire [7:0] apple_possible;
	parameter MAX_LENGTH = 30;
	input wire [(MAX_LENGTH * 4) - 1:0] snakeArrayX;
	input wire [(MAX_LENGTH * 4) - 1:0] snakeArrayY;
	input enable_in;
	output reg [199:0] apple_locations;
	output reg enable;
	reg [3:0] x_next;
	reg [3:0] y_next;
	reg [3:0] x_final;
	reg [3:0] y_final;
	reg [3:0] x_difference;
	reg [3:0] y_difference;
	reg [3:0] x_last;
	reg [3:0] y_last;
	reg enable_next;
	reg good_spot;
	reg good_spot_next;
	reg logic_enable;
	reg lucky_spot;
	reg unlucky_spot;
	reg [3:0] count;
	reg [7:0] count_luck;
	reg [7:0] count_luck_next;
	reg [7:0] total_difference;
	reg [4:0] counter;
	reg [4:0] counter2;
	reg count1;
	reg inputa;
	reg input2;
	wire collisions_n;
	reg collisions;
	reg start_enable;
	wire collisions_n2;
	t06_collisionLogic absxs(
		.next_head({y_next, x_next}),
		.body_x(snakeArrayX),
		.body_y(snakeArrayY),
		.collision(collisions_n)
	);
	t06_collisionLogic_wall abduyd(
		.next_wall({y_next, x_next}),
		.walls(apple_locations),
		.collision(collisions_n2)
	);
	always @(*) begin
		if (_sv2v_0)
			;
		enable_next = (~good_spot | input2) & start_enable;
		case (apple_luck)
			2'b00:
				if (logic_enable) begin
					if (enable) begin
						x_next = apple_possible[3:0];
						y_next = apple_possible[7:4];
						x_last = x_next;
						y_last = y_next;
					end
					else begin
						x_next = x_last;
						y_next = y_last;
						x_last = 0;
						y_last = 0;
					end
					if (((((({x_next, y_next} == {snake_head_x, snake_head_y}) | (x_next >= XMAX)) | (x_next <= XMIN)) | (y_next >= YMAX)) | (y_next <= YMIN)) | (collisions == 1)) begin
						good_spot_next = 0;
						x_difference = 0;
						y_difference = 0;
						total_difference = 0;
						lucky_spot = 0;
						unlucky_spot = 0;
						count_luck_next = count_luck;
					end
					else begin
						good_spot_next = 1'b1;
						x_difference = 0;
						y_difference = 0;
						total_difference = 0;
						lucky_spot = 0;
						unlucky_spot = 0;
						count_luck_next = count_luck;
					end
				end
				else begin
					x_next = 1;
					y_next = 1;
					good_spot_next = 1;
					x_difference = 0;
					y_difference = 0;
					total_difference = 0;
					lucky_spot = 0;
					unlucky_spot = 0;
					count_luck_next = count_luck;
					x_last = 0;
					y_last = 0;
				end
			2'b10:
				if (logic_enable) begin
					if (enable) begin
						x_next = apple_possible[3:0];
						y_next = apple_possible[7:4];
						x_last = x_next;
						y_last = y_next;
					end
					else begin
						x_next = x_last;
						y_next = y_last;
						x_last = 0;
						y_last = 0;
					end
					if (((((({x_next, y_next} == {snake_head_x, snake_head_y}) | (x_next >= XMAX)) | (x_next <= XMIN)) | (y_next >= YMAX)) | (y_next <= YMIN)) | (collisions == 1)) begin
						good_spot_next = 0;
						count_luck_next = count_luck;
						x_difference = 0;
						y_difference = 0;
						total_difference = 0;
						unlucky_spot = 0;
						lucky_spot = 0;
					end
					else begin
						if (snake_head_x >= x_next)
							x_difference = snake_head_x - x_next;
						else
							x_difference = x_next - snake_head_x;
						if (snake_head_y >= y_next)
							y_difference = snake_head_y - y_next;
						else
							y_difference = y_next - snake_head_y;
						total_difference = {4'd0, x_difference} + {4'd0, y_difference};
						if (total_difference >= 8) begin
							unlucky_spot = 1;
							lucky_spot = 0;
						end
						else if ((total_difference >= 6) & (count_luck > 50)) begin
							unlucky_spot = 1;
							lucky_spot = 0;
						end
						else if (count_luck >= 90) begin
							unlucky_spot = 1;
							lucky_spot = 0;
						end
						else begin
							unlucky_spot = 0;
							lucky_spot = 0;
						end
						if (unlucky_spot == 1) begin
							good_spot_next = 1'b1;
							count_luck_next = 0;
						end
						else begin
							good_spot_next = 0;
							count_luck_next = count_luck + 1;
						end
					end
				end
				else begin
					count_luck_next = count_luck;
					x_next = 0;
					y_next = 0;
					good_spot_next = 1;
					x_difference = 0;
					y_difference = 0;
					total_difference = 0;
					unlucky_spot = 0;
					lucky_spot = 0;
					x_last = 0;
					y_last = 0;
				end
			2'b01:
				if (logic_enable) begin
					if (enable) begin
						x_next = apple_possible[3:0];
						y_next = apple_possible[7:4];
						x_last = x_next;
						y_last = y_next;
					end
					else begin
						x_next = x_last;
						y_next = y_last;
						x_last = 0;
						y_last = 0;
					end
					if (((((({x_next, y_next} == {snake_head_x, snake_head_y}) | (x_next >= XMAX)) | (x_next <= XMIN)) | (y_next >= YMAX)) | (y_next <= YMIN)) | (collisions == 1)) begin
						good_spot_next = 0;
						count_luck_next = count_luck;
						x_difference = 0;
						y_difference = 0;
						total_difference = 0;
						lucky_spot = 0;
						unlucky_spot = 0;
					end
					else begin
						if (snake_head_x >= x_next)
							x_difference = snake_head_x - x_next;
						else
							x_difference = x_next - snake_head_x;
						if (snake_head_y >= y_next)
							y_difference = snake_head_y - y_next;
						else
							y_difference = y_next - snake_head_y;
						total_difference = {4'd0, x_difference} + {4'd0, y_difference};
						if (total_difference <= 3) begin
							unlucky_spot = 0;
							lucky_spot = 1;
						end
						else if ((total_difference <= 5) & (count_luck >= 50)) begin
							unlucky_spot = 0;
							lucky_spot = 1;
						end
						else if (count_luck >= 90) begin
							unlucky_spot = 0;
							lucky_spot = 1;
						end
						else begin
							unlucky_spot = 0;
							lucky_spot = 0;
						end
						if (lucky_spot == 1) begin
							good_spot_next = 1'b1;
							count_luck_next = 0;
						end
						else begin
							good_spot_next = 0;
							count_luck_next = count_luck + 1;
						end
					end
				end
				else begin
					count_luck_next = count_luck;
					x_next = 9;
					y_next = 7;
					good_spot_next = 1;
					x_difference = 0;
					y_difference = 0;
					total_difference = 0;
					lucky_spot = 0;
					unlucky_spot = 0;
					x_last = 0;
					y_last = 0;
				end
			default: begin
				x_next = 0;
				y_next = 1;
				good_spot_next = 1;
				x_difference = 0;
				y_difference = 0;
				total_difference = 0;
				lucky_spot = 0;
				unlucky_spot = 0;
				count_luck_next = count_luck;
				x_last = 0;
				y_last = 0;
			end
		endcase
	end
	always @(posedge good_spot or negedge nreset)
		if (~nreset)
			apple_locations <= 200'd0;
		else if (enable_in) begin
			if (start_enable == 1) begin
				apple_locations[0+:8] <= {y_final, x_final};
				apple_locations[8+:192] <= {apple_locations[0+:192]};
			end
			else
				apple_locations <= 200'd0;
		end
		else
			apple_locations <= 200'd0;
	always @(posedge system_clk or negedge nreset)
		if (~nreset) begin
			counter <= 5'd0;
			inputa <= 0;
			count1 <= 0;
		end
		else if (good_collision & (apple_locations[192+:8] == 8'd0)) begin
			if (count1) begin
				inputa <= 1;
				count1 <= 0;
				counter <= counter + 1;
			end
			else begin
				inputa <= 0;
				count1 <= 1;
				counter <= counter;
			end
		end
		else begin
			inputa <= 0;
			count1 <= count1;
			counter <= counter;
		end
	always @(posedge system_clk or negedge nreset)
		if (~nreset) begin
			input2 <= 0;
			counter2 <= 0;
		end
		else if (counter2 == 5'd30) begin
			input2 <= 1;
			counter2 <= 0;
		end
		else if (inputa) begin
			input2 <= 0;
			counter2 <= 1;
		end
		else if (input2) begin
			input2 <= 0;
			counter2 <= 0;
		end
		else if (counter2 >= 5'd1) begin
			input2 <= 0;
			counter2 <= counter2 + 1;
		end
		else begin
			input2 <= input2;
			counter2 <= counter2;
		end
	always @(posedge system_clk) begin
		if (enable_in == 1)
			good_spot = good_spot_next;
		else if (good_spot == 0)
			good_spot = 1;
		else
			good_spot = 0;
		x_final = x_next;
		y_final = y_next;
		collisions = collisions_n | collisions_n2;
		count_luck = count_luck_next;
		if (enable)
			count = count + 1;
		if (count == 4'd15) begin
			count = 0;
			enable = 0;
		end
		else
			enable = enable_next;
	end
	always @(posedge input2 or posedge good_spot or negedge nreset)
		if (~nreset)
			logic_enable = 1;
		else if (input2)
			logic_enable = 1;
		else if (start_enable == 0)
			logic_enable = 1;
		else
			logic_enable = 0;
	always @(posedge system_clk or negedge nreset)
		if (~nreset)
			start_enable = 0;
		else if (input2)
			start_enable = 1;
	initial _sv2v_0 = 0;
endmodule
