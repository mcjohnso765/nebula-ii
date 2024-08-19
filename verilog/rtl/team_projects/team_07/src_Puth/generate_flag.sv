module t07_generate_flag (
  // This module intakes coordinates of the blocks containing the flag and outputs the pixel the flag is on
  input  logic       clk, nrst,
  input  logic [8:0] x,
  input  logic [7:0] y,
  input logic [2:0] flag_x, flag_y,
  output logic       flagPixel
);

  // borders are still not implemented, when it is, there will be a 12 pixel shift

  // internal variables

    // must be given randomly by RNG of game logic
    // for now, for testbench purposes, flag is in (5,5)
  `define JUMP 36
  `define CUBE_FOR_FLAG 18
  logic [8:0] SCo = `CUBE_FOR_FLAG + `JUMP * flag_x; // beginning x
  logic [7:0] SPo = `CUBE_FOR_FLAG + `JUMP * flag_y; // beginning y
  logic flagDetect; // 1 bit since boolean 0 or 1

    // clk is needed for each of the coordinates to specify the range update is cycling through

    always_comb begin

      flagDetect = flagPixel;

      if (((x == SCo + 11)   // first  x       for pole
        &&((y >= SPo +  7)   // first  y start for pole
        && (y <= SPo + 28))) // first  y end   for pole
        ||(((x >= SCo + 12)  // second x start for flag
        && (x <= SCo + 13))  // second x end   for flag
        &&((y >= SPo + 19)   // second y start for flag
        && (y <= SPo + 28))) // second y end   for flag
        ||(((x >= SCo + 14)  // third  x start
        && (x <= SCo + 16))  // third  x end
        &&((y >= SPo + 20)   // third  y start
        && (y <= SPo + 27))) // third  y end
        ||(((x >= SCo + 17)  // fourth x start
        && (x <= SCo + 19))  // fourth x end
        &&((y >= SPo + 21)   // fourth y start
        && (y <= SPo + 26))) // fourth y end
        ||(((x >= SCo + 20)  // fifth  x start
        && (x <= SCo + 22))  // fifth  x end
        &&((y >= SPo + 22)   // fifth  y start
        && (y <= SPo + 25))) // fifth  y end
        ||(((x >= SCo + 23)  // sixth  x start
        && (x <= SCo + 25))  // sixth  x end
        &&((y >= SPo + 23)   // sixth  y start
        && (y <= SPo + 24))) // sixth  y end
      ) begin 
        flagDetect = 1;
      end else begin
        flagDetect = 0;
      end
    end

  // assign output
  always_ff @(negedge nrst, posedge clk) begin
    if(!nrst) begin
      flagPixel <= 0;
    end else begin
      flagPixel <= flagDetect;
    end
  end

endmodule