module t07_timer_counter (
    input logic nrst,               // System negedge reset
    input logic clk,                // System clk
    input logic s_strobe,           // Secounds Strobe 1Hz
    input logic [2:0] max_min,      // depends on module, default is 5 min per game  
    input logic [2:0] max_sec_ten,  // 5, tenths place
    input logic [3:0] max_sec_one,  // 9, ones place depends on module, default is 0 second
    input logic clear,              // system clear
    output logic [2:0] cnt_min,     // Count in minute
    output logic [2:0] cnt_sec_ten, // Count in secounds tenth place
    output logic [3:0] cnt_sec_one // Count in secounds ones place
);

// initialize variables
logic [3:0] nxt_cnt_sec_one;    // next count value secound's ones place
logic [2:0] nxt_cnt_min;        // next count value minutes
logic [2:0] nxt_cnt_sec_ten;    // next count value secound's tenth place

always_comb begin
    if (clear) begin
        nxt_cnt_min = max_min;
        nxt_cnt_sec_ten = max_sec_ten;
        nxt_cnt_sec_one = max_sec_one;
    end else if (! s_strobe) begin
        nxt_cnt_sec_one = cnt_sec_one;
        nxt_cnt_sec_ten = cnt_sec_ten;
        nxt_cnt_min = cnt_min;
    end else if (cnt_sec_one != 0) begin
        nxt_cnt_sec_one = cnt_sec_one-1;
        nxt_cnt_sec_ten = cnt_sec_ten;
        nxt_cnt_min = cnt_min;
    end else if (cnt_sec_ten != 0) begin
        nxt_cnt_sec_one = 4'd9;
        nxt_cnt_sec_ten = cnt_sec_ten - 1;
        nxt_cnt_min = cnt_min;
    end else if (cnt_min != 0) begin
        nxt_cnt_sec_one = 4'd9;    // when at 0 sec, became 9 sec
        nxt_cnt_sec_ten = 3'd5;    // when at 0 sec, became 5 (for 50 sec)
        nxt_cnt_min = cnt_min - 1;
    end else begin
        nxt_cnt_sec_one = 0;
        nxt_cnt_sec_ten = 0;
        nxt_cnt_min = 0;
    end
end

// counter code
always_ff@ (posedge clk, negedge nrst) begin
    if (!nrst) begin
        cnt_sec_one <= 0;
        cnt_sec_ten <= 0;
        cnt_min <= 0;
    end else begin 
        cnt_sec_one <= nxt_cnt_sec_one;
        cnt_sec_ten <= nxt_cnt_sec_ten;
        cnt_min <= nxt_cnt_min;
    end    
end

endmodule