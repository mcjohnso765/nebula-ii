/*  
    Module: wire_cut_detector
    Description:
        Take in the wire_num and wire color, to set the condition whether which wire
    should be cutted. Then, take in the wire position, strobe, and button to detect when the 
    selected wire is cutted. Then update the wire status, send the error signal
    if the wrong wire is cut, and send the clear signal if the right wire is cut.
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

module t07_wire_cut_detector(
    input logic nrst,
    input logic clk,
    input logic activate_rand,          // signal when move from MENU to PLAY
    input logic [2:0] playing_state_in, // playing_state input
    input logic strobe,
    input logic [5:0] button,
    input logic [2:0] wire_num,         // number of wires: from 3 to 6
    input logic [17:0] wire_color_bus,  // 6 wires, (3-bit colors) 6 colors: red, white, yellow, blue, grey, no_wire
    input logic [2:0] wire_pos,         // wire position
    output logic [5:0] wire_status,     // wire status, 0 - uncut, 1 - cut
    output logic wire_clear,            // wire game clear strobe signal
    output logic wire_error             // wire game error strobe signal
);  
    logic [2:0] color_num [4:0];  // number of wire of each color: 0:red, 1:white, 2:yellow, 3:blue, 4:grey
    logic [2:0] right_wire;      // position of the right wire to cut
    logic [5:0] nxt_wire_status; // wire status for six wires

    always_comb begin
        right_wire = 3'd0;
        wire_clear = 1'b0;
        wire_error = 1'b0;
        nxt_wire_status = wire_status;
        for (integer i = 0; i < 5; i++) begin
            color_num[i] = 3'd0;    // set the count for all color to zero
        end
        for (integer i = 0; i < 3'd6; i++) begin    // iterate through all wire color
            case(wire_color_bus[i * 3 +: 3]) // add the color_num of the color corresponding to the wire
                3'd0: begin color_num[0]++; end
                3'd1: begin color_num[1]++; end
                3'd2: begin color_num[2]++; end
                3'd3: begin color_num[3]++; end
                3'd4: begin color_num[4]++; end
                default:;
            endcase     
        end
        
        if (wire_num == 3'd3) begin // if there are three wires
            if (color_num[0] == 3'd0) begin     // if there's no red wire,
                right_wire = 3'd1;              // cut the second wire
            end else if (wire_color_bus[(wire_num - 1) * 3 +: 3] == 1) begin   // else if the last wire is white,
                right_wire = 3'(wire_num) - 1;                  // cut the last wire
            end else if (color_num[3] > 3'd1) begin             // else if there're more than one blue wire,
                for(integer i = 0; i < 3; i++) begin 
                    if (wire_color_bus[i * 3 +: 3] == 3'd3) begin
                        right_wire = 3'(i);                     // cut the last blue wire
                    end
                end
            end else begin                      // else,
                right_wire = 3'(wire_num) - 1;  // cut the last wire
            end

        end else if (wire_num == 3'd4) begin    // if there are four wires
            if (color_num[0] > 3'd1) begin                      // if there is more than one red wire,
                for(integer i = 0; i < 3'd4; i++) begin
                    if (wire_color_bus[i * 3 +: 3] == 3'd0) begin
                        right_wire = 3'(i);                     // cut the last red wire
                    end
                end
            end else if (color_num[0] == 3'd0 
                && wire_color_bus[(wire_num - 1) * 3 +: 3] == 2) begin     // if there is no red wire, and the last wire is yellow,
                right_wire = 3'd0;                          // cut the first wire                           
            end else if (color_num[3] == 3'd1) begin        // else if there is only one blue wire,
                right_wire = 3'd0;                          // cut the first wire
            end else if (color_num[2] > 3'd1) begin         // if there is more than one yellow wire,
                right_wire = 3'(wire_num) - 1;              // cut the last wire
            end else begin          // else,
                right_wire = 3'd1;  // cut the second wire
            end

        end else if (wire_num == 3'd5) begin    // if there are five wires
            if (wire_color_bus[(wire_num - 1) * 3 +: 3] == 3'd4) begin     // if the last wire is black
                right_wire = 3'd3;                          // cut the fourth wire
            end else if (color_num[0] == 3'd1   // if there is exactly one red wire
                && color_num[2] > 3'd1) begin   // and there is more than one yellow wire,
                right_wire = 3'd0;              // cut the first wire
            end else if (color_num[4] == 3'd0) begin    // if there is no black wire,
                right_wire = 3'd1;                      // cut the second wire
            end else begin          // else,
                right_wire = 3'd0;  // cut the first wire
            end
        
        end else if (wire_num == 3'd6) begin    // if there are six wires
            if (color_num[2] == 3'd0) begin     // if there are no yellow wires,
                right_wire = 3'd2;              // cut the third wire
            end else if (color_num[2] == 3'd1   // if there is exactly one yellow wire
                && color_num[1] > 3'd1) begin   // and there is more than one white wire,
                right_wire = 3'd3;              // cut the fourth wire
            end else if (color_num[0] == 3'd0) begin    // if there are no red wires,
                right_wire = 3'(wire_num) - 1;          // cut the last wire
            end else begin          // else,
                right_wire = 3'd3;  // cut the fourth wire
            end
        end    

        if (activate_rand) begin
            nxt_wire_status = 6'd0;
        end else if (playing_state_in == `WIRE && strobe && button == `SELECT) begin
            if (wire_status[wire_pos] != 1'b1) begin    // if the selected wire is uncut
                nxt_wire_status[wire_pos] = 1'b1;
                if (wire_pos == right_wire) begin
                    wire_clear = 1'b1;
                end else begin
                    wire_error = 1'b1;
                end
            end
        end
    end

    always_ff @(negedge nrst, posedge clk) begin
        if (!nrst) begin
            wire_status <= 6'd0;
        end else begin
            wire_status <= nxt_wire_status;
        end    
    end

endmodule