`default_nettype none
module t06_random_num_gen (
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
	reg counter_normal;
	reg counter_normal_next;
	reg counter_flip;
	reg counter_flip_next;
	always @(posedge system_clk or negedge nreset)
		if (~nreset) begin
			number = 8'd0;
			counter_next = 0;
			counter_flip_next = 0;
			counter_normal_next = 0;
		end
		else begin
			number = {number[6:0], ~(number[6] ^ number[5])};
			counter_next = counter;
			counter_flip_next = counter_flip;
			counter_normal_next = counter_normal;
		end
	always @(posedge enable) begin
		counter <= counter_next;
		counter_normal <= counter_normal_next;
		counter_flip <= counter_flip_next;
		if (counter) begin
			if (counter_normal) begin
				number_out <= number - 8'd1;
				counter <= 0;
				counter_normal <= 0;
				counter_flip <= counter_flip;
			end
			else begin
				number_out <= number;
				counter <= 0;
				counter_normal <= 1;
				counter_flip <= counter_flip;
			end
		end
		else if (counter_flip) begin
			number_out <= {number[3:0], number[7:4]} - 8'd1;
			counter <= 1;
			counter_normal <= counter_normal;
			counter_flip <= 0;
		end
		else begin
			number_out <= {number[3:0], number[7:4]};
			counter <= 1;
			counter_normal <= counter_normal;
			counter_flip <= 1;
		end
	end
endmodule
