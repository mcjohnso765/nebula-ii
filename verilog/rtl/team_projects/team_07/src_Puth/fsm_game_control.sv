/*
    Module: game_control_fsm
    Description: 
        Control the game state between MENU, PLAY, WON, and LOST.
    Keep tract of the lives and timer to switch to LOST state.
    Keep tract of the game_clear signal to switch to WON state.
    Keep tract of the error signal to dedect lives.
*/

`define SELECT 6'b000001
`define UP 6'b000010
`define RIGHT 6'b000100
`define DOWN 6'b001000
`define LEFT 6'b010000
`define BACK 6'b100000
`define NO_PRESS 6'b000000

module t07_fsm_game_control(
    input logic nrst,
    input logic clk,
    input logic strobe,
    input logic [5:0] button,
    input logic error,
    input logic game_clear,
    output logic timer_clear,
    output logic [2:0] mod_num,
    output logic[2:0] game_state_out,
    output logic [1:0] lives,
    output logic activate_rand,

    // timer inputs
    input logic [2:0] cnt_min,
    input logic [2:0] cnt_sec_ten,
    input logic [3:0] cnt_sec_one,

    // timer outputs
    output logic [2:0] max_min,
    output logic [2:0] max_sec_ten,
    output logic [3:0] max_sec_one
);
    typedef enum logic [2:0] { 
        MENU = 3'd0, PLAY = 3'd1, LOST = 3'd2, WON = 3'd3
    } game_state_t;
    
    game_state_t next_game_state, game_state;
    logic [1:0] next_lives;
    
    assign game_state_out = game_state;
    assign mod_num = 3'd4;
    assign max_min = 3'd3;
    assign max_sec_ten = 3'd0;
    assign max_sec_one = 4'd0;

    always_ff @(negedge nrst, posedge clk) begin
        if(!nrst) begin
            game_state <= MENU;
            lives <= 2'd0;
        end else begin
            game_state <= next_game_state;
            lives <= next_lives;
        end
    end
    
    always_comb begin
        next_game_state = game_state;
        next_lives = lives;
        activate_rand = 1'b0;
        timer_clear = 1'b1;
        case (game_state)
            MENU: begin
                timer_clear = 1'b1;
                if (strobe && button == `SELECT) begin //needs to be different condition to eliminate skipping menu state on one posedge
                    next_game_state = PLAY;
                    next_lives = 2'd3;
                    activate_rand = 1'b1;
                end
            end
            PLAY: begin
                timer_clear = 1'b0;
                activate_rand = 1'b0;
                if (game_clear) begin 
                    next_game_state = WON;
                end else if (cnt_min == 3'd0 && cnt_sec_ten == 3'd0 && cnt_sec_one == 4'd0) begin 
                    next_game_state = LOST;
                end else if (error) begin
                    next_lives = lives - 1;
                    if (lives - 1 == 0) begin
                        next_game_state = LOST;
                    end
                end
            end
            LOST, WON: begin
                timer_clear = 1'b1;
                if (strobe && button == `SELECT) begin 
                    next_game_state = MENU;
                end
            end
            default: ;
        endcase
    end

endmodule