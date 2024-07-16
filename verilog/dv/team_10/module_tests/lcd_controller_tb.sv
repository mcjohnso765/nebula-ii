`timescale 1ms / 100 us

module lcd_controller_tb();

localparam CLK_PERIOD = 10; // 100 Hz clk
logic tb_clk, tb_nRst, tb_lcd_en2, tb_lcd_rs2, tb_lcd_rw2;
logic [7:0] tb_lcd_data2;
logic [127:0] tb_host_row1, tb_host_row2;


always begin
    tb_clk = 1'b0; 
    #(CLK_PERIOD / 2.0);
    tb_clk = 1'b1; 
    #(CLK_PERIOD / 2.0); 
end
lcd_controller lcdHost (.clk(tb_clk), .rst(tb_nRst), .row_1(tb_host_row1), .row_2(tb_host_row2), .lcd_en(tb_lcd_en2), .lcd_rw(tb_lcd_rw2), .lcd_rs(tb_lcd_rs2), .lcd_data(tb_lcd_data2));

initial begin 
    // Signal dump
    $dumpfile("dump.vcd");
    $dumpvars;

    tb_nRst = 1'b1;
    tb_host_row1 = 128'd0;
    tb_host_row2 = 128'd0;
     // Wait some time before starting first test case
    #(0.1);

    // ***********************************
    // Test Case 0: Power-on-Reset 
    // ***********************************
    #(CLK_PERIOD * 20);
    @(negedge tb_clk);
    tb_nRst = 1'b0; 
    @(negedge tb_clk);
    @(negedge tb_clk);
    tb_nRst = 1'b1;
    #(CLK_PERIOD * 30);

    // ***********************************
    // Test Case 1: put random data 
    // ***********************************

    tb_host_row1 = {40'b0010000000100000001000000010000000100000,40'b0100100001100101011011000110110001101111, 48'b001000000010000000100000001000000010000000100000};
    tb_host_row2 = {40'b0010000000100000001000000010000000100000,40'b0100100001100101011011000110110001101111, 48'b001000000010000000100000001000000010000000100000};
    #(CLK_PERIOD * 30000000);

    $finish;
end
endmodule