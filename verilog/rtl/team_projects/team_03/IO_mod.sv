module t03_IO_mod(
     input logic clk, rst,
    input logic write_mem, read_mem,
    input logic [31:0] data_from_mem,
    input logic [31:0] data_address, data_to_write,
    output logic [31:0] data_read,
    output logic [31:0] IO_out, IO_pwm_freq, IO_pwm_duty,
    input logic [31:0] IO_in,
    input logic [31:0] spi_input,
    output logic [31:0] spi_clkdiv_out,
    output logic [31:0] spi_output
);
 logic [31:0] output_reg, input_reg, pwm_freq, pwm_duty, spi_out, spi_in, spi_clkdiv;
 logic [31:0] next_output_reg, next_input_reg, next_pwm_freq, next_pwm_duty, next_spi_out, next_spi_in, next_spi_clkdiv;


 always_comb begin

    

    next_output_reg = output_reg;
    next_input_reg = IO_in;
    next_pwm_freq = pwm_freq;
    next_pwm_duty = pwm_duty;
    next_spi_out = spi_out;
    next_spi_in = spi_in;
    next_spi_clkdiv = spi_clkdiv;

    if (write_mem) begin
        case(data_address)
            32'h31FFFFFB: begin //GPIO output register
                next_output_reg = data_to_write; 
                data_read = data_from_mem;    
            end
            32'h31FFFFFA: begin //PWM duty register
                next_pwm_duty = data_to_write;
                data_read = data_from_mem;
            end
            32'h31FFFFF9: begin //PWM freq register
                next_pwm_freq = data_to_write;
                data_read = data_from_mem;
            end
            32'h31FFFFFF: begin //SPI output register
                next_spi_out = data_to_write;
                data_read = data_from_mem;
            end
            32'h31FFFFFE: begin //SPI clock divider register
                next_spi_clkdiv = data_to_write;
                data_read = data_from_mem;
            end
            default: begin //Other addresses
                next_output_reg = output_reg;
                next_pwm_duty = pwm_duty;
                next_pwm_freq = pwm_freq;
                next_spi_in = spi_in;
                next_spi_clkdiv = spi_clkdiv;
                data_read = data_from_mem;
            end
        endcase
    end

    else if(read_mem) begin
        case(data_address)
            32'h31FFFFFC: begin //GPIO input register(?)
                data_read = input_reg;
            end
            32'h31FFFFFD: begin //SPI input register
                data_read = spi_input;
            end
            default: begin
                data_read = data_from_mem;
                next_input_reg = IO_in;
            end
        endcase
    end

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

always_ff @(posedge clk, posedge rst) begin
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

end

endmodule