module t09_frame_tracker (
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
	output wire [3:0] x;
	output wire [3:0] y;
	output wire diff;
	reg [575:0] frame;
	reg [575:0] next_frame;
	reg [3:0] current_X;
	reg [3:0] next_X;
	reg [3:0] current_Y;
	reg [3:0] next_Y;
	reg next_d;
	wire d;
	reg pulse;
	reg [2:0] temp_obj_code;
	reg [2:0] count;
	reg [2:0] next_count;
	always @(posedge clk or negedge nrst)
		if (~nrst)
			{frame[0+:36], frame[36+:36], frame[72+:36], frame[108+:36], frame[144+:36], frame[180+:36], frame[216+:36], frame[252+:36], frame[288+:36], frame[324+:36], frame[360+:36], frame[396+:36], frame[432+:36], frame[468+:36], frame[504+:36], frame[540+:36]} <= {192 {3'b000}};
		else
			frame <= next_frame;
	always @(posedge clk or negedge nrst)
		if (~nrst) begin
			current_X <= 4'b0000;
			current_Y <= 4'b0000;
		end
		else begin
			current_X <= next_X;
			current_Y <= next_Y;
		end
	always @(posedge clk or negedge nrst)
		if (~nrst)
			count <= 0;
		else
			count <= next_count;
	always @(*) begin
		if (_sv2v_0)
			;
		if (count == 2) begin
			pulse = 1'b1;
			next_count = 3'b000;
		end
		else begin
			next_count = count + 3'b001;
			pulse = 1'b0;
		end
	end
	always @(*) begin
		if (_sv2v_0)
			;
		next_X = current_X;
		next_Y = current_Y;
		next_d = 1'b0;
		next_frame = frame;
		if (enable) begin
			if ((current_X == 4'd15) && (current_Y == 4'd11)) begin
				next_X = 4'b0000;
				next_Y = 4'b0000;
			end
			else if (current_X == 4'd15) begin
				next_X = 4'b0000;
				next_Y = current_Y + 4'd1;
			end
			else begin
				next_X = current_X + 4'd1;
				next_Y = current_Y;
			end
		end
		else if (sync) begin
			next_X = 0;
			next_Y = 0;
		end
		else begin
			next_X = current_X;
			next_Y = current_Y;
		end
		temp_obj_code = frame[((current_X * 12) + current_Y) * 3+:3];
		if (sync)
			{next_frame[0+:36], next_frame[36+:36], next_frame[72+:36], next_frame[108+:36], next_frame[144+:36], next_frame[180+:36], next_frame[216+:36], next_frame[252+:36], next_frame[288+:36], next_frame[324+:36], next_frame[360+:36], next_frame[396+:36], next_frame[432+:36], next_frame[468+:36], next_frame[504+:36], next_frame[540+:36]} = {192 {3'b000}};
		else
			next_frame = frame;
		case (temp_obj_code)
			3'b000:
				if (border) begin
					next_frame[((current_X * 12) + current_Y) * 3+:3] = 3'b100;
					obj_code = 3'b100;
					next_d = 1'b1;
				end
				else if (head) begin
					next_frame[((current_X * 12) + current_Y) * 3+:3] = 3'b001;
					obj_code = 3'b001;
					next_d = 1'b1;
				end
				else if (body) begin
					next_frame[((current_X * 12) + current_Y) * 3+:3] = 3'b010;
					obj_code = 3'b010;
					next_d = 1'b1;
				end
				else if (apple) begin
					next_frame[((current_X * 12) + current_Y) * 3+:3] = 3'b011;
					obj_code = 3'b011;
					next_d = 1'b1;
				end
				else begin
					next_frame[((current_X * 12) + current_Y) * 3+:3] = 3'b000;
					obj_code = 3'b000;
					next_d = 1'b0;
				end
			3'b001:
				if (border) begin
					next_frame[((current_X * 12) + current_Y) * 3+:3] = 3'b100;
					obj_code = 3'b100;
					next_d = 1'b1;
				end
				else if (head) begin
					next_frame[((current_X * 12) + current_Y) * 3+:3] = 3'b001;
					obj_code = 3'b001;
					next_d = 1'b0;
				end
				else if (body) begin
					next_frame[((current_X * 12) + current_Y) * 3+:3] = 3'b010;
					obj_code = 3'b010;
					next_d = 1'b1;
				end
				else if (apple) begin
					next_frame[((current_X * 12) + current_Y) * 3+:3] = 3'b011;
					obj_code = 3'b011;
					next_d = 1'b1;
				end
				else begin
					next_frame[((current_X * 12) + current_Y) * 3+:3] = 3'b000;
					obj_code = 3'b000;
					next_d = 1'b1;
				end
			3'b010:
				if (border) begin
					next_frame[((current_X * 12) + current_Y) * 3+:3] = 3'b100;
					obj_code = 3'b100;
					next_d = 1'b1;
				end
				else if (head) begin
					next_frame[((current_X * 12) + current_Y) * 3+:3] = 3'b001;
					obj_code = 3'b001;
					next_d = 1'b1;
				end
				else if (body) begin
					next_frame[((current_X * 12) + current_Y) * 3+:3] = 3'b010;
					obj_code = 3'b010;
					next_d = 1'b0;
				end
				else if (apple) begin
					next_frame[((current_X * 12) + current_Y) * 3+:3] = 3'b011;
					obj_code = 3'b011;
					next_d = 1'b1;
				end
				else begin
					next_frame[((current_X * 12) + current_Y) * 3+:3] = 3'b000;
					obj_code = 3'b000;
					next_d = 1'b1;
				end
			3'b011:
				if (border) begin
					next_frame[((current_X * 12) + current_Y) * 3+:3] = 3'b100;
					obj_code = 3'b100;
					next_d = 1'b1;
				end
				else if (head) begin
					next_frame[((current_X * 12) + current_Y) * 3+:3] = 3'b001;
					obj_code = 3'b001;
					next_d = 1'b1;
				end
				else if (body) begin
					next_frame[((current_X * 12) + current_Y) * 3+:3] = 3'b010;
					obj_code = 3'b010;
					next_d = 1'b1;
				end
				else if (apple) begin
					next_frame[((current_X * 12) + current_Y) * 3+:3] = 3'b011;
					obj_code = 3'b011;
					next_d = 1'b0;
				end
				else begin
					next_frame[((current_X * 12) + current_Y) * 3+:3] = 3'b000;
					obj_code = 3'b000;
					next_d = 1'b1;
				end
			3'b100:
				if (border) begin
					next_frame[((current_X * 12) + current_Y) * 3+:3] = 3'b100;
					obj_code = 3'b100;
					next_d = 1'b0;
				end
				else if (head) begin
					next_frame[((current_X * 12) + current_Y) * 3+:3] = 3'b001;
					obj_code = 3'b001;
					next_d = 1'b1;
				end
				else if (body) begin
					next_frame[((current_X * 12) + current_Y) * 3+:3] = 3'b010;
					obj_code = 3'b010;
					next_d = 1'b1;
				end
				else if (apple) begin
					next_frame[((current_X * 12) + current_Y) * 3+:3] = 3'b011;
					obj_code = 3'b011;
					next_d = 1'b1;
				end
				else begin
					next_frame[((current_X * 12) + current_Y) * 3+:3] = 3'b000;
					obj_code = 3'b000;
					next_d = 1'b1;
				end
			default: begin
				next_frame[((current_X * 12) + current_Y) * 3+:3] = 3'b000;
				obj_code = 3'b000;
				next_d = 1'b0;
			end
		endcase
	end
	assign x = current_X;
	assign y = current_Y;
	assign diff = next_d;
	initial _sv2v_0 = 0;
endmodule
