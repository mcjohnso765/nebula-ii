/*  
    Module: mem_game
    Description:    
        implement the memory game
*/
module mem_game (
    input logic nrst,
    input logic clk,
    input logic strobe,
    input logic [5:0] button,
    input logic [2:0] game_state_in,
    input logic [2:0] playing_state_in,
    input logic activate_rand,
    output logic mem_error,
    output logic mem_clear,
    output logic [1:0] mem_pos,
    output logic [1:0] display_num[4:0],
    output logic [1:0] label_num[3:0][4:0],
    output logic [2:0] stage
);
    assign display_num = '{2'd0, 2'd1, 2'd2, 2'd3, 2'd1};
    assign label_num[0] = '{2'd0, 2'd0, 2'd0, 2'd0, 2'd0};
    assign label_num[1] = '{2'd1, 2'd1, 2'd1, 2'd1, 2'd1};
    assign label_num[2] = '{2'd2, 2'd2, 2'd2, 2'd2, 2'd2};
    assign label_num[3] = '{2'd3, 2'd3, 2'd3, 2'd3, 2'd3}; 

    // color code: 0 - red, 1 - white, 2 - yellow, 3 - blue, 4 - gray, 5 - no wire
    // wire_wire_gen wire_wire_gen_0 (
    //     .nrst(nrst),
    //     .clk(clk),
    //     .activate_rand(activate_rand),
    //     .wire_num(wire_num),
    //     .wire_color(wire_color)
    // );

    mem_select_detector wire_cut_detector_0 (
        .nrst(nrst),
        .clk(clk),
        .activate_rand(activate_rand),          
        .playing_state_in(playing_state_in), 
        .strobe(strobe),
        .button(button),
        .display_num(display_num),         
        .label_num(label_num),  
        .mem_pos(mem_pos),         
        .stage(stage),     
        .mem_clear(mem_clear),            
        .mem_error(mem_error)             
    );  

    mem_select_locator wire_locator_0 (
        .nrst(nrst),
        .clk(clk),
        .playing_state_in(playing_state_in),
        .strobe(strobe),
        .button(button),      
        .mem_pos(mem_pos)
    );

endmodule