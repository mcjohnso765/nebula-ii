module posedge_detector (
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
	reg Q1;
	reg Q2;
	always @(posedge MHz10 or negedge nrst)
		if (!nrst)
			Q1 <= 1;
		else if (en)
			Q1 <= in;
	always @(posedge MHz10 or negedge nrst)
		if (!nrst)
			Q2 <= 1;
		else if (en)
			Q2 <= Q1;
	always @(*) begin
		if (_sv2v_0)
			;
		if (Q1 && !Q2)
			out = 1;
		else
			out = 0;
	end
	initial _sv2v_0 = 0;
endmodule
