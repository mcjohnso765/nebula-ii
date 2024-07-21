/*
    Module: generate_wire
    Description:    
        take in the wire_num, wire_color, wire_status, and wire_pos,
    then generate the signal indicating the wire with the corresponding color 
    and status (cut/uncut) and the highlight around the selected wire
*/
module t07_generate_wire (
    input logic nrst,
    input logic clk,
    input logic [8:0] x,
    input logic [7:0] y, 
    input logic [2:0] wire_num,
    input logic [5:0] wire_status,
    input logic [2:0] wire_pos,
    output logic [5:0] wirePixel,
    output logic wireHighlightPixel
);
    `define WIRE_HEIGHT 120
    `define WIRE_CUT_HEIGHT 40
    `define WIRE_LENGTH 10
    `define SCREEN_WIDTH 240
    `define MARGIN 40
    `define SPACE_WIRE 20
    `define BAND_HEIGHT 20
    `define HIHGLIGHT 3

    logic [5:0] wireDetect;
    logic wireHighlightDetect;

    always_comb begin
        for(integer i = 0; i < 6; i++) begin     // set the pixel for wire_num number of wires
            wireDetect[i] = 1'd0;
            if(x < 9'(`SCREEN_WIDTH - (`MARGIN + i * (`WIRE_LENGTH + `SPACE_WIRE)))
            && x > 9'(`SCREEN_WIDTH - (`MARGIN + i * (`WIRE_LENGTH + `SPACE_WIRE) + `WIRE_LENGTH))
            && y > 8'(`MARGIN + `BAND_HEIGHT)
            && y < 8'(`MARGIN + `BAND_HEIGHT + `WIRE_HEIGHT)) begin
                wireDetect[i] = 1'd1;
                // set the pixel back to zero in the middle of the wire if it was cut
                if (wire_status[i] 
                && y > 8'(`MARGIN + `BAND_HEIGHT + `WIRE_CUT_HEIGHT)
                && y < 8'(`MARGIN + `BAND_HEIGHT + `WIRE_HEIGHT- `WIRE_CUT_HEIGHT)) begin
                    wireDetect[i] = 1'd0;
                end
            end
        end
        wireHighlightDetect = 0;
        if(x < 9'(`SCREEN_WIDTH - (`MARGIN + wire_pos * (`WIRE_LENGTH + `SPACE_WIRE)) + `HIHGLIGHT)
        && x > 9'(`SCREEN_WIDTH - (`MARGIN + wire_pos * (`WIRE_LENGTH + `SPACE_WIRE) + `WIRE_LENGTH) - `HIHGLIGHT)
        && y > 8'(`MARGIN + `BAND_HEIGHT)
        && y < 8'(`MARGIN + `BAND_HEIGHT + `WIRE_HEIGHT) 
        && !(|wireDetect)) begin
            wireHighlightDetect = 1;
        end
    end

    // assign output
    always_ff @(negedge nrst, posedge clk) begin
        if(!nrst) begin
            wirePixel <= '0;
            wireHighlightPixel <= 0;
        end else begin
            wirePixel <= wireDetect;
            wireHighlightPixel <= wireHighlightDetect;
        end
    end
endmodule