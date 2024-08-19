module t03_IO_mod (
	clk,
	rst,
	write_mem,
	read_mem,
	data_from_mem,
	data_address,
	data_to_write,
	data_read,
	IO_out,
	IO_pwm_freq,
	IO_pwm_duty,
	IO_in,
	spi_input,
	spi_clkdiv_out,
	spi_output
);
	reg _sv2v_0;
	input wire clk;
	input wire rst;
	input wire write_mem;
	input wire read_mem;
	input wire [31:0] data_from_mem;
	input wire [31:0] data_address;
	input wire [31:0] data_to_write;
	output reg [31:0] data_read;
	output wire [31:0] IO_out;
	output wire [31:0] IO_pwm_freq;
	output wire [31:0] IO_pwm_duty;
	input wire [31:0] IO_in;
	input wire [31:0] spi_input;
	output wire [31:0] spi_clkdiv_out;
	output wire [31:0] spi_output;
	reg [31:0] output_reg;
	reg [31:0] input_reg;
	reg [31:0] pwm_freq;
	reg [31:0] pwm_duty;
	reg [31:0] spi_out;
	reg [31:0] spi_in;
	reg [31:0] spi_clkdiv;
	reg [31:0] next_output_reg;
	reg [31:0] next_input_reg;
	reg [31:0] next_pwm_freq;
	reg [31:0] next_pwm_duty;
	reg [31:0] next_spi_out;
	reg [31:0] next_spi_in;
	reg [31:0] next_spi_clkdiv;
	always @(*) begin
		if (_sv2v_0)
			;
		next_output_reg = output_reg;
		next_input_reg = IO_in;
		next_pwm_freq = pwm_freq;
		next_pwm_duty = pwm_duty;
		next_spi_out = spi_out;
		next_spi_in = spi_in;
		next_spi_clkdiv = spi_clkdiv;
		if (write_mem)
			case (data_address)
				32'h31fffffb: begin
					next_output_reg = data_to_write;
					data_read = data_from_mem;
				end
				32'h31fffffa: begin
					next_pwm_duty = data_to_write;
					data_read = data_from_mem;
				end
				32'h31fffff9: begin
					next_pwm_freq = data_to_write;
					data_read = data_from_mem;
				end
				32'h31ffffff: begin
					next_spi_out = data_to_write;
					data_read = data_from_mem;
				end
				32'h31fffffe: begin
					next_spi_clkdiv = data_to_write;
					data_read = data_from_mem;
				end
				default: begin
					next_output_reg = output_reg;
					next_pwm_duty = pwm_duty;
					next_pwm_freq = pwm_freq;
					next_spi_in = spi_in;
					next_spi_clkdiv = spi_clkdiv;
					data_read = data_from_mem;
				end
			endcase
		else if (read_mem)
			case (data_address)
				32'h31fffffc: data_read = input_reg;
				32'h31fffffd: data_read = spi_input;
				default: begin
					data_read = data_from_mem;
					next_input_reg = IO_in;
				end
			endcase
		else begin
			next_output_reg = output_reg;
			next_input_reg = IO_in;
			next_pwm_duty = pwm_duty;
			next_pwm_freq = pwm_freq;
			next_spi_out = spi_out;
			next_spi_in = spi_in;
			next_spi_clkdiv = spi_clkdiv;
			data_read = data_from_mem;
		end
	end
	assign IO_out = output_reg;
	assign IO_pwm_duty = pwm_duty;
	assign IO_pwm_freq = pwm_freq;
	assign spi_clkdiv_out = spi_clkdiv;
	assign spi_output = spi_out;
	always @(posedge clk or posedge rst)
		if (rst) begin
			output_reg <= 0;
			input_reg <= 0;
			pwm_freq <= 0;
			pwm_duty <= 0;
			spi_out <= 0;
			spi_in <= 0;
			spi_clkdiv <= 0;
		end
		else begin
			output_reg <= next_output_reg;
			input_reg <= next_input_reg;
			pwm_freq <= next_pwm_freq;
			pwm_duty <= next_pwm_duty;
			spi_out <= next_spi_out;
			spi_in <= next_spi_in;
			spi_clkdiv <= next_spi_clkdiv;
		end
	initial _sv2v_0 = 0;
endmodule
