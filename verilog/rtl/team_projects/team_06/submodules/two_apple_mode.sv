`default_nettype none

module two_apple_mode(
    input logic good_collision, system_clk, nreset,// clk,
    input APPLE_LUCK apple_luck,
    input [3:0] snake_head_x, snake_head_y,  XMAX, XMIN, YMAX, YMIN, 
    input logic [7:0] apple_possible, //random number from rand_num_gen
    input logic [MAX_LENGTH - 1:0] [3:0] snakeArrayX, snakeArrayY,
    input enable_in,
    output logic [7:0] apple_location, //valid apple position
    output logic enable //enable to rand_apple_gen
);

logic [3:0] x_next, y_next, x_final, y_final, x_difference, y_difference, x_last, y_last;
logic enable_next , good_spot, good_spot_next, logic_enable, lucky_spot, unlucky_spot;
logic [3:0] count;
logic [7:0] count_luck, count_luck_next, total_difference;
parameter MAX_LENGTH = 30;

logic collisions_n,collisions, ready, start_enable;

collisionLogic absxs (.next_head({y_next, x_next}), .body_x(snakeArrayX), .body_y(snakeArrayY), .collision(collisions_n));////
always_comb begin

////////////////////////////// START OF NORMAL APPLE GEN ////////////////////////////////////////////////////////////////////////

enable_next = ((( ~good_spot) | good_collision) & start_enable) ;//& ((collisions == 1) | ~system_clk));// | (ready == 0))); //enable to change x_next, y_next, only updates possible spot every couple clk cycles
////////////////!!!!!!!!!!!! rmoved and start_enable
case (apple_luck)
APPLE_NORMAL: begin
    if (logic_enable) begin // only starts if the luck is correct and a new number is needed
////////////////////////////// ADDED ENABLE TO LINE ABOVE and commented below
if (enable) begin
x_next = apple_possible[3:0]; //update the values of x,y to be a random number
y_next = apple_possible[7:4];
x_last = x_next;
y_last = y_next;
end
else begin
    // x_next = 4'd0;//////////////////////////////////////////// error condition, 0,0 is an error
    // y_next = 0;
x_next = x_last;
y_next = y_last;
x_last = 0;
y_last = 0;
end

if (({x_next, y_next} == {snake_head_x, snake_head_y}) | (x_next >= XMAX) | (x_next <= XMIN) | (y_next >= YMAX) | (y_next <= YMIN) | (collisions == 1)) begin // if the location is invalid, find a new number
    // check if the number is in a valid spot

    good_spot_next = 0; //if number is not in a valid spot, do it again
    //////x_final = x_next;
    //////y_final = y_next;
    x_difference = 0;  //
    y_difference = 0;  //
    total_difference = 0;  // 
    lucky_spot = 0; //
    unlucky_spot = 0;
    count_luck_next = count_luck;

end 
else begin // if the number is valid, make it the new apple location


    // if (ready == 1) begin 
    good_spot_next = 1'b1;
    // end
    // else begin
    //     good_spot_next = 1'b0;
    // end
    //////x_final = x_next;
    //////y_final = y_next;
    x_difference = 0;  //
    y_difference = 0;  //
    total_difference = 0;  // 
    lucky_spot = 0; //
    unlucky_spot = 0;
    count_luck_next = count_luck;


end
end
else begin
    //default values for everything    //
    x_next = 1;
    y_next = 1;
    good_spot_next = 1;
    //////x_final = x_next;
    //////y_final = y_next;
    x_difference = 0;  //
    y_difference = 0;  //
    total_difference = 0;  // 
    lucky_spot = 0; //
    unlucky_spot = 0;
    count_luck_next = count_luck;
    x_last = 0;
y_last = 0;

end
end
//end of normal case

APPLE_UNLUCKY: begin 

if (logic_enable) begin // only starts if the luck is correct and a new number is needed

if (enable) begin
x_next = apple_possible[3:0]; //update the values of x,y to be a random number
y_next = apple_possible[7:4];
x_last = x_next;
y_last = y_next;
//error_next = 0;
end
else begin
    //x_next = 4'd6;//////////////////////////////////////////// error condition, 0,0 is an error
    //y_next = 1; /////////////could just make this a valid spot, it only happens once in a WHIle
    x_next = x_last; //update the values of x,y to be a random number
    y_next = y_last;
    x_last = 0;
    y_last  = 0;
end
    

if (({x_next, y_next} == {snake_head_x, snake_head_y}) | (x_next >= XMAX) | (x_next <= XMIN) | (y_next >= YMAX) | (y_next <= YMIN) | (collisions == 1)) begin // if the location is invalid, find a new number
    // check if the number is in a valid spot

    good_spot_next = 0; //if number is not in a valid spot, do it again
    //x_final = x_next;
    //y_final = y_next;
    count_luck_next = count_luck;
    x_difference = 0;  //
    y_difference = 0;  //
    total_difference = 0;  // 
    unlucky_spot = 0; //
    lucky_spot = 0;


end 
else begin // if the number is valid, check if it is unlucky


    // check position to make sure it is unlucky

    if (snake_head_x >= x_next) begin
        x_difference = snake_head_x - x_next;
    end                                   ///finding x_difference
    else begin 
        x_difference = x_next - snake_head_x;
    end


    if (snake_head_y >= y_next) begin
        y_difference = snake_head_y - y_next;
    end
    else begin                              //////////// finding y_difference
        y_difference = y_next - snake_head_y;
    end
 

    total_difference = {4'd0, x_difference} + {4'd0, y_difference}; // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! can change luck value here as well

    if ((total_difference >= 8)) begin   //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! change luck value
        unlucky_spot = 1;
        lucky_spot = 0;
    end
    else if ((total_difference >= 6) & (count_luck > 50)) begin   //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! change luck value
        unlucky_spot = 1;
        lucky_spot = 0;
    end
    else if (count_luck >= 90) begin //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        unlucky_spot = 1;
        lucky_spot = 0;
    end                                   
    else begin   //determining if the spot is unlucky enough
        unlucky_spot = 0;
        lucky_spot = 0;
    end


    if (unlucky_spot == 1) begin // if it is unlucky, make it the final spot

    //if (ready == 1) begin 
    good_spot_next = 1'b1;
    count_luck_next = 0;
    // end
    // else begin
    //     good_spot_next = 0;
    //     count_luck_next = count_luck;
    // end

    end
    else begin   /// if it is not unlucky, make a new spot
        good_spot_next = 0; //if number is not in a valid spot, do it again
        count_luck_next = count_luck + 1;
        //x_final = 1;
        //y_final = 1; /////////////////////////1,1 is an error condition
    end

end
end
else begin

    //default values for everything
    count_luck_next = count_luck;     //
    x_next = 0;
    y_next = 0;
    good_spot_next = 1;
    //x_final = x_next;   //
    //y_final = y_next;   //
    x_difference = 0;  //
    y_difference = 0;  //
    total_difference = 0;  // 
    unlucky_spot = 0; //
    lucky_spot = 0;
    //error_next = 1;
    x_last = 0;
y_last = 0;
end
end
//end of unlucky case

APPLE_LUCKY: begin 

if (logic_enable) begin // only starts if the luck is correct and a new number is needed

if (enable) begin
x_next = apple_possible[3:0]; //update the values of x,y to be a random number
y_next = apple_possible[7:4];
x_last = x_next;
y_last = y_next;
//error_next = 0;
end
else begin
    // x_next = 4'd6;//////////////////////////////////////////// error condition, 0,0 is an error
    // y_next = 1; // 
    x_next = x_last;
    y_next = y_last;
    x_last = 0;
    y_last = 0;
    //error_next = 1;
end

if (({x_next, y_next} == {snake_head_x, snake_head_y}) | (x_next >= XMAX) | (x_next <= XMIN) | (y_next >= YMAX) | (y_next <= YMIN) | (collisions == 1)) begin // if the location is invalid, find a new number
    // check if the number is in a valid spot

    good_spot_next = 0; //if number is not in a valid spot, do it again
    //x_final = x_next;
    //y_final = y_next;
    count_luck_next = count_luck;
    x_difference = 0;  //
    y_difference = 0;  //
    total_difference = 0;  // 
    lucky_spot = 0; //
    unlucky_spot = 0;


end 
else begin // if the number is valid, check if it is unlucky


    // check position to make sure it is unlucky

    if (snake_head_x >= x_next) begin
        x_difference = snake_head_x - x_next;
    end                                   ///finding x_difference
    else begin 
        x_difference = x_next - snake_head_x;
    end


    if (snake_head_y >= y_next) begin
        y_difference = snake_head_y - y_next;
    end
    else begin                              //////////// finding y_difference
        y_difference = y_next - snake_head_y;
    end
 

    total_difference = {4'd0, x_difference} + {4'd0, y_difference}; // !!!!!!!!!!!!!!!!!!!!!!! could also change impact of count here

    if ((total_difference <= 3)) begin   //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! change luck value
        unlucky_spot = 0;
        lucky_spot = 1;
    end
    else if ((total_difference <= 5) & (count_luck >= 50)) begin   //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! change luck value
        unlucky_spot = 0;
        lucky_spot = 1;
    end
    else if (count_luck >= 90) begin //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        unlucky_spot = 0;
        lucky_spot = 1;
    end                                   
    else begin   //determining if the spot is unlucky enough
        unlucky_spot = 0;
        lucky_spot = 0;
    end


    if (lucky_spot == 1) begin // if it is unlucky, make it the final spot

       //  if (ready == 1) begin 
            good_spot_next = 1'b1;
            count_luck_next = 0;
        // end
        // else begin
        //     good_spot_next = 1'b0;
        //     count_luck_next = count_luck;
        // end

    end
    else begin   /// if it is not unlucky, make a new spot
        good_spot_next = 0; //if number is not in a valid spot, do it again
        count_luck_next = count_luck + 1;
        //x_final = 1;
        //y_final = 1; /////////////////////////1,1 is an error condition
    end

end
end
else begin

    //default values for everything
    count_luck_next = count_luck;     //
    x_next = 9;
    y_next = 7;
    good_spot_next = 1;
    //x_final = x_next;   //
    //y_final = y_next;   //
    x_difference = 0;  //
    y_difference = 0;  //
    total_difference = 0;  // 
    lucky_spot = 0; //
    unlucky_spot = 0;
    //error_next = 1;
    x_last =0;
y_last = 0;
end
end
// end of lucky case

default: begin 
     //default values for everything
         //
    x_next = 0;
    y_next = 1;
    good_spot_next = 1;
    //x_final = x_next;   //
    //y_final = y_next;   //
    x_difference = 0;  //
    y_difference = 0;  //
    total_difference = 0;  // 
    lucky_spot = 0; //
    unlucky_spot = 0;
    count_luck_next = count_luck;
    x_last = 0;
    y_last = 0;
    //error_next = 1;
end
// end of all cases
endcase
end
/////////////////////////////////  END OF NORMAL APPLE GEN ///////////////////////////////////////////////////////////

//////////////////////////////// START OF FF LOGIC /////////////////////////////////////////////////////////

    always_ff @(posedge system_clk, negedge nreset) begin   
        if (~nreset) begin //update apple location output when good_pot is triggered
            apple_location <= 8'h57;  // default location? or other one
        end else if (enable_in && good_spot) begin
            apple_location <= {y_final, x_final};  // update apple position if it is valid\
        end else if (good_spot) begin
            apple_location <= 8'h00;
        end else begin
            apple_location <= apple_location;
        end
    end
////////////////////////// END OF FF LOGIC ////////////////////////////////////////////////////////

always_ff @(posedge system_clk) begin
    //////////////////////////////////////////////if (clk) begin
    if (enable_in == 1) begin
    good_spot <= good_spot_next;
    end
    else begin
        if (good_spot == 0) begin
            good_spot <= 1;
        end
        else begin
            good_spot <= 0;
        end
    end
    ////////////////////////////
    x_final <= x_next;
    y_final <= y_next;
    collisions <= collisions_n;
    //////////////////////////////
    count_luck <= count_luck_next;/////////////////added
    if (enable) begin
        count <= count + 1;
    end

    if (count == 4'd15) begin //////////////////// changing to 3 makes output value wrong/ the same sometimes   
    /// also seems to change randomness/ how far apart the apples are
    // 3 does not work
    // 15 is ok?, higher is better?, or does it not matter?, why do some of them not work (produce 0,0)
        count <= 0;
        enable <= 0;
    end
    else begin
    enable <= enable_next;
    end
    end

/// stop finding a spot when a new one is chosen and start again when it needs to 
always_ff @(posedge system_clk, negedge nreset) begin
    if (~nreset) begin
        start_enable <= 0;
        logic_enable <= 1;
    end else if (good_collision) begin
        start_enable <= 1;
        logic_enable <= 1;
    end else if (~start_enable) begin
        logic_enable <= 1;
        start_enable <= start_enable;
    end else if (good_spot) begin
        logic_enable <= 0;
        start_enable <= start_enable;
    end else begin
        start_enable <= start_enable;
        logic_enable <= logic_enable;
    end
end

endmodule