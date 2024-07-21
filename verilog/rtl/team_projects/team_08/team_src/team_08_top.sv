`default_nettype none

module top 
(
  // I/O ports
  input  logic hwclk, reset,
  input  logic [20:0] pb,
  output logic [7:0] left, right,
         ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0,
  output logic red, green, blue

  // UART ports
  // output logic [7:0] txdata,
  // input  logic [7:0] rxdata,
  // output logic txclk, rxclk,
  // input  logic txready, rxready
);

  // Simple Tests
  // assign right[1] = pb[0];
  // assign left[7] = pb[1];
  // assign left[7] = hwclk;

  // PLL Tests
  // pll mypll (.in_clk(hwclk), .lcd_clk(right[0]), .locked());
  // assign left[7] = hwclk;
 // assign left[7] = pb[1];
  // Instantiate top module

logic [5:0] empty;
logic [33:0] in, out;

team_08_GPIOPins game(
  .clk(hwclk), .reset(reset), .in(in), .out(out));

always_comb begin
  
    in = {31'd0, pb[17], pb[18], ~pb[19]};
    {empty[5:3], right[5], ss1[6:0], ss0[6:0], left[7:0], right[4:0], empty[2:0]} = out;
  
end

endmodule

