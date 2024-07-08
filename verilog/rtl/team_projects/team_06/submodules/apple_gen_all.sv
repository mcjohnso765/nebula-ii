`default_nettype none

module apple_gen_all(
    input logic good_collision, system_clk, nreset,// clk,
    input APPLE_LUCK apple_luck,
    input [3:0] snake_head_x, snake_head_y,  XMAX, XMIN, YMAX, YMIN, 
    input logic [7:0] apple_possible, //random number from rand_num_gen
    input logic [MAX_LENGTH - 1:0] [3:0] snakeArrayX, snakeArrayY,
    input logic [24:0] [7:0] wall_locations,
    output logic [7:0] apple_location, //valid apple position
    output logic enable //enable to rand_apple_gen
);

    logic [MAX_LENGTH - 1:0] [3:0] snakeArrayX_temp, snakeArrayY_temp, snakeArrayX_temp_n, snakeArrayY_temp_n;
    logic [7:0] count_luck, count_luck_next, total_difference;
    logic [3:0] x_next, y_next, x_final, y_final, x_difference, y_difference, x_last, y_last;
    logic [3:0] count;
    logic enable_next , good_spot, good_spot_next, logic_enable, lucky_spot, unlucky_spot;
    logic collisions_n,collisions, ready, start_enable;
    logic impossible;
    parameter MAX_LENGTH = 30;

    collisionLogic absxs (.next_head({y_next, x_next}), .body_x(snakeArrayX), .body_y(snakeArrayY), .collision(collisions_n));
    apple_check_wall_mode check_walls(.clk(system_clk), .nreset(nreset), .xmax(XMAX), .xmin(XMIN), .ymax(YMAX), .ymin(YMIN), .wall_locations(wall_locations), .apple_possible(apple_possible), .impossible(impossible));

    always_comb begin
////////////////////////////// START OF NORMAL APPLE GEN ////////////////////////////////////////////////////////////////////////

        enable_next = ((( ~good_spot) | good_collision) & start_enable) ; //enable to change x_next, y_next, only updates possible spot every couple clk cycles
////////////////!!!!!!!!!!!! rmoved and start_enable
        case (apple_luck)
            APPLE_NORMAL: begin
                if (logic_enable) begin // only starts if the luck is correct and a new number is needed
////////////////////////////// ADDED ENABLE TO LINE ABOVE and commented below
                    if (enable) begin
                        {y_next, x_next} = apple_possible; //update the values of x,y to be a random number
                        {x_last, y_last} = {x_next, y_next};
                    end else begin
                        {x_next, y_next} = {x_last, y_last};
                        {x_last, y_last} = 0;
                    end

                    if (({x_next, y_next} == {snake_head_x, snake_head_y}) | (x_next >= XMAX) | (x_next <= XMIN) | (y_next >= YMAX) | (y_next <= YMIN) | (collisions == 1) | (impossible)) begin // if the location is invalid, find a new number
                        // check if the number is in a valid spot
                        good_spot_next = 0; //if number is not in a valid spot, do it again
                        {x_difference, y_difference} = 0;
                        total_difference = 0;
                        lucky_spot = 0;
                        unlucky_spot = 0;
                        count_luck_next = count_luck;
                    end else begin // if the number is valid, make it the new apple location
                        good_spot_next = 1'b1;
                        {x_difference, y_difference} = 0;
                        total_difference = 0;
                        lucky_spot = 0;
                        unlucky_spot = 0;
                        count_luck_next = count_luck;
                    end
                end else begin
                    //default values for everything    //
                    x_next = 0;
                    y_next = 0;
                    good_spot_next = 1;
                    x_difference = 0;
                    y_difference = 0;
                    total_difference = 0;
                    lucky_spot = 0;
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
                    end else begin
                        x_next = x_last; //update the values of x,y to be a random number
                        y_next = y_last;
                        x_last = 0;
                        y_last  = 0;
                    end
    
                    if (({x_next, y_next} == {snake_head_x, snake_head_y}) | (x_next >= XMAX) | (x_next <= XMIN) | (y_next >= YMAX) | (y_next <= YMIN) | (collisions == 1) | (impossible)) begin // if the location is invalid, find a new number
                        // check if the number is in a valid spot
                        good_spot_next = 0; //if number is not in a valid spot, do it again
                        count_luck_next = count_luck;
                        x_difference = 0;
                        y_difference = 0;
                        total_difference = 0;
                        unlucky_spot = 0;
                        lucky_spot = 0;

                    end else begin // if the number is valid, check if it is unlucky
                        // check position to make sure it is unlucky

                        if (snake_head_x >= x_next) begin
                            x_difference = snake_head_x - x_next;
                        end else begin //finding x_difference
                            x_difference = x_next - snake_head_x;
                        end

                        if (snake_head_y >= y_next) begin
                            y_difference = snake_head_y - y_next;
                        end else begin                              //////////// finding y_difference
                            y_difference = y_next - snake_head_y;
                        end
                    
                        total_difference = {4'd0, x_difference} + {4'd0, y_difference}; // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! can change luck value here as well

                        if ((total_difference >= 8)) begin   //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! change luck value
                            unlucky_spot = 1;
                            lucky_spot = 0;
                        end else if ((total_difference >= 6) & (count_luck > 50)) begin   //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! change luck value
                            unlucky_spot = 1;
                            lucky_spot = 0;
                        end else if (count_luck >= 90) begin
                            unlucky_spot = 1;
                            lucky_spot = 0;
                        end else begin   //determining if the spot is unlucky enough
                            unlucky_spot = 0;
                            lucky_spot = 0;
                        end


                        if (unlucky_spot == 1) begin // if it is unlucky, make it the final spot
                            good_spot_next = 1'b1;
                            count_luck_next = 0;
                        end else begin   /// if it is not unlucky, make a new spot
                            good_spot_next = 0; //if number is not in a valid spot, do it again
                            count_luck_next = count_luck + 1;
                        end
                    end
                end else begin
                    //default values for everything
                    count_luck_next = count_luck;
                    x_next = 0;
                    y_next = 0;
                    good_spot_next = 1;
                    x_difference = 0;
                    y_difference = 0;
                    total_difference = 0;
                    unlucky_spot = 0;
                    lucky_spot = 0;
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
                    end else begin
                        x_next = x_last;
                        y_next = y_last;
                        x_last = 0;
                        y_last = 0;
                    end

                    if (({x_next, y_next} == {snake_head_x, snake_head_y}) | (x_next >= XMAX) | (x_next <= XMIN) | (y_next >= YMAX) | (y_next <= YMIN) | (collisions == 1) | (impossible)) begin // if the location is invalid, find a new number
                        // check if the number is in a valid spot
                        good_spot_next = 0; //if number is not in a valid spot, do it again
                        count_luck_next = count_luck;
                        x_difference = 0;
                        y_difference = 0;
                        total_difference = 0;
                        lucky_spot = 0;
                        unlucky_spot = 0;
                    end else begin // if the number is valid, check if it is unlucky
                        // check position to make sure it is unlucky
                        if (snake_head_x >= x_next) begin
                            x_difference = snake_head_x - x_next;
                        end else begin //finding x_difference
                            x_difference = x_next - snake_head_x;
                        end

                        if (snake_head_y >= y_next) begin
                            y_difference = snake_head_y - y_next;
                        end else begin                              //////////// finding y_difference
                            y_difference = y_next - snake_head_y;
                        end

                        total_difference = {4'd0, x_difference} + {4'd0, y_difference}; // !!!!!!!!!!!!!!!!!!!!!!! could also change impact of count here

                        if ((total_difference <= 3)) begin   //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! change luck value
                            unlucky_spot = 0;
                            lucky_spot = 1;
                        end else if ((total_difference <= 5) & (count_luck >= 50)) begin   //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! change luck value
                            unlucky_spot = 0;
                            lucky_spot = 1;
                        end else if (count_luck >= 90) begin
                            unlucky_spot = 0;
                            lucky_spot = 1;
                        end else begin   //determining if the spot is unlucky enough
                            unlucky_spot = 0;
                            lucky_spot = 0;
                        end

                        if (lucky_spot == 1) begin // if it is unlucky, make it the final spot
                            good_spot_next = 1'b1;
                            count_luck_next = 0;
                        end else begin   /// if it is not unlucky, make a new spot
                            good_spot_next = 0; //if number is not in a valid spot, do it again
                            count_luck_next = count_luck + 1;
                        end
                    end
                end else begin
                    //default values for everything
                    count_luck_next = count_luck;
                    x_next = 9;
                    y_next = 7;
                    good_spot_next = 1;
                    x_difference = 0;
                    y_difference = 0;
                    total_difference = 0;
                    lucky_spot = 0;
                    unlucky_spot = 0;
                    x_last = 0;
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
                x_difference = 0;
                y_difference = 0;
                total_difference = 0;
                lucky_spot = 0;
                unlucky_spot = 0;
                count_luck_next = count_luck;
                x_last = 0;
                y_last = 0;
            end
// end of all cases
        endcase
    end
/////////////////////////////////  END OF NORMAL APPLE GEN ///////////////////////////////////////////////////////////

//////////////////////////////// START OF FF LOGIC /////////////////////////////////////////////////////////

    always_ff @(posedge system_clk, negedge nreset) begin   
        if (~nreset) begin //update apple location output when good_pot is triggered
            apple_location <= 8'h46;  // default location!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        end else if (good_spot) begin
            if (start_enable == 1) begin
                apple_location <= {y_final, x_final};  // update apple position if it is valid\
            end else begin
                apple_location <= 8'h46; /// default location!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            end
        end else if (start_enable == 0) begin
            apple_location <= 8'h46;
        end else begin
            apple_location <= apple_location;
        end
    end
////////////////////////// END OF FF LOGIC ////////////////////////////////////////////////////////

    always_ff @(posedge system_clk, negedge nreset) begin
        //////////////////////////////////////////////if (clk) begin
        if (~nreset) begin
            good_spot <= 0;
            x_final <= 0;
            y_final <= 0;
            collisions <= 0;
            count <= 0;
            enable <= 0;
        end
        else begin
        good_spot <= good_spot_next;
        ////////////////////////////
        //if ({x_next, y_next} != 8'd0) begin
        x_final <= x_next;
        y_final <= y_next;
        //end else begin
        //    x_final <= 5;
        //    y_final <= 5;
        //end
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
        end else begin
            enable <= enable_next;
        end
        end
    end

/// stop finding a spot when a new one is chosen and start again when it needs to 
    always_ff @(posedge system_clk, negedge nreset) begin ///added enbale error
        if (~nreset) begin
            logic_enable <= 1;
            start_enable <= 0;
        end else if (good_collision || ~start_enable) begin
            logic_enable <= 1;
            if (good_collision) begin
                start_enable <= 1;
            end
            else begin
                start_enable <= start_enable;
            end
        end else if (good_spot) begin
            logic_enable <= 0;
            start_enable <= start_enable;
        end else begin
            logic_enable <= logic_enable;
            start_enable <= start_enable;
        end
    end
endmodule