/*
    Module: rising_edge_detector
    Description: detect the rising edge of the signal
*/
`define SELECT 6'b000001
`define UP 6'b000010
`define RIGHT 6'b000100
`define DOWN 6'b001000
`define LEFT 6'b010000
`define BACK 6'b100000
`define NO_PRESS 6'b000000

module t07_rising_edge_detector
(
    input logic nrst,
    input logic clk,
    input logic in,
    output logic out
);
    logic inter;
    always_ff @(negedge nrst, posedge clk) begin
        if(!nrst) begin
            inter <= 0;
        end else begin
            inter <= in;
        end
    end

    assign out = in && ~inter;

endmodule