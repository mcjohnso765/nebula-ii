`default_nettype none
module t09_variable_clock_divider (
	clk,
	nrst,
	button,
	adjusted_clk
);
	reg _sv2v_0;
	input wire clk;
	input wire nrst;
	input wire button;
	output wire adjusted_clk;
	wire button_a;
	wire signal;
	reg pulse;
	wire [1:0] mode;
	reg [22:0] count;
	reg [22:0] next_count;
	reg [22:0] MAX_COUNT;
	t09_synchronizer synch(
		.button(button),
		.clk(clk),
		.nrst(nrst),
		.signal(signal)
	);
	t09_edge_detect detect(
		.signal(signal),
		.clk(clk),
		.nrst(nrst),
		.change_state(button_a)
	);
	t09_fsm_mode fsm(
		.signal(button_a),
		.clk(clk),
		.nrst(nrst),
		.mode(mode)
	);
	always @(posedge clk or negedge nrst)
		if (~nrst)
			count <= 0;
		else
			count <= next_count;
	always @(*) begin
		if (_sv2v_0)
			;
		case (mode)
			2'd2: MAX_COUNT = 750000;
			2'd1: MAX_COUNT = 1500000;
			2'd0: MAX_COUNT = 2000000;
			default: MAX_COUNT = 2000000;
		endcase
		if (count >= (MAX_COUNT - 1)) begin
			pulse = 1;
			next_count = 0;
		end
		else begin
			pulse = 0;
			next_count = count + 23'b00000000000000000000001;
		end
	end
	assign adjusted_clk = pulse;
	initial _sv2v_0 = 0;
endmodule
