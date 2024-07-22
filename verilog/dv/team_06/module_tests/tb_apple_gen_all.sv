    `timescale 1ms/10ps



typedef enum logic [1:0] {
        APPLE_NORMAL = 2'b00,
        APPLE_LUCKY = 2'b01, 
        APPLE_UNLUCKY = 2'b10
    } APPLE_LUCK; 

module tb_apple_gen_all;//_and_apple_gen;


    logic good_collision, hz100, reset, enablea;
    logic [7:0] out_random, location1;
    APPLE_LUCK apple_luck1;
    logic [3:0] head_y, head_x, xma, xmi, yma, ymi, snakeTailX, snakeTailY;
    logic [139:0] [3:0] snakeArrayX, snakeArrayY;
    logic [139:0] difference_total;
    logic [5:0] average_difference;
    logic [20:0] difference_sum;
    logic [8:0] difference, difference_x, difference_y;

always begin
 hz100 = 1'b0;
 #(5);
 hz100 = 1'b1;
 #(5);
end

random_num_gen abcdefg(.enable(enablea), .system_clk(hz100), .nreset( ~ reset), .number_out(out_random));

apple_gen_all ab (.good_collision(good_collision), .system_clk(hz100), .clk(hz100), .nreset(reset), .apple_luck(apple_luck1), .snake_head_x(head_x), .snake_head_y(head_y), .snakeArrayX(snakeArrayX), .snakeArrayY(snakeArrayY), .XMAX(xma), .XMIN(xmi), .YMAX(yma), .YMIN(ymi), .apple_possible(out_random), .apple_location(location1), .enable(enablea), .snakeTailX(snakeTailX), .snakeTailY(snakeTailY));

    initial begin
// make sure to dump the signals so we can see them in the waveform
    $dumpfile("sim.vcd");
    $dumpvars(0, tb_apple_gen_all);
// Task 1: power-on reset case 


    normal_dis();
    $display(" task 1 done");
    lucky_dis();
    $display(" task 2 done");
    unlucky_dis();
    $display(" task 3 done");



    #1 $finish;
 end

 task normal_dis(); //////////////////////////////////////////// 
apple_luck1 = APPLE_NORMAL;
head_x = 4'd7;
head_y = 4'd5;
xma = 4'd13;
yma = 4'd9;
xmi = 4'd0;
ymi = 4'd0;
snakeArrayX = 560'd7;
snakeArrayY = 560'd7;
reset = 1;
#50;
reset = 0;
#50;
reset = 1;
#50;
good_collision = 0;
difference_sum = 0;
apple_luck1 = APPLE_NORMAL;
snakeArrayX = 560'd7;
snakeArrayY = 560'd5;
snakeTailX = 4'd1;
snakeTailY = 4'd0;
for (integer i = 0; i <= 139; i++) begin
    #500
    good_collision = 1;
    #10
    good_collision = 0;
    #450

    if ((location1[3:0] >= 7) ) begin
        difference_x = (location1[3:0] - 7);
    end
    else begin
        difference_x = ( 7 - location1[3:0]);
    end

    if ((location1[7:4] >= 5) ) begin
        difference_y = (location1[7:4] - 5);
    end
    else begin
        difference_y = ( 5 - location1[7:4]);
    end


    difference = difference_x + difference_y;

    difference_sum = difference_sum + difference;

    $display(" difference = %d", difference);
    //$display(" location1 = %d", location1);
end

average_difference = difference_sum / 140;
$display(" average distance normal = %d  / 140", difference_sum);
 endtask

task lucky_dis(); //////////////////////////////////////////// 
apple_luck1 = APPLE_LUCKY;
head_x = 4'd7;
head_y = 4'd5;
xma = 4'd13;
yma = 4'd9;
xmi = 4'd0;
ymi = 4'd0;
snakeArrayX = 560'd7;
snakeArrayY = 560'd7;
reset = 1;
#50;
reset = 0;
#50;
reset = 1;
#50;
good_collision = 0;
difference_sum = 0;
apple_luck1 = APPLE_LUCKY;
snakeArrayX = 560'd7;
snakeArrayY = 560'd5;
snakeTailX = 4'd0;
snakeTailY = 4'd0;
for (integer i = 0; i <= 139; i++) begin
    #500;
    //snakeTailX = location1[3:0];
    //snakeTailY = location1[7:4];
    snakeTailX = 1;
    snakeTailY = 1;
    good_collision = 1;
    #50;
    good_collision = 0;
    #450;

    if ((location1[3:0] >= 7) ) begin
        difference_x = (location1[3:0] - 7);
    end
    else begin
        difference_x = ( 7 - location1[3:0]);
    end

    if ((location1[7:4] >= 5) ) begin
        difference_y = (location1[7:4] - 5);
    end
    else begin
        difference_y = ( 5 - location1[7:4]);
    end


    difference = difference_x + difference_y;

    difference_sum = difference_sum + difference;

    $display(" difference = %d", difference);
    //$display(" location1 = %d", location1);
end

average_difference = difference_sum / 140;
$display(" average distance lucky = %d  / 140", difference_sum);
 endtask


 task unlucky_dis(); //////////////////////////////////////////// 
apple_luck1 = APPLE_UNLUCKY;
head_x = 4'd7;
head_y = 4'd5;
xma = 4'd13;
yma = 4'd9;
xmi = 4'd0;
ymi = 4'd0;
snakeArrayX = 560'd7;
snakeArrayY = 560'd5;
reset = 1;
#50;
reset = 0;
#50;
reset = 1;
#50;
good_collision = 0;
difference_sum = 0;
apple_luck1 = APPLE_UNLUCKY;
snakeArrayX = 560'd7;
snakeArrayY = 560'd5;
snakeTailX = 4'd0;
snakeTailY = 4'd0;
for (integer i = 0; i <= 139; i++) begin
    #500;
    //snakeTailX = location1[3:0];
    //snakeTailY = location1[7:4];
    snakeTailX = 1;
    snakeTailY = 1;
    good_collision = 1;
    #50;
    good_collision = 0;
    #450;

    if ((location1[3:0] >= 7) ) begin
        difference_x = (location1[3:0] - 7);
    end
    else begin
        difference_x = ( 7 - location1[3:0]);
    end

    if ((location1[7:4] >= 5) ) begin
        difference_y = (location1[7:4] - 5);
    end
    else begin
        difference_y = ( 5 - location1[7:4]);
    end


    difference = difference_x + difference_y;

    difference_sum = difference_sum + difference;

    $display(" difference = %d", difference);
    //$display(" location1 = %d", location1);
end

average_difference = difference_sum / 140;
$display(" average distance unlucky = %d  / 140", difference_sum);
 endtask


endmodule













// `timescale 1ms/10ps



