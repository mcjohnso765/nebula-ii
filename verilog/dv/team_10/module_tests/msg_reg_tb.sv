/* Message Register File
Descriuption: x
*/

`timescale 1ms / 100 us



module msg_reg_tb ();

// Testbench ports
localparam CLK_PERIOD = 10; // 100 Hz clk
logic tb_clk, tb_nRst, tb_ready, tb_transmit_ready;
logic [7:0] tb_data;
logic tb_blue, tb_tx_ctrl;
logic [7:0] tb_tx_byte;

// Clock generation block
always begin
    tb_clk = 1'b0; 
    #(CLK_PERIOD / 2.0);
    tb_clk = 1'b1; 
    #(CLK_PERIOD / 2.0); 
end

// Portmap 
msg_reg messsagetest(.clk(tb_clk), .nRst(tb_nRst), .ready(tb_ready), .transmit_ready(tb_transmit_ready), .data(tb_data), .blue(tb_blue), .tx_ctrl(tb_tx_ctrl), .tx_byte(tb_tx_byte));

initial begin 
    // Signal dump
    $dumpfile("dump.vcd");
    $dumpvars; 

    // Initialize test bench signals
    tb_nRst = 1'b1;
    tb_data = 8'd5;
    tb_ready = 0;
    tb_transmit_ready = 0;

    // Wait some time before starting first test case
    #(0.1);


    // ***********************************
    // Test Case 0: Power-on-Reset 
    // ***********************************
    #(CLK_PERIOD * 2);
    @(negedge tb_clk);
    tb_nRst = 1'b0; 
    @(negedge tb_clk);
    @(negedge tb_clk);
    tb_nRst = 1'b1;
    @(posedge tb_clk);
    #(CLK_PERIOD * 2);


    // ***********************************
    // Test Case 1: Take Input, Send
    // ***********************************
    tb_ready = 1;
    #(CLK_PERIOD);
    tb_transmit_ready = 1;
    #(CLK_PERIOD * 2);


    // ***********************************
    // Test Case 2: Do not take input
    // ***********************************
    tb_ready = 0;
    tb_transmit_ready = 0;

    tb_nRst = 0;
    #(CLK_PERIOD);
    tb_nRst = 1;
    #(CLK_PERIOD);

    #(CLK_PERIOD * 3);



    // ***********************************
    // Test Case 3: Take Input, Dont Send 
    // ***********************************
    tb_ready = 1;
    tb_transmit_ready = 0;
    #(CLK_PERIOD * 2)
    
    tb_transmit_ready = 1;
    #(CLK_PERIOD);

    $finish;
end
endmodule