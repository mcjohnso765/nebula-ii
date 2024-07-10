/*  
    Module: mem_game
    Description:    
        implement the memory game
*/
module mem_game (
    input logic nrst,
    input logic clk,
    input logic [5:0]button,
    input logic strobe,
    input logic [2:0] game_state_in,
    input logic [2:0] playing_state_in,
    input logic activate_rand,
    output logic mem_error,
    output logic mem_clear,
    output logic [1:0] mem_pos,
    output logic [1:0] display_num_0,
    output logic [1:0] display_num_1,
    output logic [1:0] display_num_2,
    output logic [1:0] display_num_3,
    output logic [1:0] display_num_4,
    output logic [1:0] label_num_0_0,
    output logic [1:0] label_num_0_1,
    output logic [1:0] label_num_0_2,
    output logic [1:0] label_num_0_3,
    output logic [1:0] label_num_0_4,
    output logic [1:0] label_num_1_0,
    output logic [1:0] label_num_1_1,
    output logic [1:0] label_num_1_2,
    output logic [1:0] label_num_1_3,
    output logic [1:0] label_num_1_4,
    output logic [1:0] label_num_2_0,
    output logic [1:0] label_num_2_1,
    output logic [1:0] label_num_2_2,
    output logic [1:0] label_num_2_3,
    output logic [1:0] label_num_2_4,
    output logic [1:0] label_num_3_0,
    output logic [1:0] label_num_3_1,
    output logic [1:0] label_num_3_2,
    output logic [1:0] label_num_3_3,
    output logic [1:0] label_num_3_4,
    output logic [2:0] stage
);  
    initial begin
    // Initialize display_num elements
    display_num_0 = 2'd0;
    display_num_1 = 2'd1;
    display_num_2 = 2'd2;
    display_num_3 = 2'd3;
    display_num_4 = 2'd1;

    // Initialize label_num elements for the first row
    label_num_0_0 = 2'd0;
    label_num_0_1 = 2'd0;
    label_num_0_2 = 2'd0;
    label_num_0_3 = 2'd0;
    label_num_0_4 = 2'd0;

    // Initialize label_num elements for the second row
    label_num_1_0 = 2'd1;
    label_num_1_1 = 2'd1;
    label_num_1_2 = 2'd1;
    label_num_1_3 = 2'd1;
    label_num_1_4 = 2'd1;

    // Initialize label_num elements for the third row
    label_num_2_0 = 2'd2;
    label_num_2_1 = 2'd2;
    label_num_2_2 = 2'd2;
    label_num_2_3 = 2'd2;
    label_num_2_4 = 2'd2;

    // Initialize label_num elements for the fourth row
    label_num_3_0 = 2'd3;
    label_num_3_1 = 2'd3;
    label_num_3_2 = 2'd3;
    label_num_3_3 = 2'd3;
    label_num_3_4 = 2'd3;
end
logic [1:0]display_num[4:0];
logic [1:0]label_num[3:0][4:0];
    // assign display_num = '{2'd0, 2'd1, 2'd2, 2'd3, 2'd1};
    // assign label_num[0] = '{2'd0, 2'd0, 2'd0, 2'd0, 2'd0};
    // assign label_num[1] = '{2'd1, 2'd1, 2'd1, 2'd1, 2'd1};
    // assign label_num[2] = '{2'd2, 2'd2, 2'd2, 2'd2, 2'd2};
    // assign label_num[3] = '{2'd3, 2'd3, 2'd3, 2'd3, 2'd3}; 
initial begin
        display_num[0] = display_num_4;
        display_num[1] = display_num_3;
        display_num[2] = display_num_2;
        display_num[3] = display_num_1;
        display_num[4] = display_num_0;
        label_num[0][0] = label_num_0_4;
        label_num[0][1] = label_num_0_3;
        label_num[0][2] = label_num_0_2;
        label_num[0][3] = label_num_0_1;
        label_num[0][4] = label_num_0_0;
        label_num[1][0] = label_num_1_4;
        label_num[1][1] = label_num_1_3;
        label_num[1][2] = label_num_1_2;
        label_num[1][3] = label_num_1_1;
        label_num[1][4] = label_num_1_0;
        label_num[2][0] = label_num_2_4;
        label_num[2][1] = label_num_2_3;
        label_num[2][2] = label_num_2_2;
        label_num[2][3] = label_num_2_1;
        label_num[2][4] = label_num_2_0;
        
        label_num[3][0] = label_num_3_4;
        label_num[3][1] = label_num_3_3;
        label_num[3][2] = label_num_3_2;
        label_num[3][3] = label_num_3_1;
        label_num[3][4] = label_num_3_0;
end

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
        .display_num_0(display_num[0]),
        .display_num_1(display_num[1]),
        .display_num_2(display_num[2]),
        .display_num_3(display_num[3]),
        .display_num_4(display_num[4]),
        .label_num_0_0(label_num[0][0]),
        .label_num_0_1(label_num[0][1]),
        .label_num_0_2(label_num[0][2]),
        .label_num_0_3(label_num[0][3]),
        .label_num_0_4(label_num[0][4]),
        .label_num_1_0(label_num[1][0]),
        .label_num_1_1(label_num[1][1]),
        .label_num_1_2(label_num[1][2]),
        .label_num_1_3(label_num[1][3]),
        .label_num_1_4(label_num[1][4]),
        .label_num_2_0(label_num[2][0]),
        .label_num_2_1(label_num[2][1]),
        .label_num_2_2(label_num[2][2]),
        .label_num_2_3(label_num[2][3]),
        .label_num_2_4(label_num[2][4]),
        .label_num_3_0(label_num[3][0]),
        .label_num_3_1(label_num[3][1]),
        .label_num_3_2(label_num[3][2]),
        .label_num_3_3(label_num[3][3]),
        .label_num_3_4(label_num[3][4]),   
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