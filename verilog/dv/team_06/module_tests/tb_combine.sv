`timescale 1ms/10ps


typedef enum logic [1:0] {
        UP = 2'b00,
        DOWN = 2'b01, 
        LEFT = 2'b10,
        RIGHT = 2'b11
    } DIRECTION; 

typedef enum logic [7:0] {
    Reset_High = 8'd1,
    Reset_Low = 8'd0,
    Reset_Second_High = 8'd2,
    ColorConstrast = 8'b11000101, //0xC5
    Memory = 8'b00110110,  //0x36
    PixelFormat = 8'b00111010, //0x3A
    SleepOut = 8'b00010001, //0x11
    DisplayOn = 8'b00101001, //0x29
    MemoryWrite = 8'b00101100 //0x2C
    } MODE; 


typedef enum logic [1:0] {
        RUN = 2'b00,
        WAIT = 2'b01, 
        PAUSE = 2'b10,
        END_GAME = 2'b11
    } GAME_STATE; 

typedef enum logic [1:0] {
        TWO_APPLE = 2'b00,
        NORMAL_MODE = 2'b01, 
        WALL_SPAWN = 2'b10
    } GAME_MODE; 

typedef enum logic [1:0] {
        NORMAL_SPEED = 2'b00,
        FAST_SPEED = 2'b01, 
        SLOW_SPEED = 2'b10
    } GAME_SPEED; 

typedef enum logic [1:0] {
        APPLE_NORMAL = 2'b00,
        APPLE_LUCKY = 2'b01, 
        APPLE_UNLUCKY = 2'b10
    } APPLE_LUCK; 


module tb_combine;
logic [19:0] in;
logic hz100;
logic [4:0] out;
// logic reset;
logic strobe; //define
logic strobe_2;
integer i;
integer j;
integer k;
logic [1:0] Stream [];
logic [1:0] Stream_2 [];

logic clk, clk_body, reset_button, up_direction, down_direction, left_direction, right_direction, start_pause_button, clk_display;

GAME_STATE game_state;
DIRECTION direction;
APPLE_LUCK apple_luck;
GAME_MODE game_mode;
GAME_SPEED game_speed;

logic good_collision, bad_collision;
logic [3:0] head_x, head_y, tail_x, tail_y;
logic [3:0] xmax, xmin, ymax, ymin;
logic [3:0] body_x, body_y; //// update to actual size and update apple_gen_all module
logic [7:0] apple_location, apple_possible, length, score;
logic rand_num_enable;
logic [7:0] score_out0, score_out1, score_out2, state_out, mode_out, speed_out, luck_out; // all are values in 7 seg form after ssdec
logic [3:0] out0, out1, out2, state_out_pre, mode_out_pre, speed_out_pre, luck_out_pre; // all are values before ssdec

// Clock generation block

always begin
  hz100 = 1'b0;
  #(5);
  hz100 = 1'b1;
  #(5);
end

initial strobe = 1'b0;
always begin
  strobe = 1'b0;
  #(50);
  strobe = 1'b1;
  #(50);
end

logic [1:0] tempKey;


logic wrap_time;
logic clear_time;


logic enable_time;
logic GC_Time;
logic BC_Time;
DIRECTION Direction;

logic rd;
logic rs;
logic wr;
logic cs;
logic RESET;
logic [7:0] mode;
logic pb_up;
logic pb_down;
logic pb_left;
logic pb_right;
logic pb_start;
logic pb_reset;
logic extra_reset;

// logic [7:0] tb_shift_output;
// shift_register f1 (.clk(hz100), .rst(reset), .mode_i(tempKey), .par_i(8'b00001111), .p());
// tft_LCD L1 (.clk(hz100), .nrst(~reset), .rd(rd), .rs(rs), .wr(wr), .cs(cs), .reset(RESET), .mode(mode));


syncEdge up_button(.clk(clk), .reset(reset_button), .but(pb_up), .direction(up_direction));
syncEdge down_button(.clk(clk), .reset(reset_button), .but(pb_down), .direction(down_direction));
syncEdge left_button(.clk(clk), .reset(reset_button), .but(pb_left), .direction(left_direction));
syncEdge right_button(.clk(clk), .reset(reset_button), .but(pb_right), .direction(right_direction));
syncEdge start_pause_button1(.clk(clk), .reset(reset_button), .but(pb_start), .direction(start_pause_button));
syncEdge reset_button_1(.clk(clk), .reset(extra_reset), .but(pb_reset), .direction(reset_button));

clock clock1(.system_clk(hz100), .reset(reset_button), .game_speed(), .game_state(game_state), .clk(clk), .clk_display(clk_display), .clk_body(clk_body));

DirectionLogic direction1(.clk(clk), .rst(reset_button), .up(up_direction), .down(down_direction), .left(left_direction), .right(right_direction), .directionOut(direction));

body_control conrol_1(.clk(clk_body), .rst(reset_button), .goodCollision(good_collision), .badCollision(bad_collision), .Direction(direction), .head_x(head_x), .head_y(head_y), .tail_x(tail_x), .tail_y(tail_y));

BorderGen bordera(.clk(clk), .rst(reset_button), .XMAX(xmax), .XMIN(xmin), .YMAX(ymax), .YMIN(ymin));
// border locations need to be updated

apple_gen_all apple_gen(.good_collision(good_collision), .system_clk(clk), .reset(reset_button), .apple_luck(apple_luck), .snake_head_x(head_x), .snake_head_y(head_y), .snake_body_x(body_x), .snake_body_y(body_y), .XMAX(xmax), .XMIN(xmin), .YMAX(ymax), .YMIN(ymin), .apple_possible(apple_possible), .apple_location(apple_location), .enable(rand_num_enable));
// update above module

random_num_gen rand_num(.enable(rand_num_enable), .system_clk(clk), .reset(reset_button), .number_out(apple_possible));

LS_Tracker length_score1(.clk(clk), .rst(reset_button), .goodCollision(good_collision), .badCollision(bad_collision), .length(length), .score(score));

seven_seg_out out_1(.score(score), .game_state(game_state), .game_mode(game_mode), .game_speed(game_speed), .apple_luck(apple_luck), .score_out0(out0), .score_out1(out1), .score_out2(out2), .state_out(state_out_pre), .mode_out(mode_out_pre), .speed_out(speed_out_pre), .luck_out(luck_out_pre));

ssdec num9(.in(out0), .enable(1'b1), .out(score_out0[6:0]));
ssdec num91(.in(out1), .enable(1'b1), .out(score_out1[6:0]));
ssdec num92(.in(out2), .enable(1'b1), .out(score_out2[6:0]));
ssdec num93(.in(state_out_pre), .enable(1'b1), .out(state_out[6:0]));
ssdec num94(.in(mode_out_pre), .enable(1'b1), .out(mode_out[6:0]));
ssdec num95(.in(speed_out_pre), .enable(1'b1), .out(speed_out[6:0]));
ssdec num96(.in(luck_out_pre), .enable(1'b1), .out(luck_out[6:0]));

// assign ss0 = out0_out;
// assign ss1 = out1_out;
// assign ss2 = out2_out;
// assign ss4 = state_out;
// assign ss5 = mode_out;
// assign ss6 = speed_out;
// assign ss7 = luck_out;



gameMode modea(.button(right_direction), .rst(reset_button), .state(game_state), .mode(game_mode));
// changing game mode with right button in wait mode //////////////////////////////////////////////////////////////////////


gameState state1(.button(start_pause_button), .badCollision(bad_collision), .clk(clk), .rst(reset_button), .gameMode(game_mode), .state(game_state));

collisionDetector detect(.clk(clk), .rst(reset_button), .snakeHeadX(head_x), .snakeHeadY(head_y), .borderXMin(xmin), .borderXMax(xmax), .borderYMax(ymax), .borderYMin(ymin), .AppleX(apple_location[3:0]), .AppleY(apple_location[7:4]), .snakeArrayX(), .snakeArrayY(), .badCollision(bad_collision), .goodCollision(good_collision), .ready());
////// snake array x and y as well as ready <- for what?

apple_luck_selector luck1(.button(down_direction), .rst(reset_button), .state(game_state), .apple_luck(apple_luck));
// down button to change apple_luck

game_speed_selector speed1(.button(up_direction), .rst(reset_button), .state(game_state), .game_speed(game_speed));
//up button to change speed




initial begin
// GC_Time = '0;
// BC_Time = '0;
// clear_time = '0;
// enable_time = '0;
// wrap_time = '1;
// make sure to dump the signals so we can see them in the waveform
extra_reset = '0;
pb_start = '0;
pb_up = '0;
$dumpfile("sim.vcd");
$dumpvars(0, tb_combine);
extra_reset = 0;
#10;
extra_reset= 1;
#20;
extra_reset= 0;
 #20;
 #100;
pb_start = 1;
#20;
pb_start = 0;
#20 
pb_up = 1;
// GC_Time = 0;
// #10
// GC_Time = 1;
// #10
// GC_Time = 0;
// #10
// GC_Time = 1;
// #10
// GC_Time = 0;
// #25
// BC_Time = 0;
// #25
// BC_Time = 1;
#25
#2000

// sendStream(Stream);


$finish;
end
// finish the simulation


endmodule

//Clock
module clock (
  input logic system_clk, reset, // system_clk is the max frequency clk on the chip, reset is the output of the reset button
  input GAME_STATE game_state, // game_state
  input GAME_SPEED game_speed, // game speed
  output logic clk, clk_display, clk_body // clk_display goes to the display, and clk goes to all other functions

);


logic next_clk_display, next_clk, next_body_clk;
logic [7:0] counter, next_counter, max_count;

// always_ff @(posedge system_clk, posedge reset) begin //// display clk
//         if (reset) begin
//             clk_display <= 0;
//         end else begin
//             clk_display <= next_clk_display; // update the clock when the system clock updates
//         end
//     end


always_ff @(posedge system_clk, posedge reset) begin /// clk for most functions
        if (reset) begin
            clk <= 0;
        end else begin
            clk <= next_clk; // update the clock when the system clock updates
        end
    end



always_ff @(posedge system_clk, posedge reset) begin /// clk for snake body (speed control)
        if (reset) begin
            clk_body <= 0;
            counter <= next_counter;
        end else begin
            clk_body <= next_body_clk; // update the clock when the system clock updates
            counter <= next_counter;
        end
    end

assign clk_display = system_clk;

// always_comb begin // display clk logic

// if (clk_display == 0) begin
//   next_clk_display = 1;// update the display clock 
//   end
// else begin
//   next_clk_display = 0;
//   end
// end

always_comb begin /// movement clk

case (game_speed) 
NORMAL_SPEED: max_count = 55; ///variables to change game speed////////////////!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1
FAST_SPEED: max_count = 30;
SLOW_SPEED: max_count = 70;
default: max_count = 55;
endcase


if (next_counter != max_count) begin

  next_counter = counter + 1;
  next_body_clk = 0;

end

else begin

  next_counter = 0;
  next_body_clk = 1;
end
end


always_comb begin /// clk to most functions

if ( (game_state == WAIT) || (game_state == PAUSE)) begin //update the normal clk if it needs to be updated
  next_clk = 0;
end

else begin

  next_clk = system_clk; // setting clk equal to the system clk

end
end
endmodule

//Collision Detector 
module collisionDetector (
    input logic  clk, rst,
    //Snake head, border, and apple coordinates
    input logic [3:0] snakeHeadX, snakeHeadY, borderXMin, borderXMax, borderYMax, borderYMin, AppleX, AppleY, 
    //'Array'. Long bit number split into 4 bits, representing X, Y coordinate of each snake segment 
    input logic [559:0] snakeArrayX, snakeArrayY,
    output logic badCollision, goodCollision, ready
);

logic [3:0] body_x, body_y, body_x_n, body_y_n;
logic collisions, collisions_n, goodCollision_n, badCollision_n;
logic [559:0] snakeArrayX_temp, snakeArrayY_temp, snakeArrayX_temp_n, snakeArrayY_temp_n;
logic [7:0] count, count_n;
logic rstCount;



always_comb begin
    //Hit Left Border
    //Hit Right Border
    //Hit Top Border
    //Hit Bottom Border
    //collisions_n = (snakeHeadX == body_x) && (snakeHeadY == body_y);
    badCollision_n = (snakeHeadX <= borderXMin) | (snakeHeadX >= borderXMax) | (snakeHeadY <= borderYMin) | (snakeHeadY >= borderYMax);
    //Eat Apple
    goodCollision_n = (snakeHeadX == AppleX && snakeHeadY == AppleY);
end

always_comb begin
    //Store coordinate of snake body into array 
    body_x_n = snakeArrayX_temp[3:0];
    body_y_n = snakeArrayY_temp[3:0];

    //Shift array 4 bits to the left to store next set of coordinates
    snakeArrayX_temp_n = snakeArrayX_temp >> 4;
    snakeArrayY_temp_n = snakeArrayY_temp >> 4;

    //Counter for looping through all 140 segment of the snake
    if (count < 8'd140) begin
        count_n = count + 1;
        ready = 0;
    end else begin
        count_n = 0;
        ready = 1;
    end
end

always_ff @(posedge clk, posedge rst) begin

    //Checks for global reset 
    if (rst) begin
        collisions <= 1'b0;
        //Turn off
        {badCollision, goodCollision} <= 2'b0;
        body_x <= 4'b0;
        body_y <= 4'b0;
        count <= 8'b0;

        //temperary coordinate reset to original
        {snakeArrayX_temp, snakeArrayY_temp} <= {snakeArrayX, snakeArrayY};
    end else begin
        collisions <= (snakeHeadX == body_x) && (snakeHeadY == body_y);//collisions_n;
        //temperary coordinates go to next state
        {badCollision, goodCollision} <= {badCollision_n, goodCollision_n};
        {snakeArrayX_temp, snakeArrayY_temp} <= {snakeArrayX_temp_n, snakeArrayY_temp_n};
        {body_x, body_y} <= {body_x_n, body_y_n};
        count <= count_n;
    end
end

endmodule

//Game Speed Selector
module game_speed_selector (
    input logic button, rst,
    input GAME_STATE state,
    output GAME_SPEED game_speed
);

GAME_SPEED Q, Qn;

always_comb begin 
    case (Q)
        NORMAL_SPEED: Qn = FAST_SPEED;
        FAST_SPEED: Qn = SLOW_SPEED;
        SLOW_SPEED: Qn = NORMAL_SPEED;
        default: Qn = NORMAL_SPEED;
    endcase
end

always_ff @(posedge button, posedge rst) begin
    if (rst) begin
        Q <= NORMAL_SPEED;
    end else begin
        if (state == WAIT) begin
        Q <= Qn;
        end
        else begin
            Q<= Q;
    end
end
end
always_comb begin
    game_speed = Q;
end


endmodule


//Apple Luck Selector
module apple_luck_selector (
    input logic button, rst,
    input GAME_STATE state,
    output APPLE_LUCK apple_luck
);

APPLE_LUCK Q, Qn;

always_comb begin 
    case (Q)
        APPLE_NORMAL: Qn = APPLE_LUCKY;
        APPLE_LUCKY: Qn = APPLE_UNLUCKY;
        APPLE_UNLUCKY: Qn = APPLE_NORMAL;
        default: Qn = APPLE_NORMAL;
    endcase
end

always_ff @(posedge button, posedge rst) begin
    if (rst) begin
        Q <= APPLE_NORMAL;
    end else begin
        if (state == WAIT) begin
        Q <= Qn;
        end
        else begin
            Q<= Q;
    end
end
end
always_comb begin
    apple_luck = Q;
end


endmodule


//Game State
module gameState (
    input logic button, badCollision, clk, rst,
    // input GAME_MODE gameMode,
    output GAME_STATE state
);

GAME_STATE Q, Qn;

always_comb begin
    case (Q)
        WAIT: Qn = ((button == 1) && (badCollision == 0)) ? RUN : (badCollision ? END_GAME : WAIT);
        RUN: Qn = ((button == 1) && (badCollision == 0)) ? PAUSE : (badCollision ? END_GAME : RUN);
        PAUSE: Qn = ((button == 1) && (badCollision == 0)) ? RUN : (badCollision ? END_GAME : PAUSE);
        END_GAME: Qn = ((button == 1) && (badCollision == 0)) ? WAIT : (badCollision ? END_GAME : END_GAME);
        default: Qn = WAIT;
    endcase
end 

always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
        Q <= WAIT;
    end else begin
        Q <= Qn;
    end
end

always_comb begin
    state = Q;
end


endmodule


//Direction Logic 
module DirectionLogic(
    input logic clk, rst,
    input logic up, down, left, right,
    output DIRECTION directionOut
);
    DIRECTION direction; // intermediate var

    always_comb begin
        casez({left, right, down, up}) //using casez to cover button prioritizations
            4'b???1: direction = UP; // Syntax errors right now because module with enum definitions are not linked 
            4'b?1?0: direction = RIGHT;
            4'b?010: direction = DOWN;
            4'b1000: direction = LEFT;
            default: direction = directionOut;
        endcase
    end

    always_ff @ (posedge clk, posedge rst) begin //clk, rst, and flip-flop logic
        if (rst) begin
            directionOut <= RIGHT;
        end else begin
            directionOut <= direction;
        end
    end
endmodule

//Game Mode
module gameMode (
    input logic button, rst,
    input GAME_STATE state,
    output GAME_MODE mode
);

GAME_MODE Q, Qn;

always_comb begin 
    case (Q)
        NORMAL_MODE: Qn = TWO_APPLE;
        TWO_APPLE: Qn = WALL_SPAWN;
        WALL_SPAWN: Qn = NORMAL_MODE;
        default: Qn = NORMAL_MODE;
    endcase
end

always_ff @(posedge button, posedge rst) begin
    if (rst) begin
        Q <= NORMAL_MODE;
    end else begin
        if (mode == WAIT) begin
        Q <= Qn;
        end
        else begin
            Q<= Q;
    end
end
end
always_comb begin
    mode = Q;
end


endmodule


//Sync Module
module syncEdge (
    input logic clk, reset,
    input logic but,
    output logic direction
);
    logic out1;
    sync sync1 (.in(but), .clk(clk), .rst(reset), .out(out1));
    edgeDetect eD1 (.D(out1), .clk(clk), .rst(reset), .edg(direction));
endmodule

module sync(
        input logic in, 
        input logic clk, rst,
        output logic out
    );
        logic Q, Q1, Q_n, Q1_n;

        always_comb begin
            Q_n = in;
            Q1_n = Q; 
        end
        
        always_ff @(posedge clk, posedge rst) begin
            if (rst)begin
                Q <= 1'b0;
                Q1 <= 1'b0;
            end else begin
                Q <= Q_n;
                Q1 <= Q1_n;
            end
        end
        
        always_comb begin
            out = Q1;
        end
endmodule 

module edgeDetect(
    input logic D,
    input logic clk, rst,
    output logic edg
);
    logic Q1, Q2, Q1_n, Q2_n;

    always_comb begin
            Q1_n = D;
            Q2_n = Q1; 
        end
        
        always_ff @(posedge clk, posedge rst) begin
            if (rst)begin
                Q1 <= 1'b0;
                Q2 <= 1'b0;
            end else begin
                Q1 <= Q1_n;
                Q2 <= Q2_n;
            end
        end
        
        always_comb begin
            edg = Q1 & ~Q2;
        end
endmodule

//Body Control Module
module body_control (
input logic clk,
input logic rst,
input logic goodCollision,
input logic badCollision,
input DIRECTION Direction,
output logic [3:0] head_x,
output logic [3:0] head_y,
output logic [3:0] tail_x,
output logic [3:0] tail_y
);


logic innerGC;


logic [3:0] innerhead_x; // 4 bits
logic [3:0] innerhead_y; // 4 bits
logic [3:0] innertail_x; // 4 bits
logic [3:0] innertail_y; // 4 bits

always_comb begin
 innerhead_x = head_x;
 innerhead_y = head_y;
 innertail_x = tail_x;
 innertail_y = tail_y;

 casez(Direction)
   UP: begin //Up
   innerhead_y = head_y - 1;
   innertail_y = tail_y - 1;
   end
   DOWN: begin //Down
   innerhead_y = head_y + 1;
   innertail_y = tail_y + 1;
   end
   RIGHT: begin //Right
   innerhead_x = head_x + 1;
   innertail_x = tail_x + 1;
   end
   LEFT: begin //Left
   innerhead_x = head_x - 1;
   innertail_x = tail_x - 1;
   end
   default: {innerhead_x, innerhead_y, innertail_x, innertail_y} = {head_x, head_y, tail_x, tail_y};
 endcase
end






always_ff @(posedge clk, posedge rst) begin
 head_x <= innerhead_x;
 head_y <= innerhead_y;
 tail_x <= innertail_x;
 tail_y <= innertail_y;

 if (rst | badCollision) begin
   head_x <= 4'b0010;
   head_y <= 4'b0001;
   tail_x <= 4'b0001;
   tail_y <= 4'b0001;
 end
 else if (badCollision == 0) begin //If reset 
 
 if (goodCollision == 1) begin
   if (Direction == UP) begin
     head_y <= innerhead_y + 1;
     tail_y <= innertail_y + 1;
   end
   else if (Direction == DOWN) begin
     head_y <= innerhead_y - 1;
     tail_y <= innertail_y - 1;
   end
   else if (Direction == RIGHT) begin
     head_x <= innerhead_x - 1;
     tail_x <= innertail_x - 1;
   end
   else if (Direction == LEFT) begin
     head_x <= innerhead_x + 1;
     tail_x <= innertail_x + 1;
   end
 end
end
end


endmodule

//Border Generator
module BorderGen(
    input logic clk, rst,
    output logic [3:0] XMAX, XMIN, YMAX, YMIN
);

always_ff @ (posedge clk, posedge rst) begin
    if (rst) begin
        XMAX = 4'b0;
        XMIN = 4'b0;
        YMAX = 4'b0;
        YMIN = 4'b0;
    end else begin
        XMAX = 4'd1;
        XMIN = 4'd1;
        YMAX = 4'd1;
        YMIN = 4'd1;
    end
end
endmodule 


/////////////////////////// APPLE GEN MODULE //////////////////////////////////////////////////////

module apple_gen_all(
    input logic good_collision, system_clk, reset,
    input APPLE_LUCK apple_luck,
    input [3:0] snake_head_x, snake_head_y, snake_body_x, snake_body_y, XMAX, XMIN, YMAX, YMIN, 
    input logic [7:0] apple_possible, //random number from rand_num_gen
    output logic [7:0] apple_location, //valid apple position
    output logic enable //enable to rand_apple_gen
);

logic [3:0] x_next, y_next, x_final, y_final, x_difference, y_difference;
logic enable_next , good_spot, good_spot_next, logic_enable, lucky_spot, unlucky_spot;
logic [3:0] count;
logic [7:0] count_luck, count_luck_next, total_difference;


always_comb begin

////////////////////////////// START OF NORMAL APPLE GEN ////////////////////////////////////////////////////////////////////////

enable_next = (( ~good_spot) | good_collision); //enable to change x_next, y_next, only updates possible spot every couple clk cycles

case (apple_luck)
APPLE_NORMAL: begin
    if (logic_enable) begin // only starts if the luck is correct and a new number is needed
////////////////////////////// ADDED ENABLE TO LINE ABOVE and commented below
if (enable) begin
x_next = apple_possible[3:0]; //update the values of x,y to be a random number
y_next = apple_possible[7:4];
end
else begin
    x_next = 4'd0;//////////////////////////////////////////// error condition, 0,0 is an error
    y_next = 0;
end

if (({x_next, y_next} == {snake_head_x, snake_head_y}) | (x_next >= XMAX) | (x_next <= XMIN) | (y_next >= YMAX) | (y_next <= YMIN)) begin // if the location is invalid, find a new number
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

    good_spot_next = 1'b1;
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

end
end
//end of normal case

APPLE_UNLUCKY: begin 

if (logic_enable) begin // only starts if the luck is correct and a new number is needed

if (enable) begin
x_next = apple_possible[3:0]; //update the values of x,y to be a random number
y_next = apple_possible[7:4];
//error_next = 0;
end
else begin
    x_next = 4'd0;//////////////////////////////////////////// error condition, 0,0 is an error
    y_next = 1; /////////////could just make this a valid spot, it only happens once in a WHIle
    //error_next = 1;
end

if (({x_next, y_next} == {snake_head_x, snake_head_y}) | ({x_next, y_next} == {snake_body_x, snake_body_y}) | (x_next >= XMAX) | (x_next <= XMIN) | (y_next >= YMAX) | (y_next <= YMIN)) begin // if the location is invalid, find a new number
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
 

    total_difference = {4'd0, x_difference} + {4'd0, y_difference} + count_luck; // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! can change luck value here as well

    if (total_difference >= 9) begin   //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! change luck value
        unlucky_spot = 1;
        lucky_spot = 0;
    end                                   //determining if the spot is unlucky enough
    else begin
        unlucky_spot = 0;
        lucky_spot = 0;
    end


    if (unlucky_spot == 1) begin // if it is unlucky, make it the final spot

        good_spot_next = 1'b1;
        //x_final = x_next;
        //y_final = y_next;
        count_luck_next = 0;

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
end
end
//end of unlucky case

APPLE_LUCKY: begin 

if (logic_enable) begin // only starts if the luck is correct and a new number is needed

if (enable) begin
x_next = apple_possible[3:0]; //update the values of x,y to be a random number
y_next = apple_possible[7:4];
//error_next = 0;
end
else begin
    x_next = 4'd0;//////////////////////////////////////////// error condition, 0,0 is an error
    y_next = 1; /////////////could just make this a valid spot, it only happens once in a WHIle
    //error_next = 1;
end

if (({x_next, y_next} == {snake_head_x, snake_head_y}) | ({x_next, y_next} == {snake_body_x, snake_body_y}) | (x_next >= XMAX) | (x_next <= XMIN) | (y_next >= YMAX) | (y_next <= YMIN)) begin // if the location is invalid, find a new number
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
 

    total_difference = {4'd0, x_difference} + {4'd0, y_difference} - count_luck; // !!!!!!!!!!!!!!!!!!!!!!! could also change impact of count here

    if (total_difference >= 9) begin    //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!lucky enough value
        lucky_spot = 1;
        unlucky_spot = 0;
    end                                   //determining if the spot is unlucky enough
    else begin
        lucky_spot = 0;
        unlucky_spot = 0;
    end


    if (lucky_spot == 1) begin // if it is unlucky, make it the final spot

        good_spot_next = 1'b1;
        //x_final = x_next;
        //y_final = y_next;
        count_luck_next = 0;

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
    lucky_spot = 0; //
    unlucky_spot = 0;
    //error_next = 1;
end
end
// end of lucky case

default: begin 
     //default values for everything
         //
    x_next = 0;
    y_next = 0;
    good_spot_next = 1;
    //x_final = x_next;   //
    //y_final = y_next;   //
    x_difference = 0;  //
    y_difference = 0;  //
    total_difference = 0;  // 
    lucky_spot = 0; //
    unlucky_spot = 0;
    count_luck_next = count_luck;
    //error_next = 1;
end

// end of all cases
endcase
end
/////////////////////////////////  END OF NORMAL APPLE GEN ///////////////////////////////////////////////////////////

//////////////////////////////// START OF FF LOGIC /////////////////////////////////////////////////////////

always_ff @(posedge good_spot, posedge reset) begin   
 
if (reset) begin //update apple location output when good_pot is triggered
    apple_location <= 8'd0;  // default location
end

else begin

    apple_location <= {y_final, x_final};  // update apple position if it is valid

end
end
////////////////////////// END OF FF LOGIC ////////////////////////////////////////////////////////

always_ff @(posedge system_clk) begin

    good_spot = good_spot_next;
    ////////////////////////////
    x_final = x_next;
    y_final = y_next;
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

/// stop finding a spot when a new one is chosen and start again when it needs to 
always_ff @(posedge good_collision, posedge good_spot, posedge reset) begin

    if (reset) begin
        logic_enable = 1;
    end
    else if (good_collision) begin
        logic_enable = 1;
    end

    else begin
        logic_enable = 0;
    end


end
endmodule

/////////////////module for testing

module random_num_gen(
    input logic enable, system_clk, reset, //change enable whenever a new number is wanted
    output logic [7:0] number_out  // 8 bit number first 4 are x, last 4 are y
);

logic [7:0] number;
logic counter, counter_next, counter_normal, counter_normal_next, counter_flip, counter_flip_next;

always_ff @(posedge system_clk, posedge reset) begin

if (reset) begin
    number = 8'd0;
    counter_next = 0;
    counter_flip_next = 0;
    counter_normal_next = 0;
end
else begin //"randomly cycles through numbers"
    number = {number[6:0], ~(number[6] ^ number[5])};
    counter_next = counter;
    counter_flip_next = counter_flip;
    counter_normal_next = counter_normal;
end
end

always_ff @(posedge enable) begin ///only update the random number when enable is switched on

counter <= counter_next;
counter_normal <= counter_normal_next;
counter_flip <= counter_flip_next;

if (counter) begin
  if (counter_normal) begin
    number_out <= number - 8'd1;
    counter <= 0;
    counter_normal <= 0;
    counter_flip <= counter_flip;
  end
  else begin
  number_out <= number; //do not change the number if it is not needed
  counter <= 0;
  counter_normal <= 1;
  counter_flip <= counter_flip;
  end
end

else begin
  if (counter_flip) begin
  number_out <= ({number[3:0], number[7:4]} - 8'd1);
  counter <= 1;
  counter_normal <= counter_normal;
  counter_flip <= 0;
  end
  else begin
  number_out <= ({number[3:0], number[7:4]});
  counter <= 1;
  counter_normal <= counter_normal;
  counter_flip <= 1;
end
end

end
endmodule

//module for testing


module ssdec (// -Wno-ENUMVALUE
  input logic [3:0] in,
  input logic enable ,
  output logic [6:0] out
);

assign out[0] = ((~in[3] & in[2] & in[0]) || (~in[3] & in[1]) || (in[3] & ~in[1] & ~in[2]) || (~in[2] & ~in[0]) || (in[3] & ~in[0]) || (in[1] & in[2]) )  & enable;
assign out[1] =  ((~in[3] & ~in[2]) || (~in[3] & ~in[1] & ~in[0]) || (~in[3] & in[1] & in[0]) || (~in[2] & ~in[0]) || (in[3] & ~in[1] & in[0])) & enable;
assign out[2] = ((~in[3] & ~in[1]) || (~in[3] & in[0]) || (~in[3] & in[2]) || (in[3] & ~in[2]) || (~in[1] & in[0])) & enable;
assign out[3] = ((~in[3] & ~in[2] & ~in[0]) || (~in[2] & in[1] & in[0]) || (in[3] & ~in[1] & ~in[0]) || (in[2] & ~in[1] & in[0]) || (in[2] & in[1] & ~in[0])) & enable;
assign out[4] = ((~in[2] & ~in[0]) || (in[3] & in[2]) || (in[1] & ~in[0]) || (in[3] & in[1])) & enable;
assign out[5] = ((~in[3] & in[2] & ~in[1]) || (in[3] & ~in[2]) || (~in[1] & ~in[0]) || (in[2] & ~in[0]) || (in[3] & in[1])) & enable;
assign out[6] = ((~in[3] & in[2] & ~in[1]) || (in[3] & ~in[2]) || (~in[2] & in[1]) || (in[1] & ~in[0]) || (in[3] & in[0])) & enable;

endmodule

//module for testing


//Length and Score Tracker
module LS_Tracker (
input logic clk,
input logic rst,
input logic goodCollision,
input logic badCollision,
output logic [7:0] length,
output logic [7:0] score
);

logic [7:0] innerlength;
logic [7:0] innerscore;

always_comb begin

innerlength = length ;

if (goodCollision) begin
innerlength = length + 1;
innerscore = score + 1;
end
else if (badCollision) begin
innerlength = 8'b0;
innerscore = 8'b0;
end
else begin
innerlength = length;
innerscore = score;
end
end


always_ff @ (posedge clk, posedge rst) begin
 if (rst) begin
   length <= 8'd2;
   score <= 8'b0;
 end
 else begin
   length <= innerlength;
   score <= innerscore;
 end
end
endmodule


//Seven Segment Out
module seven_seg_out(
    input logic [7:0] score,
    input GAME_STATE game_state,
    input GAME_MODE game_mode,
    input GAME_SPEED game_speed,
    input APPLE_LUCK apple_luck,
    output logic [3:0] score_out0, score_out1, score_out2, state_out, mode_out, speed_out, luck_out
);

logic [7:0] bit2_temp;
logic [7:0] bit1_temp;

always_comb begin
    
// 100's place logic

    if (score >= 8'd100) begin
        score_out2 = 4'd1;
        bit2_temp = score - 8'd100;
end
    else begin
        score_out2 = 4'd0;
        bit2_temp = score - 8'd0;
    end

//
// 10's place logic
//

    if (bit2_temp >= 8'd90) begin
        score_out1 = 4'd9;
        bit1_temp = bit2_temp - 8'd90;
    end else if (bit2_temp >= 8'd80) begin
        score_out1 = 4'd8;
        bit1_temp = bit2_temp - 8'd80;
    end else if (bit2_temp >= 8'd70) begin
        score_out1 = 4'd7;
        bit1_temp = bit2_temp - 8'd70;
    end else if (bit2_temp >= 8'd60) begin
        score_out1 = 4'd6;
        bit1_temp = bit2_temp - 8'd60;
    end else if (bit2_temp >= 8'd50) begin
        score_out1 = 4'd5;
        bit1_temp = bit2_temp - 8'd50;
    end else if (bit2_temp >= 8'd40) begin
        score_out1 = 4'd4;
        bit1_temp = bit2_temp - 8'd40;
    end else if (bit2_temp >= 8'd30) begin
        score_out1 = 4'd3;
        bit1_temp = bit2_temp - 8'd30;
    end else if (bit2_temp >= 8'd20) begin
        score_out1 = 4'd2;
        bit1_temp = bit2_temp - 8'd20;
    end else if (bit2_temp >= 8'd10) begin
        score_out1 = 4'd1;
        bit1_temp = bit2_temp - 8'd10;
    end else begin 
        score_out1 = 4'd0;
        bit1_temp = bit2_temp;
    end

//
// 1's place logic
//
case(bit1_temp)
    8'd9: score_out0 = 4'd9;
    8'd8: score_out0 = 4'd8;
    8'd7: score_out0 = 4'd7;
    8'd6: score_out0 = 4'd6;
    8'd5: score_out0 = 4'd5;
    8'd4: score_out0 = 4'd4;
    8'd3: score_out0 = 4'd3;
    8'd2: score_out0 = 4'd2;
    8'd1: score_out0 = 4'd1;
    default: score_out0 = 4'b0;
endcase
    
//
// GAME STATE DISPLAY
// 
    case (game_state)
    RUN: state_out = 4'b0010;
    WAIT: state_out = 4'b0001;
    PAUSE: state_out = 4'b0011;
    END_GAME: state_out = 4'b1000;
    endcase

//
// GAME MODE DISPLAY
// 
    case (game_mode)
    TWO_APPLE: mode_out = 4'b0010;
    NORMAL_MODE: mode_out = 4'b0001;
    WALL_SPAWN: mode_out = 4'b0011;
    default: mode_out = 4'b1111;
    endcase

//
// GAME LUCK DISPLAY
// 
    case (apple_luck)
    APPLE_NORMAL: luck_out = 4'b0001;
    APPLE_LUCKY: luck_out = 4'b0010;
    APPLE_UNLUCKY: luck_out = 4'b0011;
    default: luck_out = 4'b1111;
    endcase

//
// GAME SPEED DISPLAY
// 
    case (game_speed)
    NORMAL_SPEED: speed_out = 4'b0001;
    FAST_SPEED: speed_out = 4'b0010;
    SLOW_SPEED: speed_out = 4'b0011;
    default: speed_out = 4'b1111;
    endcase


    end

endmodule 



