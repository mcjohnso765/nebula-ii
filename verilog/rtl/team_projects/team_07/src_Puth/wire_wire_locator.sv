/*
    Module: wire_wire_locator
    Description:
        take in the strobe and button, and update the position of the selected wire
    in the wire game.
*/
`define MENU 3'b000
`define PLAY 3'b001
`define LOST 3'b010
`define WON 3'b011

`define MOD 3'b000
`define MAZE 3'b001
`define WIRE 3'b010

`define SELECT 6'b000001
`define UP 6'b000010
`define RIGHT 6'b000100
`define DOWN 6'b001000
`define LEFT 6'b010000
`define BACK 6'b100000
`define NO_PRESS 6'b000000

module t07_wire_wire_locator(
    input logic nrst,
    input logic clk,
    input logic [2:0] playing_state_in,
    input logic strobe,
    input logic [5:0] button,
    input logic wire_cleared,
    input logic [2:0] wire_num, 
    output logic [2:0] wire_pos
);
    logic [2:0] nxt_wire_pos;

    always_comb begin
        nxt_wire_pos = wire_pos;
        if (playing_state_in == `WIRE && strobe && !wire_cleared) begin
            if (button == `RIGHT && wire_pos != 3'(wire_num) - 1) begin
                nxt_wire_pos = wire_pos + 1;    // if not at the right-most and right button is pressed, move one to the right
            end else if (button == `LEFT && wire_pos != 3'd0) begin 
                nxt_wire_pos = wire_pos - 1;    // if not at the left-most and left button is pressed, move one to the left
            end
        end    
    end
    
    always_ff @ (negedge nrst, posedge clk) begin
        if (!nrst) begin
            wire_pos <= 3'd0;
        end else begin
            wire_pos <= nxt_wire_pos;
        end
    end
endmodule