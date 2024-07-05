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
  logic [6:0] curr_length;
  logic [49:0][7:0] body;
  logic x, y;
  logic randX, randY;
  logic sync, sync_i;
  logic snakeHead, snakeBody, apple, border, goodColl, badColl;
  logic [3:0] displayOut, bcd_ones, bcd_tens;
  logic blinkToggle;
  logic gameComplete;

  synchronizer synch(.button(pb[0]), .clk(hwclk), .nrst(~reset), .signal(sync_i));
  edge_detect detect(.signal(sync_i), .clk(hwclk), .nrst(~reset), .change_state(sync));
  //curr_length_increment increase(.button(pb[0]), .clk(hwclk), .nrst(~reset), .sync(sync), .curr_length(curr_length));

  snake_body_controller control(.direction_pb({pb[10], pb[2], pb[7], pb[5]}), .x(pb[19:16]), .y(pb[15:12]), .clk(hwclk), .pb_mode(pb[6]), .nrst(~reset), .sync(sync), .curr_length(curr_length), .body(body), .snakeHead(snakeHead), .snakeBody(snakeBody));

  //make sure reset input lines up and stuff
  border_generator bg1 (.x(x), .y(y), .isBorder(border));
  random r1 (.clk(hwclk), .nRst(~reset), .randX(randX), .randY(randY));
  applegenerator2 ag2 (.x(x), .y(y), .randX(randX), .randY(randY), .goodColl(goodColl), .clk(hwclk), .reset(~reset), .s_reset(sync), .body(body), .apple(apple));
  collision c1 (.clk(hwclk), .nRst(~reset), .snakeHead(snakeHead), .snakeBody(snakeBody), .border(border), .apple(apple), .goodColl(goodColl), .badColl(badColl));
  score_display2 sd2 (.clk(hwclk), .rst(~reset), .bcd_ones(bcd_ones), .bcd_tens(bcd_tens), .displayOut(displayOut), .blinkToggle(blinkToggle));
  score_tracker track1 (.clk(hwclk), .nRst(~reset), .goodColl(goodColl), .badColl(badColl), .dispScore(curr_length), .isGameComplete(gameComplete), .bcd_ones(bcd_ones), .bcd_tens(bcd_tens)); //where is gameComplete being linked to?
  ssdec ssdec1(.in(displayOut), .enable(blinkToggle), .out(ss0[6:0]));
  ssdec ssdec2(.in(displayOut), .enable(~blinkToggle), .out(ss1[6:0]));
  image_generator img_gen(.snakeBody(snakeBody), .snakeHead(snakeHead), .apple(apple), .border(border), .KeyEnc(pb[0]), .GameOver(gameComplete), .clk(hwclk), .nrst(~reset),
                          .sync(sync), .wr(left[0]), .dcx(left[1]), .D(right[7:0]), .x(x), .y(y));

endmodule
