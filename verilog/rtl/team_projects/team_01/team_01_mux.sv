module t01_mux (
    input logic [31:0]in1, in2, 
    input logic select,
    output logic [31:0]out
);
    // Write your code here!
    assign out = select ? in2 : in1;

endmodule

