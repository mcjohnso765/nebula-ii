/*  
    Module: fsm_playing_mod_locator
    Description:
        locate the position of the module select in the MOD playing_state, in PLAYING game_state.
    The location in is the table of 2 * 2.
*/  
`define SELECT 6'b000001
`define UP 6'b000010
`define RIGHT 6'b000100
`define DOWN 6'b001000
`define LEFT 6'b010000
`define BACK 6'b100000
`define NO_PRESS 6'b000000

`define MOD 3'b000
`define MAZE 3'b001

`define MENU 3'b000
`define PLAY 3'b001
`define LOST 3'b010
`define WON 3'b011

module t07_fsm_playing_mod_locator
(
    input logic nrst,
    input logic clk,
    input logic strobe,
    input logic [2:0] game_state_in,
    input logic [2:0] playing_state_in,
    input logic [5:0] button,
    output logic mod_row,               // row can be either zero or one
    output logic mod_col                // column can be either zero or one
);
    logic nxt_mod_row;
    logic nxt_mod_col;

    always_ff @(negedge nrst, posedge clk) begin 
        if(!nrst) begin
            mod_row <= 1'd0;
            mod_col <= 1'd0;
        end else begin
            mod_row <= nxt_mod_row;
            mod_col <= nxt_mod_col;
        end
    end

    always_comb begin
        nxt_mod_row = mod_row;
        nxt_mod_col = mod_col;
        if (game_state_in == `MENU) begin
            nxt_mod_row = 1'd0;
            nxt_mod_col = 1'd0;
        end if (game_state_in == `PLAY && playing_state_in == `MOD && strobe) begin
            case (button)
                `UP: begin 
                    if (mod_row != 0) begin
                        nxt_mod_row = mod_row - 1;
                    end 
                end
                `RIGHT: begin 
                    if (mod_col != 1) begin
                        nxt_mod_col = mod_col + 1;
                    end
                end
                `DOWN: begin
                    if (mod_row != 1) begin
                        nxt_mod_row = mod_row + 1;
                    end
                end
                `LEFT: begin 
                    if (mod_col != 0) begin
                        nxt_mod_col = mod_col - 1;
                    end
                end
                default: ; 
            endcase   
        end
    end
endmodule