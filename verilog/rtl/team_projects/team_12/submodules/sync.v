`default_nettype none
module sync (
	MHz10,
	nrst,
	en,
	in,
	out
);
	reg _sv2v_0;
	input wire MHz10;
	input wire nrst;
	input wire en;
	input wire in;
	output wire out;
	reg [1:0] delay;
	reg [1:0] next_delay;
	always @(posedge MHz10 or negedge nrst)
		if (!nrst)
			delay <= 2'b00;
		else if (en)
			delay <= next_delay;
	assign out = delay[1];
	always @(*) begin
		if (_sv2v_0)
			;
		next_delay = delay;
		if (en)
			next_delay = {delay[0], in};
	end
	initial _sv2v_0 = 0;
endmodule
