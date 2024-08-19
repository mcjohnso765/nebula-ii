`default_nettype none
module t09_update_controller (
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
	wire [8:0] count;
	reg [8:0] next_count;
	always @(posedge clk or negedge nrst)
		if (~nrst)
			current <= 3'd0;
		else
			current <= next;
	always @(*) begin
		if (_sv2v_0)
			;
		wr = 1'b0;
		next_count = count;
		cmd_done = 1'b0;
		case (current)
			3'd0:
				if (init_cycle)
					next = 3'd1;
				else if (en_update)
					next = 3'd2;
				else
					next = 3'd0;
			3'd1:
				if (pause)
					next = 3'd1;
				else
					next = 3'd3;
			3'd2:
				if (pause)
					next = 3'd2;
				else
					next = 3'd4;
			3'd3: begin
				wr = 1'b1;
				if (cmd_finished)
					next = 3'd5;
				else
					next = 3'd1;
			end
			3'd4: begin
				wr = 1'b1;
				if (cmd_finished)
					next = 3'd5;
				else
					next = 3'd2;
			end
			3'd5: begin
				next = 3'd0;
				cmd_done = 1'b1;
			end
			default: next = 3'd0;
		endcase
	end
	assign mode = current;
	initial _sv2v_0 = 0;
endmodule
