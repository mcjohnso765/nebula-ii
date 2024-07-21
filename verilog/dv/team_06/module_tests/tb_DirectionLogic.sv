`timescale 1ms/10ps
typedef enum logic [1:0] {
       UP = 2'b00,
       DOWN = 2'b01,
       LEFT = 2'b10,
       RIGHT = 2'b11
   } DIRECTION;

module tb_DirectionLogic;

logic [19:0] in;
logic hz100;
logic [4:0] out;
logic reset;
logic strobe; //define
logic strobe_2;
integer i;
integer j;
integer k;
logic [1:0] Stream [];
logic [1:0] Stream_2 [];


logic [1:0] dOut;

DirectionLogic direct (.clk(hz100), .rst(reset), .up(1'b0), .down(1'b1), .left(1'b1), .right(1'b0), .directionOut(dOut));
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
Stream = '{2'b00, 2'b01, 2'b10, 2'b11};
tempKey = '0;
GC_Time = '0;
BC_Time = '0;
clear_time = '0;
enable_time = '0;
wrap_time = '1;


// make sure to dump the signals so we can see them in the waveform
$dumpfile("sim.vcd");
$dumpvars(0, tb_DirectionLogic);
reset = 0;
#10;
reset = 1;
#20;
reset = 0;
#10;


sendStream(Stream);

$finish;
end
// finish the simulation

endmodule