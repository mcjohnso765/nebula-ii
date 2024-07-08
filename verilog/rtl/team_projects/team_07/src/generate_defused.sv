module generate_defused (
 // This module intakes coordinates of the blocks containing the defused and outputs the pixel the defused is on
  input  logic       clk, nrst,
  input  logic [8:0] x,
  input  logic [7:0] y,
  output logic       defusedPixel
);
  logic defusedDetect; // 1 bit since boolean 0 or 1


  logic [15:0] [8:0] array_horX;
  logic [15:0] [7:0] array_horY;
  logic [15:0] [8:0] array_verX;
  logic [15:0] [7:0] array_verY;
  logic [8:0]        SCo;
  logic [7:0]        SPo;

  logic [8:0] firBotDx;
  logic [8:0] firTopDx;
  logic [7:0] firBotDy;
  logic [7:0] firTopDy;
  logic [8:0] lasBotDx;
  logic [8:0] lasTopDx;
  logic [7:0] lasBotDy;
  logic [7:0] lasTopDy;

  //                         bottomD topD    bottomE middleE topE    bottomS middleS topS    bottomU middleF topF    bottomE middleE topE    bottomD topD
  assign array_horX [15:0] = {9'd004, 9'd004, 9'd033, 9'd033, 9'd033, 9'd066, 9'd066, 9'd066, 9'd101, 9'd128, 9'd128, 9'd157, 9'd157, 9'd157, 9'd190, 9'd190};
  assign array_horY [15:0] = {8'd042, 8'd000, 8'd000, 8'd021, 8'd042, 8'd000, 8'd021, 8'd042, 8'd000, 8'd021, 8'd042, 8'd000, 8'd021, 8'd042, 8'd000, 8'd042};
  //                         botRigD topRigD botLefE topLefE botRigS topLefS botRigU topRigU botLefu topLefU botLefF topLefF botLefE topLefE botRigD topRigD
  assign array_verX [15:0] = {9'd000, 9'd000, 9'd052, 9'd052, 9'd062, 9'd085, 9'd095, 9'd095, 9'd118, 9'd118, 9'd147, 9'd147, 9'd176, 9'd176, 9'd186, 9'd186};
  assign array_verY [15:0] = {8'd003, 8'd024, 8'd003, 8'd024, 8'd003, 8'd024, 8'd003, 8'd024, 8'd003, 8'd024, 8'd003, 8'd024, 8'd003, 8'd024, 8'd003, 8'd024};


always_comb begin
  defusedDetect = 0;

  for (integer i = 0; i < 16; i++) begin
    SCo = 55 + array_horX[i];
    SPo = 96 + array_horY[i];
    if
      ( 
        (
          ((y == SPo +  0) || (y == SPo +  4))
        &&((x >= SCo +  2) && (x <= SCo + 17))
        )
      ||(
          ((y == SPo +  1) || (y == SPo +  3))
        &&((x >= SCo +  1) && (x <= SCo + 18))
        )
      ||(
           (y == SPo +  2)
        &&((x >= SCo +  0) && (x <= SCo + 19))
        )
      ) begin
        defusedDetect = 1;
      end
  end


    for (integer j = 0; j < 16; j++) begin
      SCo = 55 + array_verX[j];
      SPo = 96 + array_verY[j];
      if
        ( 
          (
            ((x == SCo +  0) || (x == SCo +  4))
          &&((y >= SPo +  2) && (y <= SPo + 17))
          )
        ||(
            ((x == SCo +  1) || (x == SCo +  3))
          &&((y >= SPo +  1) && (y <= SPo + 18))
          )
        ||(
             (x == SCo +  2)
          &&((y >= SPo +  0) && (y <= SPo + 19))
         )
        ) begin
          defusedDetect = 1;
      end 
    end

  // first bottom D
  firBotDx = 55 + 200;
  firBotDy = 96 +   6;
  if
    ( 
      (
        ((x == firBotDx +  0) || (x == firBotDx +  4))
      &&((y >= firBotDy +  0) && (y <= firBotDy + 14))
      )
    ||(
        ((x == firBotDx +  1) || (x == firBotDx +  3))
      &&((y >= firBotDy +  0) && (y <= firBotDy + 15))
      )
    ||(
         (x == firBotDx +  2)
      &&((y >= firBotDy +  0) && (y <= firBotDy + 16))
      )
    ) begin
      defusedDetect = 1;
  end

  // last bottom D
  lasBotDx = 55 +  14;
  lasBotDy = 96 +   6;
  if
    ( 
      (
        ((x == lasBotDx +  0) || (x == lasBotDx +  4))
      &&((y >= lasBotDy +  0) && (y <= lasBotDy + 14))
      )
    ||(
        ((x == lasBotDx +  1) || (x == lasBotDx +  3))
      &&((y >= lasBotDy +  0) && (y <= lasBotDy + 15))
      )
    ||(
         (x == lasBotDx +  2)
      &&((y >= lasBotDy +  0) && (y <= lasBotDy + 16))
      )
    ) begin
      defusedDetect = 1;
  end

  // first top D
  firTopDx = 55 + 200;
  firTopDy = 96 +  24;
  if
    ( 
      (
        ((x == firTopDx +  0) || (x == firTopDx +  4))
      &&((y >= firTopDy +  2) && (y <= firTopDy + 16))
      )
    ||(
        ((x == firTopDx +  1) || (x == firTopDx +  3))
      &&((y >= firTopDy +  1) && (y <= firTopDy + 16))
      )
    ||(
         (x == firTopDx +  2)
      &&((y >= firTopDy +  0) && (y <= firTopDy + 16))
      )
    ) begin
      defusedDetect = 1;
  end

  // last top D
  lasTopDx = 55 +  14;
  lasTopDy = 96 +  24;
  if
    ( 
      (
        ((x == lasTopDx +  0) || (x == lasTopDx +  4))
      &&((y >= lasTopDy +  2) && (y <= lasTopDy + 16))
      )
    ||(
        ((x == lasTopDx +  1) || (x == lasTopDx +  3))
      &&((y >= lasTopDy +  1) && (y <= lasTopDy + 16))
      )
    ||(
         (x == lasTopDx +  2)
      &&((y >= lasTopDy +  0) && (y <= lasTopDy + 16))
      )
    ) begin
      defusedDetect = 1;
  end
end

  always_ff @(posedge clk) begin
    defusedPixel <= defusedDetect;
  end
endmodule