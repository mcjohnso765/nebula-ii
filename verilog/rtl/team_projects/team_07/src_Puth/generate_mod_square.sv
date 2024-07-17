// Module to generate a one block thick wall around the play area

// module borderGenerator(
//     input clk,              // system clock to sync up to
//     input rst,              // active low reset
//     input [8:0] x,          // current x coordinate
//     input [7:0] y,          // current y coordinate
//     output reg modSquaresPixel            // goes high if apple exists at that pixel, and 0 if not
// );
//  logic [5:0]i,j ;
//     always @(posedge clk) begin
//         modSquaresPixel <= ((x < 2) || (x > 318) || (y < 2) || (y > 238));
//         for(i = 0; i < 6; i++)begin
//             for(j = 0; j < 6; j++)begin
//                 if(x > (40*i + 10) && x < (40*i + 30) && y > (40* j + 10) && y < (40 * j + 30))begin 
//                 modSquaresPixel <= 1'b1;
//         end
//         end
//         end
//     end

// endmodule
/*
    Module:borderGenerator.sv
    Description:
        generage the gray squares of the entire map based on the 
    input template
// */
module t07_generate_mod_square
(
    input logic nrst,
    input logic clk,
    input logic [8:0] x,
    input logic [7:0] y,
    input logic mod_row,
    input logic mod_col,
    output logic modSquaresPixel, // [2][2] 
    output logic modHighlightPixel
);
    `define WIDTH 216
    `define HEIGHT 216
    `define CUBE_SQUARE 1 
    `define OFFSET 36
//     assign modHighlightPixel = 0;
//     assign modSquaresPixel = 0;
// endmodule

    logic modSquaresDetect;
    logic modHighlightDetect;
    // logic [7:0] jumpX ,jumpY;
    logic [8:0] SCo;
    logic [7:0] SPo;

    // Looping across the entire screen 
    always_comb begin
        // Jumping across each squares distance Y step all first then X step
        
        // Logic to describe modSquaresPixel outline
        modSquaresDetect = 0;
        modHighlightDetect = 0;

        // Logic to describe the squares with a separation of the offset
        for( integer jumpX = 20; jumpX < 216; jumpX = jumpX + 110) begin
            for(integer jumpY = 20; jumpY <= 216; jumpY = jumpY + 110) begin
                if((y > 8'(jumpY) && x > 9'(jumpX)) && (x < 9'(90 + jumpX) && y < 8'(90 + jumpY))) begin
                    modSquaresDetect = 1'b1;
                end
            end
        end

        SCo = 230 - (55 + (mod_col * 110));
        SPo = 230 - (55 + (mod_row * 110));
        // Logic to generate highlight hovering the selected square
        if(x > 9'(SCo - 9'd50) && y > 8'(SPo - 8'd50) && x < 9'(SCo + 9'd50) && y < 8'(SPo + 8'd50)) begin
            modHighlightDetect = 1'b1;
        end
    end

    always_ff @(negedge nrst, posedge clk) begin
        if(!nrst) begin
            modSquaresPixel <= 1'd0;
            modHighlightPixel <= 1'd0;
        end else begin
            modSquaresPixel <= modSquaresDetect;
            modHighlightPixel <= modHighlightDetect;
        end
    end

endmodule
