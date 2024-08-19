`default_nettype none
module t06_frame_tracker (
	body,
	head,
	apple,
	border,
	enable,
	clk,
	nrst,
	sync,
	obj_code,
	x,
	y,
	diff
);
	reg _sv2v_0;
	input wire body;
	input wire head;
	input wire apple;
	input wire border;
	input wire enable;
	input wire clk;
	input wire nrst;
	input wire sync;
	output reg [2:0] obj_code;
	output reg [3:0] x;
	output reg [3:0] y;
	output reg diff;
	reg [575:0] frame;
	reg [575:0] next_frame;
	reg [3:0] current_X;
	reg [3:0] next_X;
	reg [3:0] current_Y;
	reg [3:0] next_Y;
	reg next_d;
	reg [2:0] temp_obj_code;
	always @(posedge clk or negedge nrst)
		if (~nrst) begin
			frame <= {192 {3'b000}};
			{current_X, current_Y} <= 8'b00000000;
		end
		else begin
			frame <= next_frame;
			{current_X, current_Y} <= {next_X, next_Y};
		end
	always @(*) begin
		if (_sv2v_0)
			;
		{next_X, next_Y} = {current_X, current_Y};
		next_frame = frame;
		if (enable) begin
			if ((current_X == 4'd15) && (current_Y == 4'd11))
				{next_X, next_Y} = 8'b00000000;
			else if (current_X == 4'd15)
				{next_X, next_Y} = {4'b0000, current_Y + 4'd1};
			else
				{next_X, next_Y} = {current_X + 4'd1, current_Y};
		end
		else if (sync)
			{next_X, next_Y} = 8'b00000000;
		else
			{next_X, next_Y} = {current_X, current_Y};
		temp_obj_code = frame[((current_X * 12) + current_Y) * 3+:3];
		next_frame = (sync ? {192 {3'b000}} : frame);
		next_frame[((current_X * 12) + current_Y) * 3+:3] = (border ? 3'b100 : (head ? 3'b001 : (body ? 3'b010 : (apple ? 3'b011 : 3'b000))));
		obj_code = (border ? 3'b100 : (head ? 3'b001 : (body ? 3'b010 : (apple ? 3'b011 : 3'b000))));
		next_d = (temp_obj_code == 3'b000 ? ~(((~border & ~head) & ~body) & ~apple) : (temp_obj_code == 3'b001 ? ~(~border & head) : (temp_obj_code == 3'b010 ? ~((~border & ~head) & body) : (temp_obj_code == 3'b011 ? ~(((~border & ~head) & ~body) & apple) : (temp_obj_code == 3'b100 ? ~border : 1'b0)))));
		{x, y, diff} = {current_X, current_Y, next_d};
	end
	initial _sv2v_0 = 0;
endmodule
