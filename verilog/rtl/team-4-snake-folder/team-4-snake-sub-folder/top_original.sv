// FPGA Top Level

`default_nettype none

module top_original (
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
  logic [6:0] curr_length;
  logic [49:0][7:0] body;
  logic sync, sync_i;

  synchronizer synch(.button(pb[0]), .clk(hz100), .nrst(~reset), .signal(sync_i));
  edge_detect detect(.signal(sync_i), .clk(hz100), .nrst(~reset), .change_state(sync));
  curr_length_increment increase(.button(pb[0]), .clk(hz100), .nrst(~reset), .sync(sync), .curr_length(curr_length));

  snake_body_controller control(.direction_pb({pb[10], pb[2], pb[7], pb[5]}), .x(pb[19:16]), .y(pb[15:12]), .clk(hz100), .pb_mode(pb[6]), .nrst(~reset), .sync(sync), .curr_length(curr_length), .body(body), .snakeHead(left[0]), .snakeBody(left[1]));
  ssdec s7(.in(body[0][7:4]), .enable(1'b1), .out(ss7[6:0]));
  ssdec s6(.in(body[0][3:0]), .enable(1'b1), .out(ss6[6:0]));
  ssdec s4(.in(body[curr_length][7:4]), .enable(1'b1), .out(ss4[6:0]));
  ssdec s3(.in(body[curr_length][3:0]), .enable(1'b1), .out(ss3[6:0]));
  ssdec s1(.in({1'b0, curr_length[6:4]}), .enable(1'b1), .out(ss1[6:0]));
  ssdec s0(.in(curr_length[3:0]), .enable(1'b1), .out(ss0[6:0]));

  


endmodule
