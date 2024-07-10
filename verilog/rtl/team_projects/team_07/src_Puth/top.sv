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

  // logic dummy_1, dummy_2, dummy_3, dummy_4, dummy_5, dummy_6;
  // Instantiate top module
  bomb_game DUT_bomb_game (
    .clk(hwclk),
    .nrst(~pb[19]),
    .button({pb[6], pb[0], pb[4], pb[1], pb[5], pb[18]}),
    // .game_state_top(),
    // .playing_state_top(),
    // .game_state_top({dummy_1, dummy_2, dummy_3}),
    // .playing_state_top({dummy_4, dummy_5, dummy_6}),
    // .game_state_top({ss0[7], ss0[1], right[1]}),
    // .playing_state_top({ss1[2], ss1[0], ss1[6]}),
    // .lives_out({ss0[7], ss0[1]}),
    // .error_out(right[1]),
    // .ssdec_ss(right[5]),
    // .ssdec_sdi(right[3]),
    // .ssdec_sck(right[1]),
    .ssdec_ss(ss1[5]),
    .ssdec_sdi(ss1[3]),
    .ssdec_sck(ss2[7]),
    .tft_sck(right[0]),
    .tft_sdi(ss0[2]),
    .tft_dc(ss0[0]),
    .tft_rst(ss0[6]),
    .tft_cs(ss0[4]),
    .tft_state(),
    .audio(ss1[1]),
    .simon_light_up_top({left[7], ss7[4], ss7[6], left[6]}) //c16 left[7],d16 ss7[4], e16 ss7[6],d15 left[6]
  );
// always_ff @( posedge clk ) begin
//     if(!nrst) begin 
//         r_floor <= '0;
//         r_cactus <='0;
//         r_dino <= '0;
//     end
//     else begin 
//         r_floor <= floor;
//         r_cactus <= cactus;
//         r_dino <= dino;
//     end
// end

endmodule