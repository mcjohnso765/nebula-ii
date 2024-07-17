`default_nettype none
module t06_clock (
	system_clk,
	nreset,
	game_state,
	game_speed,
	clk,
	clk_main_display,
	clk_body
);
	reg _sv2v_0;
	input wire system_clk;
	input wire nreset;
	input wire [1:0] game_state;
	input wire [1:0] game_speed;
	output reg clk;
	output wire clk_main_display;
	output reg clk_body;
	reg next_clk;
	reg next_body_clk;
	reg [21:0] counter;
	reg [21:0] next_counter;
	reg [21:0] max_count;
	always @(posedge system_clk or negedge nreset)
		if (~nreset)
			clk <= 0;
		else if (game_state != 2'b00)
			clk <= 0;
		else
			clk <= next_clk;
	always @(posedge system_clk or negedge nreset)
		if (~nreset) begin
			clk_body <= 0;
			counter <= 0;
		end
		else begin
			clk_body <= next_body_clk;
			counter <= next_counter;
		end
	assign clk_main_display = system_clk;
	always @(*) begin
		if (_sv2v_0)
			;
		case (game_speed)
			2'b00: max_count = 2500000;
			2'b01: max_count = 2000000;
			2'b10: max_count = 3000000;
			default: max_count = 2500000;
		endcase
		if ((game_state == 2'b01) || (game_state == 2'b10)) begin
			next_counter = 0;
			next_body_clk = 0;
		end
		else if (counter != max_count) begin
			next_counter = counter + 22'd1;
			next_body_clk = 0;
		end
		else begin
			next_counter = 0;
			next_body_clk = 1;
		end
	end
	always @(*) begin
		if (_sv2v_0)
			;
		if ((game_state == 2'b01) || (game_state == 2'b10))
			next_clk = 0;
		else
			next_clk = 1;
	end
	initial _sv2v_0 = 0;
endmodule
