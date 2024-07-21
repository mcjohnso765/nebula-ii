/*  
    Module: wire_game
    Description:    
        implement the wire game
*/
module t07_wire_game (
    input logic nrst,
    input logic clk,
    input logic strobe,
    input logic [5:0] button,
    input logic [2:0] playing_state_in,
    input logic activate_rand,
    input logic wire_cleared,
    output logic wire_error,
    output logic wire_clear,
    output logic [2:0] wire_num,
    output logic [17:0] wire_color_bus,
    output logic [5:0] wire_status,
    output logic [2:0] wire_pos
);
    // assign wire_num = 3'd3;
    // assign wire_color = {3'd5, 3'd5, 3'd5, 3'd2, 3'd1, 3'd0};   // wire 6 first, then 5, 4, 3, 2, 1

    // color code: 0 - red, 1 - white, 2 - yellow, 3 - blue, 4 - gray, 5 - no wire
    t07_wire_wire_gen wire_wire_gen_0 (
        .nrst(nrst),
        .clk(clk),
        .activate_rand(activate_rand),
        .wire_num(wire_num),
        .wire_color_bus(wire_color_bus)
    );

    t07_wire_cut_detector wire_cut_detector_0 (
        .nrst(nrst),
        .clk(clk),
        .activate_rand(activate_rand),          
        .playing_state_in(playing_state_in), 
        .strobe(strobe),
        .button(button),
        .wire_num(wire_num),         
        .wire_color_bus(wire_color_bus),  
        .wire_pos(wire_pos),         
        .wire_status(wire_status),     
        .wire_clear(wire_clear),            
        .wire_error(wire_error)             
    );  
    t07_wire_wire_locator wire_locator_0 (
        .nrst(nrst),
        .clk(clk),
        .playing_state_in(playing_state_in),
        .strobe(strobe),
        .button(button),
        .wire_cleared(wire_cleared),
        .wire_num(wire_num),         
        .wire_pos(wire_pos)
    );
endmodule