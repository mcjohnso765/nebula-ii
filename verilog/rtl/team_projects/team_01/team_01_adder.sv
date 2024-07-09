/*
    Module Name: adder
    Description: add.
    author: Johnny
*/


module adder (
    input logic[31:0] in1, in2,
    output logic [31:0] sum
);
    // Write your code here!
    assign sum = in1 + $signed(in2);
endmodule