// $Id: $
// File name:   flex_counter.sv
// Created:     5/23/2024
// Author:      Miguel Isrrael Teran
// Description: Flexible counter

module flex_counter # (
    parameter NUM_CNT_BITS = 4
)
(
    input logic clk, nrst,
    input logic count_enable, clear,
    input logic [NUM_CNT_BITS-1:0] rollover_val,
    output logic [NUM_CNT_BITS-1:0] count_out,
    output logic rollover_flag
);
    // Internal signals
    logic [NUM_CNT_BITS-1:0] next_count;  // next count
    logic next_flag;  // next rollover flag

    // Count and Flag Registers
    always_ff @(posedge clk, negedge nrst) begin
        if (~nrst) begin
            count_out <= '0;
            rollover_flag <= 1'b0;
        end else begin
            count_out <= next_count;
            rollover_flag <= next_flag;
        end
    end

    // Next Count & Next Flag Logic
    always_comb begin
        // Next count logic
        next_count = count_out;
        if (clear)
            next_count = '0;
        else if (count_enable) begin
            if (rollover_val == '0)
                next_count = 0;
            else if (count_out < rollover_val)
                next_count = count_out + 1;
            else if (count_out == rollover_val)
                next_count = 1;  // counter rolls over back to 1
        end

        // Next flag logic
        if (next_count == rollover_val && rollover_val != '0)  // flag should be low when rollover_val is 0
            next_flag = 1'b1;
        else
            next_flag = 1'b0;
    end

endmodule