module poly_ctrl (
	MHz10,
	nrst,
	en,
	ready,
	samp_enable,
	start,
	acc,
	store_samp,
	clr,
	osc_num
);
	reg _sv2v_0;
	parameter N = 13;
	input wire MHz10;
	input wire nrst;
	input wire en;
	input wire ready;
	input wire samp_enable;
	output reg start;
	output reg acc;
	output reg store_samp;
	output reg clr;
	output reg [6:0] osc_num;
	localparam START_DIV = 0;
	localparam DONE_DIV = 1;
	localparam HOLD_SAMP = 4;
	reg [6:0] next_osc_num;
	reg [2:0] state;
	reg [2:0] next_state;
	reg [23:0] acc_delay;
	reg [23:0] next_acc;
	always @(posedge MHz10 or negedge nrst)
		if (!nrst) begin
			osc_num <= 0;
			state <= START_DIV;
			acc_delay <= 0;
		end
		else if (en) begin
			osc_num <= next_osc_num;
			state <= next_state;
			acc_delay <= next_acc;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		acc = acc_delay[23];
		next_osc_num = osc_num;
		next_state = state;
		start = 1'b0;
		store_samp = 1'b0;
		clr = 1'b0;
		next_acc = 0;
		if (en) begin
			if (state == START_DIV) begin
				next_acc = {acc_delay[22:0], 1'b0};
				next_state = START_DIV;
				if (ready) begin
					next_state = DONE_DIV;
					start = 1'b1;
				end
			end
			else if (state == DONE_DIV) begin
				next_acc = {acc_delay[22:0], 1'b1};
				next_osc_num = osc_num + 1;
				if (next_osc_num < N)
					next_state = START_DIV;
				else
					next_state = HOLD_SAMP;
			end
			else if (state == HOLD_SAMP) begin
				next_acc = {acc_delay[22:0], 1'b0};
				next_state = HOLD_SAMP;
				if (samp_enable) begin
					store_samp = 1'b1;
					clr = 1'b1;
					next_osc_num = 0;
					next_state = START_DIV;
				end
			end
		end
	end
	initial _sv2v_0 = 0;
endmodule
