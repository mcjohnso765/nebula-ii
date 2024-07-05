/*
    Module Name: tb_stop_watch
    Description: Test bench for snake_body_controller
*/


`timescale 1ms/100ps

module tb_fsm_direction ();

    // Testbench parameters
    localparam CLK_PERIOD = 10; // 10 MHz clk
    localparam MAX_LENGTH = 50; // Max length of clock.
    logic tb_checking_outputs;
    integer tb_test_num;
    string tb_test_case;

    // DUT ports
    logic tb_clk, tb_nRst_i, tb_sync;
    logic [3:0] tb_direction_pb;
    logic [2:0] heading;

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

    always begin
        tb_clk = 1'b0; 
        #(CLK_PERIOD / 2.0);
        tb_clk = 1'b1; 
        #(CLK_PERIOD / 2.0); 
    end
    
    fsm_direction DUT(.direction_a(tb_direction_pb), .clk(tb_clk), .nrst(tb_nRst_i), .sync(tb_sync), .direction(heading));

    initial begin
        // Signal dump
        $dumpfile("dump.vcd");
        $dumpvars; 

        // Initialize test bench signals
        tb_direction_pb = 4'b0; 
        tb_nRst_i = 1'b1;
        tb_test_num = -1;
        tb_checking_outputs = 1'b0;
        tb_test_case = "Initializing";
        tb_sync = 1'b0;
        

        // Wait some time before starting first test case
        #(0.1);


        // ************************************************************************
        // Test Case 0: Power On Reset of the DUT
        // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 0: Power-on-Reset of the DUT";
        $display("\n\n%s", tb_test_case);
        reset_dut;

        // ************************************************************************
        // Test Case 1: Move 4 directions 
        // ************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 1: Move 4 Directions";
        $display("\n\n%s", tb_test_case);

        //Move to the left

        right_button_press();
        #(CLK_PERIOD);
        up_button_press();
        #(CLK_PERIOD);
        left_button_press();
        #(CLK_PERIOD);
        down_button_press();
        #(CLK_PERIOD);
        reset_dut;

        $finish; 
    end

endmodule
/*
    Module Name: tb_stop_watch
    Description: Test bench for snake_body_controller
*/

