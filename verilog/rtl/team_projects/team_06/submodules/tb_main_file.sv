`timescale 1ms/10ps


module tb_main_file;
    logic clk, nrst, right, left, down, reset_in, up, starta, apple, wall, body, head, endgame, rert;
    logic [3:0] x,y;
 

    initial clk = 0;
    always clk = #50 ~clk;

    initial begin
// make sure to dump the signals so we can see them in the waveform
    $dumpfile("sim.vcd");
    $dumpvars(0, tb_main_file);
// Task 1: power-on reset case 
main_file abc(.clk(clk), .nrst(nrst), .button_right_in(right), .button_left_in(left), .button_down_in(down), .button_reset_in(reset_in), .button_up_in(up), 
.button_start_pause_in(starta), .enable_total(1), .x(x), .y(y) , .apple(apple), .wall(wall), .body(body), .head(head), .gameover(endgame), .rert(rert));


nrst = 1;
right = 0;
left = 0;
down = 0;
reset_in = 1;
up = 0;
starta = 0;
x = 4'd2;
y = 4'd2;
#100;
nrst = 0;
right = 0;
left = 0;
down = 0;
reset_in = 1;
up = 0;
starta = 0;
x = 4'd2;
y = 4'd2;
#100;
nrst = 1;
#100;
starta = 1;
#100
starta = 0;
#100;
    end
#1 $finish;
endmodule