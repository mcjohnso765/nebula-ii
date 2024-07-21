/*
    Module: simon_game
    Description:
        integrate the simon game module
*/
module t07_simon_game(
    input logic nrst,
    input logic clk,
    input logic strobe,
    input logic [5:0] button,
    input logic [5:0] unsync_button,
    input logic [2:0] playing_state_in,
    input logic activate_rand,
    input logic simon_cleared,
    input logic s_strobe,
    input logic [1:0] lives,
    output logic simon_error,
    output logic simon_clear,
    output logic [3:0] simon_light_up_state,
    output logic [3:0] simon_light_up_manual
);
    logic [9:0] simon_sequence_bus;    // 5 stages, 2-bit value vary from 1-4
    logic [3:0] simon_state;

    t07_simon_sequence_gen simon_sequence_gen_0(
        .nrst(nrst),
        .clk(clk),
        .activate_rand(activate_rand),
        .simon_sequence_bus(simon_sequence_bus)
    );

    t07_simon_light_control simon_light_control_0(
        .nrst(nrst),
        .clk(clk),
        .s_strobe(s_strobe),
        .unsync_button(unsync_button),
        .simon_state(simon_state),
        .simon_sequence_bus(simon_sequence_bus),
        .simon_cleared(simon_cleared),
        .simon_light_up_state(simon_light_up_state),
        .simon_light_up_manual(simon_light_up_manual)
    );
    t07_simon_press_detector simon_press_detector(
        .nrst(nrst),
        .clk(clk),
        .strobe(strobe),
        .button(button),
        .playing_state_in(playing_state_in), 
        .activate_rand(activate_rand),
        .simon_sequence_bus(simon_sequence_bus),     // simon says color sequence for stage 1-5, value vary from 1-4
        .lives(lives),
        .simon_cleared(simon_cleared),
        .simon_error(simon_error),
        .simon_clear(simon_clear),
        .simon_state_out(simon_state)
    );
endmodule