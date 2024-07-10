// $Id: $
// File name:   team_09.sv
// Created:     MM/DD/YYYY
// Author:      <Full Name>
// Description: <Module Description>

`default_nettype none

module team_09 (
    // HW
    input logic clk, nrst,
    
    input logic en, //This signal is an enable signal for your chip. Your design should disable if this is low.

    // Logic Analyzer - Grant access to all 128 LA
    input wire [127:0] la_data_in,
    output wire [127:0] la_data_out,
    input wire [127:0] la_oenb,

    // 34 out of 38 GPIOs (Note: if you need up to 38 GPIO, discuss with a TA)
    input  wire [33:0] gpio_in, // Breakout Board Pins
    output wire [33:0] gpio_out, // Breakout Board Pins
    output wire [33:0] gpio_oeb, // Active Low Output Enable
    
    /*
    * Add other I/O ports that you wish to interface with the
    * Wishbone bus to the management core. For examples you can 
    * add registers that can be written to with the Wishbone bus
    */
);

    // All outputs must have a value even if not used
    assign la_data_out = 128'b0;
    assign gpio_out[33:25] = 9'b0; //Inputs, but set low anyways
    assign gpio_oeb = 34'b0011111110000000000000000000000000;//All 1's inputs
    /*
    * Place code and sub-module instantiations here.
    */
    localparam MAX_LENGTH = 78;
    logic snakeBody, snakeHead, apple, border, badColl, goodColl, obstacleFlag, obstacle, good_coll, bad_coll;
    logic [3:0] x, y, randX, randY, randX2, randY2;
    logic next_map_i, next_map_a;
    logic sync;
    logic [7:0] curr_length, dispScore;
    logic [3:0] bcd_ones, bcd_tens, bcd_hundreds, displayOut, dispObs;
    logic isGameComplete;
    logic [MAX_LENGTH - 1:0][7:0] body;
    logic [1:0] blinkToggle;
    logic [1:0] junk;

    // The MAX_LENGTH value that the snake can store that will fit the size of the FPGA (subject to change with efficiency upgrades)

    // Handles the display output of the game to an 8-bit parallel MCU interface TFT display
    image_generator img_gen(.snakeBody(snakeBody), .snakeHead(snakeHead), .apple(apple), .border(border || obstacle), .KeyEnc(gpio_in[31]), .GameOver(isGameComplete), .clk(clk), .nrst(nrst&&en),
                            .sync(sync), .wr(gpio_out[9]), .dcx(gpio_out[8]), .D(gpio_out[7:0]), .x(x), .y(y));
  
    // Sets certain coordinates of the game to be permanent borders
    border_generator border_gen(.x(x), .y(y), .isBorder(border));
  
    // Generates and stores the location of the snake 
    snake_body_controller #(.MAX_LENGTH(MAX_LENGTH)) control(.direction_pb(gpio_in[28:25]), .x(x), .y(y), .clk(clk), .pb_mode(gpio_in[29]), .nrst(nrst&&en), .sync(sync), .curr_length(curr_length), .body(body), .snakeHead(snakeHead), .snakeBody(snakeBody));
  
    // Determines if obstacle generation mode is toggled on or off 
    obstacleMode obsmode(.sync_reset(sync), .obstacle_pb(gpio_in[30]), .clk(clk), .nrst(nrst||en), .obstacleFlag(obstacleFlag));
  
    // Creates random numbers based on if obstacle mode is on or off. When obstacle mode is off, apples can generate anywhere on the grid,
    // when obstacle mode is on, apples and obstacles generate on separate blocks
    obstacle_random obsrand1(.clk(clk), .nRst(nrst&&en), .randX(randX), .randY(randY), .randX2(randX2), .randY2(randY2), .obstacleFlag(obstacleFlag));
  
    // Handles the generation of apples after a good collision
    applegenerator2 #(.MAX_LENGTH(MAX_LENGTH)) ag2(.x(x), .y(y), .randX(randX), .randY(randY), .goodColl(goodColl), .clk(clk), .reset(nrst&&en), .s_reset(sync), .body(body), .apple(apple));
  
    // Handles the generation of obstacles after (usually) ever other good collision
    obstaclegen2 #(.MAX_LENGTH(MAX_LENGTH)) obsg2(.curr_length(curr_length), .obstacleCount(dispObs), .clk(clk), .nRst(nrst||en), .s_reset(sync), .body(body), .x(x), .y(y), .randX(randX2), .randY(randY2), .goodColl(goodColl), .obstacle(obstacle), .obstacleFlag(obstacleFlag));
  
    // Handles the logic that determines whether a good collision, a bad collision, or no collision have occured at a particular pixel
    collision coll(.clk(clk), .nRst(nrst&&en), .snakeHead(snakeHead), .snakeBody(snakeBody), .border(border || obstacle), .apple(apple), .goodColl(goodColl), .badColl(badColl));
  
    // Edge Detector to prevent issues with the score updating incorrectly when a good collision is triggered
    score_posedge_detector score_detect(.clk(clk), .nRst(nrst&&en), .goodColl_i(goodColl), .badColl_i(badColl), .goodColl(good_coll), .badColl(bad_coll));
  
    // Keeps track of both the high score and current score during a game session. High score shows once player dies, and current score shows 
    score_tracker3 track(.clk(clk), .nRst(nrst&&en), .goodColl(good_coll), .current_score(curr_length), .badColl(bad_coll), .bcd_ones(bcd_ones), .bcd_tens(bcd_tens), .bcd_hundreds(bcd_hundreds), .dispScore(dispScore), .isGameComplete(isGameComplete));
  
    // Chooses which seven segment display to output
    toggle_screen toggle1(.displayOut(displayOut), .blinkToggle(blinkToggle), .clk(clk), .rst(nrst&&en), .bcd_ones(bcd_ones), .bcd_tens(bcd_tens), .bcd_hundreds(bcd_hundreds));
  
    // Make sure these are outputting to 3-8 decoder and physical seven segment displays 
    ssdec ssdec1(.in(displayOut), .enable(1), .out(gpio_out[22:16]));

    assign gpio_out[24:23] = blinkToggle;

    // DEBUG
    // ssdec ssdec4(.in({3'b0, obstacleFlag}), .enable(1), .out(ss3[6:0])); // Shows if obstacle flag is active
    // ssdec ssdec5(.in(dispObs), .enable(1), .out(ss4[6:0])); // Shows the internal number of obstacles being accounted for

    // Controls what sounds are synthesized based on conditions of the game
sound_generator sound_gen(.clk(clk), .rst(~nrst&&~en), .goodColl_i(goodColl), .badColl_i(badColl), .button_i(1'b0), .soundOut({gpio_out[15:10], junk}));

endmodule
