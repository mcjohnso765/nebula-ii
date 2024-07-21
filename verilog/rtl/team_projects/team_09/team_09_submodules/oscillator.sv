module oscillator
#(
    parameter N = 8
)
(
    input logic clk, nRst,
    input logic goodColl, badColl,
    output logic at_max
);
logic [23:0] timer, timer_nxt;
logic [7:0] freq, freq_nxt;
logic [N - 1:0] count, count_nxt;
logic [23:0] stayCount, stayCount_nxt;
logic at_max_nxt, keepCounting, keepCounting_nxt;

always_ff @(posedge clk, negedge nRst) begin
    if (~nRst) begin
        count <= 0;
        at_max <= 0;
        stayCount <= 0;
        keepCounting <= 0;
        freq <= 0;
        timer <= 0;
    end else begin
        count <= count_nxt;
        at_max <= at_max_nxt;
        stayCount <= stayCount_nxt;
        keepCounting <= keepCounting_nxt;
        freq <= freq_nxt;
        timer <= timer_nxt;
    end
end

always_comb begin
    at_max_nxt = at_max;
    count_nxt = count;
    keepCounting_nxt = keepCounting;
    stayCount_nxt = stayCount;
    timer_nxt = timer;
    freq_nxt = freq;
    // 12Mhz is for FPGA, 10Mhz is for final chip
    if (goodColl && ~keepCounting) begin
        freq_nxt = 8'd89; // 12M / 1/((1/440) / 256) - (SWITCH OUT TO 89 FOR FINAL)
        timer_nxt = 3000000;
    end
    if (badColl && ~keepCounting) begin
        freq_nxt = 8'd156; // 12M / 1/((1/250) / 256) - (SWITCH OUT TO 156 FOR FINAL)
        timer_nxt = 10000000;
    end

    if (at_max == 1'b1) begin
        at_max_nxt = 1'b0;
    end
    if (goodColl || badColl) begin
        keepCounting_nxt = 1'b1;
    end
    if (keepCounting_nxt) begin
        if (stayCount < timer_nxt) begin
            if (count < freq_nxt) begin
                count_nxt = count + 1;
            end else if (count >= freq_nxt) begin 
                at_max_nxt = 1'b1;
                count_nxt = 0;
            end
            stayCount_nxt = stayCount + 1;
        end else begin
            keepCounting_nxt = 1'b0;
            stayCount_nxt = 0;
        end
    end else if (~keepCounting_nxt) begin
        count_nxt = 0;
        at_max_nxt = 0;
    end
end

endmodule
