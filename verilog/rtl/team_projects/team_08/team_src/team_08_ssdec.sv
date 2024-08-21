module team_08_ssdec (
    input logic [3:0] in,
    input logic enable,
    output logic [6:0] out
);
    assign out = {enable, in} == 5'b10000 ? 7'b0111111: //0
    {enable, in} == 5'b10001 ? 7'b0000110: //1
    {enable, in} == 5'b10010 ? 7'b1011011: //2
    {enable, in} == 5'b10011 ? 7'b1001111: //3
    {enable, in} == 5'b10100 ? 7'b1100110: //4
    {enable, in} == 5'b10101 ? 7'b1101101: //5
    {enable, in} == 5'b10110 ? 7'b1111101: //6
    {enable, in} == 5'b10111 ? 7'b0000111: //7
    {enable, in} == 5'b11000 ? 7'b1111111: //8
    {enable, in} == 5'b11001 ? 7'b1100111: //9
    {enable, in} == 5'b11010 ? 7'b1110111: //A
    {enable, in} == 5'b11011 ? 7'b1111100: //B
    {enable, in} == 5'b11100 ? 7'b0111001: //C
    {enable, in} == 5'b11101 ? 7'b1011110: //D
    {enable, in} == 5'b11110 ? 7'b1111001: //E
    {enable, in} == 5'b11111 ? 7'b1110001: //F    
    7'b0000000;
endmodule