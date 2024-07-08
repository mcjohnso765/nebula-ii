`include "source/spi.sv"
// MCP 4711 DAC Module - 10 bit data
// DAC parameters can be changed
module dac #(
    parameter BUF = 1'b1,           // 0: not buffered, 1: Vref buffered
    parameter GAIN = 1'b1,          // 0: gain = x2, 1: gain = x1
    parameter SHUTDOWN = 1'b1       // 0: DAC off, 1: DAC on
) (
    input clk,                   // system clock, ECP5 is set to 12 MHz
    input [9:0] dac_data,           // 10 bit data to send to the DAC
    input start_transmit,           // control signal to send the data to the DAC

    // SPI ports
    output dac_sclk,                // SPI clock
    output dac_cs,                  // SPI chip select
    output dac_mosi                 // SPI serial data output
);

    reg [15:0] data;
    wire transmit_complete;
    reg [15:0] data_received;
    wire miso;

    spi spi(.sysclk(clk), .data_transmit(data), .start_transmit(start_transmit), .transmit_complete(transmit_complete), .sclk(dac_sclk), .cs(dac_cs), .mosi(dac_mosi));
    // spi spi(slowClk, data, start_transmit, transmit_complete, data_received, miso, dac_sclk, dac_mosi, dac_cs);

    always @(clk) begin
        data <= {1'b0, BUF, GAIN, SHUTDOWN, dac_data, 2'b00};
    end

endmodule

