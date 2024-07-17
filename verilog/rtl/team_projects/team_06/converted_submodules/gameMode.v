`default_nettype none
module t06_gameMode (
	button,
	nrst,
	system_clk,
	state,
	mode
);
	reg _sv2v_0;
	input wire button;
	input wire nrst;
	input wire system_clk;
	input wire [1:0] state;
	output reg [1:0] mode;
	reg [1:0] Qa;
	reg [1:0] Qn;
	always @(*) begin
		if (_sv2v_0)
			;
		case (Qa)
			2'b01: Qn = 2'b00;
			2'b00: Qn = 2'b10;
			2'b10: Qn = 2'b11;
			2'b11: Qn = 2'b01;
			default: Qn = 2'b01;
		endcase
	end
	always @(negedge nrst or posedge system_clk)
		if (~nrst)
			Qa <= 2'b01;
		else if (button) begin
			if (state == 2'b01)
				Qa <= Qn;
			else
				Qa <= Qa;
		end
		else
			Qa <= Qa;
	always @(*) begin
		if (_sv2v_0)
			;
		mode = Qa;
	end
	initial _sv2v_0 = 0;
endmodule
