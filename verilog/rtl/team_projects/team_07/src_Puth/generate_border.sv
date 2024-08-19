// Module to generate a one block thick wall around the play area

// module borderGenerator(
//     input clk,              // system clock to sync up to
//     input rst,              // active low reset
//     input [8:0] x,          // current x coordinate
//     input [7:0] y,          // current y coordinate
//     output reg border            // goes high if apple exists at that pixel, and 0 if not
// );
//  logic [5:0]i,j ;
//     always @(posedge clk) begin
//         border <= ((x < 2) || (x > 318) || (y < 2) || (y > 238));
//         for(i = 0; i < 6; i++)begin
//             for(j = 0; j < 6; j++)begin
//                 if(x > (40*i + 10) && x < (40*i + 30) && y > (40* j + 10) && y < (40 * j + 30))begin 
//                 border <= 1'b1;
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
 */
module t07_generate_border
(
    input logic nrst,
    input logic clk,
    input logic [8:0] x,
    input logic [7:0] y,
    output logic borderPixel    

);
// `define WIDTH 216
// `define HEIGHT 216
// `define CUBE 1 
// `define OFFSET 36
logic synchronized_rectangle_pixel;
// logic [7:0] jumpX ,jumpY;
// assign borderPixel = 0;
// endmodule

//Looping across the entire screen 
always_comb begin
//Jumping across each squares distance Y step all first then X step
    //Logic to describe border outline
    synchronized_rectangle_pixel =borderPixel;

    // if((x <= CUBE || (x >= WIDTH && x <= (WIDTH + CUBE))) || (y <= CUBE || (y >= HEIGHT && y <= (HEIGHT + CUBE))) ) begin
    //     synchronized_rectangle_pixel <= 1'b1;
    // end else begin
    //     synchronized_rectangle_pixel <= 1'b0;
    // end
    if((y < 228 && x < 12) || (x < 228 && y < 12) || (x >= 228 && x < 240 && y < 240) || (x < 228 && y >= 228)) begin
        synchronized_rectangle_pixel = 1'b1;
    end
    else
        begin
        synchronized_rectangle_pixel = 1'b0;
        end

    //Logic to describe the squares with a separation of the offset
    for( integer jumpX = 0; jumpX < 216; jumpX = jumpX + 36) begin
        for(integer jumpY = 0; jumpY <= 216; jumpY = jumpY + 36)
            if((y > 8'(24 +jumpY) && x > 9'(24 + jumpX)) && (x < 9'(35 + jumpX) && y < 8'(35 + jumpY))) begin
                synchronized_rectangle_pixel = 1'b1;
            end
    end
        // else
        //     begin
        //     synchronized_rectangle_pixel = 1'b0;
        //     end
end
                    

always_ff @(negedge nrst, posedge clk) begin
    if(!nrst) begin
        borderPixel <= 1'd0;
    end else begin
        borderPixel <= synchronized_rectangle_pixel;
    end
end

endmodule
