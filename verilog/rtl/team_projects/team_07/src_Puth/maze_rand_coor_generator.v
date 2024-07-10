
/* 
Pseudo-random coordinate generator
Cycles through the entire grid at every clock cycle.
randX and randY should have different values depending on the time checked.
*/
module maze_rand_coor_generator(
    input clk, 
    output reg [3:0] randX, 
    output reg [3:0] randY);

    reg [3:0] X = 4;
    reg [3:0] Y = 3;

    always @(posedge clk) begin
        X <= X + 2;
        Y <= Y + 1;
    end

    always @(posedge clk) begin
        if (X >= 15)
            randX <= 14;
        else if (X < 2)
            randX <= 1;
        else
            randX <= X;
    end

    always @(posedge clk) begin
        if (Y >= 11)
            randY <= 10;
        else if (Y < 2)
            randY <= 1;
        else
            randY <= Y;
    end


endmodule