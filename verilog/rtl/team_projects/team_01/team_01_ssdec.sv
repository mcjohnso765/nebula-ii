module ssdec (
  input logic enable, 
  input logic [3:0]in,
  output logic [6:0]out
);

  always_comb begin
    case({enable, in})
      5'b10000: out = 7'b0111111;
      5'b10001: out = 7'b0000110;
      5'b10010: out = 7'b1011011;
      5'b10011: out = 7'b1001111;
      5'b10100: out = 7'b1100110;
      5'b10101: out = 7'b1101101;
      5'b10110: out = 7'b1111101;
      5'b10111: out = 7'b0000111;
      5'b11000: out = 7'b1111111;
      5'b11001: out = 7'b1100111;
      5'b11010: out = 7'b1110111;
      5'b11011: out = 7'b1111100;
      5'b11100: out = 7'b0111001;
      5'b11101: out = 7'b1011110;
      5'b11110: out = 7'b1111001;
      5'b11111: out = 7'b1110001;
      default: out = 7'b0000000;
    endcase
  end
endmodule