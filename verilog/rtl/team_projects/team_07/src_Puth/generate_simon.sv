/*
    Module: generate_simon
    Description:
        generate the pixel logic for the simon says game
*/
module t07_generate_simon(
    input logic nrst,
    input logic clk,
    input logic [8:0] x,
    input logic [7:0] y, 
    output logic [3:0] simonPixel   // the location for four diamonds (lsb - up, msb - left, clockwise)
);  
    logic [3:0] simonDetect;
    function square_gen (
        input logic [8:0] x,
        input logic [7:0] y, 
        input logic [8:0] left_x, 
        input logic [7:0] left_y, 
        input logic [8:0] right_x,
        input logic [7:0] right_y
    );
        begin
            if(x < left_x && y < 8'(left_y + (left_x - x)) && y > 8'(left_y - (left_x - x))
            && x > right_x && y < 8'(right_y + (x - right_x)) && y > 8'(right_y - (x - right_x))) begin
                square_gen = 1'd1;
            end else begin
                square_gen = 1'd0;
            end
        end
    endfunction

    always_ff @(negedge nrst, posedge clk) begin
        if(!nrst) begin
            simonPixel <= 4'd0;
        end else begin
            simonPixel <= simonDetect;
        end
    end

    always_comb begin
        // simonDetect logic
        simonDetect[0] = square_gen(x, y, 160, 160, 80, 160);
        simonDetect[1] = square_gen(x, y, 120, 120, 40, 120);
        simonDetect[2] = square_gen(x, y, 160, 80, 80, 80);
        simonDetect[3] = square_gen(x, y, 200, 120, 120, 120);
    end

endmodule