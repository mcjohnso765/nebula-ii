`default_nettype none
module t06_display (
	gameState,
	gameMode,
	appleLuck,
	gameSpeed,
	score,
	row_top,
	row_bot
);
	reg _sv2v_0;
	input wire [1:0] gameState;
	input wire [1:0] gameMode;
	input wire [1:0] appleLuck;
	input wire [1:0] gameSpeed;
	input wire [7:0] score;
	output reg [127:0] row_top;
	output reg [127:0] row_bot;
	reg [7:0] digit1;
	reg [7:0] digit2;
	reg [7:0] digit3;
	reg [7:0] temp;
	reg [7:0] temp2;
	always @(*) begin
		if (_sv2v_0)
			;
		row_top = {16 {8'h20}};
		row_bot = {16 {8'h20}};
		case (gameState)
			2'b01: begin
				row_top[127:120] = 8'd87;
				row_top[119:112] = 8'd65;
				row_top[111:104] = 8'd73;
				row_top[103:96] = 8'd84;
			end
			2'b00: begin
				row_top[127:120] = 8'd82;
				row_top[119:112] = 8'd85;
				row_top[111:104] = 8'd78;
			end
			2'b10: begin
				row_top[127:120] = 8'd80;
				row_top[119:112] = 8'd65;
				row_top[111:104] = 8'd85;
				row_top[103:96] = 8'd83;
				row_top[95:88] = 8'd69;
			end
			2'b11: begin
				row_top[127:120] = 8'd69;
				row_top[119:112] = 8'd78;
				row_top[111:104] = 8'd68;
			end
			default: begin
				row_top[127:120] = 8'd32;
				row_top[119:112] = 8'd32;
				row_top[111:104] = 8'd32;
				row_top[103:96] = 8'd32;
				row_top[95:88] = 8'd32;
				row_top[87:80] = 8'd32;
			end
		endcase
		case (gameMode)
			2'b00: begin
				row_top[31:24] = 8'd50;
				row_top[23:16] = 8'd65;
				row_top[15:8] = 8'd80;
				row_top[7:0] = 8'd80;
			end
			2'b01: begin
				row_top[31:24] = 8'd78;
				row_top[23:16] = 8'd79;
				row_top[15:8] = 8'd82;
				row_top[7:0] = 8'd77;
			end
			2'b10: begin
				row_top[31:24] = 8'd87;
				row_top[23:16] = 8'd65;
				row_top[15:8] = 8'd76;
				row_top[7:0] = 8'd76;
			end
			2'b11: begin
				row_top[31:24] = 8'd66;
				row_top[23:16] = 8'd79;
				row_top[15:8] = 8'd82;
				row_top[7:0] = 8'd68;
			end
			default: begin
				row_top[31:24] = 8'd32;
				row_top[23:16] = 8'd32;
				row_top[15:8] = 8'd32;
				row_top[7:0] = 8'd32;
			end
		endcase
		row_bot[71:64] = 8'd83;
		row_bot[63:56] = 8'd80;
		row_bot[55:48] = 8'd68;
		row_bot[47:40] = 8'd58;
		row_bot[39:32] = 8'd32;
		case (gameSpeed)
			2'b00: begin
				row_bot[31:24] = 8'd78;
				row_bot[23:16] = 8'd79;
				row_bot[15:8] = 8'd82;
				row_bot[7:0] = 8'd77;
			end
			2'b01: begin
				row_bot[31:24] = 8'd70;
				row_bot[23:16] = 8'd65;
				row_bot[15:8] = 8'd83;
				row_bot[7:0] = 8'd84;
			end
			2'b10: begin
				row_bot[31:24] = 8'd83;
				row_bot[23:16] = 8'd76;
				row_bot[15:8] = 8'd79;
				row_bot[7:0] = 8'd87;
			end
			default: begin
				row_top[31:24] = 8'd32;
				row_top[23:16] = 8'd32;
				row_top[15:8] = 8'd32;
				row_top[7:0] = 8'd32;
			end
		endcase
		case (appleLuck)
			2'b00: begin
				row_bot[127:120] = 8'd78;
				row_bot[119:112] = 8'd79;
				row_bot[111:104] = 8'd82;
				row_bot[103:96] = 8'd77;
				row_bot[95:88] = 8'd65;
				row_bot[87:80] = 8'd76;
			end
			2'b01: begin
				row_bot[127:120] = 8'd76;
				row_bot[119:112] = 8'd85;
				row_bot[111:104] = 8'd67;
				row_bot[103:96] = 8'd75;
				row_bot[95:88] = 8'd89;
			end
			2'b10: begin
				row_bot[127:120] = 8'd85;
				row_bot[119:112] = 8'd78;
				row_bot[111:104] = 8'd76;
				row_bot[103:96] = 8'd85;
				row_bot[95:88] = 8'd67;
				row_bot[87:80] = 8'd75;
				row_bot[79:72] = 8'd89;
			end
			default: begin
				row_bot[127:120] = 8'd32;
				row_bot[119:112] = 8'd32;
				row_bot[111:104] = 8'd32;
				row_bot[103:96] = 8'd32;
				row_bot[95:88] = 8'd32;
				row_bot[87:80] = 8'd32;
			end
		endcase
		digit1 = 8'b00000000;
		digit2 = 8'b00000000;
		digit3 = 8'b00000000;
		temp = 8'b00000000;
		temp2 = 8'b00000000;
		if (score >= 100) begin
			digit3 = (score % 10) + 48;
			temp = score / 10;
			digit2 = (temp % 10) + 48;
			temp2 = temp / 10;
			digit1 = (temp2 % 10) + 48;
		end
		else if (score >= 10) begin
			digit3 = (score % 10) + 48;
			temp = score / 10;
			digit2 = (temp % 10) + 48;
			digit1 = 32;
		end
		else begin
			digit3 = score + 48;
			digit2 = 32;
			digit1 = 32;
		end
		row_top[79:72] = digit1;
		row_top[71:64] = digit2;
		row_top[63:56] = digit3;
	end
	initial _sv2v_0 = 0;
endmodule
