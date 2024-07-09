/*
    Module: generate_mem
    Description:    
        generate the pixel logic for components in the memory game including:
    - displayPixel: pixel for the display number
    - buttonPixel: pixel for the button background
    - labelPixel: pixel for the label number, position 1-4
    - stagePixel: pixel for the stage light
    - buttonHighlightPixel: pixel fot the selected button highlight
*/
module generate_mem(
    input logic nrst,
    input logic clk,
    input logic [8:0] x,
    input logic [7:0] y, 
    input logic [4:0][1:0] display_num,
    input logic [3:0][4:0][1:0] label_num,
    input logic [2:0] stage,
    input logic [1:0] mem_pos,
    output logic displayPixel,
    output logic buttonPixel,
    output logic [3:0] labelPixel,
    output logic stagePixel,
    output logic buttonHighlightPixel
);

    `define SCREEN_WIDTH 240
    `define BUTTON_HEIGHT 90
    `define BUTTON_WIDTH 40
    `define MARGIN_HEIGHT 20
    `define MARGIN_WIDTH 25
    `define SPACE 10

    logic displayDetect;
    logic buttonDetect;
    logic [3:0] labelDetect;
    logic stageDetect;
    logic buttonHighlightDetect;

    always_ff @(negedge nrst, posedge clk) begin
        if(!nrst) begin
            displayPixel <= 1'd0;
            buttonPixel <= 1'd0;
            labelPixel <= 4'd0;
            stagePixel <= 1'd0;
            buttonHighlightPixel <= 1'd0;
        end else begin
            displayPixel <= displayDetect;
            buttonPixel <= buttonDetect;
            labelPixel <= labelDetect;
            stagePixel <= stageDetect;
            buttonHighlightPixel <= buttonHighlightDetect;
        end
    end

    function screen_ssdec (input logic [8:0] x, input logic [7:0] y, input logic [8:0] btm_lf_x, input logic [7:0] btm_lf_y, input logic [6:0] ssdec);
        begin
            logic [8:0] SCo;
            logic [7:0] SPo;
            logic pixelDetect;
            pixelDetect = 1'd0;
            SCo = '0;
            SPo = '0;
            if (ssdec[6]) begin
                SCo = btm_lf_x - 10;
                SPo = btm_lf_y + 45;
                pixelDetect |= hori_ssdec(x, y, SCo, SPo);
            end
            if (ssdec[5]) begin
                SCo = btm_lf_x - 10;
                SPo = btm_lf_y + 45;
                pixelDetect |= vert_ssdec(x, y, SCo, SPo);
            end
            if (ssdec[4]) begin
                SCo = btm_lf_x - 10;
                SPo = btm_lf_y + 25;
                pixelDetect |= vert_ssdec(x, y, SCo, SPo);
            end
            if (ssdec[3]) begin
                SCo = btm_lf_x - 10;
                SPo = btm_lf_y + 25;
                pixelDetect |= hori_ssdec(x, y, SCo, SPo);
            end
            if (ssdec[2]) begin
                SCo = btm_lf_x - 30;
                SPo = btm_lf_y + 25;
                pixelDetect |= vert_ssdec(x, y, SCo, SPo);
            end
            if (ssdec[1]) begin
                SCo = btm_lf_x - 30;
                SPo = btm_lf_y + 45;
                pixelDetect |= vert_ssdec(x, y, SCo, SPo);
            end
            if (ssdec[0]) begin
                SCo = btm_lf_x - 10;
                SPo = btm_lf_y + 65;
                pixelDetect |= hori_ssdec(x, y, SCo, SPo);
            end
            screen_ssdec = pixelDetect;
        end
    endfunction

    function vert_ssdec (input logic [8:0] x, input logic [7:0] y, input logic [8:0] SCo, input logic [7:0] SPo);
        begin
            if( 
            (((x == SCo -  0) || (x == SCo -  4))
            &&((y >= SPo +  2) && (y <= SPo + 17)))
            ||
            (((x == SCo -  1) || (x == SCo -  3))
            &&((y >= SPo +  1) && (y <= SPo + 18)))
            ||
            ((x == SCo -  2)
            &&((y >= SPo +  0) && (y <= SPo + 19)))) begin
                vert_ssdec = 1'd1;
            end else begin
                vert_ssdec = 1'd0;
            end
        end
    endfunction

    function hori_ssdec (input logic [8:0] x, input logic [7:0] y, input logic [8:0] SCo, input logic [7:0] SPo);
        begin
            if( 
            (((y == SPo +  0) || (y == SPo +  4))
            &&((x <= SCo -  2) && (x >= SCo - 17)))
            ||
            (((y == SPo +  1) || (y == SPo +  3))
            &&((x <= SCo -  1) && (x >= SCo - 18)))
            ||
            ((y == SPo +  2)
            &&((x <= SCo -  0) && (x >= SCo - 19)))) begin
                hori_ssdec = 1'd1;
            end else begin
                hori_ssdec = 1'd0;
            end
        end
    endfunction

    function [6:0] dig_to_ssdec (input logic [1:0] digit);
        case (digit)
            2'd0: dig_to_ssdec = 7'b0000110;    // ssdec for one
            2'd1: dig_to_ssdec = 7'b1011011;    // ssdec for two
            2'd2: dig_to_ssdec = 7'b1001111;    // ssdec for three
            2'd3: dig_to_ssdec = 7'b1100110;    // ssdec for four
            default: dig_to_ssdec = 7'd0;
        endcase
    endfunction

    always_comb begin
        buttonDetect = '0;
        displayDetect = '0;
        labelDetect = '0;
        buttonHighlightDetect = '0;

        // buttonDetect logic
        for (integer i = 0; i < 4; i++) begin
            if(x < 9'(`SCREEN_WIDTH - (`MARGIN_WIDTH + i * (`BUTTON_WIDTH + `SPACE)))
            && x > 9'(`SCREEN_WIDTH - (`MARGIN_WIDTH + i * (`BUTTON_WIDTH + `SPACE) + `BUTTON_WIDTH))
            && y > 8'(`MARGIN_HEIGHT)
            && y < 8'(`MARGIN_HEIGHT + `BUTTON_HEIGHT)) begin
                buttonDetect = 1'd1;
            end
        end
        
        // displayDetect logic
        displayDetect = screen_ssdec(x, y, 9'(`SCREEN_WIDTH - (`MARGIN_WIDTH + `BUTTON_WIDTH + `MARGIN_WIDTH)), 
        8'(`MARGIN_HEIGHT + `BUTTON_HEIGHT + `MARGIN_HEIGHT), dig_to_ssdec(display_num[stage]));
            
        // labelDetect logic
        for (integer i = 0; i < 4; i++) begin
            labelDetect[i] = screen_ssdec(x, y, 9'(`SCREEN_WIDTH - (`MARGIN_WIDTH + i * (`BUTTON_WIDTH + `SPACE))),
            8'(`MARGIN_HEIGHT + 10), dig_to_ssdec(label_num[i][stage]));
        end

        // buttonHighlightDetect logic
        if(x < 9'(`SCREEN_WIDTH - (`MARGIN_WIDTH + mem_pos * (`BUTTON_WIDTH + `SPACE)) + 5)
        && x > 9'(`SCREEN_WIDTH - (`MARGIN_WIDTH + mem_pos * (`BUTTON_WIDTH + `SPACE) + `BUTTON_WIDTH) - 5)
        && y > 8'(`MARGIN_HEIGHT - 5)
        && y < 8'(`MARGIN_HEIGHT + `BUTTON_HEIGHT + 5)) begin
            buttonDetect = 1'd1;
        end
    end
endmodule