module t08_cactusMove (
	clk,
	nRst,
	enable,
	rng_input,
	type1,
	type2,
	drawDoneCactus,
	state,
	x_dist,
	pixel,
	height1,
	height2,
	cactusMovement
);
	reg _sv2v_0;
	input wire clk;
	input wire nRst;
	input wire enable;
	input wire [1:0] rng_input;
	input wire [1:0] type1;
	input wire [1:0] type2;
	input wire drawDoneCactus;
	input wire [2:0] state;
	output reg [8:0] x_dist;
	output reg [8:0] pixel;
	output reg [8:0] height1;
	output reg [8:0] height2;
	output reg cactusMovement;
	reg [8:0] x_distance;
	reg [8:0] n_pixel;
	reg [8:0] n_h1;
	reg [8:0] n_h2;
	wire [1:0] x;
	reg [31:0] n_count;
	reg [31:0] count;
	wire [31:0] max_i;
	reg atmax;
	reg n_cactusMovement;
	always @(posedge clk or negedge nRst)
		if (~nRst)
			cactusMovement <= 0;
		else
			cactusMovement <= n_cactusMovement;
	always @(*) begin
		if (_sv2v_0)
			;
		if (n_pixel != pixel)
			n_cactusMovement = 1;
		else if (drawDoneCactus)
			n_cactusMovement = 0;
		else
			n_cactusMovement = cactusMovement;
	end
	assign max_i = 60000;
	always @(posedge clk or negedge nRst)
		if (!nRst)
			count <= 0;
		else
			count <= n_count;
	always @(*) begin
		if (_sv2v_0)
			;
		n_count = count;
		atmax = 0;
		case (state)
			3'd0: n_count = 0;
			3'd1: begin
				if (enable) begin
					n_count = count + 1;
					if (count == max_i)
						n_count = 0;
				end
				if (count == max_i)
					atmax = 1;
				else
					atmax = 0;
			end
			3'd3: n_count = 0;
			3'd2: n_count = 0;
			default: n_count = 0;
		endcase
	end
	always @(posedge clk or negedge nRst)
		if (!nRst)
			pixel <= -190;
		else
			pixel <= n_pixel;
	always @(*) begin
		if (_sv2v_0)
			;
		n_pixel = pixel;
		case (state)
			3'd0: n_pixel = 0;
			3'd1:
				if (atmax) begin
					if ((pixel <= 320) || (pixel >= 322))
						n_pixel = pixel + 1;
					else
						n_pixel = -189;
				end
			3'd2: n_pixel = 0;
			3'd3: n_pixel = 0;
			default: n_pixel = 0;
		endcase
	end
	always @(*) begin
		if (_sv2v_0)
			;
		x_distance = x_dist;
		n_h1 = height1;
		n_h2 = height2;
		case (state)
			3'd0: begin
				x_distance = 0;
				n_h1 = 0;
				n_h2 = 0;
			end
			3'd1: begin
				if (pixel == 320)
					case (rng_input)
						2'b00: x_distance = 100;
						2'b01: x_distance = 130;
						2'b10: x_distance = 160;
						2'b11: x_distance = 189;
						default: x_distance = 100;
					endcase
				else
					x_distance = x_dist;
				if (pixel == 320)
					case (type1)
						2'b00: n_h1 = 15;
						2'b01: n_h1 = 20;
						2'b10: n_h1 = 30;
						2'b11: n_h1 = 40;
						default: n_h1 = 40;
					endcase
				else
					n_h1 = height1;
				if (pixel == 320)
					case (type2)
						2'b00: n_h2 = 15;
						2'b01: n_h2 = 20;
						2'b10: n_h2 = 30;
						2'b11: n_h2 = 49;
						default: n_h2 = 40;
					endcase
				else
					n_h2 = height2;
			end
			3'd3: begin
				x_distance = 0;
				n_h1 = 0;
				n_h2 = 0;
			end
			3'd2: begin
				x_distance = 0;
				n_h1 = 0;
				n_h2 = 0;
			end
			default: begin
				x_distance = 0;
				n_h1 = 0;
				n_h2 = 0;
			end
		endcase
	end
	always @(posedge clk or negedge nRst)
		if (!nRst) begin
			x_dist <= 189;
			height1 <= 40;
			height2 <= 40;
		end
		else begin
			x_dist <= x_distance;
			height1 <= n_h1;
			height2 <= n_h2;
		end
	initial _sv2v_0 = 0;
endmodule

