module t09_fsm_control (
	GameOver,
	cmd_done,
	diff,
	clk,
	nrst,
	mode_pb,
	enable_loop,
	init_cycle,
	en_update,
	sync_reset
);
	reg _sv2v_0;
	input wire GameOver;
	input wire cmd_done;
	input wire diff;
	input wire clk;
	input wire nrst;
	input wire mode_pb;
	output reg enable_loop;
	output reg init_cycle;
	output reg en_update;
	output reg sync_reset;
	reg [1:0] current;
	reg [1:0] next;
	wire sync;
	wire detect;
	t09_synchronizer button5(
		.button(mode_pb),
		.clk(clk),
		.nrst(nrst),
		.signal(sync)
	);
	t09_edge_detect detect4(
		.signal(sync),
		.clk(clk),
		.nrst(nrst),
		.change_state(detect)
	);
	always @(posedge clk or negedge nrst)
		if (~nrst)
			current <= 2'd0;
		else
			current <= next;
	always @(*) begin
		if (_sv2v_0)
			;
		init_cycle = 1'b0;
		en_update = 1'b0;
		enable_loop = 1'b0;
		sync_reset = 1'b0;
		case (current)
			2'd0:
				if (cmd_done) begin
					next = 2'd1;
					init_cycle = 1'b0;
				end
				else begin
					next = 2'd0;
					init_cycle = 1'b1;
				end
			2'd1:
				if (diff) begin
					next = 2'd2;
					enable_loop = 1'b0;
				end
				else if (GameOver) begin
					next = 2'd3;
					enable_loop = 1'b0;
				end
				else begin
					next = 2'd1;
					enable_loop = 1'b1;
				end
			2'd2:
				if (cmd_done) begin
					next = 2'd1;
					en_update = 1'b0;
				end
				else if (GameOver) begin
					next = 2'd3;
					en_update = 1'b0;
				end
				else begin
					next = 2'd2;
					en_update = 1'b1;
				end
			2'd3: begin
				if (detect) begin
					next = 2'd0;
					sync_reset = 1'b0;
				end
				else
					next = 2'd3;
				sync_reset = 1'b1;
			end
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
