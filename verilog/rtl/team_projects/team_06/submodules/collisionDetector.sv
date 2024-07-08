
module collisionDetector (
    input logic  clk, nrst,
    //Snake head, border, and apple coordinates
    input logic [3:0] snakeHeadX, snakeHeadY, borderXMin, borderXMax, borderYMax, borderYMin, AppleX, AppleY, AppleX2, AppleY2,
    //'Array'. Long bit number split into 4 bits, representing X, Y coordinate of each snake segment 
    input logic [MAX_LENGTH - 1:0] [3:0] snakeArrayX ,//[0:3], 
    input logic [MAX_LENGTH - 1:0] [3:0] snakeArrayY , //[0:3], 
    input logic [24:0] [7:0] wall_array,
    output logic badCollision, goodCollision, good_collision2//, ready
);

logic collision, collision_n, goodCollision_n, badCollision_n, goodCollision_n2, badCollision_n2;
parameter MAX_LENGTH = 30;
collisionLogic snakeLogic (.next_head({snakeHeadY, snakeHeadX}), .body_x(snakeArrayX), .body_y(snakeArrayY), .collision(collision_n));
collisionLogic_wall rndwall (.next_wall({snakeHeadY, snakeHeadX}), .walls(wall_array), .collision(badCollision_n2));
always_comb begin
    //Hit Left Border
    //Hit Right Border
    //Hit Top Border
    //Hit Bottom Border
    badCollision_n =  (snakeHeadX <= borderXMin) | (snakeHeadX >= borderXMax) | (snakeHeadY <= borderYMin) | (snakeHeadY >= borderYMax);
    //Eat Apple
    goodCollision_n = (snakeHeadX == AppleX && snakeHeadY == AppleY);
    goodCollision_n2 = (snakeHeadX == AppleX2 && snakeHeadY == AppleY2);

    // Hit random wall spawns\ (input is above)

    // logic [24:0] collision_array;

    // for (integer i = 0; i <= 24; i++) begin ///////////are x and y flipped? are indexes flipped? for either?
    //     collision_array[i] = 
    //         (wall_array[i][0] ~^ snakeHeadX[0]) && 
    //         (wall_array[i][1] ~^ snakeHeadX[1]) && 
    //         (wall_array[i][2] ~^ snakeHeadX[2]) && 
    //         (wall_array[i][3] ~^ snakeHeadX[3]) && 
    //         (wall_array[i][4] ~^ snakeHeadY[0]) && 
    //         (wall_array[i][5] ~^ snakeHeadY[1]) && 
    //         (wall_array[i][6] ~^ snakeHeadY[2]) && 
    //         (wall_array[i][7] ~^ snakeHeadY[3]);
    // end
    // badCollision_n2 = | collision_array;
    // end of wall spawn 
end

always_ff @(posedge clk, negedge nrst) begin
    if (~nrst) begin
        goodCollision <= 0;
        badCollision <=  0;
        good_collision2 <= 0;
    end else begin
        goodCollision <= goodCollision_n;
        good_collision2 <= goodCollision_n2;
        badCollision <= (badCollision_n | badCollision_n2 | collision_n);// | collision_n | badCollision_n2);// | badCollision_n2
    end
end
// why can you not edit settings in wait mode sometimes? just after starting(without manual reset) no longer die instantly after adding logic to direction

endmodule

// module collisionLogic (
//     input logic [7:0] next_head,
//     input logic [139:0] [3:0]body_x ,//[0:3],
//     input logic [139:0] [3:0]body_y ,//[0:3],
//     output logic collision );

// logic [139:0] collision_array;

//     always_comb begin
//         for (integer i = 0; i <= 139; i++) begin
//             collision_array[i] = 
//             (body_x[i][3] ~^ next_head[0]) && 
//             (body_x[i][2] ~^ next_head[1]) && 
//             (body_x[i][1] ~^ next_head[2]) && 
//             (body_x[i][0] ~^ next_head[3]) && 
//             (body_y[i][3] ~^ next_head[4]) && 
//             (body_y[i][2] ~^ next_head[5]) && 
//             (body_y[i][1] ~^ next_head[6]) && 
//             (body_y[i][0] ~^ next_head[7]);
//         end
//         collision = |collision_array;
//     end
// endmodule