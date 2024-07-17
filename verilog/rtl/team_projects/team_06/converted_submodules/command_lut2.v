`default_nettype none
module t06_command_lut2 (
	mode,
	clk,
	nrst,
	obj_code,
	X,
	Y,
	cmd_finished,
	D,
	dcx,
	pause
);
	reg _sv2v_0;
	input wire [2:0] mode;
	input wire clk;
	input wire nrst;
	input wire [2:0] obj_code;
	input wire [3:0] X;
	input wire [3:0] Y;
	output reg cmd_finished;
	output reg [7:0] D;
	output reg dcx;
	output reg pause;
	reg [16:0] count;
	reg [16:0] next_count;
	reg [15:0] SC;
	reg [15:0] EC;
	reg [15:0] SP;
	reg [15:0] EP;
	reg [15:0] color;
	reg [4:0] cmd_num;
	reg [4:0] next_cmd_num;
	always @(posedge clk or negedge nrst)
		if (~nrst) begin
			count <= 0;
			cmd_num <= 0;
		end
		else begin
			count <= next_count;
			cmd_num <= next_cmd_num;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		next_count = count;
		pause = 1'b0;
		next_cmd_num = cmd_num;
		color = 16'h0000;
		SC = 16'b0000000000000000;
		EC = 16'b0000000000000000;
		SP = 16'b0000000000000000;
		EP = 16'b0000000000000000;
		D = 8'b00000000;
		dcx = 1'b0;
		cmd_finished = 1'b0;
		if ((mode == 3'd1) || (mode == 3'd3)) begin
			if (mode == 3'd1) begin
				if ((cmd_num == 5'd1) || (cmd_num == 5'd5)) begin
					if (count > 17'd60000) begin
						next_count = 0;
						next_cmd_num = cmd_num + 5'd1;
						pause = 1'b0;
					end
					else begin
						next_count = count + 17'b00000000000000001;
						next_cmd_num = cmd_num;
						pause = 1'b1;
					end
				end
				else if (count > 17'd76900) begin
					next_count = 17'd0;
					next_cmd_num = 5'd20;
				end
				else if (cmd_num == 5'd17)
					next_cmd_num = 5'd19;
				else if (cmd_num == 5'd18) begin
					next_cmd_num = 5'd19;
					next_count = count + 17'b00000000000000001;
				end
				else if (cmd_num == 5'd19)
					next_cmd_num = 5'd18;
				else
					next_cmd_num = cmd_num + 5'd1;
				if (count < 17'd4320)
					color = 16'h0000;
				else
					color = 16'he580;
			end
			else begin
				next_cmd_num = cmd_num;
				pause = 1'b0;
				next_count = count;
			end
			cmd_finished = 1'b0;
			case (next_cmd_num)
				5'd1: {D, dcx} = 9'b000000010;
				5'd2: {D, dcx} = 9'b001010000;
				5'd3: {D, dcx} = 9'b001110100;
				5'd4: {D, dcx} = 9'b010101011;
				5'd5: {D, dcx} = 9'b000100010;
				5'd6: {D, dcx} = 9'b001010010;
				5'd7: {D, dcx} = 9'b001010100;
				5'd8: {D, dcx} = 9'b000000001;
				5'd9: {D, dcx} = 9'b000000001;
				5'd10: {D, dcx} = 9'b000000001;
				5'd11: {D, dcx} = 9'h1e1;
				5'd12: {D, dcx} = 9'b001010110;
				5'd13: {D, dcx} = 9'b000000001;
				5'd14: {D, dcx} = 9'b000000001;
				5'd15: {D, dcx} = 9'b000000011;
				5'd16: {D, dcx} = 9'b010000001;
				5'd17: {D, dcx} = 9'b001011000;
				5'd18: {D, dcx} = {color[7:0], 1'b1};
				5'd19: {D, dcx} = {color[15:8], 1'b1};
				5'd20: begin
					D = 8'b00000000;
					dcx = 1'b0;
					cmd_finished = 1'b1;
					if (mode == 3'd3)
						next_cmd_num = 5'b00000;
				end
				default: begin
					D = 8'b00000000;
					dcx = 1'b0;
				end
			endcase
		end
		else if ((mode == 3'd2) || (mode == 3'd4)) begin
			if (mode == 3'd2) begin
				if (cmd_num == 5'd11) begin
					next_cmd_num = 5'd13;
					next_count = count;
				end
				else if (count >= 17'd900) begin
					next_count = 0;
					next_cmd_num = 5'd14;
				end
				else if (cmd_num == 5'd12) begin
					next_cmd_num = 5'd13;
					next_count = count + 17'b00000000000000001;
				end
				else if (cmd_num == 5'd13) begin
					next_cmd_num = 5'd12;
					next_count = count + 17'b00000000000000001;
				end
				else
					next_cmd_num = cmd_num + 5'd1;
			end
			else begin
				next_count = count;
				next_cmd_num = cmd_num;
			end
			SP = {12'b000000000000, X} * 16'd20;
			EP = ({12'b000000000000, X} + 1) * 16'd20;
			SC = {12'b000000000000, Y} * 16'd20;
			EC = ({12'b000000000000, Y} + 1) * 16'd20;
			case (obj_code)
				3'b001: color = 16'hf0f8;
				3'b010: color = 16'hf800;
				3'b011: color = 16'h00f8;
				3'b100: color = 16'h0000;
				default: color = 16'he580;
			endcase
			cmd_finished = 1'b0;
			case (next_cmd_num)
				5'd1: {D, dcx} = 9'h054;
				5'd2: {D, dcx} = {SC[15:8], 1'b1};
				5'd3: {D, dcx} = {SC[7:0], 1'b1};
				5'd4: {D, dcx} = {EC[15:8], 1'b1};
				5'd5: {D, dcx} = {EC[7:0], 1'b1};
				5'd6: {D, dcx} = 9'h056;
				5'd7: {D, dcx} = {SP[15:8], 1'b1};
				5'd8: {D, dcx} = {SP[7:0], 1'b1};
				5'd9: {D, dcx} = {EP[15:8], 1'b1};
				5'd10: {D, dcx} = {EP[7:0], 1'b1};
				5'd11: {D, dcx} = 9'h058;
				5'd12: {D, dcx} = {color[7:0], 1'b1};
				5'd13: {D, dcx} = {color[15:8], 1'b1};
				5'd14: begin
					{D, dcx} = 9'h000;
					cmd_finished = 1'b1;
					if (mode == 3'd4)
						next_cmd_num = 5'b00000;
				end
				default: {D, dcx} = 9'h000;
			endcase
		end
	end
	initial _sv2v_0 = 0;
endmodule
