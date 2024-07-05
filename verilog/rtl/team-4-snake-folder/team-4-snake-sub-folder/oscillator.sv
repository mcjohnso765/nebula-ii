typedef enum logic {
    OFF = 1'b0,
    ON = 1'b1
} MODE_TYPES;

module oscillator
#(
    parameter N = 8
)
(
    input logic clk, nRst,
    input logic [7:0] freq,
    input MODE_TYPES state,
    input logic playSound,
    output logic at_max
);
logic [N - 1:0] count, count_nxt;
logic at_max_nxt;
always_ff @(posedge clk, negedge nRst) begin
    if (~nRst) begin
        count <= 0;
        at_max <= 0;
    end else begin
        count <= count_nxt;
        at_max <= at_max_nxt;
    end
end

always_comb begin
    at_max_nxt = at_max;
    count_nxt = count;
    if (at_max == 1'b1) begin
        at_max_nxt = 1'b0;
    end
    if (state == ON && playSound) begin
        if (count < freq) begin
            count_nxt = count + 1;
        end else if (count >= freq) begin 
            at_max_nxt = 1'b1;
            count_nxt = 0;
        end
    end else if (state == OFF || ~playSound) begin
        count_nxt = 0;
        at_max_nxt = 1'b0;
    end
end

endmodule
