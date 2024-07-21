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

module t07_tb_fsm_game_control ();

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
    
    // inistantiate the game_control_fsm DUT and assign ports
    fsm_game_control DUT(
        .nrst(tb_nrst),
        .clk(tb_clk),
        .strobe(tb_strobe),
        .button(tb_button),
        .error(tb_error),
        .game_clear(tb_game_clear),
        .timer_clear(tb_timer_clear),
        .mod_num(tb_mod_num),
        .game_state_out(tb_game_state),
        .lives(tb_lives),
        .activate_rand(tb_activate_rand),
        .cnt_min(tb_cnt_min),
        .cnt_sec_ten(tb_cnt_sec_ten),
        .cnt_sec_one(tb_cnt_sec_one),
        .max_min(),
        .max_sec_ten(),
        .max_sec_one()
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

    // Task: send_game_clear
    // Description:
    //  Set the tb_game_clear signal to high for one clock cycle after the posedge and propogation delay time,
    // imitate the signal from playing_fsm which trigger after the posedge with a propogation delay.
    task send_game_clear();
        @(posedge tb_clk);  #(PROPAGATION_DELAY);
        tb_game_clear = 1'b1;   #(CLK_PERIOD);
        tb_game_clear = 1'b0;  
    endtask

    // Task: send_error
    // Description:
    //  Set the tb_error signal to high for one clock cycle after the posedge and propogation delay time,
    // imitate the signal from SUB (MAZE, etc.) which trigger after the posedge with a propogation delay. 
    task send_error();
        @(posedge tb_clk);  #(PROPAGATION_DELAY);
        tb_error = 1'b1;    #(CLK_PERIOD);
        tb_error = 1'b0;    
    endtask

    // Task: check_state
    // Description:
    //  check the game_state (MENU, PLAY, WON, LOST) with the expected game_state
    task check_state (
        // input string check_tag,
        input game_state_t exp_game_state
    );
        if(exp_game_state == tb_game_state) begin // Check passed
            $info("Correct output: %0d test case.", tb_test_num);
            $info("Expected %0d.", exp_game_state);
        end else begin // Check failed
            $error("Incorrect output: %0d test case.", tb_test_num);
            $error("Expected %0d, Actual %0d.", exp_game_state, tb_game_state);
        end
    endtask

    // Task: check_lives
    // Description:
    //  check the lives (3, 2, 1, 0) with the expected lives
    task check_lives (
        // input string check_tag,
        input logic [1:0] exp_lives
    );
        if(exp_lives == tb_lives) begin
            $info("Correct output: %0d test case.", tb_test_num);
            $info("Expected %0d.", exp_lives);
        end else begin        
            $error("Incorrect output: %0d test case.", tb_test_num);
            $error("Expected %0d, Actual %0d.", exp_lives, tb_lives);
        end
    endtask

    // Task: normal_operation_win
    //  Check the game_state when when the game is cleared with the following sequence:
    // MENU >> button >> PLAY >> game_clear >> WON >> button >> MENU
    task normal_operation_win ();
        reset_dut();
        check_state(MENU);

        button_press(`SELECT);   // press SELECT to move from MENU to PLAY state 
        #(CLK_PERIOD);
        check_state(PLAY);
        
        send_game_clear();      // set the game_clear signal to high for one clock cycle
        #(CLK_PERIOD);
        check_state(WON);

        button_press(`SELECT);   // press SELECT to move from WON to MENU state
        #(CLK_PERIOD);
        check_state(MENU);
    endtask

    // Task: normal_operation_lost_by_lives
    //  Check the game_state and lives when the game is lost by running out of lives with the following sequence:
    // MENU >> button >> PLAY >> error >> error >> error >> LOST >> button >> MENU
    task normal_operation_lost_by_lives ();
        reset_dut();

        button_press(`SELECT);   // press SELECT to move from MENU to PLAY state=
        #(CLK_PERIOD);
        check_lives(2'd3);       // once transition into PLAY state, the lives is set to 3

        send_error();   #(CLK_PERIOD);  // send error: lives from 3 to 2
        check_lives(2'd2);
        send_error();   #(CLK_PERIOD);  // send error: lives from 2 to 1
        check_lives(2'd1);
        send_error();   #(CLK_PERIOD);  // send error: lives from 1 to 0
        check_lives(2'd0);

        // game_state move from PLAY to LOST
        check_state(LOST);

        button_press(`SELECT);   // press SELECT to move from LOST to MENU state
    endtask

    // Task: normal_operation_lost_by_timer
    //  Check the game_state and lives when the game is lost by running out of time with the following sequence:
    // MENU >> button >> PLAY >> error >> timer == 0 >> LOST >> button >> MENU
    task normal_operation_lost_by_timer ();
        reset_dut();

        button_press(`SELECT);   // press SELECT to move from MENU to PLAY state
        #(CLK_PERIOD);

        send_error();   #(CLK_PERIOD);  // send error: lives from 3 to 2
        tb_cnt_min = 3'd0;                // timer == 0: 
        tb_cnt_sec_ten = 3'd0;
        tb_cnt_sec_one = 4'd0;
        
        // game_state move from PLAY to LOST 
        @(posedge tb_clk);  #(PROPAGATION_DELAY);  
        check_state(LOST);

        button_press(`SELECT);   // press SELECT to move from LOST to MENU state
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
        
        tb_test_num++; // tb_check_tag = "normal-lost-by-lives";
        normal_operation_lost_by_lives();

        tb_test_num++; // tb_check_tag = "normal-lost-by-timer";
        normal_operation_lost_by_timer();

        $finish;
    end
endmodule