`default_nettype none
module t06_collisionLogic (
	next_head,
	body_x,
	body_y,
	collision
);
	reg _sv2v_0;
	input wire [7:0] next_head;
	parameter MAX_LENGTH = 30;
	input wire [(MAX_LENGTH * 4) - 1:0] body_x;
	input wire [(MAX_LENGTH * 4) - 1:0] body_y;
	output reg collision;
	reg [MAX_LENGTH - 1:0] collision_array;
	always @(*) begin
		if (_sv2v_0)
			;
		collision_array = 0;
		begin : sv2v_autoblock_1
			integer i;
			for (i = 1; i <= (MAX_LENGTH - 1); i = i + 1)
				collision_array[i] = (((((((body_x[i * 4] ~^ next_head[0]) && (body_x[(i * 4) + 1] ~^ next_head[1])) && (body_x[(i * 4) + 2] ~^ next_head[2])) && (body_x[(i * 4) + 3] ~^ next_head[3])) && (body_y[i * 4] ~^ next_head[4])) && (body_y[(i * 4) + 1] ~^ next_head[5])) && (body_y[(i * 4) + 2] ~^ next_head[6])) && (body_y[(i * 4) + 3] ~^ next_head[7]);
		end
		collision = |collision_array;
	end
	initial _sv2v_0 = 0;
endmodule
