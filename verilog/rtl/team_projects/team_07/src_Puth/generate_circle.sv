module t07_generate_circle (
    // This module intakes coordinates of the blocks containing the circle and outputs the pixel the circle is on
    input  logic       clk, nrst,
    input  logic [8:0] x,           // not needded since SCo and SPo is hardcoded
    input  logic [7:0] y,           // not needded since SCo and SPo is hardcoded
    input logic [2:0] map_select,   // to show which map we are working with

    output logic       circlePixel
);

  // note: according to Puth, the first map will have the circle on block (1,2) and (4,4)
  //       keep in mind that the block coordinates ranges from 0 to 5.

  // borders are still not implemented, when it is, there will be a 12 pixel shift

  // internal variables

  `define JUMP_CIRCLE 36
  `define CUBE_CIRCLE 12
  
    ////x 5, y 4
  logic [2:0] circle_x[1:0];
  logic [2:0]circle_y [1:0];  // first dim: 2 bit, 0 - for the 1st circle, 1 - for the 2nd circle 
  logic circleDetect; // 1 bit since boolean 0 or 1
  logic [8:0] SCo;
  logic [7:0] SPo;
//   assign circlePixel = 0;
// endmodule

  always_comb begin
    case(map_select)
      0: begin 
        circle_x[0] = 0;
        circle_y[0] = 3;
        circle_x[1] = 5;
        circle_y[1] = 4; 
      end
      1: begin 
        circle_x[0] = 1;
        circle_y[0] = 4;
        circle_x[1] = 4;
        circle_y[1] = 2; 
      end
      2: begin
        circle_x[0] = 0;
        circle_y[0] = 2;
        circle_x[1] = 2;
        circle_y[1] = 2; 
      end
      3:begin 
        circle_x[0] = 5;
        circle_y[0] = 5;
        circle_x[1] = 5;
        circle_y[1] = 2; 
      end
      4:begin 
        circle_x[0] = 1;
        circle_y[0] = 3;
        circle_x[1] = 2;
        circle_y[1] = 0; 
      end
      default: begin
        circle_x[0] = '0;
        circle_y[0] = '0;
        circle_x[1] = '0;
        circle_y[1] = '0;
      end
    endcase
    // clk is needed for each of the coordinates to specify the range update is cycling through
    // circleDetect = circlePixel;
    circleDetect = 0;
    for (integer i = 0; i < 2; i++) begin 
      SCo = `CUBE_CIRCLE + `JUMP_CIRCLE* circle_x[i]; // beginning x ///0
      SPo = `CUBE_CIRCLE + `JUMP_CIRCLE* circle_y[i]; // beginning y ///3

    // if(x > 20 && y< 40)begin 
    // circleDetect = 1;
    // end else begin 
    //   circleDetect = 0;
    // end
      // circleDetect = circlePixel;
      if (((x >= SCo + 14 && x <= SCo + 21)   // first   x
        && (y == SPo +  3 || y == SPo + 32))  // first   y
        ||(((x >= SCo + 11 && x <= SCo + 13)   // second  x
        || (x >= SCo + 22 && x <= SCo + 24))  // second  x
        && (y == SPo +  4 || y == SPo + 31))  // second  y
        ||(((x >= SCo +  9 && x <= SCo + 10)   // third   x
        || (x >= SCo + 25 && x <= SCo + 26))  // third   x
        && (y == SPo +  5 || y == SPo + 30))  // third   y
        ||(((x == SCo +  8 || x == SCo + 27)   // fourth  x
        && (y == SPo +  6 || y == SPo + 29))) // fourth  y
        ||(((x == SCo +  7 || x == SCo + 28)   // fifth   x
        && (y == SPo +  7 || y == SPo + 28))) // fifth   y
        ||(((x == SCo +  6 || x == SCo + 29)   // sixth   x
        && (y == SPo +  8 || y == SPo + 27))) // sixth   y
        ||(  (x == SCo +  5 || x == SCo + 30)   // seventh x  <---
          &&((y >= SPo +  9 && y <= SPo + 10)   // seventh y
          || (y >= SPo + 25 && y <= SPo + 26))) // seventh y
        ||( (x == SCo +  4 || x == SCo + 31)   // eighth  x
          &&((y >= SPo + 11 && y <= SPo + 13)   // eighth  y
          || (y >= SPo + 22 && y <= SPo + 24))) // eighth  y   <---
        ||( (x == SCo +  3 || x == SCo + 32)   // ninth   x
        && (y >= SPo + 14 && y <= SPo + 21) ) // ninth   y
      ) begin
        circleDetect = 1;
      end 
      // else begin
      //   circleDetect = 0;
      // end 
    end 
  end
  // assign output

  always_ff @(negedge nrst, posedge clk) begin
    if(!nrst) begin
      circlePixel <= 1'd0;
    end else begin
      circlePixel <= circleDetect;
    end
  end

endmodule
