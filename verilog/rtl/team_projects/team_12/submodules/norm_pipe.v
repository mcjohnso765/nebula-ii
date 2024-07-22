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
	input wire MHz10;
	input wire nrst;
	input wire en;
	input wire start;
	input wire [19:0] count;
	input wire [19:0] max;
	output wire [7:0] count_nm;
	output wire ready;
	wire [S + 7:0] A0;
	wire [S + 7:0] A1;
	wire [S + 7:0] A2;
	wire [S + 7:0] A3;
	wire [S + 7:0] A4;
	wire [S + 7:0] A5;
	wire [S + 7:0] A6;
	wire [S + 7:0] Q0;
	wire [S + 7:0] Q1;
	wire [S + 7:0] Q2;
	wire [S + 7:0] Q3;
	wire [S + 7:0] Q4;
	wire [S + 7:0] Q5;
	wire [S + 7:0] Q6;
	wire [S + 7:0] M0;
	wire [S + 7:0] M1;
	wire [S + 7:0] M2;
	wire [S + 7:0] M3;
	wire [S + 7:0] M4;
	wire [S + 7:0] M5;
	wire [S + 7:0] M6;
	wire ready0;
	wire ready1;
	wire ready2;
	wire ready3;
	wire ready4;
	wire ready5;
	wire ready6;
	norm_in #(
		.S(S),
		.D(2)
	) n_0(
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
	norm_mid #(
		.S(S),
		.D(2)
	) n_1(
		.MHz10(MHz10),
		.nrst(nrst),
		.en(en),
		.start(ready0),
		.A_i(A0),
		.Q_i(Q0),
		.M_i(M0),
		.A_o(A1),
		.Q_o(Q1),
		.M_o(M1),
		.ready(ready1)
	);
	norm_mid #(
		.S(S),
		.D(2)
	) n_2(
		.MHz10(MHz10),
		.nrst(nrst),
		.en(en),
		.start(ready1),
		.A_i(A1),
		.Q_i(Q1),
		.M_i(M1),
		.A_o(A2),
		.Q_o(Q2),
		.M_o(M2),
		.ready(ready2)
	);
	norm_mid #(
		.S(S),
		.D(2)
	) n_3(
		.MHz10(MHz10),
		.nrst(nrst),
		.en(en),
		.start(ready2),
		.A_i(A2),
		.Q_i(Q2),
		.M_i(M2),
		.A_o(A3),
		.Q_o(Q3),
		.M_o(M3),
		.ready(ready3)
	);
	norm_mid #(
		.S(S),
		.D(2)
	) n_4(
		.MHz10(MHz10),
		.nrst(nrst),
		.en(en),
		.start(ready3),
		.A_i(A3),
		.Q_i(Q3),
		.M_i(M3),
		.A_o(A4),
		.Q_o(Q4),
		.M_o(M4),
		.ready(ready4)
	);
	norm_mid #(
		.S(S),
		.D(2)
	) n_5(
		.MHz10(MHz10),
		.nrst(nrst),
		.en(en),
		.start(ready4),
		.A_i(A4),
		.Q_i(Q4),
		.M_i(M4),
		.A_o(A5),
		.Q_o(Q5),
		.M_o(M5),
		.ready(ready5)
	);
	norm_mid #(
		.S(S),
		.D(2)
	) n_6(
		.MHz10(MHz10),
		.nrst(nrst),
		.en(en),
		.start(ready5),
		.A_i(A5),
		.Q_i(Q5),
		.M_i(M5),
		.A_o(A6),
		.Q_o(Q6),
		.M_o(M6),
		.ready(ready6)
	);
	norm_out #(
		.S(S),
		.D(2)
	) n_7(
		.MHz10(MHz10),
		.nrst(nrst),
		.en(en),
		.start(ready6),
		.A_i(A6),
		.Q_i(Q6),
		.M_i(M6),
		.count_nm(count_nm),
		.ready(ready)
	);
endmodule
