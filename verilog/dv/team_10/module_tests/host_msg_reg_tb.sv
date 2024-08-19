/* Display FSM File
Descriuption: x
*/

`timescale 1ms / 100 us

module host_msg_reg_tb ();

// Testbench ports
localparam CLK_PERIOD = 10; // 100 Hz clk
logic tb_clk, tb_nRst, tb_rec_ready, tb_key_ready, tb_toggle_state, tb_gameEnd_host;
logic [7:0] tb_setLetter;
logic [39:0] tb_temp_word;

// Clock generation block
always begin
    tb_clk = 1'b0; 
    #(CLK_PERIOD / 2.0);
    tb_clk = 1'b1; 
    #(CLK_PERIOD / 2.0); 
end

//task that presses the button once
task single_button_press;
begin
    @(negedge tb_clk);
    tb_key_ready = 1'b1;
    @(negedge tb_clk);
    tb_key_ready = 1'b0;
    @(posedge tb_clk);
end
endtask


// Portmap
host_msg_reg tb_disp_fsm(.clk(tb_clk), .nRst(tb_nRst), .rec_ready(tb_rec_ready), .key_ready(tb_key_ready), .setLetter(tb_setLetter), .gameEnd_host(tb_gameEnd_host), .toggle_state(tb_toggle_state), .temp_word(tb_temp_word));

initial begin 
    // Signal dump
    $dumpfile("dump.vcd");
    $dumpvars; 

    // Initialize test bench signals
    tb_nRst = 1'b1;
    tb_key_ready = 0;
    tb_setLetter = 8'b01000110; // F
    tb_toggle_state = 0;
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
    // Test Case 1: key_ready Low
    // ***********************************
    tb_key_ready = 0;
    #(CLK_PERIOD * 2);
    tb_setLetter = 8'b01000110; // F
    single_button_press();
    #CLK_PERIOD;

    // ***********************************
    // Test Case 2: Ready High
    // ***********************************
    tb_setLetter = 8'b01000001; // A
    #CLK_PERIOD;
    single_button_press();
    #(CLK_PERIOD * 2);
    tb_setLetter = 8'b01001110; //N
    single_button_press();
    #(CLK_PERIOD * 2);
    

    // ***********************************
    // Test Case 3: key_ready flip
    // ***********************************
    tb_setLetter = 8'b01010100; // T
    #CLK_PERIOD;
    single_button_press();
    tb_setLetter = 8'b01000001; // A
    #(CLK_PERIOD *1);
    single_button_press();
    #(CLK_PERIOD * 5)
    @(negedge tb_clk);
    tb_toggle_state = 1'b1;
    @(negedge tb_clk);
    tb_toggle_state = 1'b0;
    @(posedge tb_clk);
    #(CLK_PERIOD * 2);
    @(negedge tb_clk);
    tb_gameEnd_host = 1'b1;
    @(negedge tb_clk);
    tb_gameEnd_host = 1'b0;
    @(posedge tb_clk);
    tb_setLetter = 8'b01011111; // A
    #(CLK_PERIOD * 25);
    $finish;
end
endmodule