`default_nettype none
module t06_fsm_control (
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
	t06_synchronizer button5(
		.button(mode_pb),
		.clk(clk),
		.nrst(nrst),
		.signal(sync)
	);
	t06_edge_detect detect4(
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
			2'd0: begin
				next = (cmd_done ? 2'd1 : 2'd0);
				init_cycle = ~cmd_done;
			end
			2'd1: begin
				enable_loop = ~(diff | GameOver);
				next = (diff ? 2'd2 : (GameOver ? 2'd3 : 2'd1));
			end
			2'd2: begin
				en_update = ~(cmd_done | GameOver);
				next = (cmd_done ? 2'd1 : (GameOver ? 2'd3 : 2'd2));
			end
			2'd3: begin
				next = (detect ? 2'd0 : 2'd3);
				sync_reset = ~detect;
			end
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
