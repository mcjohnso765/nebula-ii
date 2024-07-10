
    typedef enum logic [2:0] { 
        IDLE = 3'd0, 
        RUN = 3'd1, 
        OVER = 3'd2,
        WIN = 3'd3
    } state_t;

module team_08_dinoGame (input clk, input up, input rst,

    /*spi*/ 
    output logic tft_sck, output logic tft_sdi, 
	output logic tft_dc, output logic tft_reset, output logic tft_cs,

    
    /*parallel*/output logic cs, cd, rd, wr,
    output logic [7:0] data,

    /*score*/output logic [6:0] ones_score, tens_score,
    output logic collides
    //output logic blinkToggle
    );

    // Required registers and wires
    wire[8:0] x;
	wire[7:0] y;
    reg r_floor,r_cactus,r_dino,r_cloud,r_over,r_idle,r_win;
    reg [7:0] dinoY;
    reg [8:0] x_dist;
    reg [8:0] cactusX;
    reg [6:0] dinoX;
    reg [8:0] cactusY;
    //reg collides;
    reg [1:0] cactusType1;
    reg [1:0] cactusType2;
    reg [1:0] cactusRandDist;
    reg [7:0] cactusHeight1;
    reg [8:0] cactusHeight2;
    reg dinoJumpGood;
    logic sync0, sync1, det, edge_det;
    state_t state;
    reg [6:0] score;
    reg [7:0] v;
    reg [3:0] bcd_ones, bcd_tens;
    reg [3:0] displayOut;
    reg drawDoneDino;
    reg dinoMovement;
    reg drawDoneCactus;
    reg cactusMovement;
    //reg [6:0] ss0, ss1;
    logic game_over;
    assign game_over = state == OVER;
    
    always_ff @(posedge clk, negedge rst) begin 
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
    end

    assign edge_det = sync1 && !det;
    team_08_parallelDisplay controller(
    .clk(clk), .rst(rst), .move_enable({cactusMovement, dinoMovement}), .dinoY(dinoY), .cactusX1(cactusX), 
    .cactusH1(cactusHeight1),.cactusH2(cactusHeight2), .v(v), .cs(cs), .cd(cd), .wr(wr), .x_dist(x_dist),
    .rd(rd), .data(data), .received({drawDoneCactus, drawDoneDino})
     );

    team_08_GameState game(/*inputs*/.clk(clk), .reset(rst), .collision_detect(collides), .button_pressed(edge_det), .score(score), 
    /*outputs*/.state(state)); 

    team_08_rectangleGenerator recGen(/*inputs*/.clk(clk), .nRst(rst), .state(state), .cactusH1(cactusHeight1), .cactusH2(cactusHeight2), .x(x), .y(y), .dinoY(dinoY), 
    .cactusX(cactusX), .x_dist(x_dist), 
    /*outputs*/.r_floor(r_floor), .r_cloud(r_cloud), .r_idle(r_idle), .r_over(r_over), .r_win(r_win), .r_dino(r_dino), .r_cactus(r_cactus));

    team_08_dinoJump dinoJump(/*inputs*/.clk(clk), .nRst(rst), .state(state), .button(sync1), .drawDoneDino(drawDoneDino),
    /*outputs*/.dinoY(dinoY), .v(v), .dinoMovement(dinoMovement), .dinoJumpGood(dinoJumpGood));
    
    team_08_cactusMove cactusMove(/*inputs*/.clk(clk), .nRst(rst), .enable(1'b1), .state(state), 
    .rng_input(cactusRandDist), .type1(cactusType1), .type2(cactusType2), .drawDoneCactus(drawDoneCactus),
    /*outputs*/.x_dist(x_dist), .pixel(cactusX), .height1(cactusHeight1), .height2(cactusHeight2), .cactusMovement(cactusMovement));

    team_08_collision_detector collision(/*inputs*/.clk(clk), .reset(rst), .dinoY(dinoY), .state(state),
    .dinoX(9'd280), .dinoWidth(9'd20), .cactusX1(cactusX), .cactusRandDist(x_dist), .cactusY(9'd101), 
    .cactusHeight1(cactusHeight1), .cactusHeight2(cactusHeight2), .cactusWidth(9'd20), 
    /*outputs*/.collision_detect(collides));
    
    team_08_imageGenerator lcdOutput(/*inputs*/.clk(clk), .rst(rst),
    .r_idle(r_idle), .r_over(r_over), .r_win(r_win), .r_cactus(r_cactus), .r_cloud(r_cloud), .r_dino(r_dino), .r_floor(r_floor), 
    /*outputs*/.x(x), .y(y), .tft_sck(tft_sck), .tft_sdi(tft_sdi), .tft_dc(tft_dc), .tft_reset(tft_reset), .tft_cs(tft_cs));
    
    team_08_random_generator cactus1size(/*inputs*/.clk(clk), .rst_n(rst), .MCNT1(4'd3), .MCNT2(4'd5), .button_pressed(edge_det), .state(state), 
    /*outputs*/.rnd(cactusType1));

    team_08_random_generator cactus2size(/*inputs*/.clk(clk), .rst_n(rst), .MCNT1(4'd2), .MCNT2(4'd7), .button_pressed(edge_det), .state(state), 
    /*outputs*/.rnd(cactusType2));

    team_08_random_generator cactusDist(/*inputs*/.clk(clk), .rst_n(rst), .MCNT1(4'd3), .MCNT2(4'd5), .button_pressed(edge_det), .state(state), 
    /*outputs*/.rnd(cactusRandDist));

    team_08_score_counter scoreCounter(/*inputs*/.clk(clk), .reset(rst), .collision_detect(collides), .state(state), 
    /*outputs*/.bcd_ones(bcd_ones), .bcd_tens(bcd_tens), .score(score));

    //team_08_score_display flash(/*inputs*/.clk(clk), .reset(rst), .bcd_ones(bcd_ones), .bcd_tens(bcd_tens), 
    ///*outputs*/.displayOut(displayOut), .blinkToggle(blinkToggle));

    team_08_ssdec ones(.in(bcd_ones), .enable(1'b1), .out(ones_score));

    team_08_ssdec tens(.in(bcd_tens), .enable(1'b1), .out(tens_score));

    ///add synthesizer module 
    //team_08_PWM syn(.clk(clk), .nrst(~rst), .enable(1'b1), .gameover(game_over), .light(), .out(PWM_o), .jump(dinoJumpGood));


    
endmodule
