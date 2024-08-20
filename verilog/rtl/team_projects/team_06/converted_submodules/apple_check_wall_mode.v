module t06_apple_check_wall_mode (
	xmax,
	xmin,
	ymax,
	ymin,
	wall_locations,
	apple_possible,
	clk,
	nreset,
	impossible
);
	reg _sv2v_0;
	input wire [3:0] xmax;
	input wire [3:0] xmin;
	input wire [3:0] ymax;
	input wire [3:0] ymin;
	input wire [199:0] wall_locations;
	input wire [7:0] apple_possible;
	input wire clk;
	input wire nreset;
	output reg impossible;
	reg [2:0] error_counter;
	reg [7:0] up;
	reg [7:0] down;
	reg [7:0] left;
	reg [7:0] right;
	reg collision_up;
	reg collision_down;
	reg collision_left;
	reg collision_right;
	wire collision_upn;
	wire collision_downn;
	wire collision_leftn;
	wire collision_rightn;
	t06_collisionLogic_wall above(
		.next_wall(up),
		.walls(wall_locations),
		.collision(collision_upn)
	);
	t06_collisionLogic_wall below(
		.next_wall(down),
		.walls(wall_locations),
		.collision(collision_downn)
	);
	t06_collisionLogic_wall right2(
		.next_wall(right),
		.walls(wall_locations),
		.collision(collision_rightn)
	);
	t06_collisionLogic_wall left2(
		.next_wall(left),
		.walls(wall_locations),
		.collision(collision_leftn)
	);
	always @(*) begin
		if (_sv2v_0)
			;
		error_counter = 0;
		up = apple_possible + 8'd8;
		down = apple_possible - 8'd8;
		left = apple_possible - 8'd1;
		right = apple_possible + 8'd1;
		if (up[7:4] >= ymax)
			error_counter = error_counter + 1;
		if (down[7:4] <= ymin)
			error_counter = error_counter + 1;
		if (right[3:0] >= xmax)
			error_counter = error_counter + 1;
		if (left[3:0] <= xmin)
			error_counter = error_counter + 1;
		if (collision_up)
			error_counter = error_counter + 1;
		if (collision_down)
			error_counter = error_counter + 1;
		if (collision_right)
			error_counter = error_counter + 1;
		if (collision_left)
			error_counter = error_counter + 1;
	end
	always @(posedge clk or negedge nreset)
		if (~nreset) begin
			collision_down <= 0;
			collision_left <= 0;
			collision_up <= 0;
			collision_right <= 0;
			impossible <= 0;
		end
		else begin
			collision_down <= collision_downn;
			collision_left <= collision_leftn;
			collision_up <= collision_upn;
			collision_right <= collision_rightn;
			impossible <= error_counter >= 3;
		end
	initial _sv2v_0 = 0;
endmodule
