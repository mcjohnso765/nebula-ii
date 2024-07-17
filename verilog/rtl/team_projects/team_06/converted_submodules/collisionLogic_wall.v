`default_nettype none
module t06_collisionLogic_wall (
	next_wall,
	walls,
	collision
);
	reg _sv2v_0;
	input wire [7:0] next_wall;
	input wire [199:0] walls;
	output reg collision;
	reg [24:0] collision_array;
	always @(*) begin
		if (_sv2v_0)
			;
		begin : sv2v_autoblock_1
			integer i;
			for (i = 0; i <= 24; i = i + 1)
				collision_array[i] = (((((((walls[i * 8] ~^ next_wall[0]) && (walls[(i * 8) + 1] ~^ next_wall[1])) && (walls[(i * 8) + 2] ~^ next_wall[2])) && (walls[(i * 8) + 3] ~^ next_wall[3])) && (walls[(i * 8) + 4] ~^ next_wall[4])) && (walls[(i * 8) + 5] ~^ next_wall[5])) && (walls[(i * 8) + 6] ~^ next_wall[6])) && (walls[(i * 8) + 7] ~^ next_wall[7]);
		end
		collision = |collision_array;
	end
	initial _sv2v_0 = 0;
endmodule
