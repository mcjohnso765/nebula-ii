/*
    Module: tb_playing_fsm
    Description:
        testbench for the playing_fsm.sv bomb with the following:
    - 
    - 
*/
`timescale 1ms / 100us
 
`define SELECT 6'b000001
`define UP 6'b000010
`define RIGHT 6'b000100
`define DOWN 6'b001000
`define LEFT 6'b010000
`define BACK 6'b100000
`define NO_PRESS 6'b000000

module t07_tb_fsm_playing ();

    typedef enum logic [2:0] {
        MENU = 3'd0, PLAY = 3'd1, LOST = 3'd2, WON = 3'd3
    } game_state_t;

    typedef enum logic [2:0] {
        MOD = 3'd0, MAZE = 3'd1 
    } playing_state_t;

    // Timing
    localparam CLK_PERIOD        = 83.3;    // 12 MHz clock (for FPGA)
    localparam PROPAGATION_DELAY = 15.5;    // Allow for 15.5ns for FF propogation delay

    // DUT Port - input logic
    logic tb_nrst;                  // testbench negedge reset
    logic tb_clk;                   // testbench clock
    logic tb_strobe;                // testbench strobe edge
    logic [5:0] tb_button;          // testbench button input
    logic [2:0] tb_game_state;      // testbench game state signal (playing fsm active in PLAY state)
    logic [2:0] tb_mod_num;         // testbench number of modules
    logic tb_submodule_clear_edge;  // testbench submodule clear signal edge
    
    // DUT Port - output logic
    logic [2:0] tb_playing_state;   // testbench plying state
    logic tb_game_clear;            // testbench game clear signal

    // DUT - testing logic
    integer tb_test_num;            // testbench test number

    // DUT - testing clock
    always begin
        tb_clk = 1'b1;  #(CLK_PERIOD / 2.0);
        tb_clk = 1'b0;  #(CLK_PERIOD / 2.0);
    end

    // instantiate the playing_fsm DUT and assign the ports
    t07_fsm_playing DUT(
        .nrst(tb_nrst),
        .clk(tb_clk),
        .strobe(tb_strobe),
        .button(tb_button),
        .game_state_in(tb_game_state),
        .mod_num(tb_mod_num),
        .submodule_clear_edge(tb_submodule_clear_edge),
        .playing_state_out(tb_playing_state),
        .game_clear(tb_game_clear)
    );
    
    // Task: power-on-reset
    // Description: 
    //  set the negreset value to low for two negedge clock cycles,
    // then set it back to high and wait for the next posedge
    task reset_dut();
        tb_game_state = MENU;
        @(negedge tb_clk);  tb_nrst = 1'b0;
        @(negedge tb_clk);  
        @(negedge tb_clk);  tb_nrst = 1'b1;
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

    // Task: set_game_state_play
    // Description:
    //  Set the game_state to play, imitate clicking the button from MENU to PLAY state
    task set_game_state_play ();
        tb_game_state = PLAY;
    endtask

    // Task: send_submodule_clear
    // Description:
    //  Set the submodule_clear pulse signal
    task send_submodule_clear();
        @(posedge tb_clk);  #(PROPAGATION_DELAY);   tb_submodule_clear_edge = 1'b1;
        @(posedge tb_clk);  #(PROPAGATION_DELAY);   tb_submodule_clear_edge = 1'b0;
    endtask

    // Task: check_state
    // Description:
    //  check the playing_state (MOD, MAZE, etc.) with the expected playing_state
    task check_state (
        input playing_state_t exp_playing_state
    );
        if(exp_playing_state == tb_playing_state) begin // Check passed
            $info("Correct output: %0d test case.", tb_test_num);
            $display("Expected %0d.", exp_playing_state);
        end else begin // Check failed
            $error("Incorrect output: %0d test case.", tb_test_num);
            $display("Expected %0d, Actual %0d.", exp_playing_state, tb_playing_state);
        end
    endtask

    // Task: check_game_clear
    // Description:
    //  check the game_clear signal (high when num_clear == mod_num) with the expected value
    task check_game_clear(
        input exp_game_clear
    );
        if(exp_game_clear == tb_game_clear) begin
            $info("Correct output: %0d test case.", tb_test_num);
            $display("Expected %0d.", exp_game_clear);
        end else begin // Check failed
            $error("Incorrect output: %0d test case.", tb_test_num);
            $display("Expected %0d, Actual %0d.", exp_game_clear, tb_game_clear);
        end
    endtask

    // Task: normal_iterate_module
    // Description:
    //  set the game_state signal to PLAY state, then playing state is MOD
    // set the button SELECT pressed to move into MAZE game, then
    // set the button BACK pressed to move back to MOD
    task normal_iterate_module();
        reset_dut();
        set_game_state_play();
        check_state(MOD);

        button_press(`SELECT);  // press SELECT to move from MOD into MAZE game
        #(CLK_PERIOD);          // wait one clk cycle for the playing_state to update
        check_state(MAZE);

        button_press(`BACK);    // press BACK button to go back from MAZE to MOD
        #(CLK_PERIOD);          // wait one clk cycle for the playing_state to update
        check_state(MOD);
    endtask

    // Task: normal_module_clear
    // Description: 
    //  set the game state signal to PLAY, then playing state is MOD
    // set the submodule_clear pulse to high, imitate the signal from MAZE game
    // then the num_clear should increase by one. then the game_clear signal should send high
    task normal_module_clear();
        reset_dut();
        set_game_state_play();  // PLAY game_state: MOD playing_state

        button_press(`SELECT);  // playing_state move from MOD to MAZE
        #(CLK_PERIOD);
        check_game_clear(0);

        send_submodule_clear(); // send submodule_clear signal;
        #(PROPAGATION_DELAY);   
        check_game_clear(1);    // the game_clear signal than become high during the submodule_clear signal high
    endtask

    // Task: mid_operation_reset
    // Description: 
    //  reset mid operation

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
        
        // Initialize input ports
        tb_nrst = 1'b1;
        tb_strobe = 1'b0;
        tb_button = `NO_PRESS;
        tb_game_state = MENU;
        tb_mod_num = 3'd1;
        tb_submodule_clear_edge = 1'b0; 
        
        // Initialize testing variables
        tb_test_num = 0;

        // testbenching
        tb_test_num++;
        reset_dut();

        tb_test_num++;
        normal_iterate_module();
        
        tb_test_num++;
        normal_module_clear();
        
        $finish;
    end

endmodule
