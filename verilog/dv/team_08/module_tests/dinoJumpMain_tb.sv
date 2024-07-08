`timescale 10ns/1ns
module dinoJumpMain_tb;

    localparam CLK_PERIOD = 100; // 12 MHz 
    localparam RESET_ACTIVE = 0;
    localparam RESET_INACTIVE = 1;

    // Testbench Signals
    integer tb_test_num;
    string tb_test_name; 

    // DUT Inputs
    logic tb_clk;
    logic tb_nRst;
    logic tb_button;
    logic [7:0] tb_dinoY;

    // Expected values for checks

    ////////////////////////
    // Testbenching tasks //
    ////////////////////////

    // Quick reset for 2 clock cycles
    task reset_dut;
    begin
        @(negedge tb_clk); // synchronize to negedge edge so there are not hold or setup time violations
        
        // Activate reset
        tb_nRst = RESET_ACTIVE;

        // Wait 2 clock cycles
        @(negedge tb_clk);
        @(negedge tb_clk);

        // Deactivate reset
        tb_nRst = RESET_INACTIVE; 
    end
    endtask

    // Check output values against expected values
    task check_outputs;
        input logic [7:0] exp_dinoY; 
        //input logic exp_at_max; 
    begin
        @(negedge tb_clk);  // Check away from the clock edge!
        if(exp_dinoY == tb_dinoY)
            $info("Correct tb_dinoY value.");  
        else
            $error("Incorrect tb_dionY value. Actual: %0d, Expected: %0d.", tb_dinoY, exp_dinoY);
        
        /*if(exp_at_max == tb_at_max)
            $info("Correct tb_at_max value.");
        else
            $error("Incorrect tb_at_max value. Actual: %0d, Expected: %0d.", tb_at_max, exp_at_max);*/

    end
    endtask 

    //////////
    // DUT //
    //////////

    // DUT Instance
     dinoJumpMain DUT (
        .clk(tb_clk),
        .nRst(tb_nRst),
        .button(tb_button),
        .dinoY(tb_dinoY)
    );

    // Clock generation block
    always begin
        tb_clk = 0; // set clock initially to be 0 so that they are no time violations at the rising edge 
        #(CLK_PERIOD / 2);
        tb_clk = 1;
        #(CLK_PERIOD / 2);
    end

    initial begin
        $dumpfile ("sim.vcd");
        $dumpvars(0, tb);
        tb_button = 0;
        // Initialize all test inputs
        #CLK_PERIOD;

        //reset
        reset_dut;
        #CLK_PERIOD;
        tb_button = 1'b1;
        #CLK_PERIOD;
        //tb_button = 1'b0;
        #(6000000 * CLK_PERIOD);
        check_outputs(8'd181);
        #(6000000 * CLK_PERIOD);
        check_outputs(8'd151);

        $finish;
    end


endmodule