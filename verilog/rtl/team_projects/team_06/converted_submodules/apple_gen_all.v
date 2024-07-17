`default_nettype none
module t06_apple_gen_all (
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
	wall_locations,
	apple_location,
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
	input wire [199:0] wall_locations;
	output reg [7:0] apple_location;
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
	reg logic_enable;
	reg lucky_spot;
	reg unlucky_spot;
	reg good_spot;
	reg good_spot_next;
	reg [3:0] count;
	reg [7:0] count_luck;
	reg [7:0] count_luck_next;
	reg [7:0] total_difference;
	wire collisions_n;
	reg collisions;
	reg start_enable;
	wire impossible;
	t06_collisionLogic absxs(
		.next_head({y_next, x_next}),
		.body_x(snakeArrayX),
		.body_y(snakeArrayY),
		.collision(collisions_n)
	);
	t06_apple_check_wall_mode check_walls(
		.clk(system_clk),
		.nreset(nreset),
		.xmax(XMAX),
		.xmin(XMIN),
		.ymax(YMAX),
		.ymin(YMIN),
		.wall_locations(wall_locations),
		.apple_possible(apple_possible),
		.impossible(impossible)
	);
	always @(*) begin
		if (_sv2v_0)
			;
		enable_next = (~good_spot | good_collision) & start_enable;
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
					if ((((((({x_next, y_next} == {snake_head_x, snake_head_y}) | (x_next >= XMAX)) | (x_next <= XMIN)) | (y_next >= YMAX)) | (y_next <= YMIN)) | (collisions == 1)) | impossible) begin
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
					if ((((((({x_next, y_next} == {snake_head_x, snake_head_y}) | (x_next >= XMAX)) | (x_next <= XMIN)) | (y_next >= YMAX)) | (y_next <= YMIN)) | (collisions == 1)) | impossible) begin
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
					if ((((((({x_next, y_next} == {snake_head_x, snake_head_y}) | (x_next >= XMAX)) | (x_next <= XMIN)) | (y_next >= YMAX)) | (y_next <= YMIN)) | (collisions == 1)) | impossible) begin
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
	always @(posedge system_clk or negedge nreset)
		if (~nreset)
			apple_location <= 8'h55;
		else if (~good_spot & good_spot_next) begin
			if (start_enable == 1)
				apple_location <= {y_final, x_final};
			else
				apple_location <= 8'h55;
		end
		else
			apple_location <= apple_location;
	always @(posedge system_clk) begin
		good_spot = good_spot_next;
		x_final = x_next;
		y_final = y_next;
		collisions = collisions_n;
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
	always @(posedge system_clk or negedge nreset)
		if (~nreset)
			logic_enable <= 1;
		else if (good_collision)
			logic_enable <= 1;
		else if (start_enable == 0)
			logic_enable <= 1;
		else if (good_spot)
			logic_enable <= 0;
	always @(posedge system_clk or negedge nreset)
		if (~nreset)
			start_enable <= 0;
		else if (good_collision)
			start_enable <= 1;
		else
			start_enable <= start_enable;
	initial _sv2v_0 = 0;
endmodule
