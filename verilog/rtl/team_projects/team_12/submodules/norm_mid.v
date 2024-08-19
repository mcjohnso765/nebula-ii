module norm_mid (
	MHz10,
	nrst,
	en,
	start,
	A_i,
	Q_i,
	M_i,
	A_o,
	Q_o,
	M_o,
	ready
);
	reg _sv2v_0;
	parameter S = 8;
	parameter D = 8;
	input wire MHz10;
	input wire nrst;
	input wire en;
	input wire start;
	input wire [S + 7:0] A_i;
	input wire [S + 7:0] Q_i;
	input wire [S + 7:0] M_i;
	output reg [S + 7:0] A_o;
	output reg [S + 7:0] Q_o;
	output reg [S + 7:0] M_o;
	output reg ready;
	localparam READY = 0;
	localparam DIVIDE = 1;
	reg state;
	reg next_state;
	reg [S + 7:0] A;
	reg [S + 7:0] next_A;
	reg [S + 7:0] Q;
	reg [S + 7:0] next_Q;
	reg [S + 7:0] M;
	reg [S + 7:0] next_M;
	reg [S + 7:0] next_A_o;
	reg [S + 7:0] next_Q_o;
	reg [S + 7:0] next_M_o;
	reg [$clog2(S + 8) - 1:0] i;
	reg [$clog2(S + 8) - 1:0] next_i;
	reg [4:0] start_index;
	always @(posedge MHz10 or negedge nrst)
		if (!nrst) begin
			{A_o, Q_o, M_o} <= 0;
			state <= READY;
			{A, Q, M, i} <= 0;
		end
		else begin
			{A_o, Q_o, M_o} <= {next_A_o, next_Q_o, next_M_o};
			state <= next_state;
			{A, Q, M, i} <= {next_A, next_Q, next_M, next_i};
		end
	always @(*) begin
		if (_sv2v_0)
			;
		{next_A_o, next_Q_o, next_M_o} = {A_o, Q_o, M_o};
		next_state = state;
		{next_A, next_Q, next_M, next_i} = {A, Q, M, i};
		ready = 0;
		start_index = 0;
		if (en) begin
			if (state == READY) begin
				ready = 1'b1;
				next_state = READY;
				if (start) begin
					next_A = A_i;
					next_Q = Q_i;
					next_M = M_i;
					next_i = D;
					next_state = DIVIDE;
				end
			end
			else if (state == DIVIDE) begin
				{next_A, next_Q} = {A[S + 6:0], Q, 1'b0};
				if (next_A[S + 7])
					next_A = next_A + M;
				else
					next_A = next_A - M;
				next_Q[0] = !next_A[S + 7];
				next_i = i - 1;
				if (next_i != 0)
					next_state = DIVIDE;
				else begin
					next_A_o = next_A;
					next_Q_o = next_Q;
					next_M_o = next_M;
					next_state = READY;
				end
			end
		end
	end
	initial _sv2v_0 = 0;
endmodule
