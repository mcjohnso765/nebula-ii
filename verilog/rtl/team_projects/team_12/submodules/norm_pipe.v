module norm_pipe (
	MHz10,
	nrst,
	en,
	start,
	count,
	max,
	count_nm,
	ready
);
	parameter S = 8;
	parameter D = 8;
	input wire MHz10;
	input wire nrst;
	input wire en;
	input wire start;
	input wire [19:0] count;
	input wire [19:0] max;
	output wire [7:0] count_nm;
	output wire ready;
	wire [S + 7:0] A0;
	wire [S + 7:0] Q0;
	wire [S + 7:0] M0;
	wire ready0;
	norm_in #(
		.S(S),
		.D(D)
	) norm0(
		.MHz10(MHz10),
		.nrst(nrst),
		.en(en),
		.start(start),
		.count(count),
		.max(max),
		.A_o(A0),
		.Q_o(Q0),
		.M_o(M0),
		.ready(ready0)
	);
	norm_out #(
		.S(S),
		.D(D)
	) norm1(
		.MHz10(MHz10),
		.nrst(nrst),
		.en(en),
		.start(ready0),
		.A_i(A0),
		.Q_i(Q0),
		.M_i(M0),
		.count_nm(count_nm),
		.ready(ready)
	);
endmodule
