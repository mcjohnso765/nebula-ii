// FPGA Top Level

`default_nettype none

module top (
  // I/O ports
  input  logic hwclk, reset,
  input  logic [20:0] pb,
  output logic [7:0] left, right,
         ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0,
  output logic red, green, blue,

  // UART ports
  output logic [7:0] txdata,
  input  logic [7:0] rxdata,
  output logic txclk, rxclk,
  input  logic txready, rxready
);

  logic snakeBody, snakeHead, apple, border, badColl, goodColl, obstacleFlag, obstacle, good_coll, bad_coll;
  logic [3:0] x, y, randX, randY, randX2, randY2;
  logic next_map_i, next_map_a;
  logic sync;
  logic [7:0] curr_length, dispScore;
  logic [3:0] bcd_ones, bcd_tens, bcd_hundreds, displayOut, dispObs;
  logic isGameComplete;
  logic [MAX_LENGTH-1:0][7:0] body;
  logic [1:0] blinkToggle;
  logic [1:0] junk;

  // The MAX_LENGTH value that the snake can store that will fit the size of the FPGA (subject to change with efficiency upgrades)
  localparam MAX_LENGTH = 78;

  // Handles the display output of the game to an 8-bit parallel MCU interface TFT display
  image_generator img_gen(.snakeBody(snakeBody), .snakeHead(snakeHead), .apple(apple), .border(border || obstacle), .KeyEnc(pb[0]), .GameOver(isGameComplete), .clk(hwclk), .nrst(~reset),
                          .sync(sync), .wr(left[0]), .dcx(left[1]), .D(right[7:0]), .x(x), .y(y));
  
  // Sets certain coordinates of the game to be permanent borders
  border_generator border_gen(.x(x), .y(y), .isBorder(border));
  
  // Generates and stores the location of the snake 
  snake_body_controller #(.MAX_LENGTH(MAX_LENGTH)) control(.direction_pb({pb[10], pb[6], pb[5], pb[7]}), .x(x), .y(y), .clk(hwclk), .pb_mode(pb[9]), .nrst(~reset), .sync(sync), .curr_length(curr_length), .body(body), .snakeHead(snakeHead), .snakeBody(snakeBody));
  
  // Determines if obstacle generation mode is toggled on or off 
  obstacleMode obsmode(.sync_reset(sync), .obstacle_pb(pb[8]), .clk(hwclk), .nrst(~reset), .obstacleFlag(obstacleFlag));
  
  // Creates random numbers based on if obstacle mode is on or off. When obstacle mode is off, apples can generate anywhere on the grid,
  // when obstacle mode is on, apples and obstacles generate on separate blocks
  obstacle_random obsrand1(.clk(hwclk), .nRst(~reset), .randX(randX), .randY(randY), .randX2(randX2), .randY2(randY2), .obstacleFlag(obstacleFlag));
  
  // Handles the generation of apples after a good collision
  applegenerator2 #(.MAX_LENGTH(MAX_LENGTH)) ag2(.x(x), .y(y), .randX(randX), .randY(randY), .goodColl(goodColl), .clk(hwclk), .reset(~reset), .s_reset(sync), .body(body), .apple(apple));
  
  // Handles the generation of obstacles after (usually) ever other good collision
  obstaclegen2 #(.MAX_LENGTH(MAX_LENGTH)) obsg2(.curr_length(curr_length), .obstacleCount(dispObs), .clk(hwclk), .nRst(~reset), .s_reset(sync), .body(body), .x(x), .y(y), .randX(randX2), .randY(randY2), .goodColl(goodColl), .obstacle(obstacle), .obstacleFlag(obstacleFlag));
  
  // Handles the logic that determines whether a good collision, a bad collision, or no collision have occured at a particular pixel
  collision coll(.clk(hwclk), .nRst(~reset), .snakeHead(snakeHead), .snakeBody(snakeBody), .border(border || obstacle), .apple(apple), .goodColl(goodColl), .badColl(badColl));
  
  // Edge Detector to prevent issues with the score updating incorrectly when a good collision is triggered
  score_posedge_detector score_detect(.clk(hwclk), .nRst(~reset), .goodColl_i(goodColl), .badColl_i(badColl), .goodColl(good_coll), .badColl(bad_coll));
  
  // Keeps track of both the high score and current score during a game session. High score shows once player dies, and current score shows 
  score_tracker3 track(.clk(hwclk), .nRst(~reset), .goodColl(good_coll), .current_score(curr_length), .badColl(bad_coll), .bcd_ones(bcd_ones), .bcd_tens(bcd_tens), .bcd_hundreds(bcd_hundreds), .dispScore(dispScore), .isGameComplete(isGameComplete));
  
  // Chooses which seven segment display to output
  toggle_screen toggle1(.displayOut(displayOut), .blinkToggle(blinkToggle), .clk(hwclk), .rst(~reset), .bcd_ones(bcd_ones), .bcd_tens(bcd_tens), .bcd_hundreds(bcd_hundreds));
  
  // Make sure these are outputting to 3-8 decoder and physical seven segment displays 
  ssdec ssdec1(.in(displayOut), .enable(blinkToggle == 1), .out(ss0[6:0]));
  ssdec ssdec2(.in(displayOut), .enable(blinkToggle == 2), .out(ss1[6:0]));
  ssdec ssdec3(.in(displayOut), .enable(blinkToggle == 0), .out(ss2[6:0]));

  // DEBUG
  // ssdec ssdec4(.in({3'b0, obstacleFlag}), .enable(1), .out(ss3[6:0])); // Shows if obstacle flag is active
  // ssdec ssdec5(.in(dispObs), .enable(1), .out(ss4[6:0])); // Shows the internal number of obstacles being accounted for

  // Controls what sounds are synthesized based on conditions of the game
  sound_generator sound_gen(.clk(hwclk), .rst(reset), .goodColl_i(goodColl), .badColl_i(badColl), .button_i(1'b0), .soundOut({left[7:2], junk}));
endmodule
