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
	output reg out;
	reg [1:0] delay;
	always @(posedge MHz10 or negedge nrst)
		if (!nrst)
			delay <= 2'b00;
		else if (en)
			delay <= {delay[0], in};
	always @(*) begin
		if (_sv2v_0)
			;
		out = delay[1];
	end
	initial _sv2v_0 = 0;
endmodule
