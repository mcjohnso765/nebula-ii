`default_nettype none
module UART_Receiver (
	nRst,
	clk,
	enable,
	Rx,
	data_out,
	data_ready,
	working_data,
	bits_received,
	receiving,
	BAUD_counter,
	parity_error
);
	parameter BAUD_RATE = 9600;
	parameter CLOCK_FREQ = 10000000;
	parameter CYCLES_PER_BIT = CLOCK_FREQ / BAUD_RATE;
	input wire nRst;
	input wire clk;
	input wire enable;
	input wire Rx;
	output reg [7:0] data_out;
	output reg data_ready;
	output reg [8:0] working_data;
	output reg [3:0] bits_received;
	output reg receiving;
	output reg [31:0] BAUD_counter;
	output wire parity_error;
	reg BAUD_counter_state;
	always @(posedge clk or negedge nRst)
		if (~nRst)
			BAUD_counter <= 0;
		else if ((BAUD_counter_state == 1'b0) | (BAUD_counter == CYCLES_PER_BIT))
			BAUD_counter <= 0;
		else
			BAUD_counter <= BAUD_counter + 1;
	assign parity_error = 0;
	always @(posedge clk or negedge nRst)
		if (~nRst) begin
			data_out <= 8'b00000000;
			working_data <= 9'b000000000;
			receiving <= 1'b0;
			bits_received <= 4'b0000;
			data_ready <= 1'b0;
			BAUD_counter_state <= 1'b0;
		end
		else if (enable) begin
			if (receiving) begin
				BAUD_counter_state <= 1'b1;
				if (BAUD_counter == CYCLES_PER_BIT) begin
					if (bits_received == 4'd9) begin
						if (~parity_error) begin
							data_out <= working_data[8:1];
							working_data <= working_data;
							receiving <= 1'b0;
							bits_received <= 4'b0000;
							data_ready <= 1'b1;
							BAUD_counter_state <= 1'b0;
						end
						else begin
							data_out <= data_out;
							working_data <= 9'b000000000;
							receiving <= 1'b0;
							bits_received <= 4'b0000;
							data_ready <= 1'b0;
							BAUD_counter_state <= 1'b0;
						end
					end
					else begin
						data_out <= data_out;
						working_data <= {Rx, working_data[8:1]};
						receiving <= 1'b1;
						bits_received <= bits_received + 1;
						data_ready <= 1'b0;
						BAUD_counter_state <= 1'b1;
					end
				end
				else if ((BAUD_counter == (CYCLES_PER_BIT / 2)) & (bits_received == 0)) begin
					data_out <= data_out;
					working_data <= working_data;
					receiving <= 1'b1;
					bits_received <= bits_received + 1;
					data_ready <= 1'b0;
					BAUD_counter_state <= 1'b0;
				end
			end
			else if (Rx == 1'b0) begin
				data_out <= data_out;
				working_data <= 9'b000000000;
				receiving <= 1'b1;
				bits_received <= 4'b0000;
				data_ready <= 1'b0;
				BAUD_counter_state <= 1'b1;
			end
			else begin
				data_out <= data_out;
				working_data <= 9'b000000000;
				receiving <= 1'b0;
				bits_received <= 4'b0000;
				data_ready <= 1'b0;
				BAUD_counter_state <= 1'b0;
			end
		end
		else begin
			data_out <= 8'b00000000;
			working_data <= 9'b000000000;
			receiving <= 1'b0;
			bits_received <= 4'b0000;
			data_ready <= 1'b0;
			BAUD_counter_state <= 1'b0;
		end
endmodule
