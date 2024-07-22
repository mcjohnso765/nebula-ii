`default_nettype none
module t06_gameState (
	button,
	badCollision,
	clk,
	nrst,
	gameMode,
	state
);
	reg _sv2v_0;
	input wire button;
	input wire badCollision;
	input wire clk;
	input wire nrst;
	input wire [1:0] gameMode;
	output reg [1:0] state;
	reg [1:0] Q;
	reg [1:0] Qn;
	always @(*) begin
		if (_sv2v_0)
			;
		case (gameMode)
			2'b01: Qn = (button == 1 ? 2'b00 : 2'b01);
			2'b00: Qn = (badCollision ? 2'b11 : (button ? 2'b10 : 2'b00));
			2'b10: Qn = (button ? 2'b00 : 2'b10);
			2'b11: Qn = (button == 1 ? 2'b01 : 2'b11);
			default: Qn = 2'b01;
		endcase
	end
	always @(posedge clk or negedge nrst)
		if (~nrst)
			Q <= 2'b01;
		else
			Q <= Qn;
	always @(*) begin
		if (_sv2v_0)
			;
		state = Q;
	end
	initial _sv2v_0 = 0;
endmodule
