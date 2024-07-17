module t07_timer_sec_divider (
input logic clk,
input logic nrst,
input logic clear, 
output logic s_strobe,
output logic s_strobe_fast, // half time
output logic s_strobe_faster // fourth time
);

// initialize Variables
logic [23:0] cnt;
logic [23:0] nxt_cnt;  //
logic [23:0] clk_div;  // count up to 12 million 
logic [23:0] clk_div_fast;  // count up to 6 million 
logic [23:0] clk_div_faster;  // count up to 3 million 


assign clk_div =        24'd12000000;
assign clk_div_fast =    24'd6000000;
assign clk_div_faster =  24'd3000000;


always_comb begin
    if (clear) begin
        nxt_cnt = 24'd0;
        s_strobe = '0;
        s_strobe_fast = '0;
        s_strobe_faster = '0;
    end else if (cnt == clk_div) begin
        s_strobe = 1;
        nxt_cnt = '0;
        s_strobe_fast = 1;
        s_strobe_faster = 1;
    end else if (cnt == clk_div_fast) begin
        s_strobe = 0;
        nxt_cnt = cnt + 1;
        s_strobe_fast = 1; 
        s_strobe_faster = 1;
    end else if (cnt == clk_div_faster) begin
        s_strobe = 0;
        nxt_cnt = cnt + 1;
        s_strobe_fast = 0; 
        s_strobe_faster = 1;
    end else if (cnt == 9000000) begin
        s_strobe = 0;
        nxt_cnt = cnt + 1;
        s_strobe_fast = 0; 
        s_strobe_faster = 1;
    end else begin
        s_strobe = 0;
        nxt_cnt = cnt + 1;
        s_strobe_fast = 0;
        s_strobe_faster = 0;
    end
end

always_ff@ (posedge clk, negedge nrst) begin
    if (!nrst) begin
        cnt <= 0;
    end else begin 
        cnt <= nxt_cnt;
    end    
end

endmodule
