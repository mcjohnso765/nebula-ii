/*
    Module: bomb_game.sv
    Description:
        integrate the bomb_game all together
*/

module bomb_game(
    input logic nrst,
    input logic clk,
    input logic [5:0] button,   // input: button
    output logic ssdec_sdi,     // output: ssdec lines
    output logic ssdec_ss,
    output logic ssdec_sck,
    output logic tft_sck,
    output logic tft_sdi,
    output logic tft_dc, 
    output logic tft_rst,
    output logic tft_cs,
    output logic [2:0] tft_state,
    output logic audio
    // testing output
    // output logic [2:0] game_state_top,
    // output logic [2:0] playing_state_top
    // output logic [1:0] lives_out,
    // output logic error_out
); 
    // testing output
    // assign game_state_top = game_state;
    // assign playing_state_top = playing_state;
    // assign lives_out = lives;
    // assign error_out = error;

    audio_sm audio_0 (
        .nrst(nrst), 
        .clk(clk), 
        .s_strobe(s_strobe), 
        .error(error), 
        .audio(audio)
    );

    logic s_strobe;
    logic [23:0] cnt;
    timer_sec_divider timer_sec_divider_0 (
        .clk(clk),
        .nrst(nrst),
        .clear(timer_clear),
        .s_strobe(s_strobe),
        .cnt(cnt)
    );

    logic [2:0] cnt_min;
    logic [2:0] cnt_sec_ten;
    logic [3:0] cnt_sec_one;
    timer_counter timer_counter_0(
        .clk(clk),
        .nrst(nrst),
        .s_strobe(s_strobe),
        .max_min(3'd1),
        .max_sec_ten(3'd0),
        .max_sec_one(4'd0),
        .clear(timer_clear),
        .cnt_min(cnt_min),
        .cnt_sec_ten(cnt_sec_ten),
        .cnt_sec_one(cnt_sec_one)
    );

    logic sck_clear;
    logic sck_rs_enable;
    logic sck_fl_enable;
    timer_ssdec_sck_divider timer_ssdec_sck_divider_0 (
        .clk(clk),
        .nrst(nrst),
        .clear(sck_clear),
        .sck_rs_enable(sck_rs_enable),
        .sck_fl_enable(sck_fl_enable)
    );

    timer_ssdec_spi_master timer_ssdec_spi_master_0 (
        .clk(clk),
        .nrst(nrst),
        .cnt_min(cnt_min),
        .cnt_sec_ten(cnt_sec_ten),
        .cnt_sec_one(cnt_sec_one),
        .enable(1'b1),
        .sck_rs_enable(sck_rs_enable),
        .sck_fl_enable(sck_fl_enable),
        .clear(timer_clear),
        .sck_clear(sck_clear),
        .ss(ssdec_ss),
        .sdi(ssdec_sdi),
        .sck(ssdec_sck)
    );

    logic strobe, select, up, down, left, right, back;
    logic reg_edge_back, reg_edge_left, reg_edge_down, reg_edge_right, reg_edge_up, reg_edge_select;
    logic [5:0] sync_button = {reg_edge_back, reg_edge_left, reg_edge_down, reg_edge_right, reg_edge_up, reg_edge_select};   
    assign select = button[0];
    assign up = button[1];
    assign right = button[2];
    assign down = button[3];
    assign left = button[4];
    assign back = button[5];
    button_edge_detector DUT_button_edge_detector (
        .clk(clk),
        .rst(nrst),
        .up(up),
        .down(down),
        .left(left),
        .right(right),
        .back(back),
        .select(select),
        .strobe(strobe),
        .reg_edge_up(reg_edge_up),
        .reg_edge_down(reg_edge_down),
        .reg_edge_left(reg_edge_left),
        .reg_edge_right(reg_edge_right),
        .reg_edge_select(reg_edge_select),
        .reg_edge_back(reg_edge_back)
    );

    logic error;
    logic game_clear;
    logic [2:0] game_state;
    logic [1:0] lives;
    logic [2:0] mod_num;
    logic [2:0] max_min;
    logic [2:0] max_sec_ten;
    logic [3:0] max_sec_one;
    logic activate_rand;
    logic timer_clear;
    fsm_game_control DUT_fsm_game_control(
        .nrst(nrst),
        .clk(clk),
        .strobe(strobe),
        .button(sync_button),
        .error(error),
        .timer_clear(timer_clear),
        .game_clear(game_clear),
        .mod_num(mod_num),
        .game_state_out(game_state),
        .lives(lives),
        .activate_rand(activate_rand),
        .cnt_min(cnt_min),
        .cnt_sec_ten(cnt_sec_ten),
        .cnt_sec_one(cnt_sec_one),
        .max_min(max_min),
        .max_sec_ten(max_sec_ten),
        .max_sec_one(max_sec_one)
    );

    logic mod_row;
    logic mod_col;
    fsm_playing_mod_locator DUT_fsm_playing_mod_locator(
        .nrst(nrst),
        .clk(clk),
        .strobe(strobe),
        .button(sync_button),
        .game_state_in(game_state),
        .playing_state_in(playing_state),
        .mod_row(mod_row),
        .mod_col(mod_col)
    );

    logic [2:0] playing_state;
    fsm_playing DUT_fsm_playing (
        .nrst(nrst),
        .clk(clk),
        .strobe(strobe),
        .button(sync_button),
        .game_state_in(game_state),
        .mod_num(mod_num),
        .mod_row(mod_row),
        .mod_col(mod_col),
        .submodule_clear_edge(maze_clear_edge),
        .playing_state_out(playing_state),
        .game_clear(game_clear)
    );

    logic [2:0] pos_x;
    logic [2:0] pos_y;
    logic [2:0] dest_x;
    logic [2:0] dest_y;
    logic [2:0] map_select;
    maze DUT_maze(
        .nrst(nrst),
        .clk(clk),
        .button(sync_button),
        .strobe(strobe),
        .game_state_in(game_state),
        .playing_state_in(playing_state),
        .activate_rand(activate_rand),
        .map_select(map_select),
        .error(error),
        .pos_x(pos_x),
        .pos_y(pos_y),
        .dest_x(dest_x),
        .dest_y(dest_y),
        .maze_clear(maze_clear)
    );

    logic maze_clear_edge;
    logic maze_clear;
    rising_edge_detector maze_clear_edge_detector(
        .nrst(nrst),
        .clk(clk),
        .in(maze_clear),
        .out(maze_clear_edge)
    );

    logic [8:0] x;
    logic [7:0] y;
    logic flagPixel, playerPixel, circlePixel, borderPixel, heartPixel, playButtonPixel, modSquaresPixel, modHighlightPixel;
    logic defusedPixel, boomPixel;
    generate_flag recFLAG(.clk(clk), .nrst(nrst), .flagPixel(flagPixel), .flag_x(dest_x), .flag_y(dest_y), .x(x), .y(y));
    generate_player recPLAYER(.clk(clk), .nrst(nrst), .playerPixel(playerPixel), .pos_x(pos_x), .pos_y(pos_y),  .x(x), .y(y));
    generate_circle recGen(.clk(clk), .nrst(nrst), .circlePixel(circlePixel), .map_select(map_select), .x(x), .y(y));
    generate_border borderGen(.clk(clk), .nrst(nrst), .x(x), .y(y), .borderPixel(borderPixel));
    generate_heart recHEART( .clk(clk), .nrst(nrst), .x(x), .y(y), .lives(lives), .heartPixel(heartPixel)); 
    generate_play_button recPLAY(.clk(clk), .nrst(nrst), .x(x), .y(y), .playButtonPixel(playButtonPixel));
    generate_mod_square recMOD(.clk(clk), .nrst(nrst), .x(x), .y(y), .mod_row(mod_row), .mod_col(mod_col),
        .modSquaresPixel(modSquaresPixel), .modHighlightPixel(modHighlightPixel));
    generate_defused defusedGen(.clk(clk), .nrst(nrst), .x(x), .y(y), .defusedPixel(defusedPixel));
    generate_boom boomGen(.clk(clk), .nrst(nrst), .x(x), .y(y), .boomPixel(boomPixel));

    logic tft_sdo;
    logic tft_rst;
    logic tftstate;
    initial tft_sdo = 0;
    imageGenerator lcdOutput(
        .clk(clk), 
        .nrst(nrst), 
        .tft_sdo(tft_sdo), 
        .circlePixel(circlePixel), 
        .flagPixel(flagPixel), 
        .playerPixel(playerPixel),
        .heartPixel(heartPixel),  
        .borderPixel(borderPixel),
        .playButtonPixel(playButtonPixel),
        .modSquaresPixel(modSquaresPixel),
        .modHighlightPixel(modHighlightPixel),
        .defusedPixel(defusedPixel),
        .boomPixel(boomPixel),
        .game_state(game_state), 
        .playing_state(playing_state),
        .x(x), 
        .y(y),
        .tft_sck(tft_sck),
        .tft_sdi(tft_sdi),
        .tft_dc(tft_dc),
        .tft_reset(tft_rst),
        .tft_cs(tft_cs),
        .tftstate(tft_state)
    );

endmodule