// typedef enum logic [1:0] {
//         APPLE_NORMAL = 2'b00,
//         APPLE_LUCKY = 2'b01, 
//         APPLE_UNLUCKY = 2'b10
//     } APPLE_LUCK; 

// module tb_apple_gen_all;


//     logic good_collision, hz100, reset, enablea;
//     logic [7:0] out_random, location1;
//     APPLE_LUCK apple_luck1;
//     logic [3:0] head_y, head_x, xma, xmi, yma, ymi;
//     logic [139:0] [3:0] snakeArrayX, snakeArrayY;

// always begin
//  hz100 = 1'b0;
//  #(5);
//  hz100 = 1'b1;
//  #(5);
// end


// apple_gen_all ab (.good_collision(good_collision), .system_clk(hz100), .reset(reset), .apple_luck(apple_luck1), .snake_head_x(head_x), .snake_head_y(head_y), .snakeArrayX(snakeArrayX), .snakeArrayY(snakeArrayY), .XMAX(xma), .XMIN(xmi), .YMAX(yma), .YMIN(ymi), .apple_possible(out_random), .apple_location(location1), .enable(enablea), .snakeTailX(4'd0), .snakeTailY(4'd0));

//     initial begin
// // make sure to dump the signals so we can see them in the waveform
//     $dumpfile("sim.vcd");
//     $dumpvars(0, tb_apple_gen_all);
// // Task 1: power-on reset case 


//     power_on_reset();
//     $display(" task 1 done");
//     normal_op();
//     $display(" task 2 done");
//     lucky_op();
//     $display(" task 3 done");
//     unlucky_op();
//     $display(" task 4 done");



//     #1 $finish;
//  end

//  task power_on_reset(); //////////////////////////////////////////// 
// apple_luck1 = APPLE_NORMAL;
// head_x = 4'd7;
// head_y = 4'd7;
// xma = 4'd13;
// yma = 4'd9;
// xmi = 4'd0;
// ymi = 4'd0;
// snakeArrayX = 560'd7;
// snakeArrayY = 560'd7;
// out_random = 8'h52;
// reset = 1;
// #50;
//    reset = 0;
//       out_random = 8'h52;
// #50;
//     reset = 1;
// #50;
//    good_collision = 1;
//       out_random = 8'h52;
//       #50;
//     good_collision = 0;
 
//   if (location1 != 8'h52)
//     $display("task 1 fail out =%b", location1);
//  endtask

//  task normal_op(); //////////////////////////////////////////// 
// apple_luck1 = APPLE_NORMAL;
// head_x = 4'd7;
// head_y = 4'd7;
// xma = 4'd13;
// yma = 4'd9;
// xmi = 4'd0;
// ymi = 4'd0;
// snakeArrayX = 560'd7;
// snakeArrayY = 560'd7;
// out_random = 8'h52;
// reset = 1;
// #50;
//    reset = 0;
//       out_random = 8'h52;
// #50;
//     reset = 1;
//    good_collision = 0;
//       out_random = 8'h52;
//       #50;
//     good_collision = 0;
 
//   if (location1 != 8'h55)
//     $display("task 2 fail out =%b", location1);
//  endtask


//  task lucky_op(); //////////////////////////////////////////// 
// apple_luck1 = APPLE_LUCKY;
// head_x = 4'd7;
// head_y = 4'd7;
// xma = 4'd13;
// yma = 4'd9;
// xmi = 4'd0;
// ymi = 4'd0;
// snakeArrayX = 560'd7;
// snakeArrayY = 560'd7;
// out_random = 8'h52;
// reset = 1;
// #50;
//    reset = 0;
//       out_random = 8'h52;
// #50;
//     reset = 1;
//    good_collision = 0;
//       out_random = 8'h52;
//       #50;
//     good_collision = 0;
 
//   if (location1 != 8'h55)
//     $display("task 3 fail out =%b", location1);
//  endtask

//   task unlucky_op(); //////////////////////////////////////////// 
// apple_luck1 = APPLE_UNLUCKY;
// head_x = 4'd7;
// head_y = 4'd7;
// xma = 4'd13;
// yma = 4'd9;
// xmi = 4'd0;
// ymi = 4'd0;
// snakeArrayX = 560'd7;
// snakeArrayY = 560'd7;
// out_random = 8'h52;
// reset = 1;
// #50;
//    reset = 0;
//       out_random = 8'h52;
// #50;
//     reset = 1;
//    good_collision = 0;
//       out_random = 8'h52;
//       #50;
//     good_collision = 0;
 
//   if (location1 != 8'h55)
//     $display("task 4 fail out =%b", location1);
//  endtask
// endmodule


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