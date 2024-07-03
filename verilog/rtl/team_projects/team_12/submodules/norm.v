module norm (
	MHz10,
	nrst,
	en,
	start,
	count,
	max,
	count_nm,
	ready
);
	reg _sv2v_0;
	parameter S = 8;
	input wire MHz10;
	input wire nrst;
	input wire en;
	input wire start;
	input wire [19:0] count;
	input wire [19:0] max;
	output reg [7:0] count_nm;
	output reg ready;
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
	reg [4:0] start_index;
	reg [S - 1:0] new_count;
	reg [S - 1:0] new_max;
	always @(posedge MHz10 or negedge nrst)
		if (!nrst) begin
			count_nm <= 0;
			state <= 1'd0;
			A <= 0;
			Q <= 0;
			M <= 0;
			i <= 0;
		end
		else if (en) begin
			count_nm <= next_count_nm;
			state <= next_state;
			A <= next_A;
			Q <= next_Q;
			M <= next_M;
			i <= next_i;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		next_count_nm = count_nm;
		next_state = state;
		next_A = A;
		next_Q = Q;
		next_M = M;
		next_i = i;
		ready = 1'b0;
		start_index = 0;
		new_count = 0;
		new_max = 0;
		begin : sv2v_autoblock_1
			integer j;
			for (j = 0; j <= 19; j = j + 1)
				start_index = (max[j] == 1 ? j[4:0] : start_index);
		end
		start_index = (start_index < S ? S : start_index);
		new_count = count[start_index-:S];
		new_max = max[start_index-:S];
		if (state == 1'd0) begin
			ready = 1'b1;
			next_state = 1'd0;
			if (start) begin
				next_A = 0;
				next_Q = {new_count, 8'b00000000};
				next_M = {8'b00000000, new_max};
				next_i = S + 8;
				next_state = 1'd1;
			end
		end
		else if (state == 1'd1) begin
			{next_A, next_Q} = {A[S + 6:0], Q, 1'b0};
			if (next_A[S + 7])
				next_A = next_A + M;
			else
				next_A = next_A - M;
			next_Q[0] = !next_A[S + 7];
			next_i = i - 1;
			if (next_i != 0)
				next_state = 1'd1;
			else begin
				next_count_nm = next_Q[7:0];
				if (next_A[S + 7])
					next_A = next_A + M;
				next_state = 1'd0;
			end
		end
	end
	initial _sv2v_0 = 0;
endmodule
