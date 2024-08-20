`timescale 1ms/10ps


module tb_rand_num_gen;


    logic clk, reset, enable;
    logic [7:0] number_out, x_1, x_0, x_2, x_3, x_4, x_5, x_6, x_7, x_8, x_9, x_10, x_11, x_12, x_13, x_14, x_15;
    logic [7:0]  y_1, y_0, y_2, y_3, y_4, y_5, y_6, y_7, y_8, y_9, y_10, y_11, y_12, y_13, y_14, y_15;

    initial clk = 0;
    always clk = #50 ~clk;


    rand_num_gen ab(.enable(enable), .system_clk(clk), .reset(reset), .number_out(number_out));
    
    initial begin
// make sure to dump the signals so we can see them in the waveform
    $dumpfile("sim.vcd");
    $dumpvars(0, tb_rand_num_gen);
// Task 1: power-on reset case 


    power_on_reset();
    $display(" task 1 done");
    regular_op();
    $display(" task 2 done");
 


    #1 $finish;
 end

 task power_on_reset(); //////////////////////////////////////////// 
   enable = 0;
   reset = 1;
   @(posedge clk);
   @(posedge clk);
   reset = 0;
   @(posedge clk);
   enable = 1;
   @(posedge clk);

  if (number_out == 8'd0)
    $display("task 1 fail out =%b", number_out);
 endtask

task regular_op();
x_0 = 0;
x_1 = 0;
x_2 = 0;
x_3 = 0;
x_4 = 0;
x_5 = 0;
x_6 = 0;
x_7 = 0;
x_8 = 0;
x_9 = 0;
x_10 = 0;
x_11 = 0;
x_12 = 0;
x_13 = 0;
x_14 = 0;
x_15 = 0;
y_0 = 0;
y_1 = 0;
y_2 = 0;
y_3 = 0;
y_4 = 0;
y_5 = 0;
y_6 = 0;
y_7 = 0;
y_8 = 0;
y_9 = 0;
y_10 = 0;
y_11 = 0;
y_12 = 0;
y_13 = 0;
y_14 = 0;
y_15 = 0;

for (integer i = 0; i<= 10; i = i + 1) begin

    @(posedge clk);
    enable = 1;
    @(posedge clk);
    if (number_out[3:0] ==0) begin
        x_0 = x_0 + 1;
    end
        if (number_out[3:0] ==1) begin
        x_1 = x_1 + 1;
    end
        if (number_out[3:0] ==2) begin
        x_2 = x_2 + 1;
    end
        if (number_out[3:0] ==3) begin
        x_3 = x_3 + 1;
    end
        if (number_out[3:0] ==4) begin
        x_4 = x_4 + 1;
    end
        if (number_out[3:0] ==5) begin
        x_5 = x_5 + 1;
    end
        if (number_out[3:0] ==6) begin
        x_6 = x_6 + 1;
    end
        if (number_out[3:0] ==7) begin
        x_7 = x_7 + 1;
    end
        if (number_out[3:0] ==8) begin
        x_8 = x_8 + 1;
    end
        if (number_out[3:0] ==9) begin
        x_9 = x_9 + 1;
    end
        if (number_out[3:0] ==10) begin
        x_10 = x_10 + 1;
    end
        if (number_out[3:0] ==11) begin
        x_11 = x_11 + 1;
    end
        if (number_out[3:0] ==12) begin
        x_12 = x_12 + 1;
    end
        if (number_out[3:0] ==13) begin
        x_13 = x_13 + 1;
    end
        if (number_out[3:0] ==14) begin
        x_14 = x_14 + 1;
    end
        if (number_out[3:0] ==15) begin
        x_15 = x_15 + 1;
    end
    if (number_out[7:4] ==0) begin
        y_0 = y_0 + 1;
    end
        if (number_out[7:4] ==1) begin
        y_1 = y_1 + 1;
    end
        if (number_out[7:4] ==2) begin
        y_2 = y_2 + 1;
    end
        if (number_out[7:4] ==3) begin
        y_3 = y_3 + 1;
    end
        if (number_out[7:4] ==4) begin
        y_4 = y_4 + 1;
    end
        if (number_out[7:4] ==5) begin
        y_5 = y_5 + 1;
    end
        if (number_out[7:4] ==6) begin
        y_6 = y_6 + 1;
    end
        if (number_out[7:4] ==7) begin
        y_7 = y_7 + 1;
    end
        if (number_out[7:4] ==8) begin
        y_8 = y_8 + 1;
    end
        if (number_out[7:4] ==9) begin
        y_9 = y_9 + 1;
    end
        if (number_out[7:4] ==10) begin
        y_10 = y_10 + 1;
    end
        if (number_out[7:4] ==11) begin
        y_11 = y_11 + 1;
    end
        if (number_out[7:4] ==12) begin
        y_12 = y_12 + 1;
    end
        if (number_out[7:4] ==13) begin
        y_13 = y_13 + 1;
    end
        if (number_out[7:4] ==14) begin
        y_14 = y_14 + 1;
    end
        if (number_out[7:4] ==15) begin
        y_15 = y_15 + 1;
    end
    $display(" x = %d,     y =  %d", number_out[3:0], number_out[7:4]);
    enable = 0;

end
$display(" x_0 = %d ", x_0);
$display(" x_1 = %d ", x_1);
$display(" x_2 = %d ", x_2);
$display(" x_3 = %d ", x_3);
$display(" x_4 = %d ", x_4);
$display(" x_5 = %d ", x_5);
$display(" x_6 = %d ", x_6);
$display(" x_7 = %d ", x_7);
$display(" x_8 = %d ", x_8);
$display(" x_9 = %d ", x_9);
$display(" x_10 = %d ", x_10);
$display(" x_11 = %d ", x_11);
$display(" x_12 = %d ", x_12);
$display(" x_13 = %d ", x_13);
$display(" x_14 = %d ", x_14);
$display(" x_15 = %d ", x_15);
$display(" y_0 = %d ", y_0);
$display(" y_1 = %d ", y_1);
$display(" y_2 = %d ", y_2);
$display(" y_3 = %d ", y_3);
$display(" y_4 = %d ", y_4);
$display(" y_5 = %d ", y_5);
$display(" y_6 = %d ", y_6);
$display(" y_7 = %d ", y_7);
$display(" y_8 = %d ", y_8);
$display(" y_9 = %d ", y_9);
$display(" y_10 = %d ", y_10);
$display(" y_11 = %d ", y_11);
$display(" y_12 = %d ", y_12);
$display(" y_13 = %d ", y_13);
$display(" y_14 = %d ", y_14);
$display(" y_15 = %d ", y_15);

endtask



endmodule


module rand_num_gen(
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






// module rand_num_gen(
//     input logic enable, system_clk, reset, //change enable whenever a new number is wanted
//     output logic [7:0] number_out  // 8 bit number first 4 are x, last 4 are y
// );

// logic [7:0] number;
// logic counter, counter_next;

// always_ff @(posedge system_clk, posedge reset) begin

// if (reset) begin
//     number = 8'd0;
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
// number_out <= number; //do not change the number if it is not needed
// counter <= 0;
// end

// else begin
//   number_out <= {number[3:0], number[7:4]};
//   counter <= 1;
// end


// end
// endmodule