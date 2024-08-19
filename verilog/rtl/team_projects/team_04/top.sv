
module top(
  // I/O ports
  input  logic hz100, reset,
  input  logic [20:0] pb,
  output logic [7:0] left, right,
         ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0,
  output logic red, green, blue,

  // UART ports
  output logic [7:0] txdata,
  input  logic [7:0] rxdata,
  output logic txclk, rxclk,
  input  logic txready, rxready
);


t04_very_top topbottom(
    .clk(hz100), .nRst(~reset), .button(pb[0]),

    .Rx(pb[1]),
    
    .h_out(left[6]), 
    .v_out(left[5]), 
    .pixel_data(left[7])
);




endmodule
