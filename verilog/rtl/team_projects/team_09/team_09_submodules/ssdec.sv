module ssdec (
  input logic [3:0] in,
  input logic enable, 
  output logic [6:0] out
);
logic [6:0] code;
always_comb begin
  case({in})
    {4'd0}: begin {code} = 7'b0111111; end
    {4'd1}: begin {code} = 7'b0000110; end
    {4'd2}: begin {code} = 7'b1011011; end
    {4'd3}: begin {code} = 7'b1001111; end
    {4'd4}: begin {code} = 7'b1100110; end
    {4'd5}: begin {code} = 7'b1101101; end
    {4'd6}: begin {code} = 7'b1111101; end
    {4'd7}: begin {code} = 7'b0000111; end
    {4'd8}: begin {code} = 7'b1111111; end
    {4'd9}: begin {code} = 7'b1100111; end
    {4'd10}: begin {code} = 7'b1110111; end
    {4'd11}: begin {code} = 7'b1111100; end
    {4'd12}: begin {code} = 7'b0111001; end
    {4'd13}: begin {code} = 7'b1011110; end
    {4'd14}: begin {code} = 7'b1111001; end
    {4'd15}: begin {code} = 7'b1110001; end
  endcase
end
  assign out = code & {7{enable}}; //hello world
endmodule