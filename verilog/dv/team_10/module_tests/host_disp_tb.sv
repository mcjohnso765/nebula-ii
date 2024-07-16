/* Host display for game logic
Description: 
*/

`timescale 1ms / 100 us

module host_disp_tb ();

// Testbench ports
localparam CLK_PERIOD = 10; // 100 Hz clk
logic tb_clk, tb_nRst;
logic [4:0] tb_indexCorrect;
logic [7:0] tb_letter;
logic [2:0] tb_numMistake, tb_correct;
logic [39:0] tb_word;
logic tb_mistake;
logic [127:0] tb_top;
logic [127:0] tb_bottom;
logic tb_gameEnd_host;

// Clock generation block
always begin
    tb_clk = 1'b0; 
    #(CLK_PERIOD / 2.0);
    tb_clk = 1'b1; 
    #(CLK_PERIOD / 2.0); 
end

// Portmap
HostDisplay hostdisplaytb (.clk(tb_clk), .nRst(tb_nRst), .indexCorrect(tb_indexCorrect), .letter(tb_letter), .incorrect(tb_numMistake), .correct(tb_correct), .mistake(tb_mistake), .top(tb_top), .bottom(tb_bottom), .word(tb_word), .gameEnd_host(tb_gameEnd_host));

initial begin 
    // Signal dump
    $dumpfile("dump.vcd");
    $dumpvars; 

    // Initialize test bench signals
    tb_indexCorrect = 0;
    tb_letter = 8'b01000001;
    tb_numMistake = 0;
    tb_correct = 0;
    tb_word = 40'b0100110101001111010011110101001001000101; // MOORE
    tb_mistake = 0;
    tb_gameEnd_host = 0;


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
    // Test Case 1: Getting a letter wrong
    // ***********************************
    tb_letter = 8'b01010000; //GUESS P
    #CLK_PERIOD;
    tb_mistake = 1;
    #CLK_PERIOD;
    tb_mistake = 0;
    tb_numMistake = 1;
    #(CLK_PERIOD * 25);

    // ***********************************
    // Test Case 0: Getting a letter right
    // ***********************************
    #(CLK_PERIOD * 2);
    @(negedge tb_clk);
    tb_nRst = 1'b0;
    @(negedge tb_clk);
    @(negedge tb_clk);
    tb_nRst = 1'b1;
    @(posedge tb_clk);
    #(CLK_PERIOD * 2);

    #CLK_PERIOD;
    tb_mistake = 0;
    tb_correct = 1;
    tb_indexCorrect = 5'b10000;
    tb_numMistake = 0;
    tb_letter = 8'b01001101; //GUESS M
     #(CLK_PERIOD * 25);

    // ***********************************
    // Test Case 0: Getting a letter correct and one wrong 
    // ***********************************
    #(CLK_PERIOD * 2);
    @(negedge tb_clk);
    tb_nRst = 1'b0;
    @(negedge tb_clk);
    @(negedge tb_clk);
    tb_nRst = 1'b1;
    @(posedge tb_clk);
    #(CLK_PERIOD * 2);

    #CLK_PERIOD;
    tb_mistake = 0;
    tb_correct = 1;
    tb_indexCorrect = 5'b01100;
    tb_letter = 8'b01001111; //GUESS O
    #CLK_PERIOD;
    tb_numMistake = 0;
    tb_indexCorrect = 5'b0;
    tb_letter = 8'b01010000;
    #CLK_PERIOD;
    tb_mistake = 1;
    #CLK_PERIOD;
    tb_mistake = 0;
    tb_numMistake = 1;
     #(CLK_PERIOD * 25);


    // ***********************************
    // Test Case 0: Getting a whole word right
    // ***********************************
    #(CLK_PERIOD * 2);
    @(negedge tb_clk);
    tb_nRst = 1'b0;
    @(negedge tb_clk);
    @(negedge tb_clk);
    tb_nRst = 1'b1;
    @(posedge tb_clk);
    #(CLK_PERIOD * 2);

    #CLK_PERIOD;
    tb_mistake = 0;
    tb_correct = 5;
    tb_numMistake = 0;
    tb_indexCorrect = 5'b11111;
     #(CLK_PERIOD * 25);


    // ***********************************
    // Test Case 0: Getting a whole word wrong
    // ***********************************
    #(CLK_PERIOD * 2);
    @(negedge tb_clk);
    tb_nRst = 1'b0;
    @(negedge tb_clk);
    @(negedge tb_clk);
    tb_nRst = 1'b1;
    @(posedge tb_clk);
    #(CLK_PERIOD * 2);

    #CLK_PERIOD;
    tb_mistake = 1;
    tb_correct = 0;
    tb_numMistake = 6;
    tb_indexCorrect = 5'b00000;
     #(CLK_PERIOD * 25);


    // ***********************************
    // Test Case 0: Duplicate corrects (letter O)
    // ***********************************
    #(CLK_PERIOD * 2);
    @(negedge tb_clk);
    tb_nRst = 1'b0;
    @(negedge tb_clk);
    @(negedge tb_clk);
    tb_nRst = 1'b1;
    @(posedge tb_clk);
    #(CLK_PERIOD * 2);

    #CLK_PERIOD;
    tb_mistake = 0;
    tb_correct = 2;
    tb_indexCorrect = 5'b01100;
    tb_numMistake = 0;
    tb_letter = 8'b01001111; //GUESS O
     #(CLK_PERIOD * 25);

    $finish;
end
endmodule