module t06_body_control (
	main_clk,
	body_clk,
	pause_clk,
	nrst,
	goodCollision,
	badCollision,
	enable,
	Direction,
	head_x,
	head_y,
	body_x,
	body_y,
	score
);
	reg _sv2v_0;
	input wire main_clk;
	input wire body_clk;
	input wire pause_clk;
	input wire nrst;
	input wire goodCollision;
	input wire badCollision;
	input wire enable;
	input wire [1:0] Direction;
	output reg [3:0] head_x;
	output reg [3:0] head_y;
	parameter MAX_LENGTH = 30;
	output reg [(MAX_LENGTH * 4) - 1:0] body_x;
	output reg [(MAX_LENGTH * 4) - 1:0] body_y;
	output reg [7:0] score;
	reg [3:0] innerhead_x;
	reg [3:0] innerhead_y;
	reg [(MAX_LENGTH * 4) - 1:0] nextbody_x;
	reg [(MAX_LENGTH * 4) - 1:0] nextbody_y;
	reg [(MAX_LENGTH * 4) - 1:0] finalbody_x;
	reg [(MAX_LENGTH * 4) - 1:0] finalbody_y;
	reg [7:0] innerscore;
	always @(*) begin
		if (_sv2v_0)
			;
		innerhead_x = head_x;
		innerhead_y = head_y;
		nextbody_x = body_x;
		nextbody_y = body_y;
		finalbody_x = nextbody_x;
		finalbody_y = nextbody_y;
		innerscore = score;
		if (enable == 1'b1) begin
			case (Direction)
				2'b00: innerhead_y = head_y - 1;
				2'b01: innerhead_y = head_y + 1;
				2'b11: innerhead_x = head_x + 1;
				2'b10: innerhead_x = head_x - 1;
				default: {innerhead_x, innerhead_y} = {head_x, head_y};
			endcase
			nextbody_x = {body_x[4 * (((MAX_LENGTH - 2) >= 0 ? MAX_LENGTH - 2 : ((MAX_LENGTH - 2) + ((MAX_LENGTH - 2) >= 0 ? MAX_LENGTH - 1 : 3 - MAX_LENGTH)) - 1) - (((MAX_LENGTH - 2) >= 0 ? MAX_LENGTH - 1 : 3 - MAX_LENGTH) - 1))+:4 * ((MAX_LENGTH - 2) >= 0 ? MAX_LENGTH - 1 : 3 - MAX_LENGTH)], innerhead_x};
			nextbody_y = {body_y[4 * (((MAX_LENGTH - 2) >= 0 ? MAX_LENGTH - 2 : ((MAX_LENGTH - 2) + ((MAX_LENGTH - 2) >= 0 ? MAX_LENGTH - 1 : 3 - MAX_LENGTH)) - 1) - (((MAX_LENGTH - 2) >= 0 ? MAX_LENGTH - 1 : 3 - MAX_LENGTH) - 1))+:4 * ((MAX_LENGTH - 2) >= 0 ? MAX_LENGTH - 1 : 3 - MAX_LENGTH)], innerhead_y};
			if ((goodCollision == 0) && (badCollision == 0))
				case (score)
					0: {finalbody_x[0+:8], finalbody_y[0+:8]} = {nextbody_x[0+:8], nextbody_y[0+:8]};
					1: {finalbody_x[0+:12], finalbody_y[0+:12]} = {nextbody_x[0+:12], nextbody_y[0+:12]};
					2: {finalbody_x[0+:16], finalbody_y[0+:16]} = {nextbody_x[0+:16], nextbody_y[0+:16]};
					3: {finalbody_x[0+:20], finalbody_y[0+:20]} = {nextbody_x[0+:20], nextbody_y[0+:20]};
					4: {finalbody_x[0+:24], finalbody_y[0+:24]} = {nextbody_x[0+:24], nextbody_y[0+:24]};
					5: {finalbody_x[0+:28], finalbody_y[0+:28]} = {nextbody_x[0+:28], nextbody_y[0+:28]};
					6: {finalbody_x[0+:32], finalbody_y[0+:32]} = {nextbody_x[0+:32], nextbody_y[0+:32]};
					7: {finalbody_x[0+:36], finalbody_y[0+:36]} = {nextbody_x[0+:36], nextbody_y[0+:36]};
					8: {finalbody_x[0+:40], finalbody_y[0+:40]} = {nextbody_x[0+:40], nextbody_y[0+:40]};
					9: {finalbody_x[0+:44], finalbody_y[0+:44]} = {nextbody_x[0+:44], nextbody_y[0+:44]};
					10: {finalbody_x[0+:48], finalbody_y[0+:48]} = {nextbody_x[0+:48], nextbody_y[0+:48]};
					11: {finalbody_x[0+:52], finalbody_y[0+:52]} = {nextbody_x[0+:52], nextbody_y[0+:52]};
					12: {finalbody_x[0+:56], finalbody_y[0+:56]} = {nextbody_x[0+:56], nextbody_y[0+:56]};
					13: {finalbody_x[0+:60], finalbody_y[0+:60]} = {nextbody_x[0+:60], nextbody_y[0+:60]};
					14: {finalbody_x[0+:64], finalbody_y[0+:64]} = {nextbody_x[0+:64], nextbody_y[0+:64]};
					15: {finalbody_x[0+:68], finalbody_y[0+:68]} = {nextbody_x[0+:68], nextbody_y[0+:68]};
					16: {finalbody_x[0+:72], finalbody_y[0+:72]} = {nextbody_x[0+:72], nextbody_y[0+:72]};
					17: {finalbody_x[0+:76], finalbody_y[0+:76]} = {nextbody_x[0+:76], nextbody_y[0+:76]};
					18: {finalbody_x[0+:80], finalbody_y[0+:80]} = {nextbody_x[0+:80], nextbody_y[0+:80]};
					19: {finalbody_x[0+:84], finalbody_y[0+:84]} = {nextbody_x[0+:84], nextbody_y[0+:84]};
					20: {finalbody_x[0+:88], finalbody_y[0+:88]} = {nextbody_x[0+:88], nextbody_y[0+:88]};
					21: {finalbody_x[0+:92], finalbody_y[0+:92]} = {nextbody_x[0+:92], nextbody_y[0+:92]};
					22: {finalbody_x[0+:96], finalbody_y[0+:96]} = {nextbody_x[0+:96], nextbody_y[0+:96]};
					23: {finalbody_x[0+:100], finalbody_y[0+:100]} = {nextbody_x[0+:100], nextbody_y[0+:100]};
					24: {finalbody_x[0+:104], finalbody_y[0+:104]} = {nextbody_x[0+:104], nextbody_y[0+:104]};
					25: {finalbody_x[0+:108], finalbody_y[0+:108]} = {nextbody_x[0+:108], nextbody_y[0+:108]};
					26: {finalbody_x[0+:112], finalbody_y[0+:112]} = {nextbody_x[0+:112], nextbody_y[0+:112]};
					27: {finalbody_x[0+:116], finalbody_y[0+:116]} = {nextbody_x[0+:116], nextbody_y[0+:116]};
					28: {finalbody_x[0+:120], finalbody_y[0+:120]} = {nextbody_x[0+:120], nextbody_y[0+:120]};
					default: {finalbody_x, finalbody_y} = {nextbody_x, nextbody_y};
				endcase
			else if (goodCollision == 1) begin
				finalbody_x = nextbody_x;
				finalbody_y = nextbody_y;
				innerscore = score + 1;
			end
			else begin
				finalbody_x <= 120'h000000000000000000000000000044;
				finalbody_y <= 120'h000000000000000000000000000034;
			end
		end
	end
	always @(posedge main_clk or negedge nrst)
		if (nrst == 1'b0) begin
			head_x <= 4'd4;
			head_y <= 4'd4;
			body_x <= 120'h000000000000000000000000000034;
			body_y <= 120'h000000000000000000000000000044;
			score <= 0;
		end
		else if (pause_clk) begin
			if (body_clk) begin
				if (badCollision == 0) begin
					head_x <= innerhead_x;
					head_y <= innerhead_y;
					body_x <= finalbody_x;
					body_y <= finalbody_y;
					score <= innerscore;
				end
				else begin
					head_x <= 4'd4;
					head_y <= 4'd4;
					body_x <= 120'h000000000000000000000000000034;
					body_y <= 120'h000000000000000000000000000044;
				end
			end
			else begin
				head_x = head_x;
				head_y = head_y;
				body_x = body_x;
				body_y = body_y;
				score = score;
			end
		end
		else begin
			head_x = head_x;
			head_y = head_y;
			body_x = body_x;
			body_y = body_y;
			score = score;
		end
	initial _sv2v_0 = 0;
endmodule
