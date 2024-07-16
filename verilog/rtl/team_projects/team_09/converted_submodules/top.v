`default_nettype none
module top (
	hwclk,
	reset,
	pb,
	left,
	right,
	ss7,
	ss6,
	ss5,
	ss4,
	ss3,
	ss2,
	ss1,
	ss0,
	red,
	green,
	blue,
	txdata,
	rxdata,
	txclk,
	rxclk,
	txready,
	rxready
);
	input wire hwclk;
	input wire reset;
	input wire [20:0] pb;
	output wire [7:0] left;
	output wire [7:0] right;
	output wire [7:0] ss7;
	output wire [7:0] ss6;
	output wire [7:0] ss5;
	output wire [7:0] ss4;
	output wire [7:0] ss3;
	output wire [7:0] ss2;
	output wire [7:0] ss1;
	output wire [7:0] ss0;
	output wire red;
	output wire green;
	output wire blue;
	output wire [7:0] txdata;
	input wire [7:0] rxdata;
	output wire txclk;
	output wire rxclk;
	input wire txready;
	input wire rxready;
	wire snakeBody;
	wire snakeHead;
	wire apple;
	wire border;
	wire badColl;
	wire goodColl;
	wire obstacleFlag;
	wire obstacle;
	wire good_coll;
	wire bad_coll;
	wire [3:0] x;
	wire [3:0] y;
	wire [3:0] randX;
	wire [3:0] randY;
	wire [3:0] randX2;
	wire [3:0] randY2;
	wire next_map_i;
	wire next_map_a;
	wire sync;
	wire [7:0] curr_length;
	wire [7:0] dispScore;
	wire [3:0] bcd_ones;
	wire [3:0] bcd_tens;
	wire [3:0] bcd_hundreds;
	wire [3:0] displayOut;
	wire [3:0] dispObs;
	wire isGameComplete;
	localparam MAX_LENGTH = 78;
	wire [623:0] body;
	wire [1:0] blinkToggle;
	wire [1:0] junk;
	image_generator img_gen(
		.snakeBody(snakeBody),
		.snakeHead(snakeHead),
		.apple(apple),
		.border(border || obstacle),
		.KeyEnc(pb[0]),
		.GameOver(isGameComplete),
		.clk(hwclk),
		.nrst(~reset),
		.sync(sync),
		.wr(left[0]),
		.dcx(left[1]),
		.D(right[7:0]),
		.x(x),
		.y(y)
	);
	border_generator border_gen(
		.x(x),
		.y(y),
		.isBorder(border)
	);
	snake_body_controller #(.MAX_LENGTH(MAX_LENGTH)) control(
		.direction_pb({pb[10], pb[6], pb[5], pb[7]}),
		.x(x),
		.y(y),
		.clk(hwclk),
		.pb_mode(pb[9]),
		.nrst(~reset),
		.sync(sync),
		.curr_length(curr_length),
		.body(body),
		.snakeHead(snakeHead),
		.snakeBody(snakeBody)
	);
	obstacleMode obsmode(
		.sync_reset(sync),
		.obstacle_pb(pb[8]),
		.clk(hwclk),
		.nrst(~reset),
		.obstacleFlag(obstacleFlag)
	);
	obstacle_random obsrand1(
		.clk(hwclk),
		.nRst(~reset),
		.randX(randX),
		.randY(randY),
		.randX2(randX2),
		.randY2(randY2),
		.obstacleFlag(obstacleFlag)
	);
	applegenerator2 #(.MAX_LENGTH(MAX_LENGTH)) ag2(
		.x(x),
		.y(y),
		.randX(randX),
		.randY(randY),
		.goodColl(goodColl),
		.clk(hwclk),
		.reset(~reset),
		.s_reset(sync),
		.body(body),
		.apple(apple)
	);
	obstaclegen2 #(.MAX_LENGTH(MAX_LENGTH)) obsg2(
		.curr_length(curr_length),
		.obstacleCount(dispObs),
		.clk(hwclk),
		.nRst(~reset),
		.s_reset(sync),
		.body(body),
		.x(x),
		.y(y),
		.randX(randX2),
		.randY(randY2),
		.goodColl(goodColl),
		.obstacle(obstacle),
		.obstacleFlag(obstacleFlag)
	);
	collision coll(
		.clk(hwclk),
		.nRst(~reset),
		.snakeHead(snakeHead),
		.snakeBody(snakeBody),
		.border(border || obstacle),
		.apple(apple),
		.goodColl(goodColl),
		.badColl(badColl)
	);
	score_posedge_detector score_detect(
		.clk(hwclk),
		.nRst(~reset),
		.goodColl_i(goodColl),
		.badColl_i(badColl),
		.goodColl(good_coll),
		.badColl(bad_coll)
	);
	score_tracker3 track(
		.clk(hwclk),
		.nRst(~reset),
		.goodColl(good_coll),
		.current_score(curr_length),
		.badColl(bad_coll),
		.bcd_ones(bcd_ones),
		.bcd_tens(bcd_tens),
		.bcd_hundreds(bcd_hundreds),
		.dispScore(dispScore),
		.isGameComplete(isGameComplete)
	);
	toggle_screen toggle1(
		.displayOut(displayOut),
		.blinkToggle(blinkToggle),
		.clk(hwclk),
		.rst(~reset),
		.bcd_ones(bcd_ones),
		.bcd_tens(bcd_tens),
		.bcd_hundreds(bcd_hundreds)
	);
	ssdec ssdec1(
		.in(displayOut),
		.enable(blinkToggle == 1),
		.out(ss0[6:0])
	);
	ssdec ssdec2(
		.in(displayOut),
		.enable(blinkToggle == 2),
		.out(ss1[6:0])
	);
	ssdec ssdec3(
		.in(displayOut),
		.enable(blinkToggle == 0),
		.out(ss2[6:0])
	);
	sound_generator sound_gen(
		.clk(hwclk),
		.rst(reset),
		.goodColl_i(goodColl),
		.badColl_i(badColl),
		.button_i(1'b0),
		.soundOut({left[7:2], junk})
	);
endmodule
