`default_nettype none
module t06_update_controller (
	init_cycle,
	en_update,
	clk,
	nrst,
	cmd_finished,
	pause,
	cmd_done,
	wr,
	mode
);
	reg _sv2v_0;
	input wire init_cycle;
	input wire en_update;
	input wire clk;
	input wire nrst;
	input wire cmd_finished;
	input wire pause;
	output reg cmd_done;
	output reg wr;
	output wire [2:0] mode;
	reg [2:0] current;
	reg [2:0] next;
	always @(*) begin
		if (_sv2v_0)
			;
		wr = 1'b0;
		cmd_done = 1'b0;
		case (current)
			3'd0: next = (init_cycle ? 3'd1 : (en_update ? 3'd2 : 3'd0));
			3'd1: next = (pause ? 3'd1 : 3'd3);
			3'd2: next = (pause ? 3'd2 : 3'd4);
			3'd3: {next, wr} = {(cmd_finished ? 3'd5 : 3'd1), 1'b1};
			3'd4: {next, wr} = {(cmd_finished ? 3'd5 : 3'd2), 1'b1};
			3'd5: {next, cmd_done} = 4'h1;
			default: next = 3'd0;
		endcase
	end
	always @(posedge clk or negedge nrst)
		if (~nrst)
			current <= 3'd0;
		else
			current <= next;
	assign mode = current;
	initial _sv2v_0 = 0;
endmodule
