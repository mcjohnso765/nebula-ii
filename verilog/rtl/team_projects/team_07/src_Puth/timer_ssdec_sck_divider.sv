/*
    Module: timer_ssdec_sck_divider
    Description:
        divide the internal clock 12 MHz to 200kHz for ssdec SPI
*/
module t07_timer_ssdec_sck_divider(
    input logic clk,
    input logic nrst,
    input logic clear, 
    output logic sck_rs_enable,     // sck rising edge enable
    output logic sck_fl_enable      // sck falling edge enable
);
    // initialize Variables
    logic [6:0] nxt_cnt;     // nxt_count up logic
    logic [6:0] clk_div;     // count up to 48 
    logic [6:0] cnt;         // count up to 48, 48 periods of 12 MHz clk is 1 period of 200KHz   (have it 18 bits?????????)
    logic nxt_sck_rs_enable; // next logic for the sck clock rising edge send as enable
    logic nxt_sck_fl_enable; // next logic for the sck clock falling edge send as enable

    assign clk_div = 7'd59;

    always_ff @(posedge clk, negedge nrst) begin
        if (!nrst) begin
            cnt <= 0;
            sck_rs_enable <= 0;
            sck_fl_enable <= 0;
        end else begin 
            cnt <= nxt_cnt;
            sck_rs_enable <= nxt_sck_rs_enable;
            sck_fl_enable <= nxt_sck_fl_enable;
        end    
    end

    always_comb begin
        nxt_cnt = cnt;
        // gotta intialize some stuff to not have the error
        if (clear) begin
            nxt_cnt = 7'd0;
            nxt_sck_rs_enable = 0;
            nxt_sck_fl_enable = 0;
        end else if (cnt == clk_div) begin
            nxt_cnt = '0;
            nxt_sck_rs_enable = 1;
            nxt_sck_fl_enable = 0;
        end else if (cnt == 7'd29) begin        // half a 60 cycle
            nxt_cnt = cnt + 1;
            nxt_sck_rs_enable = 0;
            nxt_sck_fl_enable = 1;
        end else begin
            nxt_cnt = cnt + 1;
            nxt_sck_rs_enable = 0;
            nxt_sck_fl_enable = 0;
        end
    end

endmodule