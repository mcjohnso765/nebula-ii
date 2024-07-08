// // FPGA Top Level

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

  localparam MAX_LENGTH = 78;

  image_generator img_gen(.snakeBody(snakeBody), .snakeHead(snakeHead), .apple(apple), .border(border || obstacle), .KeyEnc(pb[0]), .GameOver(isGameComplete), .clk(hwclk), .nrst(~reset),
                          .sync(sync), .wr(left[0]), .dcx(left[1]), .D(right[7:0]), .x(x), .y(y));
  //curr_length_increment increase(.button(pb[1]), .clk(hwclk), .nrst(~reset), .sync(sync), .curr_length(curr_length));
  snake_body_controller #(.MAX_LENGTH(MAX_LENGTH)) control(.direction_pb({pb[10], pb[6], pb[5], pb[7]}), .x(x), .y(y), .clk(hwclk), .pb_mode(pb[9]), .nrst(~reset), .sync(sync), .curr_length(curr_length), .body(body), .snakeHead(snakeHead), .snakeBody(snakeBody));
  //random rand123(.clk(hwclk), .nRst(~reset), .randX(randX), .randY(randY));
  obstacleMode obsmode(.sync_reset(sync), .obstacle_pb(pb[8]), .clk(hwclk), .nrst(~reset), .obstacleFlag(obstacleFlag));
  //assign obstacleFlag = 1;
  //assign left[0] = obstacleFlag;
  obstacle_random obsrand1(.clk(hwclk), .nRst(~reset), .randX(randX), .randY(randY), .randX2(randX2), .randY2(randY2), .obstacleFlag(obstacleFlag));
  applegenerator2 #(.MAX_LENGTH(MAX_LENGTH)) ag2(.x(x), .y(y), .randX(randX), .randY(randY), .goodColl(goodColl), .clk(hwclk), .reset(~reset), .s_reset(sync), .body(body), .apple(apple));
  obstaclegen2 #(.MAX_LENGTH(MAX_LENGTH)) obsg2(.curr_length(curr_length), .obstacleCount(dispObs), .clk(hwclk), .nRst(~reset), .s_reset(sync), .body(body), .x(x), .y(y), .randX(randX2), .randY(randY2), .goodColl(goodColl), .obstacle(obstacle), .obstacleFlag(obstacleFlag));
  collision coll(.clk(hwclk), .nRst(~reset), .snakeHead(snakeHead), .snakeBody(snakeBody), .border(border || obstacle), .apple(apple), .goodColl(goodColl), .badColl(badColl));
  // collision coll(.clk(hwclk), .nRst(~reset), .snakeHead(snakeHead), .snakeBody(snakeBody), .border(border), .apple(apple), .goodColl(goodColl), .badColl(badColl));
  //score_tracker2 track(.clk(hwclk), .nRst(~reset), .goodColl(goodColl), .badColl(badColl), .current_score(curr_length), .dispScore(dispScore), .bcd_ones(bcd_ones), .bcd_tens(bcd_tens), .isGameComplete(isGameComplete));
  score_posedge_detector score_detect(.clk(hwclk), .nRst(~reset), .goodColl_i(goodColl), .badColl_i(badColl), .goodColl(good_coll), .badColl(bad_coll));
  score_tracker3 track(.clk(hwclk), .nRst(~reset), .goodColl(good_coll), .current_score(curr_length), .badColl(bad_coll), .bcd_ones(bcd_ones), .bcd_tens(bcd_tens), .bcd_hundreds(bcd_hundreds), .dispScore(dispScore), .isGameComplete(isGameComplete));
  toggle_screen toggle1(.displayOut(displayOut), .blinkToggle(blinkToggle), .clk(hwclk), .rst(~reset), .bcd_ones(bcd_ones), .bcd_tens(bcd_tens), .bcd_hundreds(bcd_hundreds));
  ssdec ssdec1(.in(displayOut), .enable(blinkToggle == 1), .out(ss0[6:0]));
  ssdec ssdec2(.in(displayOut), .enable(blinkToggle == 2), .out(ss1[6:0]));
  ssdec ssdec3(.in(displayOut), .enable(blinkToggle == 0), .out(ss2[6:0]));
  ssdec ssdec4(.in({3'b0, obstacleFlag}), .enable(1), .out(ss3[6:0]));
  ssdec ssdec5(.in(dispObs), .enable(1), .out(ss4[6:0]));
  border_generator border_gen(.x(x), .y(y), .isBorder(border));
  sound_generator sound_gen(.clk(hwclk), .rst(reset), .goodColl_i(goodColl), .badColl_i(badColl), .button_i(1'b0), .soundOut({left[7:2], junk}));
endmodule
