`default_nettype none
module t06_apple_luck_selector (
	button,
	nrst,
	clk,
	state,
	apple_luck
);
	reg _sv2v_0;
	input wire button;
	input wire nrst;
	input wire clk;
	input wire [1:0] state;
	output reg [1:0] apple_luck;
	reg [1:0] Qa;
	reg [1:0] Qna;
	always @(*) begin
		if (_sv2v_0)
			;
		case (Qa)
			2'b00: Qna = 2'b01;
			2'b01: Qna = 2'b10;
			2'b10: Qna = 2'b00;
			default: Qna = 2'b00;
		endcase
		if (state != 2'b01)
			Qna = Qa;
	end
	always @(negedge nrst or posedge clk)
		if (~nrst)
			Qa <= 2'b00;
		else if (button)
			Qa <= Qna;
		else
			Qa <= Qa;
	always @(*) begin
		if (_sv2v_0)
			;
		apple_luck = Qa;
	end
	initial _sv2v_0 = 0;
endmodule
