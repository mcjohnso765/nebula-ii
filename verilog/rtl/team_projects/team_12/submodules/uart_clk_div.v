`default_nettype none
module uart_clk_div (
	MHz10,
	nrst,
	en,
	enable,
	clear,
	at_max
);
	reg _sv2v_0;
	input wire MHz10;
	input wire nrst;
	input wire en;
	input wire enable;
	input wire clear;
	output reg at_max;
	reg [8:0] count;
	reg [8:0] next_count;
	wire [8:0] max;
	assign max = 319;
	always @(posedge MHz10 or negedge nrst)
		if (~nrst)
			count <= 0;
		else
			count <= next_count;
	always @(*) begin
		if (_sv2v_0)
			;
		at_max = 0;
		next_count = count;
		if (en) begin
			if (clear)
				next_count = 0;
			else if (enable) begin
				next_count = count + 1;
				if (count >= max) begin
					next_count = 0;
					at_max = 1;
				end
			end
		end
	end
	initial _sv2v_0 = 0;
endmodule
