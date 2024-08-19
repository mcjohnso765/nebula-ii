`default_nettype none
module t06_collisionDetector (
	clk,
	nrst,
	check_enable,
	snakeHeadX,
	snakeHeadY,
	borderXMin,
	borderXMax,
	borderYMax,
	borderYMin,
	AppleX,
	AppleY,
	AppleX2,
	AppleY2,
	snakeArrayX,
	snakeArrayY,
	wall_array,
	badCollision,
	goodCollision,
	good_collision2
);
	reg _sv2v_0;
	input wire clk;
	input wire nrst;
	input wire check_enable;
	input wire [3:0] snakeHeadX;
	input wire [3:0] snakeHeadY;
	input wire [3:0] borderXMin;
	input wire [3:0] borderXMax;
	input wire [3:0] borderYMax;
	input wire [3:0] borderYMin;
	input wire [3:0] AppleX;
	input wire [3:0] AppleY;
	input wire [3:0] AppleX2;
	input wire [3:0] AppleY2;
	parameter MAX_LENGTH = 30;
	input wire [(MAX_LENGTH * 4) - 1:0] snakeArrayX;
	input wire [(MAX_LENGTH * 4) - 1:0] snakeArrayY;
	input wire [199:0] wall_array;
	output reg badCollision;
	output reg goodCollision;
	output reg good_collision2;
	wire collision_n;
	reg goodCollision_n;
	reg badCollision_n;
	reg goodCollision_n2;
	wire badCollision_n2;
	t06_collisionLogic snakeLogic(
		.next_head({snakeHeadY, snakeHeadX}),
		.body_x(snakeArrayX),
		.body_y(snakeArrayY),
		.collision(collision_n)
	);
	t06_collisionLogic_wall rndwall(
		.next_wall({snakeHeadY, snakeHeadX}),
		.walls(wall_array),
		.collision(badCollision_n2)
	);
	always @(*) begin
		if (_sv2v_0)
			;
		badCollision_n = (((snakeHeadX <= borderXMin) | (snakeHeadX >= borderXMax)) | (snakeHeadY <= borderYMin)) | (snakeHeadY >= borderYMax);
		goodCollision_n = (snakeHeadX == AppleX) && (snakeHeadY == AppleY);
		goodCollision_n2 = (snakeHeadX == AppleX2) && (snakeHeadY == AppleY2);
	end
	always @(posedge clk or negedge nrst)
		if (~nrst) begin
			goodCollision <= 0;
			badCollision <= 0;
			good_collision2 <= 0;
		end
		else if (check_enable) begin
			goodCollision <= goodCollision_n;
			good_collision2 <= goodCollision_n2;
			badCollision <= (badCollision_n | badCollision_n2) | collision_n;
		end
		else begin
			goodCollision <= goodCollision;
			good_collision2 <= good_collision2;
			badCollision <= badCollision;
		end
	initial _sv2v_0 = 0;
endmodule
