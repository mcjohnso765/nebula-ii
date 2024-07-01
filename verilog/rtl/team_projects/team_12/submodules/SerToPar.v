module SerToPar (
	clk,
	nrst,
	serial,
	clear,
	parOut
);
	reg _sv2v_0;
	input wire clk;
	input wire nrst;
	input wire serial;
	input wire clear;
	output wire [7:0] parOut;
	localparam N = 8;
	reg [7:0] next_state;
	reg [7:0] current_state;
	always @(posedge clk or negedge nrst) begin : register
		if (~nrst)
			current_state <= 0;
		else if (clear)
			current_state <= 0;
		else
			current_state <= next_state;
	end
	always @(*) begin
		if (_sv2v_0)
			;
		next_state = {serial, current_state[7:1]};
	end
	assign parOut = current_state;
	initial _sv2v_0 = 0;
endmodule
