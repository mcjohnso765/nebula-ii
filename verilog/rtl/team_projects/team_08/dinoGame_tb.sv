`timescale 10ns/1ns
module tb;

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
     dinoGame DUT (
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

        tb_up = 1'b1;
        #(1000000000 * CLK_PERIOD);
        //tb_button = 1'b0;
        // #(6000000 * CLK_PERIOD);
        // check_outputs(8'd181);
        // #(6000000 * CLK_PERIOD);
        // check_outputs(8'd151);
        // #(2000000 * CLK_PERIOD);

        // //tb_button = 1'b1;
        // #CLK_PERIOD;
        // //tb_button = 1'b0;
        // #(3000000 * CLK_PERIOD);
        // //tb_button = 1'b1;
        // #CLK_PERIOD;
        // //tb_button = 1'b0;
        // #(3000000 * CLK_PERIOD);
        // check_outputs(8'd181);
        // #(2000000 * CLK_PERIOD);

        $finish;
    end

endmodule

// Module to keep track of the snake body and control it

/*module snakeGame (input clk, input up, input rst, input tft_sdo, output wire tft_sck, output wire tft_sdi, 
	output wire tft_dc, output wire tft_reset, output wire tft_cs,
	output wire[2:0] leds, output wire[2:0] tftstate, output dac_sdi, output dac_cs, output dac_sck, output test);

    // Required registers and wires

    
    wire[8:0] x;
	wire[7:0] y;
    reg button_press;
    reg r_floor,r_cactus,r_dino;
    reg [7:0] dinoY;
    reg [8:0] x_dist;
    reg [8:0] cactusX;
    reg [6:0] dinoX;
    reg [8:0] cactusY;
    reg collides;
    reg [1:0] cactusType1;
    reg [1:0] cactusType2;
    reg [1:0] cactusRandDist;
    reg [8:0] cactusHeight1;
    reg [8:0] cactusHeight2;
    reg dinoJumpGood;
    logic sync0, sync1;
    
    always_ff @(posedge clk, negedge rst) begin 
        if (!rst) begin
            sync0 <= 0;
            sync1 <= 0;
        end
        else begin
            sync0 <= up;
            sync1 <= sync0;
    end
    end
    
    // Clock dividers
    
    rectangleGenerator recGen(.clk(clk), .nRst(rst), .r_floor(r_floor), 
    .r_dino(r_dino), .r_cactus(r_cactus), .cactusH1(cactusHeight1), .cactusH2(cactusHeight2), .x(x), .y(y), .dinoY(dinoY), 
    .cactusX(cactusX), .x_dist(x_dist));
    
    dinoJump dinoJump(.clk(clk), .nRst(rst), .button(sync1), .dinoY(dinoY), 
    .dinoJumpGood(dinoJumpGood));
    
    cactusMove cactusMove(.clk(clk), .nRst(rst), .enable(1'b1), 
    .rng_input(cactusRandDist), .type1(cactusType1), .type2(cactusType2), .x_dist(x_dist), 
    .pixel(cactusX), .height1(cactusHeight1), .height2(cactusHeight2));

    collision_detector collision(.clk(clk), .reset(rst), .dinoY(dinoY), 
    .dinoX(9'd280), .dinoWidth(9'd20), .cactusX1(cactusX), .cactusRandDist(x_dist), .cactusY(9'd101), 
    .cactusHeight1(cactusHeight1), .cactusHeight2(cactusHeight2), .cactusWidth(9'd20), .collision_detect(collides));

    imageGenerator lcdOutput(.clk(clk), .rst(rst), .tft_sdo(tft_sdo), 
    .fatalCollision(collides), .r_cactus(r_cactus), 
    .r_dino(r_dino), .r_floor(r_floor), .x(x), .y(y), .tft_sck(tft_sck), .tft_sdi(tft_sdi), .tft_dc(tft_dc), 
    .tft_reset(tft_reset), .tft_cs(tft_cs), .tftstate(tftstate));

    random_generator cactus1size(.clk(clk), .rst_n(rst), .MCNT1(4'd3), .MCNT2(4'd5), .button_pressed(up), .rnd(cactusType1));
    random_generator cactus2size(.clk(clk), .rst_n(rst), .MCNT1(4'd2), .MCNT2(4'd7), .button_pressed(up), .rnd(cactusType2));
    random_generator cactusDist(.clk(clk), .rst_n(rst), .MCNT1(4'd3), .MCNT2(4'd5), .button_pressed(up), .rnd(cactusRandDist));

    
endmodule*/