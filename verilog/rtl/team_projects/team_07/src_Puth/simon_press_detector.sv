/*
    Module: simon_press_detector
    Description:
        takes in the button and the strobe, the check whenever a button is pressed,
    Then change between showing the sequence and receiving input states and send
    the game clear signal when all sequence is pressed in the right order, and send the
    error and reset the state to showing when the wrong button is pressed.
    - button to color to number: UP - blue(0), RIGHT - yellow(1), DOWN - green(2), LEFT - red(3)
*/

`define MENU 3'b000
`define PLAY 3'b001
`define LOST 3'b010
`define WON 3'b011

`define MOD 3'b000
`define MAZE 3'b001
`define WIRE 3'b010
`define MEM 3'b011
`define SIMON 3'd4

`define SELECT 6'b000001
`define UP 6'b000010
`define RIGHT 6'b000100
`define DOWN 6'b001000
`define LEFT 6'b010000
`define BACK 6'b100000
`define NO_PRESS 6'b000000

module t07_simon_press_detector(
    input logic nrst,
    input logic clk,
    input logic strobe,
    input logic [5:0] button,
    input logic [2:0] playing_state_in, 
    input logic activate_rand,
    input logic [9:0] simon_sequence_bus, // simon says color sequence for stage 1-5, value vary from 1-4
    input logic [1:0] lives,
    input logic simon_cleared, 
    output logic simon_error,
    output logic simon_clear,
    output logic [3:0] simon_state_out
);
    logic [1:0] right_bt [4:0];     // right button to be pressed corresponding to simon_sequence, for stage 1- 5, value vary from 1-4
    logic [2:0] num_pressed, nxt_num_pressed;
    logic [2:0] stage, nxt_stage;
    typedef enum logic [3:0] {
        D1 = 4'd0, I1 = 4'd1,
        D2 = 4'd2, I2 = 4'd3,
        D3 = 4'd4, I3 = 4'd5,
        D4 = 4'd6, I4 = 4'd7,
        D5 = 4'd8, I5 = 4'd9
    } simon_state_t;

    function [5:0] color_to_button (input logic [1:0] color);
        begin
            case(color)
                2'b00: color_to_button = `UP;
                2'b01: color_to_button = `RIGHT;
                2'b10: color_to_button = `DOWN;
                2'b11: color_to_button = `LEFT;
            endcase
        end
    endfunction

    assign simon_state_out = simon_state;
    
    simon_state_t simon_state, nxt_simon_state;
    always_ff @(negedge nrst, posedge clk) begin
        if (!nrst) begin
            simon_state <= D1;
            num_pressed <= 3'd0;
            stage <= 3'd0;
        end else begin
            simon_state <= nxt_simon_state;
            num_pressed <= nxt_num_pressed;
            stage <= nxt_stage;
        end
    end

    // button to color: UP - blue, RIGHT - yellow, DOWN - green, LEFT - red
    always_comb begin
        simon_clear = 1'd0;
        simon_error = 1'd0;
        nxt_simon_state = simon_state;
        nxt_stage = stage;
        nxt_num_pressed = num_pressed;
        // logic for the right button to be pressed for each stage 1-5
        for (integer i = 0; i < 5; i++) begin
            right_bt[i] = 2'd0;
            if (lives == 2'd3) begin   // if no strikes (the lives is still three)
                case (simon_sequence_bus[i * 2 +: 2])    
                    2'd0: begin right_bt[i] = 2'd3; end // blue -> red
                    2'd1: begin right_bt[i] = 2'd2; end // yellow -> green
                    2'd2: begin right_bt[i] = 2'd1; end // green -> yellow
                    2'd3: begin right_bt[i] = 2'd0; end // red -> blue
                    default:;
                endcase 
            end else if (lives == 2'd2) begin   // if one strikes (the lives is two)
                case (simon_sequence_bus[i * 2 +: 2])    
                    2'd0: begin right_bt[i] = 2'd2; end // blue -> green
                    2'd1: begin right_bt[i] = 2'd3; end // yellow -> red
                    2'd2: begin right_bt[i] = 2'd0; end // green -> blue
                    2'd3: begin right_bt[i] = 2'd1; end // red -> yellow
                    default:;
                endcase 
            end else if (lives == 2'd1) begin   // if two strikes (the lives is one)
                case (simon_sequence_bus[i * 2 +: 2])    
                    2'd0: begin right_bt[i] = 2'd3; end // blue -> red
                    2'd1: begin right_bt[i] = 2'd0; end // yellow -> blue
                    2'd2: begin right_bt[i] = 2'd1; end // green -> yellow
                    2'd3: begin right_bt[i] = 2'd2; end // red -> green
                    default:;
                endcase 
            end
        end

        // logic to proceed between displaying sequence and receiving input states
        if (activate_rand) begin
            nxt_simon_state = D1;
            nxt_stage = 0;
        end else if (playing_state_in == `SIMON && !simon_cleared) begin
            case (simon_state)
                D1, D2, D3, D4, D5: begin
                    nxt_num_pressed = 0;
                    if (button == color_to_button(right_bt[0]) && strobe) begin
                        if (simon_state == D1) begin
                            nxt_simon_state = I1;
                        end else if (simon_state == D2) begin
                            nxt_simon_state = I2;
                        end else if (simon_state == D3) begin
                            nxt_simon_state = I3;
                        end else if (simon_state == D4) begin
                            nxt_simon_state = I4;
                        end else begin
                            nxt_simon_state = I5;
                        end
                        // nxt_simon_state = (simon_state == D1) ? I1 :
                        //     (simon_state == D2) ? I2 :
                        //     (simon_state == D3) ? I3 :
                        //     (simon_state == D4) ? I4 : I5;
                        nxt_num_pressed = 3'd1;
                    end else if (button != `SELECT && button != `BACK && strobe) begin
                        simon_error = 1'd1;
                    end
                end
                I1: begin
                    nxt_stage = stage + 1;
                    nxt_simon_state = D2;
                end
                I2, I3, I4, I5: begin
                    if (button == color_to_button(right_bt[num_pressed]) && strobe) begin     // if pressing the right button
                        if(num_pressed == stage) begin          // if that the last in the sequence
                            if(stage == 3'd4) begin             // if in the last simon state
                                simon_clear = 1'd1;             // send the simon_clear strobe signal
                            end else begin                      // else
                                nxt_stage = stage + 1;          // increase to the next stage
                                nxt_num_pressed = 3'd0;         // reset the num_pressed to zero for the next stage
                                if (simon_state == I1) begin
                                    nxt_simon_state = D2;
                                end else if (simon_state == I2) begin
                                    nxt_simon_state = D3;
                                end else if (simon_state == I3) begin
                                    nxt_simon_state = D4;
                                end else if (simon_state == I4) begin
                                    nxt_simon_state = D5;
                                end
                                // nxt_simon_state = (simon_state == I1) ? D2 :
                                //     (simon_state == I2) ? D3 :
                                //     (simon_state == I3) ? D4 :
                                //     (simon_state == I4) ? D5 : D5;
                            end
                        end else begin                          // if not the last in the sequence,
                            nxt_num_pressed = num_pressed + 1;  // increase the num_pressed to check the next button in the sequence
                        end
                    end else if (button != `SELECT && button != `BACK && strobe) begin    // else,
                        simon_error = 1'd1;                     // send out the error signal
                        if (simon_state == I1) begin            // go back to the displaying sequence state again
                            nxt_simon_state = D1;
                        end else if (simon_state == I2) begin
                            nxt_simon_state = D2;
                        end else if (simon_state == I3) begin
                            nxt_simon_state = D3;
                        end else if (simon_state == I4) begin
                            nxt_simon_state = D4;
                        end else begin
                            nxt_simon_state = D5;
                        end
                        // nxt_simon_state = (simon_state == I1) ? D1 :                
                        //     (simon_state == I2) ? D2 :
                        //     (simon_state == I3) ? D3 :
                        //     (simon_state == I4) ? D4 : D5;
                    end 
                end
                default:;
            endcase
        end
    end

endmodule