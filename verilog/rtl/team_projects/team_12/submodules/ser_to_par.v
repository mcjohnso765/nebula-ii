`default_nettype none
module ser_to_par (
	MHz10,
	nrst,
	en,
	enable,
	clear,
	serial,
	parOut
);
	reg _sv2v_0;
	input wire MHz10;
	input wire nrst;
	input wire en;
	input wire enable;
	input wire clear;
	input wire serial;
	output wire [7:0] parOut;
	localparam N = 8;
	reg [7:0] next_state;
	reg [7:0] current_state;
	always @(posedge MHz10 or negedge nrst) begin : register
		if (~nrst)
			current_state <= 0;
		else if (clear)
			current_state <= 0;
		else
			current_state <= next_state;
	end
	always @(*) begin
		if (_sv2v_0)
			;
		next_state = current_state;
		if (en) begin
			if (enable)
				next_state = {serial, current_state[7:1]};
		end
	end
	assign parOut = current_state;
	initial _sv2v_0 = 0;
endmodule
