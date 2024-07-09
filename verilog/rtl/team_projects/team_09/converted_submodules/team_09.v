`default_nettype none
module team_09 (
	clk,
	nrst,
	en,
	la_data_in,
	la_data_out,
	la_oenb,
	gpio_in,
	gpio_out,
	gpio_oeb
);
	input wire clk;
	input wire nrst;
	input wire en;
	input wire [127:0] la_data_in;
	output wire [127:0] la_data_out;
	input wire [127:0] la_oenb;
	input wire [33:0] gpio_in;
	output wire [33:0] gpio_out;
	output wire [33:0] gpio_oeb;
	assign la_data_out = 128'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
	assign gpio_oeb = 34'b0011111110000000000000000000000000;
	localparam MAX_LENGTH = 78;
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
	wire [623:0] body;
	wire [1:0] blinkToggle;
	wire [1:0] junk;
	image_generator img_gen(
		.snakeBody(snakeBody),
		.snakeHead(snakeHead),
		.apple(apple),
		.border(border || obstacle),
		.KeyEnc(gpio_in[31]),
		.GameOver(isGameComplete),
		.clk(clk),
		.nrst(nrst || en),
		.sync(sync),
		.wr(gpio_out[9]),
		.dcx(gpio_out[8]),
		.D(gpio_out[7:0]),
		.x(x),
		.y(y)
	);
	border_generator border_gen(
		.x(x),
		.y(y),
		.isBorder(border)
	);
	snake_body_controller #(.MAX_LENGTH(MAX_LENGTH)) control(
		.direction_pb(gpio_in[28:25]),
		.x(x),
		.y(y),
		.clk(clk),
		.pb_mode(gpio_in[29]),
		.nrst(nrst || en),
		.sync(sync),
		.curr_length(curr_length),
		.body(body),
		.snakeHead(snakeHead),
		.snakeBody(snakeBody)
	);
	obstacleMode obsmode(
		.sync_reset(sync),
		.obstacle_pb(gpio_in[30]),
		.clk(clk),
		.nrst(nrst || en),
		.obstacleFlag(obstacleFlag)
	);
	obstacle_random obsrand1(
		.clk(clk),
		.nRst(nrst || en),
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
		.clk(clk),
		.reset(nrst || en),
		.s_reset(sync),
		.body(body),
		.apple(apple)
	);
	obstaclegen2 #(.MAX_LENGTH(MAX_LENGTH)) obsg2(
		.curr_length(curr_length),
		.obstacleCount(dispObs),
		.clk(clk),
		.nRst(nrst || en),
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
		.clk(clk),
		.nRst(nrst || en),
		.snakeHead(snakeHead),
		.snakeBody(snakeBody),
		.border(border || obstacle),
		.apple(apple),
		.goodColl(goodColl),
		.badColl(badColl)
	);
	score_posedge_detector score_detect(
		.clk(clk),
		.nRst(nrst || en),
		.goodColl_i(goodColl),
		.badColl_i(badColl),
		.goodColl(good_coll),
		.badColl(bad_coll)
	);
	score_tracker3 track(
		.clk(clk),
		.nRst(nrst || en),
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
		.clk(clk),
		.rst(nrst),
		.bcd_ones(bcd_ones),
		.bcd_tens(bcd_tens),
		.bcd_hundreds(bcd_hundreds)
	);
	ssdec ssdec1(
		.in(displayOut),
		.enable(1),
		.out(gpio_out[22:16])
	);
	assign gpio_out[24:23] = blinkToggle;
	sound_generator sound_gen(
		.clk(clk),
		.rst(~nrst || ~en),
		.goodColl_i(goodColl),
		.badColl_i(badColl),
		.button_i(1'b0),
		.soundOut({gpio_out[15:10], junk})
	);
endmodule
