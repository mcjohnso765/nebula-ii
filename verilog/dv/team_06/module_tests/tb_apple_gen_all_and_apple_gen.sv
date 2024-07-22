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
    logic [3:0] head_y, head_x, xma, xmi, yma, ymi;
    logic [139:0] [3:0] snakeArrayX, snakeArrayY;
    logic [139:0] difference_total;
    logic [5:0] average_difference;
    logic [20:0] difference_sum;

always begin
 hz100 = 1'b0;
 #(5);
 hz100 = 1'b1;
 #(5);
end

random_num_gen abcdefg(.enable(enablea), .system_clk(hz100), .reset(reset), .number_out(out_random));

apple_gen_all ab (.good_collision(good_collision), .system_clk(hz100), .reset(reset), .apple_luck(apple_luck1), .snake_head_x(head_x), .snake_head_y(head_y), .snakeArrayX(snakeArrayX), .snakeArrayY(snakeArrayY), .XMAX(xma), .XMIN(xmi), .YMAX(yma), .YMIN(ymi), .apple_possible(out_random), .apple_location(location1), .enable(enablea), .snakeTailX(4'd0), .snakeTailY(4'd0));

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
difference_sum = 0;
for (integer i = 0; i <= 139; i++) begin
    #50
    good_collision = 1;
    #50
    good_collision = 0;
    difference_total[i] = location1[3:0] - 7 + (location1[7:4] - 5);
    difference_sum = difference_sum + difference_total[i];

    end

average_difference = difference_sum / 140;
$display(" average distance = %b", average_difference);
 endtask

endmodule