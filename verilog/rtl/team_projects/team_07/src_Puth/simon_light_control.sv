/*
    Module: simon_light_control
    Description:
        Take in the simon_state and output the signal to light up the corresponding color
    [ button to color to number: UP - blue(0), RIGHT - yellow(1), DOWN - green(2), LEFT - red(3) ]
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

`define D1 4'd0
`define I1 4'd1
`define D2 4'd2
`define I2 4'd3
`define D3 4'd4
`define I3 4'd5
`define D4 4'd6
`define I4 4'd7
`define D5 4'd8
`define I5 4'd9

module t07_simon_light_control(
    input logic nrst,
    input logic clk,
    input logic s_strobe,
    input logic [5:0] unsync_button,
    input logic [3:0] simon_state,
    input logic [9:0] simon_sequence_bus,       // 5 stages, 2-bit color code
    input logic simon_cleared,
    output logic [3:0] simon_light_up_state,    // state for the virtual button to light up showing the sequence
    output logic [3:0] simon_light_up_manual    // state for the virtual button to light up when pressing the actual button
);
    logic [2:0] light_cnt, nxt_light_cnt;
    logic [1:0] wait_cnt, nxt_wait_cnt;
    logic [3:0] nxt_simon_light_up_state;
    logic [2:0] stage;
    always_ff @(negedge nrst, posedge clk) begin
        if(!nrst) begin
            light_cnt <= 3'd0;
            wait_cnt <= 2'd0;
            simon_light_up_state <= 4'd0;
        end else begin
            light_cnt <= nxt_light_cnt;
            wait_cnt <= nxt_wait_cnt;
            simon_light_up_state <= nxt_simon_light_up_state;
        end
    end

    always_comb begin
        nxt_simon_light_up_state = simon_light_up_state;
        nxt_wait_cnt = wait_cnt;
        nxt_light_cnt = light_cnt;
        case (simon_state)
            `D1, `I1: stage = 3'd0;
            `D2, `I2: stage = 3'd1;
            `D3, `I3: stage = 3'd2;
            `D4, `I4: stage = 3'd3;
            `D5, `I5: stage = 3'd4;
            default: stage = 3'd0;
        endcase
        if (simon_cleared) begin
            nxt_simon_light_up_state = 4'b1111;
        end else begin
            case (simon_state)
                `D1, `D2, `D3, `D4, `D5: begin
                    if (s_strobe && wait_cnt < 2'd3) begin     // if wait time less than 3 seconds,
                        nxt_simon_light_up_state = 4'd0;
                        nxt_light_cnt = 3'd0;
                        nxt_wait_cnt = wait_cnt + 1;            // increase the wait count by one
                    end else if (s_strobe && light_cnt <= stage) begin  // every second, 
                        nxt_simon_light_up_state[simon_sequence_bus[light_cnt * 2 +: 2]] = 1'b1;   // set the light up state for the corresponding light_cnt to one
                        if (light_cnt != 0) begin
                            nxt_simon_light_up_state[simon_sequence_bus[(light_cnt - 1) * 2 +: 2]] = 1'b0;   // set the light up state for the corresponding light_cnt to one
                        end
                        nxt_light_cnt = light_cnt + 1;                      // proceed to the next light in the sequence
                    end else if (s_strobe && light_cnt == stage + 1) begin
                        nxt_simon_light_up_state[simon_sequence_bus[(light_cnt - 1) * 2 +: 2]] = 1'b0;
                        nxt_light_cnt = 3'd0;
                        nxt_wait_cnt = 2'd0;
                    end
                end
                `I1, `I2, `I3, `I4, `I5: begin
                    nxt_wait_cnt = 2'd0;
                    nxt_light_cnt = 3'd0;
                end
                default:;
            endcase
        end
        case (unsync_button)
            `UP:    simon_light_up_manual = 4'b0001;
            `RIGHT: simon_light_up_manual = 4'b0010;
            `DOWN:  simon_light_up_manual = 4'b0100;
            `LEFT:  simon_light_up_manual = 4'b1000;
            default: simon_light_up_manual = 4'b0000;
        endcase
    end
endmodule