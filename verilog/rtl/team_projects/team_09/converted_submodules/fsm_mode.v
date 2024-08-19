module t09_fsm_mode (
	signal,
	clk,
	nrst,
	mode
);
	reg _sv2v_0;
	input wire signal;
	input wire clk;
	input wire nrst;
	output wire [1:0] mode;
	reg [1:0] current_mode;
	reg [1:0] next_mode;
	always @(posedge clk or negedge nrst)
		if (~nrst)
			current_mode <= 2'd1;
		else
			current_mode <= next_mode;
	always @(*) begin
		if (_sv2v_0)
			;
		if (signal) begin
			if (current_mode == 2'd1)
				next_mode = 2'd2;
			else if (current_mode == 2'd2)
				next_mode = 2'd0;
			else if (current_mode == 2'd0)
				next_mode = 2'd1;
			else
				next_mode = 2'd1;
		end
		else
			next_mode = current_mode;
	end
	assign mode = current_mode;
	initial _sv2v_0 = 0;
endmodule
