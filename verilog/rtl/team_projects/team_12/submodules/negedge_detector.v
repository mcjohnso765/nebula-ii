module negedge_detector (
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
	reg Q1;
	reg Q2;
	reg next_in;
	always @(posedge MHz10 or negedge nrst)
		if (!nrst) begin
			Q1 <= 0;
			Q2 <= 0;
		end
		else begin
			Q1 <= next_in;
			Q2 <= Q1;
		end
	assign out = !Q1 && Q2;
	always @(*) begin
		if (_sv2v_0)
			;
		next_in = Q1;
		if (en)
			next_in = in;
	end
	initial _sv2v_0 = 0;
endmodule
