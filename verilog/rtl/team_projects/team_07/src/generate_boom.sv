module generate_boom (
 // This module intakes coordinates of the blocks containing the boom and outputs the pixel the boom is on
  input  logic       clk, nrst,
  input  logic [8:0] x,
  input  logic [7:0] y,
  output logic       boomPixel
);
  logic boomDetect; // 1 bit since boolean 0 or 1


  logic [15:0] [8:0] array_horX;
  logic [15:0] [7:0] array_horY;
  logic [15:0] [8:0] array_verX;
  logic [15:0] [7:0] array_verY;
  logic [8:0]        SCo;
  logic [7:0]        SPo;

  logic [8:0] startX = 82;
  logic [7:0] startY = 96;

  logic [8:0] topBx;
  logic [7:0] topBy;
  logic [8:0] midBx;
  logic [7:0] midBy;
  logic [8:0] botBx;
  logic [7:0] botBy;

  //                         toprigM  toplefM botrigO toprigO botlefO toplefO botB    topB
  assign array_horX [ 7:0] = {9'd004, 9'd027, 9'd060, 9'd060, 9'd093, 9'd093, 9'd126, 9'd126};
  assign array_horY [ 7:0] = {8'd042, 8'd042, 8'd000, 8'd042, 8'd000, 8'd042, 8'd000, 8'd042};
  //                         botrigM  toprigM botcenM topcenM botlefM toplefM botrigO toprigO botlefO toplefO botrigO toprigO botlefO toplefO botrigB toprigB
  assign array_verX [15:0] = {9'd000, 9'd000, 9'd023, 9'd023, 9'd046, 9'd046, 9'd056, 9'd056, 9'd079, 9'd079, 9'd089, 9'd089, 9'd112, 9'd112, 9'd122, 9'd122};
  assign array_verY [15:0] = {8'd003, 8'd024, 8'd003, 8'd024, 8'd003, 8'd024, 8'd003, 8'd024, 8'd003, 8'd024, 8'd003, 8'd024, 8'd003, 8'd024, 8'd003, 8'd024};

always_comb begin
  boomDetect = 0;

  for (integer i = 0; i <  8; i++) begin
    SCo = startX + array_horX[i];
    SPo = startY + array_horY[i];
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
        boomDetect = 1;
      end
  end


    for (integer j = 0; j < 16; j++) begin
      SCo = startX + array_verX[j];
      SPo = startY + array_verY[j];
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
          boomDetect = 1;
      end 
    end

  // top left B
  topBx = startX + 137;
  topBy = startY +  24;
  if
    ( 
      (
        ((x == topBx +  0) || (x == topBx +  4))
      &&((y >= topBy +  2) && (y <= topBy + 16))
      )
    ||(
        ((x == topBx +  1) || (x == topBx +  3))
      &&((y >= topBy +  1) && (y <= topBy + 16))
      )
    ||(
         (x == topBx +  2)
      &&((y >= topBy +  0) && (y <= topBy + 16))
      )
    ) begin
      boomDetect = 1;
  end

  // middle center B
  midBx = startX + 126;
  midBy = startY +  21;
  if
    ( 
      (
        ((x >= midBx +  2) && (x <= midBx +  9))
      &&((y == midBy +  0) || (y == midBy +  4))
      )
    ||(
        ((x >= midBx +  1) && (x <= midBx + 10))
      &&((y == midBy +  1) || (y == midBy +  3))
      )
    ||(
        ((x >= midBx +  0) && (x <= midBx + 11))
      && (y == midBy +  2)
      )
    ) begin
      boomDetect = 1;
  end

  // bottom left B
  botBx = startX + 137;
  botBy = startY +   6;
  if
    ( 
      (
        ((x == botBx +  0) || (x == botBx +  4))
      &&((y >= botBy +  0) && (y <= botBy + 14))
      )
    ||(
        ((x == botBx +  1) || (x == botBx +  3))
      &&((y >= botBy +  0) && (y <= botBy + 15))
      )
    ||(
         (x == botBx +  2)
      &&((y >= botBy +  0) && (y <= botBy + 16))
      )
    ) begin
      boomDetect = 1;
  end
end

  always_ff @(posedge clk) begin
    boomPixel <= boomDetect;
  end
endmodule