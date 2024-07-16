`timescale 1ms/10ps
typedef enum logic [1:0] {
       UP = 2'b00,
       DOWN = 2'b01,
       LEFT = 2'b10,
       RIGHT = 2'b11
   } DIRECTION;
typedef enum logic [1:0] {
        RUN = 2'b00,
        WAIT = 2'b01, 
        PAUSE = 2'b10,
        END_GAME = 2'b11
    } GAME_STATE; 

typedef enum logic [1:0] {
        NORMAL_SPEED = 2'b00,
        FAST_SPEED = 2'b01, 
        SLOW_SPEED = 2'b10
    } GAME_SPEED; 

module tb_clock;

logic [19:0] in;
logic mhz10;
logic [4:0] out;
logic nreset;
logic strobe; //define
logic strobe_2;
integer i;
integer j;
integer k;
logic [1:0] Stream [];
logic [1:0] Stream_2 [];
logic clockDisOut;
logic clockOut;
GAME_STATE game_state= RUN;
GAME_SPEED game_speed = NORMAL_SPEED;



logic [1:0] dOut;
always begin
 mhz10 = 1'b0;
 #(5);
 mhz10 = 1'b1;
 #(8);
end

clock c1 (.system_clk(mhz10), .nreset(nreset), .clk_display(clockDisOut), .clk(clockOut), .game_state(game_state), .game_speed(game_speed));
// Clock generation block



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
$dumpvars(0, tb_clock);
reset = 1;
#10;
reset = 0;
#20;
reset = 1;
#10;


sendStream(Stream);

$finish;
end
// finish the simulation

endmodule