`timescale 1ms / 100us

module tb_applegenerator ();

    // Use your test bench code in tb_counter.sv
    // to start writing this test bench.
    // Think about what changes need to made...
    /////////////////////
    // Testbench Setup //
    /////////////////////
    
    // Define local parameters
    localparam CLK_PERIOD = 10; // 100 MHz 
    localparam RESET_ACTIVE = 0;
    localparam RESET_INACTIVE = 1;

    // Testbench Signals
    integer tb_test_num;
    string tb_test_name; 

    // DUT Inputs

    logic [3:0] tb_x, tb_y, tb_randX, tb_randY;
    logic tb_goodColl;
    logic tb_clk;
    logic tb_reset;
    logic tb_s_reset;
    logic [49:0][7:0] tb_body;

    // DUT Outputs
    logic tb_apple;

    // Expected values for checks
    logic tb_apple_exp; 

    // Signal Dump
    initial begin
        $dumpfile ("dump.vcd");
        $dumpvars;
    end

    // Quick reset for 2 clock cycles
    task reset_dut;
    begin
        @(negedge tb_clk); // synchronize to negedge edge so there are not hold or setup time violations
        
        // Activate reset
        tb_reset = RESET_ACTIVE;

        // Wait 2 clock cycles
        @(negedge tb_clk);
        @(negedge tb_clk);

        // Deactivate reset
        tb_reset = RESET_INACTIVE; 
    end
    endtask

    // Check output values against expected values
    task check_outputs;
        input logic tb_apple_exp;
    begin
        @(negedge tb_clk);  // Check away from the clock edge!
        if(tb_apple_exp == tb_apple)
            $info("Correct tb_apple value.");  
        else
            $error("Incorrect tb_apple value. Actual: %0d, Expected: %0d.", tb_apple, tb_apple_exp);
        

    end
    endtask 

    // DUT Portmap___________________________________________________________________________________________________________________________
    applegenerator DUT (
        .x(tb_x),
        .y(tb_y),
        .randX(tb_randX),
        .randY(tb_randY),
        .goodColl(tb_goodColl),
        .clk(tb_clk),
        .reset(tb_reset),
        .s_reset(tb_s_reset),
        .apple(tb_apple),
        .body(tb_body)
    ); 

    // Clock generation block___________________________________________________________________________________________________________________________
    always begin
        tb_clk = 1'b0; 
        #(CLK_PERIOD / 2.0);
        tb_clk = 1'b1; 
        #(CLK_PERIOD / 2.0); 
    end

    // Main Test Bench Process___________________________________________________________________________________________________________________________
    initial begin
        // Signal dump
        $dumpfile("dump.vcd");
        $dumpvars; 

        // Initialize test bench signals
        tb_reset = 1;
        for(int i = 0; i < 50; i++) begin
            tb_body[i] = 8'b00000000;
        end
        tb_body[0] = 8'b01000111; //102 on grid
        tb_body[1] = 8'b01000111; //88 on grid
        tb_body[2] = 8'b01000110; //74 on grid
        tb_body[3] = 8'b01000101; //60 on grid
        tb_x = 1;
        tb_y = 1;
        tb_randX = 5;
        tb_randY = 8;
        tb_goodColl = 0;
        tb_s_reset = 0;
        tb_test_num = 0;
        tb_test_name = "Initializing";

        // Wait some time before starting first test case
        #(0.1);

        ////////////////////////////
        // Test 1: Power-on-reset //
        ////////////////////////////

        tb_test_num += 1; 
        tb_test_name = "Power-on-reset";
        $display("\n\n%s", tb_test_name);
        reset_dut();

        // Set inputs
        for(int i = 0; i < 50; i++) begin
            tb_body[i] = 8'b0;
        end
        tb_body[0] = 8'b01000111; //102 on grid
        tb_body[1] = 8'b01000111; //88 on grid
        tb_body[2] = 8'b01000110; //74 on grid
        tb_body[3] = 8'b01000101; //60 on grid
        tb_x = 1;
        tb_y = 1;
        tb_randX = 5;
        tb_randY = 8;
        tb_goodColl = 0;
        tb_s_reset = 0;
        tb_reset = 0;
        @(posedge tb_clk);
        @(posedge tb_clk);
        tb_apple_exp = 0; 
        check_outputs(tb_apple_exp);

        ////////////////////////////
        // Test 2: Generating Apple //
        ////////////////////////////

        tb_test_num += 1; 
        tb_test_name = "Generating Apple";
        $display("\n\n%s", tb_test_name);
        reset_dut();

        /// Set inputs
        for(int i = 0; i < 50; i++) begin
            tb_body[i] = 8'b0;
        end
        tb_body[0] = 8'b01001000; //102 on grid
        tb_body[1] = 8'b01000111; //88 on grid
        tb_body[2] = 8'b01000110; //74 on grid
        tb_body[3] = 8'b01000101; //60 on grid
        tb_x = 5;
        tb_y = 8;
        tb_randX = 5; //0101
        tb_randY = 8; //1000
        tb_goodColl = 1;
        tb_s_reset = 0;
        tb_reset = 1;
        tb_apple_exp = 0; 
        check_outputs(tb_apple_exp);

        @(posedge tb_clk);
        @(posedge tb_clk);
        tb_apple_exp = 1; 
        check_outputs(tb_apple_exp); // checking whether apple is there

        /////////////////////////////
        // Test 3: Random Error //
        /////////////////////////////

        tb_test_num += 1; 
        tb_test_name = "Random Error";
        $display("\n\n%s", tb_test_name);
        reset_dut();

        // Set inputs
        for(int i = 0; i < 50; i++) begin
            tb_body[i] = 8'b0;
        end
        tb_body[0] = 8'b01001000; //102 on grid
        tb_body[1] = 8'b01000111; //88 on grid
        tb_body[2] = 8'b01000110; //74 on grid
        tb_body[3] = 8'b01000101; //60 on grid
        tb_x = 4;
        tb_y = 8;
        tb_randX = 4;
        tb_randY = 8;
        tb_goodColl = 1;
        tb_s_reset = 0;
        tb_reset = 1;

        @(posedge tb_clk);
        tb_apple_exp = 0; 
        check_outputs(tb_apple_exp);

        /////////////////////////////
        // Test 4:  //
        /////////////////////////////

        $finish; 
    end
endmodule
