
module Tx_clock_divider 
(
input logic clk,nrst,

output logic new_clk

);

parameter OG_CLK = 240000; /// 2.4 GHz signal ie 2400000000
parameter BAUD_RATE = 9600; // a higher baud rate means a higher rate of transmission, it's essentially a unit of measurement that represents the number of signal changes
parameter DIV_FACTOR = 1250; // so input signal divided by the rate of transmission 

parameter N = 32;

logic next_clk;
logic [N-1:0] count;
logic [N-1:0]next_count;

always_ff @(posedge clk, negedge nrst) begin
    if(!nrst) begin
        count <= 0;
        new_clk <= 1'b0; // it's one not 0 because when it resets the clk starts on the posedge of the clk we're not starting on negedge of clock
    end
     else begin
        count <= next_count; 
        new_clk <= next_clk;
     end
end

always_comb begin
    next_clk = 1'b0;
    next_count = count + 1; 

    if(count == DIV_FACTOR) begin   
        next_count = 0; 
        next_clk = 1'b1; 
    end 
end

endmodule