`default_nettype none

module top 
(
  // I/O ports
  input  logic hwclk, reset,
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

  // Simple Tests
  // assign right[1] = pb[0];
  // assign left[7] = pb[1];
  // assign left[7] = hwclk;

  // PLL Tests
  // pll mypll (.in_clk(hwclk), .lcd_clk(right[0]), .locked());
  // assign left[7] = hwclk;

  t07_bomb_game DUT_bomb_game (
    .clk(hwclk),
    .nrst(~pb[19]),
    .button({pb[6], pb[0], pb[4], pb[1], pb[5], pb[18]}),
    .ssdec_ss(ss1[5]),
    .ssdec_sdi(ss1[3]),
    .ssdec_sck(ss2[7]),
    .tft_sck(right[0]),
    .tft_sdi(ss0[2]),
    .tft_dc(ss0[0]),
    .tft_rst(ss0[6]),
    .tft_cs(ss0[4]),
    .tft_state(),
    .audio(ss1[1])
  );


endmodule