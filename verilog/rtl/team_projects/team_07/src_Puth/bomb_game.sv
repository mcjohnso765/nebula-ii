/*
    Module: bomb_game.sv
    Description:
        integrate the bomb_game all together
*/

module t07_bomb_game(
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
); 

    logic submodule_clear_edge;
    logic error;
    assign submodule_clear_edge = maze_clear_edge | wire_clear | mem_clear | simon_clear;
    assign error = maze_error | wire_error | mem_error | simon_error;
    t07_audio_sm audio_0 (
        .nrst(nrst), 
        .clk(clk), 
        .s_strobe(s_strobe),
        .s_strobe_fast(s_strobe_faster), 
        .s_strobe_faster(s_strobe_faster),
        .cnt_min(cnt_min),
        .cnt_sec_ten(cnt_sec_ten),
        .cnt_sec_one(cnt_sec_one),
        .submodule_clear_edge(submodule_clear_edge),
        .game_clear(game_clear),
        .error(error), 
        .audio(audio)
    );

    logic s_strobe;
    logic s_strobe_fast;
    logic s_strobe_faster;
    logic [23:0] cnt;
    t07_timer_sec_divider timer_sec_divider_0 (
        .clk(clk),
        .nrst(nrst),
        .clear(timer_clear),
        .s_strobe(s_strobe),
        .s_strobe_fast(s_strobe_fast),
        .s_strobe_faster(s_strobe_faster)
    );

    logic [2:0] cnt_min;
    logic [2:0] cnt_sec_ten;
    logic [3:0] cnt_sec_one;
    t07_timer_counter timer_counter_0(
        .clk(clk),
        .nrst(nrst),
        .s_strobe(s_strobe),
        .max_min(max_min),
        .max_sec_ten(max_sec_ten),
        .max_sec_one(max_sec_one),
        .clear(timer_clear),
        .cnt_min(cnt_min),
        .cnt_sec_ten(cnt_sec_ten),
        .cnt_sec_one(cnt_sec_one)
    );

    logic sck_clear;
    logic sck_rs_enable;
    logic sck_fl_enable;
    t07_timer_ssdec_sck_divider timer_ssdec_sck_divider_0 (
        .clk(clk),
        .nrst(nrst),
        .clear(sck_clear),
        .sck_rs_enable(sck_rs_enable),
        .sck_fl_enable(sck_fl_enable)
    );

    t07_timer_ssdec_spi_master timer_ssdec_spi_master_0 (
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
    logic [5:0] sync_button;
    assign sync_button = {reg_edge_back, reg_edge_left, reg_edge_down, reg_edge_right, reg_edge_up, reg_edge_select};   
    assign select = button[0];
    assign up = button[1];
    assign right = button[2];
    assign down = button[3];
    assign left = button[4];
    assign back = button[5];
    t07_button_edge_detector DUT_button_edge_detector (
        .clk(clk),
        .nrst(nrst),
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

    logic game_clear;
    logic [2:0] game_state;
    logic [1:0] lives;
    logic [2:0] mod_num;
    logic [2:0] max_min;
    logic [2:0] max_sec_ten;
    logic [3:0] max_sec_one;
    logic activate_rand;
    logic timer_clear;
    t07_fsm_game_control DUT_fsm_game_control(
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
    t07_fsm_playing_mod_locator DUT_fsm_playing_mod_locator(
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
    logic [3:0] submodule_cleared;
    t07_fsm_playing DUT_fsm_playing (
        .nrst(nrst),
        .clk(clk),
        .strobe(strobe),
        .button(sync_button),
        .game_state_in(game_state),
        .mod_num(mod_num),
        .mod_row(mod_row),
        .mod_col(mod_col),
        .submodule_cleared(submodule_cleared),
        .submodule_clear_edge(submodule_clear_edge),
        .playing_state_out(playing_state),
        .game_clear(game_clear)
    );

    logic [2:0] pos_x;
    logic [2:0] pos_y;
    logic [2:0] dest_x;
    logic [2:0] dest_y;
    logic [2:0] map_select;
    logic maze_error;
    t07_maze DUT_maze(
        .nrst(nrst),
        .clk(clk),
        .button(sync_button),
        .strobe(strobe),
        .playing_state_in(playing_state),
        .activate_rand(activate_rand),
        .maze_cleared(submodule_cleared[0]),
        .map_select(map_select),
        .error(maze_error),
        .pos_x(pos_x),
        .pos_y(pos_y),
        .dest_x(dest_x),
        .dest_y(dest_y),
        .maze_clear(maze_clear)
    );

    logic maze_clear_edge;
    logic maze_clear;
    t07_rising_edge_detector maze_clear_edge_detector(
        .nrst(nrst),
        .clk(clk),
        .in(maze_clear),
        .out(maze_clear_edge)
    );

    logic [2:0] wire_num;
    logic [5:0] wire_status;
    logic [2:0] wire_pos;
    logic [17:0] wire_color_bus;    // 6 wires, 3-bit color code
    logic [5:0] wirePixel;
    logic wireHighlightPixel;
    logic wire_error;
    logic wire_clear;
    t07_wire_game wire_game_0 (
        .nrst(nrst),
        .clk(clk),
        .button(sync_button),
        .strobe(strobe),
        .playing_state_in(playing_state),
        .activate_rand(activate_rand),
        .wire_cleared(submodule_cleared[1]),
        .wire_error(wire_error),
        .wire_clear(wire_clear),
        .wire_num(wire_num),
        .wire_color_bus(wire_color_bus),
        .wire_status(wire_status),
        .wire_pos(wire_pos)
    );

    logic mem_error;
    logic mem_clear;
    logic [1:0] mem_pos;
    logic [9:0] display_num_bus;    // 5 stages, 2-bit value 1-4
    logic [39:0] label_num_bus;     // 5 stages, 4 positions, 2-bit value 1-4
    logic [2:0] stage;
    t07_mem_game mem_game_0 (
        .nrst(nrst),
        .clk(clk),
        .button(sync_button),
        .strobe(strobe),
        .mem_cleared(submodule_cleared[2]),
        .playing_state_in(playing_state),
        .activate_rand(activate_rand),
        .mem_error(mem_error),
        .mem_clear(mem_clear),
        .mem_pos(mem_pos),
        .display_num_bus(display_num_bus),
        .label_num_bus(label_num_bus),
        .stage(stage)
    );

    logic simon_error;
    logic simon_clear;
    logic [3:0] simon_light_up_state;
    logic [3:0] simon_light_up_manual;
    t07_simon_game simon_game_0(
        .nrst(nrst),
        .clk(clk),
        .button(sync_button),
        .unsync_button(button),
        .strobe(strobe),
        .playing_state_in(playing_state),
        .activate_rand(activate_rand),
        .s_strobe(s_strobe_fast),
        .simon_cleared(submodule_cleared[3]),
        .lives(lives),
        .simon_error(simon_error),
        .simon_clear(simon_clear),
        .simon_light_up_state(simon_light_up_state),
        .simon_light_up_manual(simon_light_up_manual)
    );

    logic [8:0] x;
    logic [7:0] y;
    logic flagPixel, playerPixel, circlePixel, borderPixel, heartPixel, playButtonPixel, modSquaresPixel, modHighlightPixel;
    logic defusedPixel, boomPixel, displayPixel, buttonPixel, stagePixel, buttonHighlightPixel;
    logic [3:0] labelPixel;
    logic [3:0] simonPixel;
    t07_generate_flag recFLAG(.clk(clk), .nrst(nrst), .flagPixel(flagPixel), .flag_x(dest_x), .flag_y(dest_y), .x(x), .y(y));
    t07_generate_player recPLAYER(.clk(clk), .nrst(nrst), .playerPixel(playerPixel), .pos_x(pos_x), .pos_y(pos_y),  .x(x), .y(y));
    t07_generate_circle recGen(.clk(clk), .nrst(nrst), .circlePixel(circlePixel), .map_select(map_select), .x(x), .y(y));
    t07_generate_border borderGen(.clk(clk), .nrst(nrst), .x(x), .y(y), .borderPixel(borderPixel));
    t07_generate_heart recHEART( .clk(clk), .nrst(nrst), .x(x), .y(y), .lives(lives), .heartPixel(heartPixel)); 
    t07_generate_play_button recPLAY(.clk(clk), .nrst(nrst), .x(x), .y(y), .playButtonPixel(playButtonPixel));
    t07_generate_mod_square recMOD(.clk(clk), .nrst(nrst), .x(x), .y(y), .mod_row(mod_row), .mod_col(mod_col),
        .modSquaresPixel(modSquaresPixel), .modHighlightPixel(modHighlightPixel));
    t07_generate_defused defusedGen(.clk(clk), .nrst(nrst), .x(x), .y(y), .defusedPixel(defusedPixel));
    t07_generate_boom boomGen(.clk(clk), .nrst(nrst), .x(x), .y(y), .boomPixel(boomPixel));
    t07_generate_wire wireGen(.nrst(nrst), .clk(clk), .x(x), .y(y), .wire_num(wire_num), .wire_status(wire_status), .wire_pos(wire_pos),
       .wirePixel(wirePixel), .wireHighlightPixel(wireHighlightPixel));
    t07_generate_mem memGen(.nrst(nrst), .clk(clk), .x(x), .y(y), .display_num_bus(display_num_bus), .label_num_bus(label_num_bus), .stage(stage), .mem_pos(mem_pos),
        .displayPixel(displayPixel), .buttonPixel(buttonPixel), .labelPixel(labelPixel), .stagePixel(stagePixel), .buttonHighlightPixel(buttonHighlightPixel));
    t07_generate_simon simonGen(.nrst(nrst), .clk(clk), .x(x), .y(y), .simonPixel(simonPixel));

    logic tft_sdo;
    assign tft_sdo = 1'd0;
    logic tftstate;
    t07_imageGenerator lcdOutput(
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
        .wirePixel(wirePixel),
        .wireHighlightPixel(wireHighlightPixel),
        .wire_color_bus(wire_color_bus),
        .displayPixel(displayPixel), 
        .buttonPixel(buttonPixel), 
        .labelPixel(labelPixel), 
        .stagePixel(stagePixel), 
        .buttonHighlightPixel(buttonHighlightPixel),
        .simonPixel(simonPixel),
        .simon_light_up_state(simon_light_up_state),
        .simon_light_up_manual(simon_light_up_manual),
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