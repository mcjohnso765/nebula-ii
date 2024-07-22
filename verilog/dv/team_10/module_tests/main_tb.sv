`timescale 1ms / 100 us

module main_tb ();

// Testbench ports
localparam CLK_PERIOD = 10; // 100 Hz clk
logic tb_clk, tb_nRst, tb_role_switch, tb_red, tb_green, tb_blue, tb_error, tb_msg_sent; //Input
logic [3:0] tb_row_host, tb_row_player;
logic [127:0] tb_play_row1, tb_play_row2, tb_host_row1, tb_host_row2;

integer tb_test_num;

// Clock generation block
always begin
    tb_clk = 1'b0; 
    #(CLK_PERIOD / 2.0);
    tb_clk = 1'b1; 
    #(CLK_PERIOD / 2.0); 
end

// Portmap
main main0 (.clk(tb_clk), .nRst(tb_nRst), .role_switch(tb_role_switch), .red(tb_red), .green(tb_green), .blue(tb_blue), .error(tb_error), .play_row1(tb_play_row1), .play_row2(tb_play_row2), .host_row1(tb_host_row1), .host_row2(tb_host_row2), .input_row_player(tb_row_player), .input_row_host(tb_row_host), .msg_sent(tb_msg_sent));


initial begin 
    // Signal dump
    $dumpfile("dump.vcd");
    $dumpvars;

    tb_row_host = 4'd0;
    tb_row_player = 4'd0;
    tb_role_switch = 0;
    tb_test_num = -1;

    // Wait some time before starting first test case
    #(0.1);

    // ***********************************
    // Test Case 0: Power-on-Reset 
    // ***********************************
    tb_test_num += 1;
    #(CLK_PERIOD * 20);
    @(negedge tb_clk);
    tb_nRst = 1'b0; 
    @(negedge tb_clk);
    @(negedge tb_clk);
    tb_nRst = 1'b1;
    #(CLK_PERIOD * 300000);
    // // ***********************************
    // // Test Case 1: Host Side: Setting the word APPLE 
    // // ***********************************
    // tb_test_num += 1;
    // //START of A
    // tb_row_host = 4'b1000; // R0 C1 -> 'A'

    // #(CLK_PERIOD * 100000);

    // @(negedge tb_clk);
    // tb_row_host = 4'd0;

    // @(posedge tb_clk);
    // #(CLK_PERIOD * 300000); // R3 C0 (submit_letter_key)
    // tb_row_host = 4'b0001;

    // #(CLK_PERIOD * 100000);

    // @(negedge tb_clk);
    // tb_row_host = 4'd0;

    // #(CLK_PERIOD * 100000);
    

    // // end of pressing A, Start of pressing P1
    // #(CLK_PERIOD * 300000);
    // tb_row_host = 4'b0010; // R2 C0 -> 'P'

    // #(CLK_PERIOD * 100000);

    // @(negedge tb_clk);
    // tb_row_host = 4'd0;

    // @(posedge tb_clk);
    // #(CLK_PERIOD * 400000); // R3 C0 (submit_letter_key)
    // tb_row_host = 4'b0001;

    // #(CLK_PERIOD * 100000);

    // @(negedge tb_clk);
    // tb_row_host = 4'd0;
    // // end of pressing P1, Start of pressing P2

    // #(CLK_PERIOD * 400000);
    // tb_row_host = 4'b0010; // R2 C0 -> 'P'

    // #(CLK_PERIOD * 100000);

    // @(negedge tb_clk);
    // tb_row_host = 4'd0;

    // @(posedge tb_clk);
    // #(CLK_PERIOD * 400000); // R3 C0 (submit_letter_key)
    // tb_row_host = 4'b0001;

    // #(CLK_PERIOD * 100000);

    // @(negedge tb_clk);
    // tb_row_host = 4'd0;
    
    // // ENd of pressing P2, Start of L
    // #(CLK_PERIOD * 100000);
    // tb_row_host = 4'b0100; // R1 C1 -> 'L'
    // #(CLK_PERIOD * 100000);

    // @(negedge tb_clk);
    // tb_row_host = 4'd0;

    // #(CLK_PERIOD * 400000);
    // tb_row_host = 4'b0100; // R1 C1 -> 'L'
    // #(CLK_PERIOD * 100000);

    // @(negedge tb_clk);
    // tb_row_host = 4'd0;

    //  #(CLK_PERIOD * 400000);
    // tb_row_host = 4'b0100; // R1 C1 -> 'L'
    // #(CLK_PERIOD * 100000);

    // @(negedge tb_clk);
    // tb_row_host = 4'd0;

    //  @(posedge tb_clk);
    // #(CLK_PERIOD * 300000); // R3 C0 (submit_letter_key)
    // tb_row_host = 4'b0001;

    // #(CLK_PERIOD * 100000);

    // @(negedge tb_clk);
    // tb_row_host = 4'd0;

    // //end pressing L, Start pressing E 

    // #(CLK_PERIOD * 600000);
    // tb_row_host = 4'b1000; //for E
    // #(CLK_PERIOD * 100000);

    // @(negedge tb_clk);
    // tb_row_host = 4'd0;

    // #(CLK_PERIOD * 400000);
    // tb_row_host = 4'b1000; // 'E'
    // #(CLK_PERIOD * 100000);

    // @(negedge tb_clk);
    // tb_row_host = 4'd0;

    // @(posedge tb_clk);
    // #(CLK_PERIOD * 200000); // R3 C0 (submit_letter_key)
    // tb_row_host = 4'b0001;

    // #(CLK_PERIOD * 100000);

    // @(negedge tb_clk);
    // tb_row_host = 4'd0;
    // #(CLK_PERIOD * 100000);

    // #(CLK_PERIOD * 500000);
    //  tb_row_host = 4'b0001;
    //  #(CLK_PERIOD * 100000);
    //  @(negedge tb_clk);
    // tb_row_host = 4'd0;
    // #(CLK_PERIOD * 500000);

    // // ***********************************
    // // Test Case 2: Player Side: Winning by guessing apple 
    // // ***********************************
    // tb_test_num += 1;
    // tb_row_host = 4'd0;
    // tb_row_player = 4'd0;
    // tb_role_switch = 1;

    // // GUESS first letter P
    // #(CLK_PERIOD * 500000);
    // tb_row_player = 4'b0010; // R2 C0 -> 'P'

    // #(CLK_PERIOD * 100000);

    // @(negedge tb_clk);
    // tb_row_player = 4'd0;

    // @(posedge tb_clk);
    // #(CLK_PERIOD * 400000); // R3 C0 (submit_letter_key)
    // tb_row_player = 4'b0001;

    // #(CLK_PERIOD * 100000);

    // @(negedge tb_clk);
    // tb_row_player = 4'd0;
    // #(CLK_PERIOD * 400000);

    // //GUESS second letter H
    // tb_row_player = 4'b0100; //H 
    // #(CLK_PERIOD * 100000);

    // @(negedge tb_clk);
    // tb_row_player = 4'd0;
    //  #(CLK_PERIOD * 400000);
    // tb_row_player = 4'b0100; // R1 C1 -> 'H'
    // #(CLK_PERIOD * 100000);

    // @(negedge tb_clk);
    // tb_row_player = 4'd0;

    //  @(posedge tb_clk);
    // #(CLK_PERIOD * 400000); // R3 C0 (submit_letter_key)
    // tb_row_player = 4'b0001;

    // #(CLK_PERIOD * 100000);

    // @(negedge tb_clk);
    // tb_row_player = 4'd0;
    // #(CLK_PERIOD * 500000);

    // // GUESS A
    // tb_row_player = 4'b1000; // R0 C1 -> 'A'

    // #(CLK_PERIOD * 100000);

    // @(negedge tb_clk);
    // tb_row_player = 4'd0;

    // @(posedge tb_clk);
    // #(CLK_PERIOD * 300000); // R3 C0 (submit_letter_key)
    // tb_row_player = 4'b0001;

    // #(CLK_PERIOD * 100000);

    // @(negedge tb_clk);
    // tb_row_player = 4'd0;
    //  #(CLK_PERIOD * 400000);

    // // press E

    // #(CLK_PERIOD * 600000);
    // tb_row_player = 4'b1000; //for E
    // #(CLK_PERIOD * 100000);

    // @(negedge tb_clk);
    // tb_row_player = 4'd0;

    // #(CLK_PERIOD * 400000);
    // tb_row_player = 4'b1000; // 'E'
    // #(CLK_PERIOD * 100000);

    // @(negedge tb_clk);
    // tb_row_player = 4'd0;

    // @(posedge tb_clk);
    // #(CLK_PERIOD * 200000); // R3 C0 (submit_letter_key)
    // tb_row_player = 4'b0001;

    // #(CLK_PERIOD * 100000);

    // @(negedge tb_clk);
    // tb_row_player = 4'd0;
    // #(CLK_PERIOD * 100000);

    // // presss L 
    // tb_row_player = 4'b0100; // R1 C1 -> 'L'
    // #(CLK_PERIOD * 100000);

    // @(negedge tb_clk);
    // tb_row_player = 4'd0;

    // #(CLK_PERIOD * 400000);
    // tb_row_player = 4'b0100; // R1 C1 -> 'L'
    // #(CLK_PERIOD * 100000);

    // @(negedge tb_clk);
    // tb_row_player = 4'd0;

    //  #(CLK_PERIOD * 400000);
    // tb_row_player = 4'b0100; // R1 C1 -> 'L'
    // #(CLK_PERIOD * 100000);

    // @(negedge tb_clk);
    // tb_row_player = 4'd0;

    //  @(posedge tb_clk);
    // #(CLK_PERIOD * 300000); // R3 C0 (submit_letter_key)
    // tb_row_player = 4'b0001;

    // #(CLK_PERIOD * 100000);

    // @(negedge tb_clk);
    // tb_row_player = 4'd0;
    // #(CLK_PERIOD * 300000);
    
    // // game end
    // tb_row_player = 4'b0010;

    // #(CLK_PERIOD * 100000);

    // @(negedge tb_clk);
    // tb_row_player = 4'd0;
    // #(CLK_PERIOD * 100000);

    // ***********************************
    // Test Case 3: Host Side: Setting the word  MOORE 
    // ***********************************

    tb_test_num += 1;
    // //game end
    // tb_row_host = 4'b0010;

    // #(CLK_PERIOD * 100000);

    // @(negedge tb_clk);
    // tb_row_host = 4'd0;
    // #(CLK_PERIOD * 600000);
    // press A
    tb_row_host = 4'b1000; // R0 C1 -> 'A'

    #(CLK_PERIOD * 100000);

    @(negedge tb_clk);
    tb_row_host = 4'd0;

    @(posedge tb_clk);
    #(CLK_PERIOD * 300000); // R3 C0 (submit_letter_key)
    tb_row_host = 4'b0001;

    #(CLK_PERIOD * 100000);

    @(negedge tb_clk);
    tb_row_host = 4'd0;
    #(CLK_PERIOD * 200000);

    // START E

    tb_row_host = 4'b1000; //for E
    #(CLK_PERIOD * 100000);

    @(negedge tb_clk);
    tb_row_host = 4'd0;

    #(CLK_PERIOD * 400000);
    tb_row_host = 4'b1000; // 'E'
    #(CLK_PERIOD * 100000);

    @(negedge tb_clk);
    tb_row_host = 4'd0;

    @(posedge tb_clk);
    #(CLK_PERIOD * 200000); // R3 C0 (submit_letter_key)
    tb_row_host = 4'b0001;

    #(CLK_PERIOD * 100000);

    @(negedge tb_clk);
    tb_row_host = 4'd0;
    #(CLK_PERIOD * 500000);

    // PRESS A

    tb_row_host = 4'b1000; // R0 C1 -> 'A'

    #(CLK_PERIOD * 100000);

    @(negedge tb_clk);
    tb_row_host = 4'd0;

    @(posedge tb_clk);
    #(CLK_PERIOD * 300000); // R3 C0 (submit_letter_key)
    tb_row_host = 4'b0001;

    #(CLK_PERIOD * 100000);

    @(negedge tb_clk);
    tb_row_host = 4'd0;
     #(CLK_PERIOD * 100000);

    // PRESS I
    #(CLK_PERIOD * 300000);
    tb_row_host = 4'b0100; // R1 C1 -> 'I'
    #(CLK_PERIOD * 100000);

    @(negedge tb_clk);
    tb_row_host = 4'd0;

    #(CLK_PERIOD * 400000);
    tb_row_host = 4'b0100; // R1 C1 -> 'I'
    #(CLK_PERIOD * 100000);

    @(negedge tb_clk);
    tb_row_host = 4'd0;

     #(CLK_PERIOD * 400000);
    tb_row_host = 4'b0100; // R1 C1 -> 'I'
    #(CLK_PERIOD * 100000);

    @(negedge tb_clk);
    tb_row_host = 4'd0;

     @(posedge tb_clk);
    #(CLK_PERIOD * 500000); // R3 C0 (clear_letter_key)
    tb_row_host = 4'b0001;

    #(CLK_PERIOD * 100000);

    @(negedge tb_clk);
    tb_row_host = 4'd0;
    #(CLK_PERIOD * 300000);

    // PRESS R

     tb_row_host = 4'b0010; // 'R'
    #(CLK_PERIOD * 100000);

    @(negedge tb_clk);
    tb_row_host = 4'd0;

    #(CLK_PERIOD * 400000);
    tb_row_host = 4'b0010; // 'R'
    #(CLK_PERIOD * 100000);

    @(negedge tb_clk);
    tb_row_host = 4'd0;

     #(CLK_PERIOD * 400000);
    tb_row_host = 4'b0010; // 'R'
    #(CLK_PERIOD * 100000);

    @(negedge tb_clk);
    tb_row_host = 4'd0;

     @(posedge tb_clk);
    #(CLK_PERIOD * 400000); // R3 C0 (submit_letter_key)
    tb_row_host = 4'b0001;

    #(CLK_PERIOD * 100000);

    @(negedge tb_clk);
    tb_row_host = 4'd0;
    #(CLK_PERIOD * 100000);

    // PRESS T

    tb_row_host = 4'b0010; // 'T'
    #(CLK_PERIOD * 100000);

    @(negedge tb_clk);
    tb_row_host = 4'd0;

     @(posedge tb_clk);
    #(CLK_PERIOD * 300000); // R3 C0 (submit_letter_key)
    tb_row_host = 4'b0001;

    #(CLK_PERIOD * 100000);

    @(negedge tb_clk);
    tb_row_host = 4'd0;
    #(CLK_PERIOD * 400000);

    //PRESS H


    tb_row_host = 4'b0100; //H 
    #(CLK_PERIOD * 100000);

    @(negedge tb_clk);
    tb_row_host = 4'd0;
     #(CLK_PERIOD * 400000);
    tb_row_host = 4'b0100; // R1 C1 -> 'H'
    #(CLK_PERIOD * 100000);

    @(negedge tb_clk);
    tb_row_host = 4'd0;

     @(posedge tb_clk);
    #(CLK_PERIOD * 400000); // R3 C0 (submit_letter_key)
    tb_row_host = 4'b0001;

    #(CLK_PERIOD * 100000);

    @(negedge tb_clk);
    tb_row_host = 4'd0;
    #(CLK_PERIOD * 600000);

    tb_row_host = 4'b0001; // (submit word key)
    #(CLK_PERIOD * 100000);
    @(negedge tb_clk);
    tb_row_host = 4'd0;
    #(CLK_PERIOD * 300000);

     // ***********************************
    // Test Case 4: Player Side: losing ;-;
    // ***********************************

    tb_test_num += 1;
    tb_row_host = 4'd0;
    tb_row_player = 4'd0;
    tb_role_switch = 1;

    #(CLK_PERIOD * 10000);

    tb_row_player = 4'b0010; // R2 C0 -> 'P'

    #(CLK_PERIOD * 100000);

    @(negedge tb_clk);
    tb_row_player = 4'd0;

    #(CLK_PERIOD * 400000);

    @(posedge tb_clk);
    tb_row_player = 4'b0001;  // R3 C0 (submit_letter_key)

    #(CLK_PERIOD * 100000);

    @(negedge tb_clk);
    tb_row_player = 4'd0;
    #(CLK_PERIOD * 200000);

     tb_row_player = 4'b1000; // R2 C0 -> 'D'

    #(CLK_PERIOD * 100000);

    @(negedge tb_clk);
    tb_row_player = 4'd0;

    @(posedge tb_clk);
    #(CLK_PERIOD * 600000); // R3 C0 (submit_letter_key)
    tb_row_player = 4'b0001;

    #(CLK_PERIOD * 100000);

    @(negedge tb_clk);
    tb_row_player = 4'd0;
    #(CLK_PERIOD * 100000);

    tb_row_player = 4'b1000; //for B
    #(CLK_PERIOD * 100000);

    @(negedge tb_clk);
    tb_row_player = 4'd0;

    #(CLK_PERIOD * 400000);
    tb_row_player = 4'b1000; // 'B'
    #(CLK_PERIOD * 100000);

    @(negedge tb_clk);
    tb_row_player = 4'd0;

    @(posedge tb_clk);
    #(CLK_PERIOD * 300000); // R3 C0 (submit_letter_key)
    tb_row_player = 4'b0001;

    #(CLK_PERIOD * 100000);

    @(negedge tb_clk);
    tb_row_player = 4'd0;
    #(CLK_PERIOD * 500000);

    tb_row_player = 4'b0100; // R0 C1 -> 'J'

    #(CLK_PERIOD * 100000);

    @(negedge tb_clk);
    tb_row_player = 4'd0;

    @(posedge tb_clk);
    #(CLK_PERIOD * 300000); // R3 C0 (submit_letter_key)
    tb_row_player = 4'b0001;

    #(CLK_PERIOD * 100000);

    @(negedge tb_clk);
    tb_row_player = 4'd0;
     #(CLK_PERIOD * 200000);

     tb_row_player = 4'b0100; // R0 C1 -> 'M'

    #(CLK_PERIOD * 100000);

    @(negedge tb_clk);
    tb_row_player = 4'd0;

    @(posedge tb_clk);
    #(CLK_PERIOD * 200000); // R3 C0 (submit_letter_key)
    tb_row_player = 4'b0001;

    #(CLK_PERIOD * 100000);

    @(negedge tb_clk);
    tb_row_player = 4'd0;
     #(CLK_PERIOD * 200000);

     tb_row_player = 4'b0010; // R0 C1 -> 'W'

    #(CLK_PERIOD * 100000);

    @(negedge tb_clk);
    tb_row_player = 4'd0;

    @(posedge tb_clk);
    #(CLK_PERIOD * 200000); // R3 C0 (submit_letter_key)
    tb_row_player = 4'b0001;

    #(CLK_PERIOD * 100000);

    @(negedge tb_clk);
    tb_row_player = 4'd0;
     #(CLK_PERIOD * 300000);








    $finish;
end
endmodule