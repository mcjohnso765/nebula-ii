/*
    Module Name: program_counter
    Description: keeps track of where we are in the program, adding 4 bits every normal cycle and accounting for jumps and branches. Contains an enable flag, coming from the request unit, to make sure the instruction has been fetched before updating.
    Author: Johnny, Andrew
*/

module program_counter (
    input logic clk, nRst,
    input logic [31:0] next_pc,
    output logic [31:0] pc
);
    // Write your code here!
    always_ff @(posedge clk, negedge nRst) begin
        if(~nRst)
            pc <= 32'b0;
        else begin
            pc <= next_pc;
        end
    end
endmodule