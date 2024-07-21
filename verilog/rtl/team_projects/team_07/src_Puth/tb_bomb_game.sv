/*
    Testbench for game_control_fsm:
    - power on reset
    - normal operation: game clear signal high
    - normal operation: make error three times
    - mid operation reset
*/
`timescale 1ms / 100us

`define SELECT 6'b000001
`define UP 6'b000010
`define RIGHT 6'b000100
`define DOWN 6'b001000
`define LEFT 6'b010000
`define BACK 6'b100000
`define NO_PRESS 6'b000000

module t07_tb_bomb_game ();

    typedef enum logic [2:0] {
        MENU = 3'd0, PLAY = 3'd1, LOST = 3'd2, WON = 3'd3
    } game_state_t;

    // Timing
    localparam CLK_PERIOD        = 83.3;    // 12 MHz clock (for FPGA)
    localparam PROPAGATION_DELAY = 15.5;     // Allow for 5.5ns for FF propogation delay
    
    // DUT ports - input logic
    logic tb_clk;               // testbench clock
    logic tb_nrst;              // testbench negreset
    logic tb_strobe;            // testbench button strobe
    logic [5:0] tb_button;      // testbench button
    logic tb_error;             // testbench error
    logic tb_game_clear;        // testbench game_clear signal
    logic [8:0] tb_timer;       // testbench timer
    logic [2:0] tb_cnt_min;        // testbench count for min digit of the timer
    logic [2:0] tb_cnt_sec_ten;    // testbench count for second ten digit of the timer
    logic [3:0] tb_cnt_sec_one;    // testbench count for second one digit of the timer

    // DUT ports - output logic
    logic tb_timer_clear;       // testbench logic set to high to clear the timer
    logic [2:0] tb_mod_num;     // testbench number of modules
    logic [8:0] tb_max_timer;   // testbench max timer
    logic [2:0] tb_game_state;  // testbench game_state
    logic [1:0] tb_lives;       // testbench lives
    logic tb_activate_rand;

    // DUT - testing logic
    integer tb_test_num;            // testbench number

    // DUT - testing clock
    always begin
        tb_clk = 1'b0; #(CLK_PERIOD / 2);
        tb_clk = 1'b1; #(CLK_PERIOD / 2);
    end
    
    t07_bomb_game DUT_bomb_game(
        .nrst(tb_nrst),
        .clk(tb_clk),
        .button(tb_button),   // input: button
        .ssdec_sdi(),     // output: ssdec lines
        .ssdec_ss(),
        .ssdec_sck(),
        .tft_sck(),
        .tft_sdi(),
        .tft_dc(), 
        .tft_rst(),
        .tft_cs(),
        .tft_state(),
        .audio()
    );

    // Task: power-on-reset
    // Description: 
    //  set the negreset value to low for two negedge clock cycles,
    // then set it back to high and wait for the next posedge
    task reset_dut();
        @(negedge tb_clk); tb_nrst = 1'b0;
        @(negedge tb_clk);
        @(negedge tb_clk); tb_nrst = 1'b1;
        @(posedge tb_clk);
    endtask
    
    // Task: button_press
    // Description:
    //  set the tb_button to the button_in (UP, DOWN, LEFT, RIGHT, SELECT) at the negedge for two clock cycle
    // wait for the next postedge and after the propagation delay for the state/lives logic
    // to update. Then, those can be check with the check_state/check_lives after this.
    task button_press(
        input logic [5:0] button_in
    );
        @(negedge tb_clk);  
        tb_button = button_in;                      // set the button to the button pressed
        @(posedge tb_clk);  #(PROPAGATION_DELAY);   // once the button pressed is detected at the posedge  
        #(CLK_PERIOD);  #(CLK_PERIOD);              // after two clock cycle, the strobe pulse then goes high for one clock cycle
        tb_strobe = 1'b1;   #(CLK_PERIOD);          // the strobe pulse goes high
        tb_strobe = 1'b0;                           // the strobe pulse goes back to zero

        #(CLK_PERIOD);  #(CLK_PERIOD);  // the button needed to stay high for longer than the strobe to be read
        tb_button = `NO_PRESS;          // set the button back to low

        @(posedge tb_clk); #(PROPAGATION_DELAY);
    endtask


    // Task: normal_operation_win
    //  Check the game_state when when the game is cleared with the following sequence:
    // MENU >> button >> PLAY >> game_clear >> WON >> button >> MENU
    task normal_operation_win ();
        reset_dut();

        button_press(`SELECT);  #1000;

        button_press(`RIGHT);   #1000;
        button_press(`DOWN);    #1000;
        button_press(`SELECT);  #1000;
        
        button_press(`RIGHT);   #1000;

        button_press(`RIGHT);   #1000;
        button_press(`UP);      #1000;
        
        button_press(`RIGHT);   #1000;
        button_press(`UP);      #1000;
        button_press(`RIGHT);   #1000;

        #1000;
    endtask



    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;

        // initialize the testbench input
        tb_nrst = 1'b1;         // set the negedge reset to high (inactive)
        tb_strobe = 1'b0;       // set the strobe to zero (no button pressed)
        tb_button = `NO_PRESS;  // set the button to zero (no button pressed)
        tb_error = 1'b0;        // set the error to zero
        tb_game_clear = 1'b0;   // set the game_clear signal to zero
        tb_timer = 9'd300;      // set the timer to 300 s
        
        // initialize the testbench tracker 
        tb_test_num = 0;

        tb_test_num++; // tb_check_tag = "power-on-reset";
        reset_dut();

        tb_test_num++; // tb_check_tag = "normal-win";
        normal_operation_win();

        $finish;
    end
endmodule