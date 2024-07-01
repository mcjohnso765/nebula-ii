module poly_ctrl (
	MHz10,
	nrst,
	en,
	ready,
	samp_enable,
	vol_done,
	start,
	acc,
	store_samp,
	clr,
	start_vol,
	osc_num
);
	reg _sv2v_0;
	parameter N = 13;
	input wire MHz10;
	input wire nrst;
	input wire en;
	input wire ready;
	input wire samp_enable;
	input wire vol_done;
	output reg start;
	output reg acc;
	output reg store_samp;
	output reg clr;
	output reg start_vol;
	output reg [5:0] osc_num;
	localparam START_DIV = 0;
	localparam DONE_DIV = 1;
	localparam WAIT_VOL = 2;
	localparam HOLD_SAMP = 3;
	reg [5:0] next_osc_num;
	reg [1:0] state;
	reg [1:0] next_state;
	always @(posedge MHz10 or negedge nrst)
		if (!nrst) begin
			osc_num <= 0;
			state <= START_DIV;
		end
		else if (en) begin
			osc_num <= next_osc_num;
			state <= next_state;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		next_osc_num = osc_num;
		next_state = state;
		start = 1'b0;
		acc = 1'b0;
		store_samp = 1'b0;
		clr = 1'b0;
		start_vol = 0;
		if (state == START_DIV) begin
			next_state = START_DIV;
			start_vol = 0;
			if (ready) begin
				next_state = DONE_DIV;
				start = 1'b1;
			end
		end
		else if (state == DONE_DIV) begin
			acc = 1'b1;
			next_osc_num = osc_num + 1;
			start_vol = 1;
			if (next_osc_num < N)
				next_state = START_DIV;
			else
				next_state = WAIT_VOL;
		end
		else if (state == WAIT_VOL) begin
			acc = 0;
			start_vol = 0;
			next_state = WAIT_VOL;
			if (vol_done) begin
				acc = 1;
				next_state = HOLD_SAMP;
			end
		end
		else if (state == HOLD_SAMP) begin
			next_state = HOLD_SAMP;
			start_vol = 0;
			if (samp_enable) begin
				store_samp = 1'b1;
				clr = 1'b1;
				next_osc_num = 0;
				next_state = START_DIV;
			end
		end
	end
	initial _sv2v_0 = 0;
endmodule
