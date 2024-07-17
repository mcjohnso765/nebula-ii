`default_nettype none
module t06_random_num_gen_wall_mode (
	enable,
	system_clk,
	nreset,
	number_out
);
	input wire enable;
	input wire system_clk;
	input wire nreset;
	output reg [7:0] number_out;
	reg [7:0] number;
	reg counter;
	reg counter_next;
	always @(posedge system_clk or negedge nreset)
		if (~nreset) begin
			number = 8'd2;
			counter_next = 0;
		end
		else begin
			number = {number[6:0], ~(number[6] ^ number[5])};
			counter_next = counter;
		end
	always @(posedge enable) begin
		counter <= counter_next;
		if (counter) begin
			number_out <= number;
			counter <= 0;
		end
		else begin
			number_out <= {number[3:0], number[7:4]};
			counter <= 1;
		end
	end
endmodule
