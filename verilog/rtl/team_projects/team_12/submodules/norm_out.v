module norm_out (
	MHz10,
	nrst,
	en,
	start,
	A_i,
	Q_i,
	M_i,
	count_nm,
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
	output reg [7:0] count_nm;
	output reg ready;
	localparam READY = 0;
	localparam DIVIDE = 1;
	reg [7:0] next_count_nm;
	reg state;
	reg next_state;
	reg [S + 7:0] A;
	reg [S + 7:0] next_A;
	reg [S + 7:0] Q;
	reg [S + 7:0] next_Q;
	reg [S + 7:0] M;
	reg [S + 7:0] next_M;
	reg [$clog2(S + 8) - 1:0] i;
	reg [$clog2(S + 8) - 1:0] next_i;
	always @(posedge MHz10 or negedge nrst)
		if (!nrst) begin
			count_nm <= 0;
			state <= READY;
			{A, Q, M, i} <= 0;
		end
		else begin
			count_nm <= next_count_nm;
			state <= next_state;
			{A, Q, M, i} <= {next_A, next_Q, next_M, next_i};
		end
	always @(*) begin
		if (_sv2v_0)
			;
		next_count_nm = count_nm;
		next_state = state;
		{next_A, next_Q, next_M, next_i} = {A, Q, M, i};
		ready = 1'b0;
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
					next_count_nm = next_Q[7:0];
					if (next_A[S + 7])
						next_A = next_A + M;
					next_state = READY;
				end
			end
		end
	end
	initial _sv2v_0 = 0;
endmodule
