/* 
    Module: mem_select_detector
    Description:
        takes in the strobe, button, and mem_pos to detect when the select button is pressed.
    takes in the random display number and labels for stages to set the right number to be pressed.
    Update the stage until stage five then send out the mem_clear signal, otherwise, 
    send out the error signal if the wrong button is pressed. 
*/

`define MENU 3'b000
`define PLAY 3'b001
`define LOST 3'b010
`define WON 3'b011

`define MOD 3'b000
`define MAZE 3'b001
`define WIRE 3'b010
`define MEM 3'b011

`define SELECT 6'b000001
`define UP 6'b000010
`define RIGHT 6'b000100
`define DOWN 6'b001000
`define LEFT 6'b010000
`define BACK 6'b100000
`define NO_PRESS 6'b000000

module mem_select_detector(
    input logic nrst,
    input logic clk,
    input logic [2:0] playing_state_in, 
    input logic activate_rand,
    input logic strobe,
    input logic [5:0] button,
    input logic [1:0] display_num_0,
    input logic [1:0] display_num_1,
    input logic [1:0] display_num_2,
    input logic [1:0] display_num_3,
    input logic [1:0] display_num_4,
    input logic [1:0] label_num_0_0,
    input logic [1:0] label_num_0_1,
    input logic [1:0] label_num_0_2,
    input logic [1:0] label_num_0_3,
    input logic [1:0] label_num_0_4,
    input logic [1:0] label_num_1_0,
    input logic [1:0] label_num_1_1,
    input logic [1:0] label_num_1_2,
    input logic [1:0] label_num_1_3,
    input logic [1:0] label_num_1_4,
    input logic [1:0] label_num_2_0,
    input logic [1:0] label_num_2_1,
    input logic [1:0] label_num_2_2,
    input logic [1:0] label_num_2_3,
    input logic [1:0] label_num_2_4,
    input logic [1:0] label_num_3_0,
    input logic [1:0] label_num_3_1,
    input logic [1:0] label_num_3_2,
    input logic [1:0] label_num_3_3,
    input logic [1:0] label_num_3_4,
  // display number for position 1-4, stage 1-5, vary from 1-4
    input logic [1:0] mem_pos,  // current selected position
    output logic mem_error,     // memory game error strobe signal
    output logic mem_clear,     // memory game clear strobe signal
    output logic [2:0] stage
);  

    logic [1:0]display_num[4:0];
    logic [1:0]label_num[3:0][4:0];
    // assign display_num = '{2'd0, 2'd1, 2'd2, 2'd3, 2'd1};
    // assign label_num[0] = '{2'd0, 2'd0, 2'd0, 2'd0, 2'd0};
    // assign label_num[1] = '{2'd1, 2'd1, 2'd1, 2'd1, 2'd1};
    // assign label_num[2] = '{2'd2, 2'd2, 2'd2, 2'd2, 2'd2};
    // assign label_num[3] = '{2'd3, 2'd3, 2'd3, 2'd3, 2'd3}; 
    // assign display_num[4:0] = '{display_num_0, display_num_1, display_num_2, display_num_3, display_num_4};
    // assign label_num[0] = '{label_num_0_0, label_num_0_1, label_num_0_2, label_num_0_3, label_num_0_4};
    // assign label_num[1] = '{label_num_1_0, label_num_1_1, label_num_1_2, label_num_1_3, label_num_1_4};
    // assign label_num[2] = '{label_num_2_0, label_num_2_1, label_num_2_2, label_num_2_3, label_num_2_4};
    // assign label_num[3] = '{label_num_3_0, label_num_3_1, label_num_3_2, label_num_3_3, label_num_3_4};

    assign    display_num[0] = display_num_4;
    assign    display_num[1] = display_num_3;
    assign    display_num[2] = display_num_2;
    assign    display_num[3] = display_num_1;
    assign    display_num[4] = display_num_0;
    assign    label_num[0][0] = label_num_0_4;
    assign    label_num[0][1] = label_num_0_3;
    assign    label_num[0][2] = label_num_0_2;
    assign    label_num[0][3] = label_num_0_1;
    assign    label_num[0][4] = label_num_0_0;
    assign    label_num[1][0] = label_num_1_4;
    assign    label_num[1][1] = label_num_1_3;
    assign    label_num[1][2] = label_num_1_2;
    assign    label_num[1][3] = label_num_1_1;
    assign    label_num[1][4] = label_num_1_0;
    assign    label_num[2][0] = label_num_2_4;
    assign    label_num[2][1] = label_num_2_3;
    assign    label_num[2][2] = label_num_2_2;
    assign    label_num[2][3] = label_num_2_1;
    assign    label_num[2][4] = label_num_2_0;
        
    assign   label_num[3][0] = label_num_3_4;
    assign   label_num[3][1] = label_num_3_3;
    assign   label_num[3][2] = label_num_3_2;
    assign   label_num[3][3] = label_num_3_1;
   assign     label_num[3][4] = label_num_3_0;
    logic [2:0] nxt_stage;      // logic to update the stage
    logic [1:0] right_pos[4:0]; // correct position for stage 1-5, position vary from 1-4

    always_ff @ (negedge nrst, posedge clk) begin
        if(!nrst) begin
            stage <= 3'd0;
        end else begin
            stage <= nxt_stage;
        end
    end

    always_comb begin
        for(integer i = 0; i < 4; i++) begin
        
                right_pos[i] = 2'b0; 
        end 
        mem_clear = 1'b0;
        mem_error = 1'b0;
        nxt_stage = stage;

        case (display_num[0])
            0: begin right_pos[0] = 2'd1; end  // if display 1: press the second position
            1: begin right_pos[0] = 2'd1; end  // if display 2: press the second position
            2: begin right_pos[0] = 2'd2; end  // if display 3: press the third position
            3: begin right_pos[0] = 2'd3; end  // if display 4: press the fourth position
            default:;
        endcase

        case (display_num[1])
            0: begin                                    // if display 1:
                for(integer i = 0; i < 4; i++) begin
                    if (label_num[i][1] == 2'd3) begin  // press the button labled 4
                        right_pos[1] = 2'(i); 
                    end
                end 
            end
            1: begin right_pos[1] = right_pos[0]; end   // if display 2: press the button in the same position as stage 1
            2: begin right_pos[1] = 2'd0; end           // if display 3: press the first position
            3: begin right_pos[1] = right_pos[0]; end   // if display 4: press the button in the same position as stage 1
            default:;
        endcase

        case (display_num[2])
            0: begin                                    // if display 1:
                for(integer i = 0; i < 4; i++) begin
                    if (label_num[i][2] == label_num[right_pos[1]][1]) begin
                        right_pos[2] = 2'(i);           // press the button with the same label you pressed in stage 2
                    end
                end
            end
            1: begin                                    // if display 2:
                for(integer i = 0; i < 4; i++) begin
                    if (label_num[i][2] == label_num[right_pos[0]][0]) begin
                        right_pos[2] = 2'(i);           // press the button with the same label you pressed in stage 1
                    end
                end
            end
            2: begin right_pos[2] = 2'd2; end   // if display 3: press the third position
            3: begin                                    // if display 4:
                for(integer i = 0; i < 4; i++) begin
                    if (label_num[i][2] == 2'd3) begin  // press the button labled 4
                        right_pos[2] = 2'(i); 
                    end
                end 
            end
            default:;
        endcase
    
        case (display_num[3])
            0: begin right_pos[3] = right_pos[0]; end   // if display 1: press the button in the same position as stage 1
            1: begin right_pos[3] = 2'd0; end           // if display 2: press the first position
            2: begin right_pos[3] = right_pos[1]; end   // if display 3: press the button in the same position as stage 2
            3: begin right_pos[3] = right_pos[1]; end   // if display 4: press the button in the same position as stage 2
            default:;
        endcase
    
        case (display_num[4])
            0: begin                    
                right_pos[4] = 2'd0;                // if display 1:
                for(integer i = 0; i < 4; i++) begin
                    if (label_num[i][4] == label_num[right_pos[0]][0]) begin
                        right_pos[4] = 2'(i);           // press the button with the same label you pressed in stage 1
                    end
                end
            end
            1: begin                                    // if display 2:
                for(integer i = 0; i < 4; i++) begin
                    right_pos[4] = 2'd0;  
                    if (label_num[i][4] == label_num[right_pos[1]][1]) begin
                        right_pos[4] = 2'(i);           // press the button with the same label you pressed in stage 2
                    end
                end
            end
            2: begin                                    // if display 3:
                for(integer i = 0; i < 4; i++) begin
                    right_pos[4] = 2'd0;  
                    if (label_num[i][4] == label_num[right_pos[3]][3]) begin
                        right_pos[4] = 2'(i);           // press the button with the same label you pressed in stage 4
                    end
                end
            end
            3: begin                                    // if display 4:
                for(integer i = 0; i < 4; i++) begin
                    right_pos[4] = 2'd0;  
                    if (label_num[i][4] == label_num[right_pos[2]][2]) begin
                        right_pos[4] = 2'(i);           // press the button with the same label you pressed in stage 3
                    end
                end
            end
            default:
            right_pos[4] = 2'd0; 
        endcase

        if (activate_rand) begin
            nxt_stage = 3'd0;
        end else if (playing_state_in == `MEM && strobe && button == `SELECT) begin
            if (mem_pos == right_pos[stage]) begin
                if (stage == 3'd4) begin
                    mem_clear = 1'b1;
                end else begin
                    nxt_stage = stage + 1;
                end
            end else begin
                mem_error = 1'b1;
            end
        end
    end

endmodule