module t09_command_lut2 (
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
	reg [16:0] SC;
	reg [16:0] EC;
	reg [16:0] SP;
	reg [16:0] EP;
	reg [16:0] color;
	reg [4:0] cmd_num;
	reg [4:0] next_cmd_num;
	wire [15:0] rainbowRNG;
	reg enable;
	wire apple_rgb;
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
		if (obj_code == 4'b0010)
			enable = 1;
		else
			enable = 0;
	end
	t09_rainbowRand rR1(
		.clk(clk),
		.reset(nrst),
		.rainbowRNG(rainbowRNG),
		.enable(enable)
	);
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
					color = 16'h1408;
			end
			else begin
				next_cmd_num = cmd_num;
				pause = 1'b0;
				next_count = count;
			end
			cmd_finished = 1'b0;
			case (next_cmd_num)
				5'd1: begin
					D = 8'b00000001;
					dcx = 1'b0;
				end
				5'd2: begin
					D = 8'b00101000;
					dcx = 1'b0;
				end
				5'd3: begin
					D = 8'b00111010;
					dcx = 1'b0;
				end
				5'd4: begin
					D = 8'b01010101;
					dcx = 1'b1;
				end
				5'd5: begin
					D = 8'b00010001;
					dcx = 1'b0;
				end
				5'd6: begin
					D = 8'b00101001;
					dcx = 1'b0;
				end
				5'd7: begin
					D = 8'b00101010;
					dcx = 1'b0;
				end
				5'd8: begin
					D = 8'h00;
					dcx = 1'b1;
				end
				5'd9: begin
					D = 8'h00;
					dcx = 1'b1;
				end
				5'd10: begin
					D = 8'h00;
					dcx = 1'b1;
				end
				5'd11: begin
					D = 8'hf0;
					dcx = 1'b1;
				end
				5'd12: begin
					D = 8'b00101011;
					dcx = 1'b0;
				end
				5'd13: begin
					D = 8'h00;
					dcx = 1'b1;
				end
				5'd14: begin
					D = 8'h00;
					dcx = 1'b1;
				end
				5'd15: begin
					D = 8'h01;
					dcx = 1'b1;
				end
				5'd16: begin
					D = 8'h40;
					dcx = 1'b1;
				end
				5'd17: begin
					D = 8'b00101100;
					dcx = 1'b0;
				end
				5'd18: begin
					D = color[7:0];
					dcx = 1'b1;
				end
				5'd19: begin
					D = color[15:8];
					dcx = 1'b1;
				end
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
			SP = X * 20;
			EP = (X + 1) * 20;
			SC = Y * 20;
			EC = (Y + 1) * 20;
			case (obj_code)
				3'b000: color = 16'h1408;
				3'b001: color = 16'h901e;
				3'b010: color = rainbowRNG;
				3'b011: color = 16'h00f8;
				3'b100: color = 16'h0000;
				default: color = 16'h1408;
			endcase
			cmd_finished = 1'b0;
			case (next_cmd_num)
				5'd1: begin
					D = 8'b00101010;
					dcx = 1'b0;
				end
				5'd2: begin
					D = SC[15:8];
					dcx = 1'b1;
				end
				5'd3: begin
					D = SC[7:0];
					dcx = 1'b1;
				end
				5'd4: begin
					D = EC[15:8];
					dcx = 1'b1;
				end
				5'd5: begin
					D = EC[7:0];
					dcx = 1'b1;
				end
				5'd6: begin
					D = 8'b00101011;
					dcx = 1'b0;
				end
				5'd7: begin
					D = SP[15:8];
					dcx = 1'b1;
				end
				5'd8: begin
					D = SP[7:0];
					dcx = 1'b1;
				end
				5'd9: begin
					D = EP[15:8];
					dcx = 1'b1;
				end
				5'd10: begin
					D = EP[7:0];
					dcx = 1'b1;
				end
				5'd11: begin
					D = 8'b00101100;
					dcx = 1'b0;
				end
				5'd12: begin
					D = color[7:0];
					dcx = 1'b1;
				end
				5'd13: begin
					D = color[15:8];
					dcx = 1'b1;
				end
				5'd14: begin
					D = 8'b00000000;
					dcx = 1'b0;
					cmd_finished = 1'b1;
					if (mode == 3'd4)
						next_cmd_num = 5'b00000;
				end
				default: begin
					D = 8'b00000000;
					dcx = 1'b0;
				end
			endcase
		end
	end
	initial _sv2v_0 = 0;
endmodule
