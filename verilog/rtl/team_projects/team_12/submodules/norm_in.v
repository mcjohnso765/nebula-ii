module norm_in (
	MHz10,
	nrst,
	en,
	start,
	count,
	max,
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
	input wire [19:0] count;
	input wire [19:0] max;
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
	reg [S - 1:0] new_count;
	reg [S - 1:0] new_max;
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
		new_count = 0;
		new_max = 0;
		if (en) begin
			begin : sv2v_autoblock_1
				integer j;
				for (j = 0; j <= 19; j = j + 1)
					start_index = (max[j] == 1 ? j[4:0] : start_index);
			end
			start_index = (start_index < S ? S : start_index);
			new_count = count[start_index-:S];
			new_max = max[start_index-:S];
			if (state == READY) begin
				ready = 1'b1;
				next_state = READY;
				if (start) begin
					next_A = 0;
					next_Q = {new_count, 8'b00000000};
					next_M = {8'b00000000, new_max};
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