module t08_pll (
	in_clk,
	lcd_clk,
	locked
);
	input in_clk;
	output wire lcd_clk;
	output wire locked;
	wire BYPASS = 0;
	wire RESETB = 1;
	SB_PLL40_CORE #(
		.FEEDBACK_PATH("PHASE_AND_DELAY"),
		.DELAY_ADJUSTMENT_MODE_FEEDBACK("FIXED"),
		.DELAY_ADJUSTMENT_MODE_RELATIVE("FIXED"),
		.PLLOUT_SELECT("SHIFTREG_0deg"),
		.SHIFTREG_DIV_MODE(1'b1),
		.FDA_FEEDBACK(4'b0000),
		.FDA_RELATIVE(4'b0000),
		.DIVR(4'd5),
		.DIVF(7'd4),
		.DIVQ(3'd0),
		.FILTER_RANGE(3'd1)
	) pll(
		.REFERENCECLK(in_clk),
		.PLLOUTCORE(lcd_clk),
		.BYPASS(BYPASS),
		.RESETB(RESETB),
		.LOCK(locked)
	);
endmodule

module team_08_GPIOPins (
	in,
	out,
	clk,
	reset
);
	input wire [33:0] in;
	output wire [33:0] out;
	input wire clk;
	input wire reset;
	wire cs;
	wire cd;
	wire wr;
	wire rd;
	wire tft_sck;
	wire tft_sdi;
	wire tft_dc;
	wire tft_reset;
	wire tft_cs;
	wire [6:0] ones_score;
	wire [6:0] tens_score;
	wire up;
	wire collides;
	wire [7:0] data;
	team_08_dinoGame game(
		.clk(clk),
		.rst(~in[0] & reset),
		.up(in[1]),
		.collides(out[30]),
		.cs(cs),
		.cd(cd),
		.wr(wr),
		.rd(rd),
		.data(data),
		.tft_sck(tft_sck),
		.tft_sdi(tft_sdi),
		.tft_dc(tft_dc),
		.tft_reset(tft_reset),
		.tft_cs(tft_cs),
		.ones_score(ones_score),
		.tens_score(tens_score)
	);
	assign out[33:31] = 0;
	assign out[2:0] = 0;
	assign out[22:16] = ones_score;
	assign out[29:23] = tens_score;
	assign out[15:8] = (in[2] ? 0 : data);
	assign out[3] = (in[2] ? tft_sck : cs);
	assign out[4] = (in[2] ? tft_sdi : cd);
	assign out[5] = (in[2] ? tft_dc : wr);
	assign out[6] = (in[2] ? tft_reset : rd);
	assign out[7] = (in[2] ? tft_cs : 0);
endmodule
module team_08_GameState (
	clk,
	reset,
	collision_detect,
	button_pressed,
	score,
	state
);
	reg _sv2v_0;
	input wire clk;
	input wire reset;
	input wire collision_detect;
	input wire button_pressed;
	input wire [6:0] score;
	output reg [2:0] state;
	reg [2:0] next_state;
	always @(posedge clk or negedge reset)
		if (!reset)
			state <= 3'd0;
		else
			state <= next_state;
	always @(*) begin
		if (_sv2v_0)
			;
		next_state = state;
		case (state)
			3'd0:
				if (button_pressed)
					next_state = 3'd1;
			3'd1:
				if (score > 101)
					next_state = 3'd2;
				else if (score == 99)
					next_state = 3'd3;
			3'd3:
				if (button_pressed)
					next_state = 3'd0;
			3'd2:
				if (button_pressed)
					next_state = 3'd0;
			default: next_state = 3'd0;
		endcase
	end
	initial _sv2v_0 = 0;
endmodule

module team_08_cactusMove (
	clk,
	nRst,
	enable,
	rng_input,
	type1,
	type2,
	drawDoneCactus,
	state,
	x_dist,
	pixel,
	height1,
	height2,
	cactusMovement
);
	reg _sv2v_0;
	input wire clk;
	input wire nRst;
	input wire enable;
	input wire [1:0] rng_input;
	input wire [1:0] type1;
	input wire [1:0] type2;
	input wire drawDoneCactus;
	input wire [2:0] state;
	output reg [8:0] x_dist;
	output reg [8:0] pixel;
	output reg [8:0] height1;
	output reg [8:0] height2;
	output reg cactusMovement;
	reg [8:0] x_distance;
	reg [8:0] n_pixel;
	reg [8:0] n_h1;
	reg [8:0] n_h2;
	wire [1:0] x;
	reg [31:0] n_count;
	reg [31:0] count;
	wire [31:0] max_i;
	reg atmax;
	reg n_cactusMovement;
	always @(posedge clk or negedge nRst)
		if (~nRst)
			cactusMovement <= 0;
		else
			cactusMovement <= n_cactusMovement;
	always @(*) begin
		if (_sv2v_0)
			;
		if (n_pixel != pixel)
			n_cactusMovement = 1;
		else if (drawDoneCactus)
			n_cactusMovement = 0;
		else
			n_cactusMovement = cactusMovement;
	end
	assign max_i = 240000;
	always @(posedge clk or negedge nRst)
		if (!nRst)
			count <= 0;
		else
			count <= n_count;
	always @(*) begin
		if (_sv2v_0)
			;
		n_count = count;
		atmax = 0;
		case (state)
			3'd0: n_count = 0;
			3'd1: begin
				n_count = count + 1;
				if (count == max_i)
					n_count = 0;
				if (count == max_i)
					atmax = 1;
				else
					atmax = 0;
			end
			3'd3: n_count = 0;
			3'd2: n_count = 0;
			default: n_count = 0;
		endcase
	end
	always @(posedge clk or negedge nRst)
		if (!nRst)
			pixel <= 328;
		else
			pixel <= n_pixel;
	always @(*) begin
		if (_sv2v_0)
			;
		n_pixel = pixel;
		case (state)
			3'd0: n_pixel = pixel;
			3'd1:
				if (atmax)
					n_pixel = pixel + 4;
			3'd2:
				;
			3'd3:
				;
			default:
				;
		endcase
	end
	always @(*) begin
		if (_sv2v_0)
			;
		x_distance = x_dist;
		n_h1 = height1;
		n_h2 = height2;
		case (state)
			3'd0:
				;
			3'd1: begin
				if ((pixel == 320) && drawDoneCactus)
					case (rng_input)
						2'b00: x_distance = 100;
						2'b01: x_distance = 130;
						2'b10: x_distance = 160;
						2'b11: x_distance = 180;
						default: x_distance = 100;
					endcase
				else
					x_distance = x_dist;
				if ((pixel == 320) && drawDoneCactus)
					case (type1)
						2'b00: n_h1 = 15;
						2'b01: n_h1 = 20;
						2'b10: n_h1 = 30;
						2'b11: n_h1 = 40;
						default: n_h1 = 40;
					endcase
				else
					n_h1 = height1;
				if ((pixel == 320) && drawDoneCactus)
					case (type2)
						2'b00: n_h2 = 15;
						2'b01: n_h2 = 20;
						2'b10: n_h2 = 30;
						2'b11: n_h2 = 40;
						default: n_h2 = 40;
					endcase
				else
					n_h2 = height2;
			end
			3'd3:
				;
			3'd2:
				;
			default:
				;
		endcase
	end
	always @(posedge clk or negedge nRst)
		if (!nRst) begin
			x_dist <= 180;
			height1 <= 40;
			height2 <= 40;
		end
		else begin
			x_dist <= x_distance;
			height1 <= n_h1;
			height2 <= n_h2;
		end
	initial _sv2v_0 = 0;
endmodule
module team_08_collision_detector (
	clk,
	reset,
	dinoY,
	dinoX,
	dinoWidth,
	state,
	cactusX1,
	cactusRandDist,
	cactusY,
	cactusHeight1,
	cactusHeight2,
	cactusWidth,
	collision_detect
);
	reg _sv2v_0;
	input wire clk;
	input wire reset;
	input wire [8:0] dinoY;
	input wire [8:0] dinoX;
	input wire [8:0] dinoWidth;
	input wire [2:0] state;
	input wire [8:0] cactusX1;
	input wire [8:0] cactusRandDist;
	input wire [8:0] cactusY;
	input wire [8:0] cactusHeight1;
	input wire [8:0] cactusHeight2;
	input wire [8:0] cactusWidth;
	output reg collision_detect;
	wire [8:0] cactusX2;
	reg collision_detect1;
	reg collision_detect2;
	assign cactusX2 = cactusX1 + cactusRandDist;
	always @(*) begin
		if (_sv2v_0)
			;
		collision_detect = 0;
		collision_detect1 = 0;
		collision_detect2 = 0;
		case (state)
			3'd0: collision_detect = 0;
			3'd1: begin
				if (dinoY <= (cactusY + cactusHeight1)) begin
					if ((cactusX1 < (dinoWidth + dinoX)) & ((dinoWidth + dinoX) <= (cactusX1 + cactusWidth)))
						collision_detect1 = 1;
					else if ((cactusX1 < dinoX) & (dinoX <= (cactusX1 + cactusWidth)))
						collision_detect1 = 1;
					else
						collision_detect1 = 0;
				end
				else
					collision_detect1 = 0;
				if (dinoY <= (cactusY + cactusHeight2)) begin
					if ((cactusX2 < (dinoWidth + dinoX)) & ((dinoWidth + dinoX) <= (cactusX2 + cactusWidth)))
						collision_detect2 = 1;
					else if ((cactusX2 < dinoX) & (dinoX <= (cactusX2 + cactusWidth)))
						collision_detect2 = 1;
					else
						collision_detect2 = 0;
				end
				else
					collision_detect2 = 0;
				collision_detect = collision_detect1 || collision_detect2;
			end
			3'd2: collision_detect = 0;
			3'd3: collision_detect = 0;
			default: collision_detect = 0;
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
module team_08_dinoGame (
	clk,
	up,
	rst,
	tft_sck,
	tft_sdi,
	tft_dc,
	tft_reset,
	tft_cs,
	cs,
	cd,
	rd,
	wr,
	data,
	ones_score,
	tens_score,
	collides
);
	input clk;
	input up;
	input rst;
	output wire tft_sck;
	output wire tft_sdi;
	output wire tft_dc;
	output wire tft_reset;
	output wire tft_cs;
	output wire cs;
	output wire cd;
	output wire rd;
	output wire wr;
	output wire [7:0] data;
	output wire [6:0] ones_score;
	output wire [6:0] tens_score;
	output wire collides;
	wire [8:0] x;
	wire [7:0] y;
	reg r_floor;
	reg r_cactus;
	reg r_dino;
	reg r_cloud;
	reg r_over;
	reg r_idle;
	reg r_win;
	reg [7:0] dinoY;
	reg [8:0] x_dist;
	reg [8:0] cactusX;
	reg [6:0] dinoX;
	reg [8:0] cactusY;
	reg [1:0] cactusType1;
	reg [1:0] cactusType2;
	reg [1:0] cactusRandDist;
	reg [7:0] cactusHeight1;
	reg [8:0] cactusHeight2;
	reg dinoJumpGood;
	reg sync0;
	reg sync1;
	reg det;
	wire edge_det;
	wire [2:0] state;
	reg [6:0] score;
	reg [7:0] v;
	reg [3:0] bcd_ones;
	reg [3:0] bcd_tens;
	reg [3:0] displayOut;
	reg drawDoneDino;
	reg dinoMovement;
	reg drawDoneCactus;
	reg cactusMovement;
	wire game_over;
	assign game_over = state == 3'd2;
	always @(posedge clk or negedge rst)
		if (!rst) begin
			sync0 <= 0;
			sync1 <= 0;
			det <= 0;
		end
		else begin
			sync0 <= up;
			sync1 <= sync0;
			det <= sync1;
		end
	assign edge_det = sync1 && !det;
	wire [2:1] sv2v_tmp_controller_received;
	always @(*) {drawDoneCactus, drawDoneDino} = sv2v_tmp_controller_received;
	team_08_parallelDisplay controller(
		.clk(clk),
		.rst(rst),
		.move_enable({cactusMovement, dinoMovement}),
		.dinoY(dinoY),
		.cactusX1(cactusX),
		.cactusH1(cactusHeight1),
		.cactusH2(cactusHeight2),
		.v(v),
		.cs(cs),
		.cd(cd),
		.wr(wr),
		.x_dist(x_dist),
		.rd(rd),
		.data(data),
		.received(sv2v_tmp_controller_received)
	);
	team_08_GameState game(
		.clk(clk),
		.reset(rst),
		.collision_detect(collides),
		.button_pressed(edge_det),
		.score(score),
		.state(state)
	);
	wire [1:1] sv2v_tmp_recGen_r_floor;
	always @(*) r_floor = sv2v_tmp_recGen_r_floor;
	wire [1:1] sv2v_tmp_recGen_r_cloud;
	always @(*) r_cloud = sv2v_tmp_recGen_r_cloud;
	wire [1:1] sv2v_tmp_recGen_r_idle;
	always @(*) r_idle = sv2v_tmp_recGen_r_idle;
	wire [1:1] sv2v_tmp_recGen_r_over;
	always @(*) r_over = sv2v_tmp_recGen_r_over;
	wire [1:1] sv2v_tmp_recGen_r_win;
	always @(*) r_win = sv2v_tmp_recGen_r_win;
	wire [1:1] sv2v_tmp_recGen_r_dino;
	always @(*) r_dino = sv2v_tmp_recGen_r_dino;
	wire [1:1] sv2v_tmp_recGen_r_cactus;
	always @(*) r_cactus = sv2v_tmp_recGen_r_cactus;
	team_08_rectangleGenerator recGen(
		.clk(clk),
		.nRst(rst),
		.state(state),
		.cactusH1(cactusHeight1),
		.cactusH2(cactusHeight2),
		.x(x),
		.y(y),
		.dinoY(dinoY),
		.cactusX(cactusX),
		.x_dist(x_dist),
		.r_floor(sv2v_tmp_recGen_r_floor),
		.r_cloud(sv2v_tmp_recGen_r_cloud),
		.r_idle(sv2v_tmp_recGen_r_idle),
		.r_over(sv2v_tmp_recGen_r_over),
		.r_win(sv2v_tmp_recGen_r_win),
		.r_dino(sv2v_tmp_recGen_r_dino),
		.r_cactus(sv2v_tmp_recGen_r_cactus)
	);
	wire [8:1] sv2v_tmp_dinoJump_dinoY;
	always @(*) dinoY = sv2v_tmp_dinoJump_dinoY;
	wire [8:1] sv2v_tmp_dinoJump_v;
	always @(*) v = sv2v_tmp_dinoJump_v;
	wire [1:1] sv2v_tmp_dinoJump_dinoMovement;
	always @(*) dinoMovement = sv2v_tmp_dinoJump_dinoMovement;
	wire [1:1] sv2v_tmp_dinoJump_dinoJumpGood;
	always @(*) dinoJumpGood = sv2v_tmp_dinoJump_dinoJumpGood;
	team_08_dinoJump dinoJump(
		.clk(clk),
		.nRst(rst),
		.state(state),
		.button(sync1),
		.drawDoneDino(drawDoneDino),
		.dinoY(sv2v_tmp_dinoJump_dinoY),
		.v(sv2v_tmp_dinoJump_v),
		.dinoMovement(sv2v_tmp_dinoJump_dinoMovement),
		.dinoJumpGood(sv2v_tmp_dinoJump_dinoJumpGood)
	);
	wire [9:1] sv2v_tmp_cactusMove_x_dist;
	always @(*) x_dist = sv2v_tmp_cactusMove_x_dist;
	wire [9:1] sv2v_tmp_cactusMove_pixel;
	always @(*) cactusX = sv2v_tmp_cactusMove_pixel;
	wire [8:1] sv2v_tmp_cactusMove_height1;
	always @(*) cactusHeight1 = sv2v_tmp_cactusMove_height1;
	wire [9:1] sv2v_tmp_cactusMove_height2;
	always @(*) cactusHeight2 = sv2v_tmp_cactusMove_height2;
	wire [1:1] sv2v_tmp_cactusMove_cactusMovement;
	always @(*) cactusMovement = sv2v_tmp_cactusMove_cactusMovement;
	team_08_cactusMove cactusMove(
		.clk(clk),
		.nRst(rst),
		.enable(1'b1),
		.state(state),
		.rng_input(cactusRandDist),
		.type1(cactusType1),
		.type2(cactusType2),
		.drawDoneCactus(drawDoneCactus),
		.x_dist(sv2v_tmp_cactusMove_x_dist),
		.pixel(sv2v_tmp_cactusMove_pixel),
		.height1(sv2v_tmp_cactusMove_height1),
		.height2(sv2v_tmp_cactusMove_height2),
		.cactusMovement(sv2v_tmp_cactusMove_cactusMovement)
	);
	team_08_collision_detector collision(
		.clk(clk),
		.reset(rst),
		.dinoY(dinoY),
		.state(state),
		.dinoX(9'd280),
		.dinoWidth(9'd20),
		.cactusX1(cactusX),
		.cactusRandDist(x_dist),
		.cactusY(9'd101),
		.cactusHeight1(cactusHeight1),
		.cactusHeight2(cactusHeight2),
		.cactusWidth(9'd20),
		.collision_detect(collides)
	);
	team_08_imageGenerator lcdOutput(
		.clk(clk),
		.rst(rst),
		.r_idle(r_idle),
		.r_over(r_over),
		.r_win(r_win),
		.r_cactus(r_cactus),
		.r_cloud(r_cloud),
		.r_dino(r_dino),
		.r_floor(r_floor),
		.x(x),
		.y(y),
		.tft_sck(tft_sck),
		.tft_sdi(tft_sdi),
		.tft_dc(tft_dc),
		.tft_reset(tft_reset),
		.tft_cs(tft_cs)
	);
	wire [2:1] sv2v_tmp_cactus1size_rnd;
	always @(*) cactusType1 = sv2v_tmp_cactus1size_rnd;
	team_08_random_generator cactus1size(
		.clk(clk),
		.rst_n(rst),
		.MCNT1(4'd3),
		.MCNT2(4'd5),
		.button_pressed(edge_det),
		.state(state),
		.rnd(sv2v_tmp_cactus1size_rnd)
	);
	wire [2:1] sv2v_tmp_cactus2size_rnd;
	always @(*) cactusType2 = sv2v_tmp_cactus2size_rnd;
	team_08_random_generator cactus2size(
		.clk(clk),
		.rst_n(rst),
		.MCNT1(4'd2),
		.MCNT2(4'd7),
		.button_pressed(edge_det),
		.state(state),
		.rnd(sv2v_tmp_cactus2size_rnd)
	);
	wire [2:1] sv2v_tmp_cactusDist_rnd;
	always @(*) cactusRandDist = sv2v_tmp_cactusDist_rnd;
	team_08_random_generator cactusDist(
		.clk(clk),
		.rst_n(rst),
		.MCNT1(4'd3),
		.MCNT2(4'd5),
		.button_pressed(edge_det),
		.state(state),
		.rnd(sv2v_tmp_cactusDist_rnd)
	);
	wire [4:1] sv2v_tmp_scoreCounter_bcd_ones;
	always @(*) bcd_ones = sv2v_tmp_scoreCounter_bcd_ones;
	wire [4:1] sv2v_tmp_scoreCounter_bcd_tens;
	always @(*) bcd_tens = sv2v_tmp_scoreCounter_bcd_tens;
	wire [7:1] sv2v_tmp_scoreCounter_score;
	always @(*) score = sv2v_tmp_scoreCounter_score;
	team_08_score_counter scoreCounter(
		.clk(clk),
		.reset(rst),
		.collision_detect(collides),
		.state(state),
		.bcd_ones(sv2v_tmp_scoreCounter_bcd_ones),
		.bcd_tens(sv2v_tmp_scoreCounter_bcd_tens),
		.score(sv2v_tmp_scoreCounter_score)
	);
	team_08_ssdec ones(
		.in(bcd_ones),
		.enable(1'b1),
		.out(ones_score)
	);
	team_08_ssdec tens(
		.in(bcd_tens),
		.enable(1'b1),
		.out(tens_score)
	);
endmodule
module team_08_dinoJump (
	clk,
	nRst,
	button,
	state,
	drawDoneDino,
	dinoY,
	dinoJumpGood,
	v,
	dinoMovement
);
	reg _sv2v_0;
	input wire clk;
	input wire nRst;
	input wire button;
	input wire [2:0] state;
	input wire drawDoneDino;
	output reg [7:0] dinoY;
	output reg dinoJumpGood;
	output reg [7:0] v;
	output reg dinoMovement;
	reg n_dinoMovement;
	reg [7:0] floorY = 8'd100;
	reg [7:0] onFloor = 8'd101;
	reg en;
	reg en2;
	reg [20:0] count;
	reg [20:0] next_count;
	reg [20:0] dinoDelay;
	reg [20:0] next_dinoDelay;
	reg [7:0] next_v;
	reg [7:0] next_dinoY;
	reg at_max;
	reg maxdinoDelay;
	always @(posedge clk or negedge nRst)
		if (~nRst) begin
			v <= 8'd0;
			dinoY <= 8'd101;
		end
		else begin
			v <= next_v;
			dinoY <= next_dinoY;
		end
	always @(posedge clk or negedge nRst)
		if (~nRst) begin
			count <= 0;
			dinoDelay <= 0;
		end
		else begin
			count <= next_count;
			dinoDelay <= next_dinoDelay;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		if (dinoY == onFloor)
			en = 1'b1;
		else
			en = 1'b0;
		if (next_dinoY == onFloor)
			en2 = 1'b1;
		else
			en2 = 1'b0;
	end
	always @(posedge clk or negedge nRst)
		if (~nRst)
			dinoMovement <= 0;
		else
			dinoMovement <= n_dinoMovement;
	always @(*) begin
		if (_sv2v_0)
			;
		if (next_dinoY != dinoY)
			n_dinoMovement = 1;
		else if (drawDoneDino)
			n_dinoMovement = 0;
		else
			n_dinoMovement = dinoMovement;
	end
	always @(*) begin
		if (_sv2v_0)
			;
		next_dinoDelay = dinoDelay;
		maxdinoDelay = 0;
		case (state)
			3'd0: begin
				maxdinoDelay = 0;
				next_dinoDelay = 0;
			end
			3'd1: begin
				maxdinoDelay = 0;
				if (!button) begin
					next_dinoDelay = 0;
					maxdinoDelay = 0;
				end
				else if (button) begin
					next_dinoDelay = dinoDelay + 1;
					if (dinoDelay == 300000) begin
						next_dinoDelay = 0;
						maxdinoDelay = 1;
					end
					else if (at_max)
						next_dinoDelay = 0;
					else
						maxdinoDelay = 0;
				end
				else begin
					next_dinoDelay = dinoDelay;
					maxdinoDelay = maxdinoDelay;
				end
			end
			3'd3: begin
				maxdinoDelay = 0;
				next_dinoDelay = 0;
			end
			3'd2: begin
				maxdinoDelay = 0;
				next_dinoDelay = 0;
			end
			default: next_dinoDelay = 0;
		endcase
	end
	reg n_dinoJumpGood;
	always @(posedge clk or negedge nRst)
		if (!nRst)
			dinoJumpGood <= 0;
		else
			dinoJumpGood <= n_dinoJumpGood;
	always @(*) begin
		if (_sv2v_0)
			;
		if (en && maxdinoDelay)
			n_dinoJumpGood = 1;
		else if (next_v == 0)
			n_dinoJumpGood = 0;
		else
			n_dinoJumpGood = dinoJumpGood;
	end
	always @(*) begin
		if (_sv2v_0)
			;
		next_dinoY = 101;
		next_count = count;
		next_v = v;
		at_max = 0;
		case (state)
			3'd0: begin
				next_dinoY = 101;
				at_max = 0;
			end
			3'd1: begin
				next_count = 0;
				at_max = 0;
				if (en && maxdinoDelay)
					next_count = 0;
				else if (count == 400000) begin
					next_count = 0;
					at_max = 1;
				end
				else
					next_count = count + 1;
				if (en && maxdinoDelay) begin
					next_v = 8'd10;
					next_dinoY = dinoY + 11;
				end
				else if (at_max) begin
					next_dinoY = dinoY + v;
					if (en2 && !maxdinoDelay)
						next_v = 8'd0;
					else
						next_v = v - 1;
				end
				else begin
					next_dinoY = dinoY;
					next_v = v;
				end
			end
			3'd2: begin
				next_dinoY = 0;
				at_max = 0;
			end
			3'd3: begin
				next_dinoY = 0;
				at_max = 0;
			end
			default: next_dinoY = 0;
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
module team_08_imageGenerator (
	clk,
	rst,
	r_cactus,
	r_dino,
	r_floor,
	r_cloud,
	r_idle,
	r_over,
	r_win,
	x,
	y,
	tft_sck,
	tft_sdi,
	tft_dc,
	tft_reset,
	tft_cs
);
	input clk;
	input rst;
	input r_cactus;
	input r_dino;
	input r_floor;
	input r_cloud;
	input r_idle;
	input r_over;
	input r_win;
	output wire [8:0] x;
	output wire [7:0] y;
	output wire tft_sck;
	output wire tft_sdi;
	output wire tft_dc;
	output wire tft_reset;
	output wire tft_cs;
	wire [2:0] tftstate;
	wire tft_clk;
	wire clk_10khz;
	assign tft_clk = clk;
	reg [16:0] framebufferIndex = 17'd0;
	wire fbClk;
	initial framebufferIndex = 17'd0;
	always @(posedge fbClk) framebufferIndex <= (framebufferIndex + 1'b1) % 17'sd76800;
	function automatic [8:0] sv2v_cast_9;
		input reg [8:0] inp;
		sv2v_cast_9 = inp;
	endfunction
	assign x = sv2v_cast_9(framebufferIndex / 240);
	function automatic [7:0] sv2v_cast_8;
		input reg [7:0] inp;
		sv2v_cast_8 = inp;
	endfunction
	assign y = sv2v_cast_8(framebufferIndex % 240);
	wire [15:0] currentPixel = (r_floor ? 16'd0 : (r_cactus ? 16'b0000000000011111 : (r_dino ? 16'b0000011111100000 : (r_cloud ? 16'd0 : (r_win ? 16'd0 : (r_idle ? 16'd0 : (r_over ? 16'd0 : 16'b0011111111111111)))))));
	team_08_tft_ili9341 #(.INPUT_CLK_MHZ(12)) tft(
		.clk(tft_clk),
		.tft_sck(tft_sck),
		.tft_sdi(tft_sdi),
		.tft_dc(tft_dc),
		.tft_reset(tft_reset),
		.tft_cs(tft_cs),
		.framebufferData(currentPixel),
		.framebufferClk(fbClk),
		.tftstate(tftstate)
	);
endmodule
module team_08_parallelDisplay (
	clk,
	rst,
	move_enable,
	dinoY,
	cactusX1,
	x_dist,
	cactusH1,
	cactusH2,
	v,
	cs,
	cd,
	wr,
	rd,
	data,
	received
);
	reg _sv2v_0;
	input wire clk;
	input wire rst;
	input wire [1:0] move_enable;
	input wire [7:0] dinoY;
	input wire [8:0] cactusX1;
	input wire [8:0] x_dist;
	input wire [7:0] cactusH1;
	input wire [7:0] cactusH2;
	input wire [7:0] v;
	output wire cs;
	output wire cd;
	output wire wr;
	output wire rd;
	output wire [7:0] data;
	output reg [1:0] received;
	wire init_done;
	reg [1:0] current_object;
	wire block_done;
	reg [3:0] state;
	reg [8:0] x_start;
	reg [8:0] x_end;
	reg [8:0] cactusX2;
	reg [7:0] y_start;
	reg [7:0] y_end;
	reg [15:0] color;
	reg [8:0] d_x_start;
	reg [8:0] d_x_end;
	reg [7:0] d_y_start;
	reg [7:0] d_y_end;
	reg [15:0] d_color;
	reg [8:0] c1_x_start;
	reg [8:0] c1_x_end;
	reg [7:0] c1_y_start;
	reg [7:0] c1_y_end;
	reg [15:0] c1_color;
	reg [8:0] c2_x_start;
	reg [8:0] c2_x_end;
	reg [7:0] c2_y_start;
	reg [7:0] c2_y_end;
	reg [15:0] c2_color;
	wire cs_init;
	wire cd_init;
	wire wr_init;
	wire rd_init;
	wire [7:0] data_init;
	wire cs_draw;
	wire cd_draw;
	wire wr_draw;
	wire rd_draw;
	wire [7:0] data_draw;
	t08_tft_init init_module(
		.clk(clk),
		.rst(rst),
		.cs(cs_init),
		.cd(cd_init),
		.wr(wr_init),
		.rd(rd_init),
		.data(data_init),
		.init_done(init_done),
		.state()
	);
	t08_draw_block drawBlock(
		.clk(clk),
		.rst(rst),
		.init_done(init_done),
		.x_start(x_start),
		.x_end(x_end),
		.y_start(y_start),
		.y_end(y_end),
		.color(color),
		.cs(cs_draw),
		.cd(cd_draw),
		.wr(wr_draw),
		.rd(rd_draw),
		.data(data_draw),
		.block_done(block_done),
		.state(),
		.idx()
	);
	assign {cs, cd, wr, rd, data} = (init_done ? {cs_draw, cd_draw, wr_draw, rd_draw, data_draw} : {cs_init, cd_init, wr_init, rd_init, data_init});
	always @(*) begin
		if (_sv2v_0)
			;
		cactusX2 = cactusX1 + x_dist;
		d_x_start = 9'd280;
		d_x_end = 9'd300;
		d_y_start = dinoY;
		d_y_end = dinoY + 8'd40;
		d_color = 16'h0000;
		c1_x_start = cactusX1;
		c1_x_end = cactusX1 + 9'd20;
		c1_y_start = 8'd101;
		c1_y_end = 8'd101 + cactusH1;
		c1_color = 16'h07e0;
		c2_x_start = cactusX2;
		c2_x_end = cactusX2 + 9'd20;
		c2_y_start = 8'd101;
		c2_y_end = 8'd101 + cactusH2;
		c2_color = 16'h001f;
	end
	always @(posedge clk or negedge rst)
		if (!rst) begin
			state <= 4'd0;
			current_object <= 0;
			received <= 2'b00;
		end
		else begin
			state <= state;
			received <= 2'b00;
			x_start <= 1;
			x_end <= 1;
			y_start <= 1;
			y_end <= 1;
			color <= 16'heeee;
			case (state)
				4'd0: begin
					x_start <= 9'd0;
					x_end <= 9'd320;
					y_start <= 8'b00000000;
					y_end <= 8'd240;
					color <= 16'heeee;
					if (block_done) begin
						state <= 4'd1;
						current_object <= 0;
					end
				end
				4'd1: begin
					x_start <= d_x_start;
					x_end <= d_x_end;
					y_start <= d_y_start;
					y_end <= d_y_end;
					color <= d_color;
					if (block_done)
						state <= 4'd2;
				end
				4'd2:
					if (move_enable[0] && block_done) begin
						current_object <= 0;
						state <= 4'd3;
					end
					else if (move_enable[1] && block_done)
						state <= 4'd4;
					else
						state <= 4'd2;
				4'd3: begin
					if ((v == 0) && (dinoY == 8'd101)) begin
						x_start <= d_x_start;
						x_end <= d_x_end;
						y_start <= d_y_end + 1;
						y_end <= d_y_end + 12;
						color <= 16'heeee;
					end
					else if ((v >= 0) && (v < 12)) begin
						x_start <= d_x_start;
						x_end <= d_x_end;
						y_start <= (d_y_start - v) - 1;
						y_end <= d_y_start - 1;
						color <= 16'heeee;
					end
					else begin
						x_start <= d_x_start;
						x_end <= d_x_end;
						y_start <= d_y_end + 1;
						y_end <= (d_y_end - v) + 2;
						color <= 16'heeee;
					end
					received <= 2'b01;
					if (block_done) begin
						state <= 4'd6;
						current_object <= 0;
					end
				end
				4'd4: begin
					if ((c1_x_start - 12) > (c1_x_start - 1))
						state <= 4'd7;
					else begin
						x_start <= c1_x_start - 12;
						x_end <= c1_x_start - 1;
						y_start <= c1_y_start;
						y_end <= c1_y_start + 40;
						color <= 16'heeee;
					end
					if (block_done) begin
						state <= 4'd7;
						current_object <= 1;
					end
				end
				4'd5: begin
					if ((c2_x_start - 12) > (c2_x_start - 1))
						state <= 4'd8;
					else begin
						x_start <= c2_x_start - 12;
						x_end <= c2_x_start - 1;
						y_start <= c2_y_start;
						y_end <= c2_y_start + 40;
						color <= 16'heeee;
					end
					if (block_done) begin
						state <= 4'd8;
						current_object <= 1;
					end
				end
				4'd6: begin
					if ((v == 0) && (dinoY == 8'd101)) begin
						x_start <= d_x_start;
						x_end <= d_x_end;
						y_start <= dinoY;
						y_end <= dinoY + 12;
						color <= d_color;
					end
					else if ((v >= 0) && (v < 12)) begin
						x_start <= d_x_start;
						x_end <= d_x_end;
						y_start <= d_y_end - v;
						y_end <= d_y_end;
						color <= d_color;
					end
					else begin
						x_start <= d_x_start;
						x_end <= d_x_end;
						y_start <= dinoY;
						y_end <= dinoY - v;
						color <= d_color;
					end
					if (block_done) begin
						state <= 4'd2;
						current_object <= 0;
					end
				end
				4'd7: begin
					if ((c1_x_end + 4) < (c1_x_end - 7))
						state <= 4'd5;
					else begin
						x_start <= c1_x_end - 7;
						x_end <= c1_x_end + 4;
						y_start <= c1_y_start;
						y_end <= c1_y_end;
						color <= c1_color;
					end
					if (block_done) begin
						state <= 4'd5;
						current_object <= 1;
					end
				end
				4'd8: begin
					if ((c2_x_end + 4) < (c2_x_end - 7))
						state <= 4'd9;
					else begin
						x_start <= c2_x_end - 7;
						x_end <= c2_x_end + 4;
						y_start <= c2_y_start;
						y_end <= c2_y_end;
						color <= 16'h0000;
					end
					if (block_done) begin
						state <= 4'd9;
						current_object <= 2;
					end
				end
				4'd9: begin
					x_start <= d_x_start;
					x_end <= d_x_end;
					y_start <= d_y_start;
					y_end <= d_y_end;
					color <= d_color;
					received <= 2'b10;
					if (block_done) begin
						state <= 4'd2;
						current_object <= 2;
					end
				end
			endcase
		end
	initial _sv2v_0 = 0;
endmodule
module t08_draw_block (
	clk,
	rst,
	init_done,
	x_start,
	x_end,
	y_start,
	y_end,
	color,
	cs,
	cd,
	wr,
	rd,
	data,
	block_done,
	state,
	idx
);
	reg _sv2v_0;
	input wire clk;
	input wire rst;
	input wire init_done;
	input wire [8:0] x_start;
	input wire [8:0] x_end;
	input wire [7:0] y_start;
	input wire [7:0] y_end;
	input wire [15:0] color;
	output reg cs;
	output reg cd;
	output reg wr;
	output reg rd;
	output reg [7:0] data;
	output reg block_done;
	output reg [3:0] state;
	output reg [4:0] idx;
	reg [20:0] counter;
	wire [1:0] pixel_state;
	always @(posedge clk or negedge rst)
		if (!rst) begin
			state <= 4'd0;
			wr <= 1;
			counter <= 0;
			block_done <= 0;
			idx <= 0;
		end
		else if (init_done) begin
			block_done <= 0;
			counter <= counter;
			idx <= idx;
			case (state)
				4'd0: state <= 4'd1;
				4'd1: begin
					wr <= 0;
					if (idx <= 12)
						idx <= idx + 1;
					else if (idx == 13) begin
						idx <= 12;
						counter <= counter + 1;
					end
					if (counter == (((x_end - x_start) + 1) * ((y_end - y_start) + 1)))
						state <= 4'd3;
					else
						state <= 4'd2;
				end
				4'd2: begin
					wr <= 1;
					state <= 4'd1;
				end
				4'd3: begin
					block_done <= 1;
					counter <= 0;
					idx <= 0;
					state <= 4'd0;
				end
			endcase
			if ((x_start > x_end) || (y_start > y_end))
				state <= 4'd3;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		cs = 0;
		cd = 0;
		rd = 1;
		data = 8'b00000000;
		case (idx)
			default: begin
				cs = 0;
				cd = 0;
				rd = 1;
				data = 8'b00000000;
			end
			5'd0: begin
				cs = 0;
				cd = 0;
				rd = 1;
				data = 8'b00000000;
			end
			5'd1: begin
				cs = 0;
				cd = 0;
				rd = 1;
				data = 8'h2a;
			end
			5'd2: begin
				cd = 1;
				rd = 1;
				data = 8'h00;
			end
			5'd3: begin
				cd = 1;
				data = y_start;
			end
			5'd4: begin
				cd = 1;
				data = 8'h00;
			end
			5'd5: begin
				cd = 1;
				data = y_end;
			end
			5'd6: begin
				cs = 0;
				cd = 0;
				rd = 1;
				data = 8'h2b;
			end
			5'd7: begin
				cd = 1;
				rd = 1;
				data = {7'b0000000, x_start[8]};
			end
			5'd8: begin
				cd = 1;
				data = x_start[7:0];
			end
			5'd9: begin
				cd = 1;
				data = {7'b0000000, x_end[8]};
			end
			5'd10: begin
				cd = 1;
				data = x_end[7:0];
			end
			5'd11: begin
				cs = 0;
				cd = 0;
				rd = 1;
				data = 8'h2c;
			end
			5'd12: begin
				cd = 1;
				rd = 1;
				data = color[15:8];
			end
			5'd13: begin
				cd = 1;
				data = color[7:0];
			end
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
module t08_tft_init (
	clk,
	rst,
	cs,
	cd,
	wr,
	rd,
	data,
	init_done,
	state
);
	reg _sv2v_0;
	input wire clk;
	input wire rst;
	output reg cs;
	output reg cd;
	output reg wr;
	output reg rd;
	output reg [7:0] data;
	output reg init_done;
	output reg [3:0] state;
	reg [5:0] idx;
	reg [23:0] delay_counter;
	always @(posedge clk or negedge rst)
		if (!rst) begin
			state <= 4'd0;
			wr <= 1;
			delay_counter <= 0;
			init_done <= 0;
			idx <= 0;
		end
		else begin
			init_done <= 0;
			idx <= idx;
			case (state)
				4'd0: state <= 4'd1;
				4'd1: begin
					wr <= 0;
					delay_counter <= 0;
					if ((idx == 2) || (idx == 6)) begin
						state <= 4'd1;
						delay_counter <= delay_counter + 1;
						if (delay_counter >= 24'd200000) begin
							state <= 4'd2;
							idx <= idx + 1;
						end
					end
					else if (idx < 6) begin
						idx <= idx + 1;
						state <= 4'd2;
					end
					else
						state <= 4'd3;
				end
				4'd2: begin
					wr <= 1;
					state <= 4'd1;
				end
				4'd3: begin
					init_done <= 1;
					state <= 4'd3;
					idx <= 6;
				end
				default: state <= 4'd0;
			endcase
		end
	always @(*) begin
		if (_sv2v_0)
			;
		cs = 0;
		cd = 0;
		rd = 1;
		data = 8'b00000000;
		case (idx)
			0: begin
				cs = 0;
				cd = 0;
				rd = 1;
				data = 8'b00000000;
			end
			1: begin
				cs = 0;
				cd = 0;
				rd = 1;
				data = 8'h01;
			end
			2: begin
				cs = 0;
				cd = 0;
				rd = 1;
				data = 8'h28;
			end
			3: begin
				cd = 0;
				rd = 1;
				data = 8'h3a;
			end
			4: begin
				cd = 1;
				data = 8'h55;
			end
			5: begin
				cs = 0;
				cd = 0;
				rd = 1;
				data = 8'h11;
			end
			6: begin
				cs = 0;
				cd = 0;
				rd = 1;
				data = 8'h29;
			end
			7: begin
				cs = 0;
				cd = 0;
				rd = 1;
				data = 8'b00000000;
			end
			default: begin
				cs = 0;
				cd = 0;
				rd = 1;
				data = 8'b00000000;
			end
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
module team_08_random_generator (
	clk,
	rst_n,
	MCNT1,
	MCNT2,
	button_pressed,
	state,
	rnd
);
	reg _sv2v_0;
	input wire clk;
	input wire rst_n;
	input wire [3:0] MCNT1;
	input wire [3:0] MCNT2;
	input wire button_pressed;
	input wire [2:0] state;
	output reg [1:0] rnd;
	wire slow_clk1;
	wire slow_clk2;
	wire [3:0] MCNT;
	t08_clock_div0 clock_div_inst0(
		.clk(clk),
		.reset(rst_n),
		.button_pressed(button_pressed),
		.MCNT(MCNT1),
		.clk1(slow_clk1)
	);
	t08_clock_div0 clock_div_inst1(
		.clk(clk),
		.reset(rst_n),
		.button_pressed(button_pressed),
		.MCNT(MCNT2),
		.clk1(slow_clk2)
	);
	reg [1:0] lfsr1;
	reg [1:0] n_lfsr1;
	reg feedback1;
	reg [1:0] lfsr2;
	reg [1:0] n_lfsr2;
	reg feedback2;
	always @(posedge clk or negedge rst_n)
		if (!rst_n)
			lfsr1 <= 2'b11;
		else
			lfsr1 <= n_lfsr1;
	always @(posedge clk or negedge rst_n)
		if (!rst_n)
			lfsr2 <= 2'b10;
		else
			lfsr2 <= n_lfsr2;
	always @(*) begin
		if (_sv2v_0)
			;
		feedback1 = lfsr1[1] ^ lfsr1[0];
		feedback2 = lfsr2[1] ^ lfsr2[0];
		n_lfsr1 = lfsr1;
		n_lfsr2 = lfsr2;
		rnd = lfsr1 ^ lfsr2;
		case (state)
			3'd0: begin
				n_lfsr1 = 2'b11;
				n_lfsr2 = 2'b10;
				rnd = lfsr1 ^ lfsr2;
			end
			3'd1: begin
				if (slow_clk1) begin
					feedback1 = lfsr1[1] ^ lfsr1[0];
					n_lfsr1 = {lfsr1[0], feedback1};
				end
				else begin
					feedback1 = feedback1;
					n_lfsr1 = lfsr1;
				end
				if (slow_clk2) begin
					feedback2 = lfsr2[1] ^ lfsr2[0];
					n_lfsr2 = {lfsr2[0], feedback2};
				end
				else begin
					feedback2 = feedback2;
					n_lfsr2 = lfsr2;
				end
				rnd = lfsr1 ^ lfsr2;
			end
			3'd2: begin
				n_lfsr1 = 2'b11;
				n_lfsr2 = 2'b10;
			end
			3'd3: begin
				n_lfsr1 = 2'b11;
				n_lfsr2 = 2'b10;
			end
			default: begin
				n_lfsr1 = 0;
				n_lfsr2 = 0;
			end
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
module t08_clock_div0 (
	clk,
	reset,
	button_pressed,
	MCNT,
	clk1
);
	input wire clk;
	input wire reset;
	input wire button_pressed;
	input wire [3:0] MCNT;
	output reg clk1;
	reg [13:0] counter;
	always @(posedge clk or negedge reset)
		if (!reset)
			counter <= 0;
		else if (button_pressed)
			counter <= 0;
		else if (counter == (MCNT - 1)) begin
			counter <= 0;
			clk1 = 1;
		end
		else begin
			counter <= counter + 1;
			clk1 = 0;
		end
endmodule
module team_08_rectangleGenerator (
	clk,
	nRst,
	x,
	y,
	dinoY,
	cactusH1,
	cactusH2,
	x_dist,
	cactusX,
	state,
	r_floor,
	r_dino,
	r_cactus,
	r_cloud,
	r_idle,
	r_over,
	r_win
);
	reg _sv2v_0;
	input wire clk;
	input wire nRst;
	input wire [8:0] x;
	input wire [7:0] y;
	input wire [7:0] dinoY;
	input wire [7:0] cactusH1;
	input wire [7:0] cactusH2;
	input wire [8:0] x_dist;
	input wire [8:0] cactusX;
	input wire [2:0] state;
	output reg r_floor;
	output reg r_dino;
	output reg r_cactus;
	output reg r_cloud;
	output reg r_idle;
	output reg r_over;
	output reg r_win;
	reg floor;
	reg dino;
	reg cactus;
	reg cloud;
	reg idle;
	reg over;
	reg win;
	reg [7:0] dinoH = 40;
	reg [8:0] cactusW = 20;
	always @(posedge clk)
		if (!nRst) begin
			r_floor <= 1'sb0;
			r_cactus <= 1'sb0;
			r_dino <= 1'sb0;
			r_cloud <= 1'sb0;
			r_idle <= 1'sb0;
			r_over <= 1'sb0;
			r_win <= 1'sb0;
		end
		else begin
			r_floor <= floor;
			r_cactus <= cactus;
			r_dino <= dino;
			r_cloud <= cloud;
			r_idle <= idle;
			r_over <= over;
			r_win <= win;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		win = 0;
		over = 0;
		idle = 0;
		case (state)
			3'd0: begin
				if (y <= 100)
					floor = 1;
				else
					floor = 0;
				dino = 0;
				cactus = 0;
				cloud = 0;
				win = 0;
				over = 0;
				if (((((((((((((((((((((((((((x >= 8) && (x <= 24)) && (y >= 162)) && (y <= 210)) || ((((x >= 24) && (x <= 56)) && (y >= 194)) && (y <= 210))) || ((((x >= 40) && (x <= 56)) && (y >= 186)) && (y <= 194))) || ((((x >= 24) && (x <= 40)) && (y >= 146)) && (y <= 162))) || ((((x >= 24) && (x <= 40)) && (y >= 130)) && (y <= 138))) || ((((x >= 64) && (x <= 112)) && (y >= 194)) && (y <= 210))) || ((((x >= 80) && (x <= 96)) && (y >= 130)) && (y <= 194))) || ((((x >= 120) && (x <= 168)) && (y >= 194)) && (y <= 210))) || ((((x >= 120) && (x <= 136)) && (y >= 170)) && (y <= 194))) || ((((x >= 128) && (x <= 136)) && (y >= 162)) && (y <= 170))) || ((((x >= 120) && (x <= 136)) && (y >= 130)) && (y <= 162))) || ((((x >= 136) && (x <= 152)) && (y >= 162)) && (y <= 178))) || ((((x >= 152) && (x <= 168)) && (y >= 130)) && (y <= 194))) || ((((x >= 176) && (x <= 192)) && (y >= 130)) && (y <= 210))) || ((((x >= 200) && (x <= 216)) && (y >= 130)) && (y <= 210))) || ((((x >= 192) && (x <= 200)) && (y >= 194)) && (y <= 210))) || ((((x >= 192) && (x <= 200)) && (y >= 162)) && (y <= 178))) || ((((x >= 224) && (x <= 272)) && (y >= 194)) && (y <= 210))) || ((((x >= 240) && (x <= 256)) && (y >= 130)) && (y <= 194))) || ((((x >= 280) && (x <= 312)) && (y >= 194)) && (y <= 210))) || ((((x >= 296) && (x <= 312)) && (y >= 178)) && (y <= 194))) || ((((x >= 280) && (x <= 312)) && (y >= 162)) && (y <= 178))) || ((((x >= 280) && (x <= 296)) && (y >= 146)) && (y <= 162))) || ((((x >= 280) && (x <= 312)) && (y >= 130)) && (y <= 146)))
					idle = 1;
				else
					idle = 0;
			end
			3'd1: begin
				if (y <= 100)
					floor = 1;
				else
					floor = 0;
				if (((((x >= cactusX) && (x <= (cactusX + cactusW))) && (y >= 101)) && (y <= (101 + cactusH1))) || ((((x >= (cactusX + x_dist)) && (x <= ((cactusX + x_dist) + cactusW))) && (y >= 101)) && (y <= (101 + cactusH2))))
					cactus = 1;
				else
					cactus = 0;
				if ((((((((((x >= 280) && (x <= 288)) && (y >= (dinoY + 32))) && (y <= (dinoY + 38))) || ((((x >= 284) && (x <= 288)) && (y >= (dinoY + 14))) && (y <= (dinoY + 32)))) || ((((x >= 282) && (x <= 296)) && (y >= (dinoY + 6))) && (y <= (dinoY + 14)))) || ((((x >= 284) && (x <= 286)) && (y >= dinoY)) && (y <= (dinoY + 6)))) || ((((x >= 294) && (x <= 296)) && (y >= dinoY)) && (y <= (dinoY + 6)))) || ((((x >= 296) && (x <= 298)) && (y >= (dinoY + 8))) && (y <= (dinoY + 12)))) || ((((x >= 298) && (x <= 300)) && (y >= (dinoY + 10))) && (y <= (dinoY + 14))))
					dino = 1;
				else
					dino = 0;
				if ((((((((((x >= (cactusX + 34)) && (x <= (cactusX + 44))) && (y >= 220)) && (y <= 222)) || ((((x >= (cactusX + 30)) && (x <= (cactusX + 26))) && (y >= 222)) && (y <= 224))) || ((((x >= (cactusX + 34)) && (x <= (cactusX + 30))) && (y >= 224)) && (y <= 226))) || ((((x >= (cactusX + 38)) && (x <= (cactusX + 38))) && (y >= 226)) && (y <= 228))) || ((((x >= (cactusX + 48)) && (x <= (cactusX + 42))) && (y >= 224)) && (y <= 226))) || ((((x >= (cactusX + 52)) && (x <= (cactusX + 44))) && (y >= 224)) && (y <= 228))) || (((((((((x >= ((cactusX + x_dist) + 34)) && (x <= ((cactusX + x_dist) + 44))) && (y >= 220)) && (y <= 222)) || ((((x >= ((cactusX + x_dist) + 30)) && (x <= ((cactusX + x_dist) + 26))) && (y >= 222)) && (y <= 224))) || ((((x >= ((cactusX + x_dist) + 34)) && (x <= ((cactusX + x_dist) + 30))) && (y >= 224)) && (y <= 226))) || ((((x >= ((cactusX + x_dist) + 38)) && (x <= ((cactusX + x_dist) + 38))) && (y >= 226)) && (y <= 228))) || ((((x >= ((cactusX + x_dist) + 48)) && (x <= ((cactusX + x_dist) + 42))) && (y >= 224)) && (y <= 226))) || ((((x >= ((cactusX + x_dist) + 52)) && (x <= ((cactusX + x_dist) + 44))) && (y >= 224)) && (y <= 228))))
					cloud = 1;
				else
					cloud = 0;
				win = 0;
				over = 0;
				idle = 0;
			end
			3'd2: begin
				if (y <= 100)
					floor = 1;
				else
					floor = 0;
				dino = 0;
				cactus = 0;
				cloud = 0;
				win = 0;
				idle = 0;
				if ((((((((((((((((((((((x >= 230) && (x <= 300)) && (y >= 120)) && (y <= 140)) || ((((x >= 230) && (x <= 300)) && (y >= 200)) && (y <= 220))) || ((((x >= 280) && (x <= 300)) && (y >= 120)) && (y <= 220))) || ((((x >= 230) && (x <= 250)) && (y >= 120)) && (y <= 220))) || ((((x >= 200) && (x <= 220)) && (y >= 150)) && (y <= 220))) || ((((x >= 150) && (x <= 170)) && (y >= 150)) && (y <= 220))) || ((((x >= 190) && (x <= 210)) && (y >= 140)) && (y <= 150))) || ((((x >= 160) && (x <= 180)) && (y >= 140)) && (y <= 150))) || ((((x >= 170) && (x <= 200)) && (y >= 120)) && (y <= 140))) || ((((x >= 120) && (x <= 140)) && (y >= 120)) && (y <= 220))) || ((((x >= 90) && (x <= 120)) && (y >= 200)) && (y <= 220))) || ((((x >= 90) && (x <= 120)) && (y >= 160)) && (y <= 180))) || ((((x >= 90) && (x <= 120)) && (y >= 120)) && (y <= 140))) || ((((x >= 20) && (x <= 80)) && (y >= 200)) && (y <= 220))) || ((((x >= 60) && (x <= 80)) && (y >= 120)) && (y <= 200))) || ((((x >= 30) && (x <= 60)) && (y >= 160)) && (y <= 180))) || ((((x >= 30) && (x <= 40)) && (y >= 180)) && (y <= 200))) || ((((x >= 20) && (x <= 30)) && (y >= 170)) && (y <= 200))) || ((((x >= 20) && (x <= 40)) && (y >= 120)) && (y <= 160)))
					over = 1;
				else
					over = 0;
			end
			3'd3: begin
				if (y <= 100)
					floor = 1;
				else
					floor = 0;
				dino = 0;
				cactus = 0;
				cloud = 0;
				over = 0;
				idle = 0;
				if ((((((((((x >= 90) && (x <= 110)) && (y >= 140)) && (y <= 220)) || ((((x >= 90) && (x <= 110)) && (y >= 120)) && (y <= 130))) || ((((x >= 130) && (x <= 150)) && (y >= 120)) && (y <= 220))) || ((((x >= 150) && (x <= 170)) && (y >= 120)) && (y <= 140))) || ((((x >= 170) && (x <= 190)) && (y >= 120)) && (y <= 170))) || ((((x >= 190) && (x <= 210)) && (y >= 120)) && (y <= 140))) || ((((x >= 210) && (x <= 230)) && (y >= 120)) && (y <= 220)))
					win = 1;
				else
					win = 0;
			end
			default: begin
				cactus = 0;
				dino = 0;
				floor = 0;
				cloud = 0;
				over = 0;
				win = 0;
				if (((((((((((((((((((((((((((x >= 8) && (x <= 24)) && (y >= 162)) && (y <= 210)) || ((((x >= 24) && (x <= 56)) && (y >= 194)) && (y <= 210))) || ((((x >= 40) && (x <= 56)) && (y >= 186)) && (y <= 194))) || ((((x >= 24) && (x <= 40)) && (y >= 146)) && (y <= 162))) || ((((x >= 24) && (x <= 40)) && (y >= 130)) && (y <= 138))) || ((((x >= 64) && (x <= 112)) && (y >= 194)) && (y <= 210))) || ((((x >= 80) && (x <= 96)) && (y >= 130)) && (y <= 194))) || ((((x >= 120) && (x <= 168)) && (y >= 194)) && (y <= 210))) || ((((x >= 120) && (x <= 136)) && (y >= 170)) && (y <= 194))) || ((((x >= 128) && (x <= 136)) && (y >= 162)) && (y <= 170))) || ((((x >= 120) && (x <= 136)) && (y >= 130)) && (y <= 162))) || ((((x >= 136) && (x <= 152)) && (y >= 162)) && (y <= 178))) || ((((x >= 152) && (x <= 168)) && (y >= 130)) && (y <= 194))) || ((((x >= 176) && (x <= 192)) && (y >= 130)) && (y <= 210))) || ((((x >= 200) && (x <= 216)) && (y >= 130)) && (y <= 210))) || ((((x >= 192) && (x <= 200)) && (y >= 194)) && (y <= 210))) || ((((x >= 192) && (x <= 200)) && (y >= 162)) && (y <= 178))) || ((((x >= 224) && (x <= 272)) && (y >= 194)) && (y <= 210))) || ((((x >= 240) && (x <= 256)) && (y >= 130)) && (y <= 194))) || ((((x >= 280) && (x <= 312)) && (y >= 194)) && (y <= 210))) || ((((x >= 296) && (x <= 312)) && (y >= 178)) && (y <= 194))) || ((((x >= 280) && (x <= 312)) && (y >= 162)) && (y <= 178))) || ((((x >= 280) && (x <= 296)) && (y >= 146)) && (y <= 162))) || ((((x >= 280) && (x <= 312)) && (y >= 130)) && (y <= 146)))
					idle = 1;
				else
					idle = 0;
			end
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
module team_08_score_counter (
	clk,
	reset,
	collision_detect,
	state,
	bcd_ones,
	bcd_tens,
	score
);
	reg _sv2v_0;
	input wire clk;
	input wire reset;
	input wire collision_detect;
	input wire [2:0] state;
	output reg [3:0] bcd_ones;
	output reg [3:0] bcd_tens;
	output reg [6:0] score;
	wire slow_clock;
	reg col;
	reg det;
	reg [6:0] n_score;
	reg [6:0] deconcatenate;
	reg [3:0] n_bcd_ones;
	reg [3:0] n_bcd_tens;
	reg [2:0] next_state;
	t08_clock_divider clock_div(
		.clk(clk),
		.nRst_i(reset),
		.slow_clk(slow_clock)
	);
	always @(posedge clk or negedge reset)
		if (!reset) begin
			score <= 10;
			bcd_ones <= 0;
			bcd_tens <= 1;
			col <= 0;
		end
		else begin
			col <= collision_detect;
			score <= n_score;
			bcd_ones <= n_bcd_ones;
			bcd_tens <= n_bcd_tens;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		det = collision_detect && !col;
		next_state = state;
		n_score = score;
		n_bcd_ones = 0;
		n_bcd_tens = 1;
		deconcatenate = 0;
		case (state)
			3'd0: begin
				n_score = 10;
				n_bcd_ones = 0;
				n_bcd_tens = 1;
				deconcatenate = deconcatenate;
			end
			3'd1: begin
				n_score = score;
				n_bcd_ones = bcd_ones;
				n_bcd_tens = bcd_tens;
				deconcatenate = 0;
				if (det)
					n_score = score - 3;
				if (slow_clock) begin
					if (score < 99)
						n_score = score + 1;
					else if (score == 99)
						n_score = score;
				end
				if (n_score > 89) begin
					deconcatenate = n_score - 90;
					n_bcd_ones = deconcatenate[3:0];
					n_bcd_tens = 9;
				end
				else if (n_score > 79) begin
					deconcatenate = n_score - 80;
					n_bcd_ones = deconcatenate[3:0];
					n_bcd_tens = 8;
				end
				else if (n_score > 69) begin
					deconcatenate = n_score - 70;
					n_bcd_ones = deconcatenate[3:0];
					n_bcd_tens = 7;
				end
				else if (n_score > 59) begin
					deconcatenate = n_score - 60;
					n_bcd_ones = deconcatenate[3:0];
					n_bcd_tens = 6;
				end
				if (n_score > 49) begin
					deconcatenate = n_score - 50;
					n_bcd_ones = deconcatenate[3:0];
					n_bcd_tens = 5;
				end
				else if (n_score > 39) begin
					deconcatenate = n_score - 40;
					n_bcd_ones = deconcatenate[3:0];
					n_bcd_tens = 4;
				end
				else if (n_score > 29) begin
					deconcatenate = n_score - 30;
					n_bcd_ones = deconcatenate[3:0];
					n_bcd_tens = 3;
				end
				else if (n_score > 19) begin
					deconcatenate = n_score - 20;
					n_bcd_ones = deconcatenate[3:0];
					n_bcd_tens = 2;
				end
				else if (n_score > 9) begin
					deconcatenate = n_score - 10;
					n_bcd_ones = deconcatenate[3:0];
					n_bcd_tens = 1;
				end
				else begin
					deconcatenate = n_score;
					n_bcd_ones = deconcatenate[3:0];
					n_bcd_tens = 0;
				end
			end
			3'd3: begin
				n_score = score;
				n_bcd_ones = 9;
				n_bcd_tens = 9;
				deconcatenate = deconcatenate;
			end
			3'd2: begin
				n_score = score;
				n_bcd_ones = bcd_ones;
				n_bcd_tens = bcd_tens;
				deconcatenate = deconcatenate;
			end
			default: begin
				n_score = 10;
				n_bcd_ones = 0;
				n_bcd_tens = 1;
				deconcatenate = deconcatenate;
			end
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
module t08_clock_divider (
	clk,
	nRst_i,
	slow_clk
);
	input wire clk;
	input wire nRst_i;
	output reg slow_clk;
	reg [25:0] counter;
	always @(posedge clk or negedge nRst_i)
		if (!nRst_i) begin
			counter <= 0;
			slow_clk <= 0;
		end
		else if (counter >= 29999999) begin
			counter <= 0;
			slow_clk <= 1;
		end
		else begin
			counter <= counter + 1;
			slow_clk <= 0;
		end
endmodule
module team_08_score_display (
	clk,
	reset,
	bcd_ones,
	bcd_tens,
	displayOut,
	blinkToggle
);
	reg _sv2v_0;
	input wire clk;
	input wire reset;
	input wire [3:0] bcd_ones;
	input wire [3:0] bcd_tens;
	output reg [3:0] displayOut;
	output reg blinkToggle;
	reg [3:0] nextDisplayOut;
	reg nextBlinkToggle;
	always @(posedge clk or negedge reset)
		if (~reset) begin
			blinkToggle <= 0;
			displayOut <= 0;
		end
		else begin
			blinkToggle <= nextBlinkToggle;
			displayOut <= nextDisplayOut;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		nextBlinkToggle = 0;
		nextDisplayOut = 0;
		nextBlinkToggle = ~blinkToggle;
		if (~blinkToggle)
			nextDisplayOut = bcd_ones;
		else
			nextDisplayOut = bcd_tens;
	end
	initial _sv2v_0 = 0;
endmodule
module team_08_ssdec (
	in,
	enable,
	out
);
	input wire [3:0] in;
	input wire enable;
	output wire [6:0] out;
	assign out = ({enable, in} == 5'b10000 ? 7'b0111111 : ({enable, in} == 5'b10001 ? 7'b0000110 : ({enable, in} == 5'b10010 ? 7'b1011011 : ({enable, in} == 5'b10011 ? 7'b1001111 : ({enable, in} == 5'b10100 ? 7'b1100110 : ({enable, in} == 5'b10101 ? 7'b1101101 : ({enable, in} == 5'b10110 ? 7'b1111101 : ({enable, in} == 5'b10111 ? 7'b0000111 : ({enable, in} == 5'b11000 ? 7'b1111111 : ({enable, in} == 5'b11001 ? 7'b1100111 : ({enable, in} == 5'b11010 ? 7'b1110111 : ({enable, in} == 5'b11011 ? 7'b1111100 : ({enable, in} == 5'b11100 ? 7'b0111001 : ({enable, in} == 5'b11101 ? 7'b1011110 : ({enable, in} == 5'b11110 ? 7'b1111001 : ({enable, in} == 5'b11111 ? 7'b1110001 : 7'b0000000))))))))))))))));
endmodule
module team_08_tft_ili9341 (
	clk,
	tft_sck,
	tft_sdi,
	tft_dc,
	tft_reset,
	tft_cs,
	framebufferData,
	framebufferClk,
	tftstate
);
	input clk;
	output wire tft_sck;
	output wire tft_sdi;
	output wire tft_dc;
	output reg tft_reset;
	output wire tft_cs;
	input [15:0] framebufferData;
	output wire framebufferClk;
	output wire [2:0] tftstate;
	parameter INPUT_CLK_MHZ = 12;
	initial tft_reset = 1'b1;
	reg [8:0] spiData;
	reg spiDataSet = 1'b0;
	wire spiIdle;
	reg frameBufferLowNibble = 1'b1;
	assign framebufferClk = !frameBufferLowNibble;
	team_08_tft_ili9341_spi spi(
		.spiClk(clk),
		.data(spiData),
		.dataAvailable(spiDataSet),
		.tft_sck(tft_sck),
		.tft_sdi(tft_sdi),
		.tft_dc(tft_dc),
		.tft_cs(tft_cs),
		.idle(spiIdle)
	);
	localparam INIT_SEQ_LEN = 52;
	reg [5:0] initSeqCounter = 6'b000000;
	reg [8:0] INIT_SEQ [0:51];
	initial $readmemh("tft.mem", INIT_SEQ, 0, 51);
	reg [23:0] remainingDelayTicks = 24'b000000000000000000000000;
	reg [2:0] state;
	initial state = 3'd0;
	assign tftstate = state;
	function automatic signed [23:0] sv2v_cast_24_signed;
		input reg signed [23:0] inp;
		sv2v_cast_24_signed = inp;
	endfunction
	always @(posedge clk) begin
		spiDataSet <= 1'b0;
		if (remainingDelayTicks > 0)
			remainingDelayTicks <= remainingDelayTicks - 1'b1;
		else if (spiIdle && !spiDataSet)
			case (state)
				3'd0: begin
					tft_reset <= 1'b0;
					remainingDelayTicks <= sv2v_cast_24_signed(INPUT_CLK_MHZ * 10);
					state <= 3'd1;
				end
				3'd1: begin
					tft_reset <= 1'b1;
					remainingDelayTicks <= sv2v_cast_24_signed(INPUT_CLK_MHZ * 120000);
					state <= 3'd2;
					frameBufferLowNibble <= 1'b0;
				end
				3'd2: begin
					spiData <= 9'h011;
					spiDataSet <= 1'b1;
					remainingDelayTicks <= sv2v_cast_24_signed(INPUT_CLK_MHZ * 5000);
					state <= 3'd3;
					frameBufferLowNibble <= 1'b1;
				end
				3'd3:
					if (initSeqCounter < INIT_SEQ_LEN) begin
						spiData <= INIT_SEQ[initSeqCounter];
						spiDataSet <= 1'b1;
						initSeqCounter <= initSeqCounter + 1'b1;
					end
					else begin
						state <= 3'd4;
						remainingDelayTicks <= sv2v_cast_24_signed(INPUT_CLK_MHZ * 10000);
					end
				default: begin
					spiData <= (!frameBufferLowNibble ? {1'b1, framebufferData[15:8]} : {1'b1, framebufferData[7:0]});
					spiDataSet <= 1'b1;
					frameBufferLowNibble <= !frameBufferLowNibble;
				end
			endcase
	end
endmodule
module team_08_tft_ili9341_spi (
	spiClk,
	data,
	dataAvailable,
	tft_sck,
	tft_sdi,
	tft_dc,
	tft_cs,
	idle
);
	input spiClk;
	input [8:0] data;
	input dataAvailable;
	output wire tft_sck;
	output reg tft_sdi;
	output reg tft_dc;
	output wire tft_cs;
	output reg idle;
	reg [0:2] counter = 3'b000;
	reg [8:0] internalData;
	reg internalSck;
	reg cs;
	initial internalSck <= 1'b1;
	initial idle <= 1'b1;
	initial cs <= 1'b0;
	wire dataDc = internalData[8];
	wire [0:7] dataShift = internalData[7:0];
	assign tft_sck = internalSck & cs;
	assign tft_cs = !cs;
	always @(posedge spiClk) begin
		if (dataAvailable) begin
			internalData <= data;
			idle <= 1'b0;
		end
		if (!idle) begin
			internalSck <= !internalSck;
			if (internalSck) begin
				tft_dc <= dataDc;
				tft_sdi <= dataShift[counter];
				cs <= 1'b1;
				counter <= counter + 1'b1;
				idle <= &counter;
			end
		end
		else begin
			internalSck <= 1'b1;
			if (internalSck)
				cs <= 1'b0;
		end
	end
endmodule