/*
module spi_controller(
    input logic [31:0] clkdiv,

    input [7:0] spi_data_out, 
    input logic data_out_ready,

    output [7:0] spi_data_in,
    output logic data_in_ready,

    input logic spi_enable,
    input [1:0] spi_mode,
    
    //SPI signals
    output logic sclk,
    input logic miso,
    output logic mosi,

    //CS will be taken care of by GPIO module(s)

    input logic clock,
    input logic reset
);

reg [31:0] counter;
reg div_clock;
reg [7:0] input_buffer;
reg [7:0] output_buffer;
reg [2:0] bit_counter;
reg output_bit;

always_ff @(posedge data_out_ready) begin
    output_buffer = spi_data_out;
end

always_ff @(posedge clock, posedge reset) begin
    if(reset) begin
        counter = 0;
        div_clock = 0;
        input_buffer = 0;
        output_buffer = 0;
    end
    else begin
        if(spi_enable) begin
            if(counter == clkdiv) begin
                counter = 0;
                div_clock = ~div_clock;
            end
            else
                counter = counter + 1;
        end
    end
end

always_ff @(posedge div_clock) begin
    if(~(spi_mode[1] ^ spi_mode[0])) begin //data sampled at the rising edge
        input_buffer = {input_buffer[6:0],miso};
    end
    else begin //data shifted out at the rising edge
        output_bit = output_buffer[7];
        mosi = output_bit;
        output_buffer = {output_buffer[6:0],1'b0};
    end
end

always_ff @(negedge div_clock) begin
    if(spi_mode[1] ^ spi_mode[0]) begin //data sampled at the falling edge
        input_buffer = {input_buffer[6:0],miso};
    end
    else begin //data shifted out at the falling edge
        output_bit = output_buffer[7];
        mosi = output_bit;
        output_buffer = {output_buffer[6:0],1'b0};
    end

    counter = counter + 1;
    if(counter[2] & counter [1] & counter[0]) begin
        data_in_ready = 1;
    end
end

endmodule
*/