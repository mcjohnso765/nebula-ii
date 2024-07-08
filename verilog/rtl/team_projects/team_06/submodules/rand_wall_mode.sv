/* 
  Module Name:apple_gen.sv
  Module Function/Purpose: to generate random apple location
  Module Inputs:good_collision, enable, system_clk, enable
  Module Outputs: apple_location (8 bits), finrst 4 are x, next 4 are y

  Best Commenting Practices (to make debugging easier):
    1) Explain what each block of logic does.
    2) Explain what each input and output represents and what its values represent.

  Best Coding Practices (to make debugging easier):
    1) Assign outputs using always_ff blocks whenever possible.
    2) Use enable variables for blocks that can be used to change game modes.

*/ 

`default_nettype none


module rand_wall_mode(
    input logic good_collision, system_clk, nreset,// clk,
    input APPLE_LUCK apple_luck,
    input [3:0] snake_head_x, snake_head_y,  XMAX, XMIN, YMAX, YMIN, 
    input logic [7:0] apple_possible, //random number from rand_num_gen
    input logic [MAX_LENGTH - 1:0] [3:0] snakeArrayX, snakeArrayY,
    input enable_in,
    output logic [24:0] [7:0] apple_locations, //25 max
    output logic enable //enable to rand_apple_gen
);

logic [3:0] x_next, y_next, x_final, y_final, x_difference, y_difference, x_last, y_last;
logic enable_next , good_spot, good_spot_next, logic_enable, lucky_spot, unlucky_spot;
logic [3:0] count;
logic [7:0] count_luck, count_luck_next, total_difference;
logic [4:0] counter, counter2;
logic count1, inputa, input2;
parameter MAX_LENGTH = 30;
//last 2 are for input slection

logic collisions_n,collisions, ready, start_enable, collisions_n2;
//logic [199:0] apple_locations_last;

collisionLogic absxs (.next_head({y_next, x_next}), .body_x(snakeArrayX), .body_y(snakeArrayY), .collision(collisions_n));////

collisionLogic_wall abduyd (.next_wall({y_next, x_next}), .walls(apple_locations), .collision(collisions_n2));

always_comb begin

////////////////////////////// START OF NORMAL APPLE GEN ////////////////////////////////////////////////////////////////////////

enable_next = ((( ~good_spot) | input2) & start_enable) ;//& ((collisions == 1) | ~system_clk));// | (ready == 0))); //enable to change x_next, y_next, only updates possible spot every couple clk cycles
////////////////!!!!!!!!!!!! rmoved and start_enable
// input was good_collision
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

always_ff @(posedge good_spot, negedge nreset) begin   
 

 
if (~nreset) begin //update apple location output when good_pot is triggered
    apple_locations <= 200'd0;  // default location? or other one
end

else  if (enable_in) begin
   // if ({y_final, x_final} == apple_possible) begin
   if (start_enable == 1) begin
    apple_locations [0] <= {y_final, x_final};
    apple_locations [24:1] <= {apple_locations[23:0]};  // update apple position if it is valid\
   end
   else begin
    apple_locations <= 200'd0; /// default location!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
   end

end
else begin
    apple_locations <= 200'd0;
end
end


//good collision input logic !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
always_ff @(posedge system_clk, negedge nreset) begin
if (~nreset) begin //reset condition
    counter <= 5'd0;
    inputa <= 0;
    count1 <= 0;
end
else if (good_collision & (counter <= 5'd24)) begin // or 23? //if a new wall can spawn
    if (count1) begin  //only makes a new wall every other good_collision
        inputa <= 1;
        count1 <= 0;
        counter <= counter + 1;
    end
    else begin //does not make a new wall if on odd numbered collision
        inputa <= 0;
        count1 <= 1;
        counter <= counter;
    end
end
else begin /// do nothing if there was no good_collision
        inputa <= 0;
        count1 <= count1;
        counter <= counter;
    end
end


always_ff @(posedge system_clk, negedge nreset) begin

    if (~nreset) begin //reset condition
        input2 <= 0;
        counter2 <= 0;
    end
    else if (counter2 == 5'd30) begin //if the counter has already went, turn the output on, this makes the delay
        input2 <= 1;
        counter2 <= 0;
    end
    else if (inputa) begin // if the non-delayed input is on make the actual input a one the next clk cycle
        input2 <= 0;
        counter2 <= 1;
    end
    else if (input2) begin
        input2 <= 0;
        counter2 <= 0;
    end
    else if (counter2 >= 5'd1) begin
        input2 <= 0;
        counter2 <= counter2 + 1;
    end
    else begin // don't do anything 
        input2 <= input2;
        counter2 <= counter2;
    end

end

////////////////////////// END OF FF LOGIC ////////////////////////////////////////////////////////

always_ff @(posedge system_clk) begin
    //////////////////////////////////////////////if (clk) begin
    if (enable_in == 1) begin
    good_spot = good_spot_next;
    end
    else begin
        if (good_spot == 0) begin
            good_spot = 1;
        end
        else begin
            good_spot = 0;
        end
    end
    ////////////////////////////
    x_final = x_next;
    y_final = y_next;
    collisions = collisions_n | collisions_n2;
    //////////////////////////////
    count_luck = count_luck_next;/////////////////added
    if (enable) begin
        count = count + 1;
    end

    if (count == 4'd15) begin //////////////////// changing to 3 makes output value wrong/ the same sometimes   
    /// also seems to change randomness/ how far apart the apples are
    // 3 does not work
    // 15 is ok?, higher is better?, or does it not matter?, why do some of them not work (produce 0,0)
        count = 0;
        enable = 0;
    end
    else begin
    enable = enable_next;
    end
    end
    // else begin
    //     good_spot = good_spot;
    //     x_final = x_final;
    //     y_final = y_final;
    //     collisions = collisions;
    //     count = count;
    //     enable = enable;
    // end

/// stop finding a spot when a new one is chosen and start again when it needs to 
//input2s were good_collision for this block and the one after
always_ff @(posedge input2, posedge good_spot, negedge nreset) begin ///added enbale error

    if (~nreset) begin
        logic_enable = 1;
    end
    else if (input2) begin
        logic_enable = 1;
    end
    else if (start_enable == 0) begin
        logic_enable = 1;
    end
    else begin
        logic_enable = 0;
    end


end

always_ff @(posedge input2, negedge nreset) begin
      if (~nreset) begin
        start_enable = 0;
    end
    else begin
        start_enable = 1;
    end


end


/// collision detect needed 


// end of collision detect

endmodule

/////////////////module for testing
//!!This is the random num that should be used for wall gen

// module random_num_gen_wall_mode(
//     input logic enable, system_clk, nreset, //change enable whenever a new number is wanted
//     output logic [7:0] number_out  // 8 bit number finrst 4 are x, last 4 are y
// );

// logic [7:0] number;
// logic counter, counter_next;

// always_ff @(posedge system_clk, negedge nreset) begin

// if (~nreset) begin
//     number = 8'd2;
//     counter_next = 0;
// end
// else begin //"randomly cycles through numbers"
//     number = {number[6:0], ~(number[6] ^ number[5])};
//     counter_next = counter;
// end
// end

// always_ff @(posedge enable) begin ///only update the random number when enable is switched on

// counter <= counter_next;

// if (counter) begin
//     number_out <= number;
//     counter <= 0;
//   end

// else begin
//   number_out <= ({number[3:0], number[7:4]});
//   counter <= 1;
//   end
// end

// endmodule

// //module for testing


// module ssdec (// -Wno-ENUMVALUE
//   input logic [3:0] in,
//   input logic enable ,
//   output logic [6:0] out
// );

// assign out[0] = ((~in[3] & in[2] & in[0]) || (~in[3] & in[1]) || (in[3] & ~in[1] & ~in[2]) || (~in[2] & ~in[0]) || (in[3] & ~in[0]) || (in[1] & in[2]) )  & enable;
// assign out[1] =  ((~in[3] & ~in[2]) || (~in[3] & ~in[1] & ~in[0]) || (~in[3] & in[1] & in[0]) || (~in[2] & ~in[0]) || (in[3] & ~in[1] & in[0])) & enable;
// assign out[2] = ((~in[3] & ~in[1]) || (~in[3] & in[0]) || (~in[3] & in[2]) || (in[3] & ~in[2]) || (~in[1] & in[0])) & enable;
// assign out[3] = ((~in[3] & ~in[2] & ~in[0]) || (~in[2] & in[1] & in[0]) || (in[3] & ~in[1] & ~in[0]) || (in[2] & ~in[1] & in[0]) || (in[2] & in[1] & ~in[0])) & enable;
// assign out[4] = ((~in[2] & ~in[0]) || (in[3] & in[2]) || (in[1] & ~in[0]) || (in[3] & in[1])) & enable;
// assign out[5] = ((~in[3] & in[2] & ~in[1]) || (in[3] & ~in[2]) || (~in[1] & ~in[0]) || (in[2] & ~in[0]) || (in[3] & in[1])) & enable;
// assign out[6] = ((~in[3] & in[2] & ~in[1]) || (in[3] & ~in[2]) || (~in[2] & in[1]) || (in[1] & ~in[0]) || (in[3] & in[0])) & enable;

// endmodule

// //module for testing



// module syncEdge(
//     input logic clk, nreset,
//     input logic but,
//     output logic direction
// );
//     logic out1;
//     sync sync1 (.in(but), .clk(clk), .nrst(nreset), .out(out1));
//     edgeDetect eD1 (.D(out1), .clk(clk), .nrst(nreset), .edg(direction));
// endmodule

// module sync(
//         input logic in, 
//         input logic clk, nrst,
//         output logic out
//     );
//         logic Q, Q1, Q_n, Q1_n;

//         always_comb begin
//             Q_n = in;
//             Q1_n = Q; 
//         end
        
//         always_ff @(posedge clk, negedge nrst) begin
//             if (~nrst)begin
//                 Q <= 1'b0;
//                 Q1 <= 1'b0;
//             end else begin
//                 Q <= Q_n;
//                 Q1 <= Q1_n;
//             end
//         end
        
//         always_comb begin
//             out = Q1;
//         end
// endmodule 

// module edgeDetect(
//     input logic D,
//     input logic clk, nrst,
//     output logic edg
// );
//     logic Q1, Q2, Q1_n, Q2_n;

//     always_comb begin
//             Q1_n = D;
//             Q2_n = Q1; 
//         end
        
//         always_ff @(posedge clk, negedge nrst) begin
//             if (~nrst)begin
//                 Q1 <= 1'b0;
//                 Q2 <= 1'b0;
//             end else begin
//                 Q1 <= Q1_n;
//                 Q2 <= Q2_n;
//             end
//         end
        
//         always_comb begin
//             edg = Q1 & ~Q2;
//         end
// endmodule






// module collisionLogic (
//     input logic [7:0] next_head,
//     input logic [139:0] [3:0]body_x ,//[0:3],
//     input logic [139:0] [3:0]body_y ,//[0:3],
//     output logic collision );

// logic [139:0] collision_array;

//     always_comb begin
//         for (integer i = 0; i <= 139; i++) begin
//             collision_array[i] = 
//             (body_x[i][0] ~^ next_head[0]) && 
//             (body_x[i][1] ~^ next_head[1]) && 
//             (body_x[i][2] ~^ next_head[2]) && 
//             (body_x[i][3] ~^ next_head[3]) && 
//             (body_y[i][0] ~^ next_head[4]) && 
//             (body_y[i][1] ~^ next_head[5]) && 
//             (body_y[i][2] ~^ next_head[6]) && 
//             (body_y[i][3] ~^ next_head[7]);
//         end
//         collision = |collision_array;
//     end
// endmodule


// module collisionLogic_wall (
//     input logic [7:0] next_wall,
//     input logic [24:0] [7:0] walls ,//[0:3],
//     output logic collision );

// logic [24:0] collision_array;

//     always_comb begin
//         for (integer i = 0; i <= 24; i++) begin
//             collision_array[i] = 
//             (walls[i][0] ~^ next_wall[0]) && 
//             (walls[i][1] ~^ next_wall[1]) && 
//             (walls[i][2] ~^ next_wall[2]) && 
//             (walls[i][3] ~^ next_wall[3]) && 
//             (walls[i][4] ~^ next_wall[4]) && 
//             (walls[i][5] ~^ next_wall[5]) && 
//             (walls[i][6] ~^ next_wall[6]) && 
//             (walls[i][7] ~^ next_wall[7]);
//         end
//         collision = |collision_array;
//     end
// endmodule