/*
    Module: tb_maze_game
    Description:
        Testbench for maze game includes the following:
        - power-on-reset
        - normal-win (move the mazer to the destination)
        - normal-collide (move the mazer into the wall)
*/
`define SELECT 6'b000001
`define UP 6'b000010
`define RIGHT 6'b000100
`define DOWN 6'b001000
`define LEFT 6'b010000
`define BACK 6'b100000
`define NO_PRESS 6'b000000

module t07_tb_maze();

    // Timing
    localparam CLK_PERIOD        = 83.3;    // 12 MHz clock (for FPGA)
    localparam PROPAGATION_DELAY = 15.5;    // Allow for 15.5ns for FF propogation delay

    // DUT Port - input logic 
    logic tb_nrst;
    logic tb_clk;
    logic tb_strobe;
    logic [5:0] tb_button;

    // DUT Port - output logic
    logic tb_error;
    logic tb_maze_clear;
    logic [2:0] tb_pos_x;
    logic [2:0] tb_pos_y;
    
    /*
        For testing, set the random generator to generate:
        start position (x, y) to (2, 4)
        destination (x, y) to (4, 5)
    */

    // DUT testing logic
    integer tb_test_num;

    // DUT testing clock
    always begin
        tb_clk = 1'b1;  #(CLK_PERIOD / 2.0);
        tb_clk = 1'b0;  #(CLK_PERIOD / 2.0);  
    end

    // instantiate maze_game and assign the ports
    t07_maze maze_game_DUT (
        .nrst(tb_nrst),
        .clk(tb_clk),
        .strobe(tb_strobe),
        .button(tb_button),
        .error(tb_error),
        .maze_clear(tb_maze_clear),
        .pos_x(tb_pos_x),
        .pos_y(tb_pos_y)
    );

    // Task: reset_dut
    //  set the negreset value to low for two negedge clock cycles,
    // then set it back to high and wait for the next posedge
    task reset_dut();
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

    // Task: check_position
    // Description:
    //  check the tb_pos_x and tb_pos_y (from 0 - 5) 
    // with the expected pos_x and expected pos_y
    task check_position (
        input logic [2:0] exp_pos_x,
        input logic [2:0] exp_pos_y
    );
        if(exp_pos_x == tb_pos_x && exp_pos_y == tb_pos_y) begin // Check passed
            $info("Correct output: %0d test case.", tb_test_num);
            $display("Expected pos_x: %0d, Expected pos_y: %0d", exp_pos_x, exp_pos_y);
        end else begin // Check failed
            $error("Incorrect output: %0d test case.", tb_test_num);
            $display("Expected pos_x: %0d, Actual pos_x: %0d.", exp_pos_x, tb_pos_x);
            $display("Expected pos_y: %0d, Actual pos_y: %0d.", exp_pos_y, tb_pos_y);
        end
    endtask

    // Task: check_maze_clear
    // Description:
    //  check the game_clear signal (high when num_clear == mod_num) with the expected value
    task check_game_clear(
        input exp_maze_clear
    );
        if(exp_maze_clear == tb_maze_clear) begin
            $info("Correct output: %0d test case.", tb_test_num);
            $display("Expected %0d.", exp_maze_clear);
        end else begin // Check failed
            $error("Incorrect output: %0d test case.", tb_test_num);
            $display("Expected %0d, Actual %0d.", exp_maze_clear, tb_maze_clear);
        end
    endtask

    // Task: normal_maze_clear
    // Description:
    //  move the mazer from the start position (2, 4) to the destination (4, 5) 
    // (from [0-5] * [0-5] map),  then the maze_clear signal should become high
    task normal_maze_clear ();
        reset_dut();
        check_position(3'd2, 3'd4);

        button_press(`RIGHT);
        check_position(3'd3, 3'd4);

        button_press(`UP);
        check_position(3'd3, 3'd5);

        button_press(`RIGHT);
        check_position(3'd4, 3'd5);
    endtask

    // Task: normal_collide
    // Description:
    //  move the mazer into the wall multiple times,
    // then the error pulse signal should be sent
    task normal_collide ();
        reset_dut();
        check_position(3'd2, 3'd4);

        button_press(`RIGHT);
        check_position(3'd3, 3'd4);

        button_press(`RIGHT);
        check_position(3'd3, 3'd4); // the position should remain the same
        // the error signal should be synchronous with strobe, check the waveform

        button_press(`UP);
        check_position(3'd3, 3'd5);

        button_press(`UP);
        check_position(3'd3, 3'd5); // the position should remain the same
        // the error signal should be synchronous with strobe, check the waveform

        button_press(`LEFT);
        check_position(3'd3, 3'd5); // the position should remain the same
        // the error signal should be synchronous with strobe, check the waveform
    endtask
    
    initial begin
    $dumpfile("dump.vcd");
    $dumpvars;

    // initialize input ports
    tb_nrst = 1'b1;
    tb_strobe = 1'b0;
    tb_button = `NO_PRESS;

    // initialize testing variables
    tb_test_num = 0;

    // testbenching
    tb_test_num++;
    reset_dut();

    tb_test_num++;
    normal_maze_clear();

    tb_test_num++;
    normal_collide();

    $finish;
    end
endmodule;