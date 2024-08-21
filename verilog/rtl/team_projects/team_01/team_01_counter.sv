module t01_counter
#(
    parameter N = 17 // Size of counter (i.e. number of bits at the output). Maximum count is 2^N - 1
)
(
    input logic clk,            // Clock
    input logic nrst,           // Asyncronous active low reset
    input logic enable,         // Enable
    input logic clear,          // Synchronous active high clear 
    input logic wrap,           // 0: no wrap at max, 1: wrap to 0 at max
    input logic [N - 1:0] max,      // Max number of count (inclusive)
    output logic [N - 1:0] count,   // Current count
    output logic at_max         // 1 when counter is at max, otherwise 0
);

    // Write your code here!
    logic next_atmax;
    logic [N - 1:0]next_count;
    always_ff @(negedge nrst, posedge clk) begin
        if(~nrst) begin
        at_max <= 0;
        count <= 0;
        end
        else begin
        at_max <= next_atmax;
        count <= next_count; 
        end
    end

    always_comb begin
        if(clear) begin
        next_count = 0;
        next_atmax = 1'b0; end
        else begin
        next_atmax = 1'b0;
        if(enable)
            next_count = count + 1;
        else
            next_count = count; end
        if(count == max) begin
        next_atmax = 1'b0;
        if(wrap)
            next_count = 0;
        else
            next_count = count; end 
        if(next_count == max)
        next_atmax = 1'b1;
    end

endmodule
