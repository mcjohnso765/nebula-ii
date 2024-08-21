/*  
    Module: mem_game
    Description:    
        implement the memory game
*/
module t07_mem_game (
    input logic nrst,
    input logic clk,
    input logic strobe,
    input logic [5:0] button,
    input logic [2:0] playing_state_in,
    input logic activate_rand,
    input logic mem_cleared,
    output logic mem_error,
    output logic mem_clear,
    output logic [1:0] mem_pos,
    output logic [9:0] display_num_bus,    // 5 stages, 2-bit number (1-4)
    output logic [39:0] label_num_bus,     // 5 stages, 4 position, 2-bit values
    output logic [2:0] stage
);
    // assign display_num = {2'd0, 2'd1, 2'd2, 2'd3, 2'd1};    // Note that lsb (stage 1) last
    // assign label_num[0] = {2'd0, 2'd1, 2'd2, 2'd3};
    // assign label_num[1] = {2'd1, 2'd2, 2'd3, 2'd0};
    // assign label_num[2] = {2'd2, 2'd3, 2'd0, 2'd1};
    // assign label_num[3] = {2'd3, 2'd0, 2'd1, 2'd2}; 
    // assign label_num[4] = {2'd0, 2'd1, 2'd2, 2'd3};
   
    t07_mem_num_gen mem_num_gen_0 (
        .nrst(nrst),
        .clk(clk),
        .activate_rand(activate_rand),
        .display_num_bus(display_num_bus),
        .label_num_bus(label_num_bus)
    );

    t07_mem_select_detector wire_cut_detector_0 (
        .nrst(nrst),
        .clk(clk),
        .activate_rand(activate_rand),          
        .playing_state_in(playing_state_in), 
        .strobe(strobe),
        .button(button),
        .mem_cleared(mem_cleared),
        .display_num_bus(display_num_bus),         
        .label_num_bus(label_num_bus),  
        .mem_pos(mem_pos),         
        .stage(stage),     
        .mem_clear(mem_clear),            
        .mem_error(mem_error)             
    );  

    t07_mem_select_locator wire_locator_0 (
        .nrst(nrst),
        .clk(clk),
        .playing_state_in(playing_state_in),
        .strobe(strobe),
        .button(button),      
        .mem_cleared(mem_cleared),
        .mem_pos(mem_pos)
    );

endmodule