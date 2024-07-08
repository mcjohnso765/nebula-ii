`timescale 10ns/1ns
module snakeGame_tb;

    localparam CLK_PERIOD = 100; // 12 MHz 
    localparam RESET_ACTIVE = 0;
    localparam RESET_INACTIVE = 1;

    // Testbench Signals
    integer tb_test_num;
    string tb_test_name; 

    // DUT Inputs
    logic tb_clk;
    logic tb_up;
    logic tb_rst;

    // Expected values for checks

    ////////////////////////
    // Testbenching tasks //
    ////////////////////////

    // Quick reset for 2 clock cycles
    task reset_dut;
    begin
        @(negedge tb_clk); // synchronize to negedge edge so there are not hold or setup time violations
        
        // Activate reset
        tb_rst = RESET_ACTIVE;

        // Wait 2 clock cycles
        @(negedge tb_clk);
        @(negedge tb_clk);

        // Deactivate reset
        tb_rst = RESET_INACTIVE; 
    end
    endtask

    // Check output values against expected values
    /*task check_outputs;
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

    // end
    // endtask 

    //////////
    // DUT //
    //////////

    // DUT Instance
    snakeGame DUT (
        .clk(tb_clk),
        .rst(tb_rst),
        .up(tb_up),
        
        // BELOW PORTS ARE NOT USED
        .tft_sck(),
        .tft_sdi(),
        .tft_dc(),
        .tft_reset(),
        .tft_cs(),
        .tft_sdo(),  
        .leds(),
        .dac_sdi(),
        .dac_cs(),
        .dac_sck(),
        .test(),
        .tftstate()
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
        $dumpvars(0, snakeGame_tb);
        tb_up = 0;
        // Initialize all test inputs
        #CLK_PERIOD;

        //reset
        reset_dut;
        #CLK_PERIOD;

        tb_up = 1'b0;
        #(1000000000 * CLK_PERIOD);

        $finish;
    end

endmodule