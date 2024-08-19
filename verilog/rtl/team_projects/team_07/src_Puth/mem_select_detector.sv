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

module t07_mem_select_detector(
    input logic nrst,
    input logic clk,
    input logic [2:0] playing_state_in, 
    input logic activate_rand,
    input logic strobe,
    input logic [5:0] button,
    input logic mem_cleared,
    input logic [9:0] display_num_bus,     // display number for stage 1-5, 2-bit value vary from 1-4
    input logic [39:0] label_num_bus,      // display number for 5 stages, 4 position, 2-bit values from 1-4
    input logic [1:0] mem_pos,  // current selected position
    output logic mem_error,     // memory game error strobe signal
    output logic mem_clear,     // memory game clear strobe signal
    output logic [2:0] stage
);
    logic [2:0] nxt_stage;      // logic to update the stage
    logic [1:0] right_pos[4:0]; // correct position for stage 1-5, 2-bit position value vary from 1-4

    always_ff @ (negedge nrst, posedge clk) begin
        if(!nrst) begin
            stage <= 3'd0;
        end else begin
            stage <= nxt_stage;
        end
    end

    always_comb begin
        for (integer i = 0; i < 5; i++) begin
            right_pos[i] = 2'd0;
        end
        mem_clear = 1'b0;
        mem_error = 1'b0;
        nxt_stage = stage;

        case (display_num_bus[0 * 2 +: 2])
            0: begin right_pos[0] = 2'd1; end  // if display 1: press the second position
            1: begin right_pos[0] = 2'd1; end  // if display 2: press the second position
            2: begin right_pos[0] = 2'd2; end  // if display 3: press the third position
            3: begin right_pos[0] = 2'd3; end  // if display 4: press the fourth position
            default:;
        endcase

        case (display_num_bus[1 * 2 +: 2])
            0: begin                                    // if display 1:
                for(integer i = 0; i < 4; i++) begin
                    if (label_num_bus[1 * 8 + i * 2 +: 2] == 2'd3) begin  // press the button labled 4
                        right_pos[1] = 2'(i); 
                    end
                end 
            end
            1: begin right_pos[1] = right_pos[0]; end   // if display 2: press the button in the same position as stage 1
            2: begin right_pos[1] = 2'd0; end           // if display 3: press the first position
            3: begin right_pos[1] = right_pos[0]; end   // if display 4: press the button in the same position as stage 1
            default:;
        endcase

        case (display_num_bus[2 * 2 +: 2])
            0: begin                                    // if display 1:
                for(integer i = 0; i < 4; i++) begin
                    if (label_num_bus[2 * 8 + i * 2 +: 2] == label_num_bus[1 * 8 + right_pos[1] * 2 +: 2]) begin
                        right_pos[2] = 2'(i);           // press the button with the same label you pressed in stage 2
                    end
                end
            end
            1: begin                                    // if display 2:
                for(integer i = 0; i < 4; i++) begin
                    if (label_num_bus[2 * 8 + i * 2 +: 2] == label_num_bus[0 * 8 + right_pos[0] * 2 +: 2]) begin
                        right_pos[2] = 2'(i);           // press the button with the same label you pressed in stage 1
                    end
                end
            end
            2: begin right_pos[2] = 2'd2; end   // if display 3: press the third position
            3: begin                                    // if display 4:
                for(integer i = 0; i < 4; i++) begin
                    if (label_num_bus[2 * 8 + i * 2 +: 2] == 2'd3) begin  // press the button labled 4
                        right_pos[2] = 2'(i); 
                    end
                end 
            end
            default:;
        endcase
    
        case (display_num_bus[3 * 2 +: 2])
            0: begin right_pos[3] = right_pos[0]; end   // if display 1: press the button in the same position as stage 1
            1: begin right_pos[3] = 2'd0; end           // if display 2: press the first position
            2: begin right_pos[3] = right_pos[1]; end   // if display 3: press the button in the same position as stage 2
            3: begin right_pos[3] = right_pos[1]; end   // if display 4: press the button in the same position as stage 2
            default:;
        endcase
    
        case (display_num_bus[4 * 2 +: 2])
            0: begin                                    // if display 1:
                for(integer i = 0; i < 4; i++) begin
                    if (label_num_bus[4 * 8 + i * 2 +: 2] == label_num_bus[0 * 8 + right_pos[0] * 2 +: 2]) begin
                        right_pos[4] = 2'(i);           // press the button with the same label you pressed in stage 1
                    end
                end
            end
            1: begin                                    // if display 2:
                for(integer i = 0; i < 4; i++) begin
                    if (label_num_bus[4 * 8 + i * 2 +: 2] == label_num_bus[1 * 8 + right_pos[1] * 2 +: 2]) begin
                        right_pos[4] = 2'(i);           // press the button with the same label you pressed in stage 2
                    end
                end
            end
            2: begin                                    // if display 3:
                for(integer i = 0; i < 4; i++) begin
                    if (label_num_bus[4 * 8 + i * 2 +: 2] == label_num_bus[3 * 8 + right_pos[3] * 2 +: 2]) begin
                        right_pos[4] = 2'(i);           // press the button with the same label you pressed in stage 4
                    end
                end
            end
            3: begin                                    // if display 4:
                for(integer i = 0; i < 4; i++) begin
                    if (label_num_bus[4 * 8 + i * 2 +: 2] == label_num_bus[2 * 8 + right_pos[2] * 2 +: 2]) begin
                        right_pos[4] = 2'(i);           // press the button with the same label you pressed in stage 3
                    end
                end
            end
        endcase

        if (activate_rand) begin
            nxt_stage = 3'd0;
        end else if (playing_state_in == `MEM && strobe && button == `SELECT && !mem_cleared) begin
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