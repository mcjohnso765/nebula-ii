`timescale 1ms/10ps
typedef enum logic [1:0] {
       UP = 2'b00,
       DOWN = 2'b01,
       LEFT = 2'b10,
       RIGHT = 2'b11
   } DIRECTION;

module tb_collisionDetector;

collisionDetector detector(.clk(hz100), .nrst(reset), .snakeHeadX(snakeHeadX), .snakeHeadY(snakeHeadY), .borderXMin(4'd0), .borderXMax(4'd15), 
.borderYMax(4'd11), .borderYMin(4'd0), .AppleX(4'd2), .AppleY(4'd8), .snakeArrayX(x_array), .snakeArrayY (y_array), .badCollision(bad), .goodCollision(good),
 .ready(ready), .snakeTailX(4'd2), .snakeTailY(4'd7));



logic [19:0] in;
logic hz100;
logic [4:0] out, head_x, head_y;
logic reset;
logic strobe; //define
logic strobe_2;
integer i;
integer j;
integer k;
logic [1:0] Stream [];
logic [1:0] Stream_2 [];


// Clock generation block
always begin
 hz100 = 1'b0;
 #(5);
 hz100 = 1'b1;
 #(5);
end

logic [3:0] snakeHeadX, snakeHeadY;
logic [139:0] [0:3] x_array ;//[0:3];
logic [139:0] [0:3] y_array ;//[0:3]; 
logic [27:0] ignore;
logic [1:0] tempKey;
logic [3:0] x, y;
logic ready, bad, good;
logic wrap_time;
logic clear_time;
logic enable_time;
logic GC_Time;
logic BC_Time;
DIRECTION Direction;

task simKey;
 input logic [1:0] keyin; begin
 @ (negedge strobe);
 tempKey = keyin;
 @ (posedge strobe);
 end
endtask


task sendStream;
 input logic [1:0] taskStream []; begin
 for (integer keynumb = 0; keynumb < taskStream.size(); keynumb++) begin
     simKey(taskStream[keynumb]);
 end
  
 end
endtask

initial begin
x_array  = '0;
y_array  = '0;
Stream = '{2'b00, 2'b01, 2'b10, 2'b11};
tempKey = '0;
GC_Time = '0;
BC_Time = '0;
clear_time = '0;
enable_time = '0;
wrap_time = '1;


// make sure to dump the signals so we can see them in the waveform
$dumpfile("sim.vcd");
$dumpvars(0, tb_collisionDetector);
reset = 1;
#50;
reset = 0;
#50;
reset = 1;
// for (integer i = 0 ; i <= 5; i++) begin
//     {ignore, x} = 2 + i;
//     {ignore, y} = 4 + i;
//     {x_array[i * 4 + 3], x_array[i * 4 + 2], x_array[i * 4 + 1], x_array[i * 4]} = x;
//     {y_array[i * 4 + 3], y_array[i * 4 + 2], y_array[i * 4 + 1], y_array[i * 4]} = y;
//     #141;
// end
 
reset = 0;
#50;
reset = 1;
#50;

snakeHeadX = 4'd2;
snakeHeadY = 4'd8;
x_array [12] [0:3] = 4'd7;
y_array [12] [0:3] = 4'd7;

#50;
if (bad != 0) begin
    $display("Good Collision1. Error. ");
end 
if (good != 1) begin
    $display("Good Collision2. Error. ");
end 
reset = 0;
#50;
reset = 1;
#50;

snakeHeadX = 4'd0;
snakeHeadY = 4'd5;
#50;
if (bad != 1) begin
    $display("Bad Collision1. Error. ");
end 
if (good == 1) begin
    $display("badcollisiin12. Error. ");
end 
reset = 0;
#50;
reset = 1;
#50;

snakeHeadX = 4'd15;
snakeHeadY = 4'd5;
#50;
if (bad != 1) begin
    $display("Bad Collision2. Error. ");
end 
if (good == 1) begin
    $display("badcollisiin22. Error. ");
end 
reset = 0;
#50;
reset = 1;
#50;

snakeHeadX = 4'd7;
snakeHeadY = 4'd0;
#50;
if (bad != 1) begin
    $display("Bad Collision3. Error. ");
end 
if (good == 1) begin
    $display("badcollisiin32. Error. ");
end 
reset = 0;
#50;
reset = 1;
#50;

snakeHeadX = 4'd7;
snakeHeadY = 4'd11;
#50;
if (bad != 1) begin
    $display("Bad Collision4. Error. ");
end 
if (good == 1) begin
    $display("badcollisiin42. Error. ");
end 
reset = 0;
#50;
reset = 1;
#50;

snakeHeadX = 4'd7;
snakeHeadY = 4'd7;
x_array [0] [0:3] = 4'd7;
y_array [0] [0:3] = 4'd7;
#50;
if (bad != 1) begin
    $display("Body Collision4. Error. ");
end 
if (good == 1) begin
    $display("body collisiin42. Error. ");
end 
#100
$finish;
end
// finish the simulation
endmodule