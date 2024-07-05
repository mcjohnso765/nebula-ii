/*
    Module Name: tb_stop_watch
    Description: Test bench for snake_body_controller
*/

`timescale 1ms/100us

module tb_snake_body_controller ();

    // Testbench parameters
    localparam CLK_PERIOD = 100; // 10 MHz clk
    localparam MAX_LENGTH = 50; // Max length of clock.
    logic tb_checking_outputs;
    integer tb_test_num;
    string tb_test_case;

    // DUT ports
    logic tb_clk, tb_nRst_i, tb_mode_pb, tb_sync, tb_snakeHead, tb_snakeBody;
    logic [3:0] tb_direction_pb, tb_x, tb_y;
    logic [6:0] tb_curr_length;
    logic [MAX_LENGTH - 1: 0][7:0] tb_body;

    // Reset DUT Task
    task reset_dut;
        @(negedge tb_clk);
        tb_nRst_i = 1'b0; 
        @(negedge tb_clk);
        @(negedge tb_clk);
        tb_nRst_i = 1'b1;
        @(posedge tb_clk);
    endtask
    
    // Task that presses the button once
    task mode_button_press;
    begin
        @(negedge tb_clk);
        tb_mode_pb = 1'b1; 
        @(negedge tb_clk);
        tb_mode_pb = 1'b0; 
        @(posedge tb_clk);  // Task ends in rising edge of clock: remember this!
    end
    endtask

    task left_button_press;
    begin
        @(negedge tb_clk);
        tb_direction_pb[0] = 1'b1;
        @(negedge tb_clk)
        tb_direction_pb[0] = 1'b0;
        @(posedge tb_clk);
    end
    endtask

    task right_button_press;
    begin
        @(negedge tb_clk);
        tb_direction_pb[1] = 1'b1;
        @(negedge tb_clk)
        tb_direction_pb[1] = 1'b0;
        @(posedge tb_clk);
    end
    endtask

    task down_button_press;
    begin
        @(negedge tb_clk);
        tb_direction_pb[2] = 1'b1;
        @(negedge tb_clk)
        tb_direction_pb[2] = 1'b0;
        @(posedge tb_clk);
    end
    endtask

    task up_button_press;
    begin
        @(negedge tb_clk);
        tb_direction_pb[3] = 1'b1;
        @(negedge tb_clk)
        tb_direction_pb[3] = 1'b0;
        @(posedge tb_clk);
    end
    endtask

    task toggle_sync;
    begin
        @(negedge tb_clk);
        tb_sync = 1'b1;
        @(negedge tb_clk);
        tb_sync = 1'b0;
        @(posedge tb_clk);
    end
    endtask

    task check_head;
    input logic [7:0] expected_position;
    begin
        @(negedge tb_clk);
        tb_checking_outputs = 1'b1;
        if(tb_body[0] == expected_position)
            $info("Correct Head Position: %0d, %0d.", expected_position[7:4], expected_position[3:0]);
        else   
            $error("Incorrect Head Position: Expected: %0d, %0d. Actual: %0d, %0d.", expected_position[7:4], expected_position[3:0], tb_body[0][7:4], tb_body[0][3:0]);
        #(1);
        tb_checking_outputs = 1'b0;
    end
    endtask

    task check_tail;
    input logic [7:0] expected_position;
    begin
        @(negedge tb_clk);
        tb_checking_outputs = 1'b1;
        if(tb_body[tb_curr_length] == expected_position)
            $info("Correct Tail Position: %0d, %0d.", expected_position[7:4], expected_position[3:0]);
        else
            $error("Incorrect Tail Position: Expected: %0d, %0d. Actual: %0d, %0d", expected_position[7:4], expected_position[3:0], tb_body[tb_curr_length][7:4], tb_body[tb_curr_length][3:0]);
        #(1);
        tb_checking_outputs = 1'b0;
    end
    endtask

    task check_segment;
    input logic [7:0] expected_position;
    input logic [6:0] segment_num;
    begin
        @(negedge tb_clk);
        tb_checking_outputs = 1'b1;
        if(tb_body[segment_num] == expected_position)
            $info("Correct Body Position: [%0d] %0d, %0d.", segment_num, expected_position[7:4], expected_position[3:0]);
        else
            $error("Incorrect Tail Position: Expected: [%0d] %0d, %0d. Actual: %0d, %0d", segment_num, expected_position[7:4], expected_position[3:0], tb_body[segment_num][7:4], tb_body[segment_num][3:0]);
        #(1);
        tb_checking_outputs = 1'b0;
    end
    endtask

    task check_snakeHead;
        input logic expected_value;
        input logic [7:0] coordinates;
    begin
        @(negedge tb_clk);
        tb_checking_outputs = 1'b1;
        tb_x = coordinates[7:4];
        tb_y = coordinates[3:0];
        @(posedge tb_clk);
        if(tb_snakeHead == expected_value)
            $info("Correct Value for snakeHead");
        else
            $error("Incorrect Value for snakeHead");
        #(1);
        tb_checking_outputs = 1'b0;
    end
    endtask

    task check_snakeBody;
        input logic expected_value;
        input logic [7:0] coordinates;
    begin
        @(negedge tb_clk);
        tb_checking_outputs = 1'b1;
        tb_x = coordinates[7:4];
        tb_y = coordinates[3:0];
        @(posedge tb_clk);
        if(tb_snakeBody == expected_value)
            $info("Correct Value for snakeBody");
        else
            $error("Incorrect Value for snakeBody");
        #(1);
        tb_checking_outputs = 1'b0;
    end
    endtask
    // Clock generation block
    always begin
        tb_clk = 1'b0; 
        #(CLK_PERIOD / 2.0);
        tb_clk = 1'b1; 
        #(CLK_PERIOD / 2.0); 
    end
    

    // DUT Portmap
    snake_body_controller DUT(.direction_pb(tb_direction_pb),
                .x(tb_x),
                .y(tb_y),
                .clk(tb_clk),
                .pb_mode(tb_mode_pb),
                .nrst(tb_nRst_i),
                .sync(tb_sync),
                .curr_length(tb_curr_length),
                .body(tb_body),
                .snakeHead(tb_snakeHead),
                .snakeBody(tb_snakeBody)); 

    // Main Test Bench Process
    initial begin
        // Signal dump
        $dumpfile("dump.vcd");
        $dumpvars; 

        // Initialize test bench signals
        tb_direction_pb = 4'b0; 
        tb_nRst_i = 1'b1;
        tb_curr_length = 0;
        tb_test_num = -1;
        tb_checking_outputs = 1'b0;
        tb_test_case = "Initializing";
        tb_x = 4'b0;
        tb_y = 4'b0;
        tb_sync = 1'b0;
        tb_mode_pb = 1'b0;
        

        // Wait some time before starting first test case
        #(0.1);


        // ************************************************************************
        // Test Case 0: Power On Reset of the DUT
        // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 0: Power-on-Reset of the DUT";
        $display("\n\n%s", tb_test_case);
        reset_dut;
        #(CLK_PERIOD); //go for one second
        check_head(8'h44);
        reset_dut;

        // ************************************************************************
        // Test Case 1: Move 4 directions 
        // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 1: Move 4 Directions";
        $display("\n\n%s", tb_test_case);

        //Move to the right
        right_button_press();
        #(CLK_PERIOD * 100);
        check_head(8'h64);

        //Move down
        down_button_press();
        #(CLK_PERIOD * 100);
        check_head(8'h66);

        //Move to the left
        left_button_press();
        #(CLK_PERIOD * 100);
        check_head(8'h46);

        //Move to up
        up_button_press();
        #(CLK_PERIOD * 100);
        check_head(8'h44);

        reset_dut;

        /**
        Test Case 2: Make the snake two segments long and see if tail follows
        **/
        tb_test_num += 1;
        tb_test_case = "Test Case 2: Tail Follow Test";
        $display("\n\n%s", tb_test_case);

        //set the curr length to 1 (1:0 is snake)
        tb_curr_length = 7'b0000001;

        right_button_press();
        #(CLK_PERIOD * 100);
        check_head(8'h64);
        check_tail(8'h54);

        down_button_press();
        #(CLK_PERIOD * 100);
        check_head(8'h66);
        check_tail(8'h65);

        //Move to the left
        left_button_press();
        #(CLK_PERIOD * 100);
        check_head(8'h46);
        check_tail(8'h56);

        //Move to up
        up_button_press();
        #(CLK_PERIOD * 100);
        check_head(8'h44);
        check_tail(8'h45);

        reset_dut;

        /*
        Test Case 3: Check Tail with 4 segment long snake
        */
        tb_test_num += 1;
        tb_test_case = "Test Case 3: Tail Follow Test (length 3)";
        $display("\n\n%s", tb_test_case);

        tb_curr_length = 7'd2;

        //fully stretch out snake
        right_button_press();
        #(CLK_PERIOD * 100);
        check_head(8'h64);
        check_tail(8'h44);

        //now check after one move, should be at a turn
        down_button_press();
        #(CLK_PERIOD * 50);
        check_head(8'h65);
        check_tail(8'h54);

        //Move to the left, after one move
        left_button_press();
        #(CLK_PERIOD * 50);
        check_head(8'h55);
        check_tail(8'h64);

        //Move to up (twice)
        up_button_press();
        #(CLK_PERIOD * 100);
        check_head(8'h53);
        check_tail(8'h55);
    
        reset_dut;

        /*
        Test Case 4: Check that body segments are in correct locations after a sequence of multiple moves
        */

        tb_test_num += 1;
        tb_test_case = "Test Case 4: Body Segment Accuracy (length 4)";
        $display("\n\n%s", tb_test_case);

        tb_curr_length = 7'd3;

        mode_button_press();

        //full strech out snake
        right_button_press();
        #(CLK_PERIOD * 100);
        
        up_button_press();
        #(CLK_PERIOD * 25);
        right_button_press();
        #(CLK_PERIOD * 25);
        down_button_press();
        #(CLK_PERIOD * 50);
        right_button_press();
        #(CLK_PERIOD * 25);

        check_head(8'hA5);
        check_segment(8'h95, 7'd1);
        check_segment(8'h94, 7'd2);
        check_tail(8'h93);

        reset_dut;

        /*
        Test Case 5: Increase the length of the snake while it's moving and see if the tail remains in the same location before and after the move
        */

        tb_test_num += 1;
        tb_test_case = "Test Case 5: Increase length of snake during movement";
        $display("\n\n%s", tb_test_case);

        tb_curr_length = 7'd0;

        right_button_press();
        #(CLK_PERIOD * 100);
        check_head(8'h64);
        check_tail(8'h64);
        tb_curr_length = 7'd1;
        #(CLK_PERIOD * 50);
        check_head(8'h74);
        check_tail(8'h64);

        reset_dut;

        /*
        Test Case 6: Does snakeBody and snakeHead return correct values?
        */

        tb_test_num += 1;
        tb_test_case = "Test Case 6: Check snakeBody and snakeHead";
        $display("\n\n%s", tb_test_case);

        tb_curr_length = 7'd4;
        right_button_press();
        #(CLK_PERIOD * 50);
        check_snakeHead(1'b1, 8'h54);
        check_snakeBody(1'b0, 8'h54);
        up_button_press();
        #(CLK_PERIOD * 50);
        left_button_press();
        #(CLK_PERIOD * 50);
        down_button_press();
        #(CLK_PERIOD * 50);

        check_snakeHead(1'b1, 8'h44);
        check_snakeBody(1'b1, 8'h44);

        check_snakeHead(1'b0, 8'h43);
        check_snakeBody(1'b1, 8'h43);

        check_snakeHead(1'b0, 8'h54);
        check_snakeBody(1'b1, 8'h54);

        check_snakeHead(1'b0, 8'h53);
        check_snakeBody(1'b1, 8'h53);


        reset_dut;
        tb_x = 4'b0;
        tb_y = 4'b0;

        /*
        Test Case 7: Does sync reset reset the whole body and set head to 8'h44?
        */

        tb_test_num += 1;
        tb_test_case = "Test Case 7: Checking sync";
        $display("\n\n%s", tb_test_case);

        tb_curr_length = 7'b0;
        right_button_press();
        #(CLK_PERIOD * 100);
        toggle_sync();
        #(CLK_PERIOD * 50);
        //wait a lil bit to change the state
        check_head(8'h44);
        #(CLK_PERIOD * 50);
        //wait to see if the snake has stopped
        check_head(8'h44);
        // now move the snake
        right_button_press();
        #(CLK_PERIOD * 50);
        check_head(8'h54);

        reset_dut;

        /*
        Test Case 8: Does the speed of the snake change consistently when mode is toggled. 
        */

        tb_test_num += 1;
        tb_test_case = "Test Case 8: Changing the speed";
        $display("\n\n%s", tb_test_case);

        tb_curr_length = 7'b0;
        right_button_press();
        #(CLK_PERIOD * 50);
        check_snakeHead(1'b1, 8'h54);
        mode_button_press();
        #(CLK_PERIOD * 50);
        check_snakeHead(1'b1, 8'h74);
        mode_button_press();
        #(CLK_PERIOD * 50);
        check_snakeHead(1'b1, 8'h84);

        reset_dut;
        
        $finish; 
    end

endmodule 