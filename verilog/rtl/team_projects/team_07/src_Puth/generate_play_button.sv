module t07_generate_play_button (
  // This module intakes coordinates of the blocks containing the playButton and outputs the pixel the playButton is on
  input logic nrst,
  input logic clk,
  input logic [8:0] x, // not needded since SCo1 and SPo1 is hardcoded
  input logic [7:0] y, // not needded since SCo1 and SPo1 is hardcoded
  output logic playButtonPixel
);
  logic [8:0] SCo = 125; // <--- module's input x
  logic [7:0] SPo =  90; // <--- module's input y

  // screen                     = 320 x 240
  // total pixel area of sprite =  70 x  60
  // half screen                = 160 x 120
  // starting point for sprite  = 125,   90


  // assign playButtonPixel = 0;
  // endmodule

  logic playButtonDetect; // 1 bit since boolean 0 or 1

  always_comb begin
   if (
    // sprite for text "play"
        ((y == SPo +  0)
    && (((x >= SCo +  9) && (x <= SCo + 12)) ||  (x == SCo + 53))
    )|| ((y == SPo +  1)
    && (((x >= SCo +  8) && (x <= SCo + 13)) ||  (x == SCo + 53))
    )|| ((y == SPo +  2)
    && (((x >= SCo +  7) && (x <= SCo +  9)) || ((x >= SCo + 12) && (x <= SCo + 14)) || ((x >= SCo + 53) && (x <= SCo + 54)))
    )|| ((y == SPo +  3)
    && (((x >= SCo +  6) && (x <= SCo +  8)) || ((x >= SCo + 13) && (x <= SCo + 15)) || ((x >= SCo + 53) && (x <= SCo + 54)))
    )|| ((y == SPo +  4)
    && (((x >= SCo +  6) && (x <= SCo +  7)) || ((x >= SCo + 14) && (x <= SCo + 15)) || ((x >= SCo + 53) && (x <= SCo + 54)))
    )||(((y == SPo +  5) || (y == SPo +  6))
    && (((x >= SCo +  6) && (x <= SCo +  7)) ||  (x == SCo + 15)                     || ((x >= SCo + 53) && (x <= SCo + 54)))
    )||(((y >= SPo +  7) && (y <= SPo +  9))
    && (((x >= SCo +  6) && (x <= SCo +  7)) || ((x >= SCo + 53) && (x <= SCo + 54)))
    )|| ((y == SPo + 10)
    && (((x >= SCo +  6) && (x <= SCo +  7)) || ((x >= SCo +  9) && (x <= SCo + 12)) || ((x >= SCo + 53) && (x <= SCo + 54)))
    )|| ((y == SPo + 11)
    && (((x >= SCo +  6) && (x <= SCo + 13)) || ((x >= SCo + 21) && (x <= SCo + 22)) || ((x >= SCo + 24) && (x <= SCo + 28)) || ((x >= SCo + 36) && (x <= SCo + 38)) || ((x >= SCo + 48) && (x <= SCo + 54)))
    )|| ((y == SPo + 12)
    && (((x >= SCo +  6) && (x <= SCo +  9)) || ((x >= SCo + 12) && (x <= SCo + 14)) || ((x >= SCo + 22) && (x <= SCo + 29)) || ((x >= SCo + 37) && (x <= SCo + 39)) || ((x >= SCo + 47) && (x <= SCo + 54)))
    )|| ((y == SPo + 13)
    && (((x >= SCo +  6) && (x <= SCo +  8)) || ((x >= SCo + 13) && (x <= SCo + 15)) || ((x >= SCo + 22) && (x <= SCo + 25)) || ((x >= SCo + 28) && (x <= SCo + 30)) || ((x >= SCo + 38) && (x <= SCo + 39) || ((x >= SCo + 46) && (x <= SCo + 48)) || ((x >= SCo + 52) && (x <= SCo + 54))))
    )|| ((y == SPo + 14)
    && (((x >= SCo +  6) && (x <= SCo +  7)) || ((x >= SCo + 14) && (x <= SCo + 15)) || ((x >= SCo + 22) && (x <= SCo + 23)) || ((x >= SCo + 29) && (x <= SCo + 30)) || ((x >= SCo + 38) && (x <= SCo + 39) || ((x >= SCo + 45) && (x <= SCo + 47)) || ((x >= SCo + 53) && (x <= SCo + 54))))
    )|| ((y == SPo + 15)
    && (((x >= SCo +  6) && (x <= SCo +  7)) || ((x >= SCo + 14) && (x <= SCo + 15)) || ((x >= SCo + 22) && (x <= SCo + 23)) || ((x >= SCo + 28) && (x <= SCo + 30)) || ((x >= SCo + 38) && (x <= SCo + 39) || ((x >= SCo + 45) && (x <= SCo + 46)) || ((x >= SCo + 53) && (x <= SCo + 54))))
    )|| ((y == SPo + 16)
    && (((x >= SCo +  6) && (x <= SCo +  7)) || ((x >= SCo + 14) && (x <= SCo + 15)) || ((x >= SCo + 22) && (x <= SCo + 24)) || ((x >= SCo + 27) && (x <= SCo + 29)) || ((x >= SCo + 38) && (x <= SCo + 39) || ((x >= SCo + 45) && (x <= SCo + 46)) || ((x >= SCo + 53) && (x <= SCo + 54))))
    )|| ((y == SPo + 17)
    && (((x >= SCo +  6) && (x <= SCo +  7)) || ((x >= SCo + 14) && (x <= SCo + 15)) || ((x >= SCo + 22) && (x <= SCo + 28)) ||                                         ((x >= SCo + 38) && (x <= SCo + 39) || ((x >= SCo + 45) && (x <= SCo + 46)) || ((x >= SCo + 53) && (x <= SCo + 54))))
    )|| ((y == SPo + 18)
    && (((x >= SCo +  6) && (x <= SCo +  7)) || ((x >= SCo + 14) && (x <= SCo + 15)) || ((x >= SCo + 22) && (x <= SCo + 23)) || ((x >= SCo + 25) && (x <= SCo + 27)) || ((x >= SCo + 38) && (x <= SCo + 39) || ((x >= SCo + 45) && (x <= SCo + 46)) || ((x >= SCo + 53) && (x <= SCo + 54))))
    )|| ((y == SPo + 19)
    && (((x >= SCo +  6) && (x <= SCo +  7)) || ((x >= SCo + 14) && (x <= SCo + 15)) || ((x >= SCo + 22) && (x <= SCo + 23)) ||  (x == SCo + 30)                     || ((x >= SCo + 38) && (x <= SCo + 39) || ((x >= SCo + 45) && (x <= SCo + 47)) || ((x >= SCo + 53) && (x <= SCo + 54))))
    )|| ((y == SPo + 20)
    && (((x >= SCo +  6) && (x <= SCo +  7)) || ((x >= SCo + 14) && (x <= SCo + 15)) || ((x >= SCo + 22) && (x <= SCo + 24)) || ((x >= SCo + 29) && (x <= SCo + 30)) || ((x >= SCo + 38) && (x <= SCo + 39) || ((x >= SCo + 46) && (x <= SCo + 48)) || ((x >= SCo + 52) && (x <= SCo + 54))))
    )|| ((y == SPo + 21)
    &&  ((x == SCo +  7)                      || (x == SCo + 14)                     || ((x >= SCo + 23) && (x <= SCo + 29))                                         || ((x >= SCo + 38) && (x <= SCo + 39) || ((x >= SCo + 47) && (x <= SCo + 53))))
    )|| ((y == SPo + 22)
    &&  ((x == SCo +  7)                      || (x == SCo + 14)                     || ((x >= SCo + 25) && (x <= SCo + 28))                                         || ((x >= SCo + 38) && (x <= SCo + 39) || ((x >= SCo + 48) && (x <= SCo + 52))))
    )||(((y >= SPo + 23) && (y <= SPo + 27))
    &&  ((x >= SCo + 38) && (x <= SCo + 39))
    )||(((y >= SPo + 28) && (y <= SPo + 29))
    &&   (x == SCo + 38)
    )
    // sprite for image "play button"
    ||  ((y == SPo + 35)
    &&  ((x >= SCo + 18) && (x <= SCo + 42))
    )|| ((y == SPo + 36)
    &&  ((x >= SCo + 11) && (x <= SCo + 50))
    )|| ((y == SPo + 37)
    &&  ((x >= SCo +  6) && (x <= SCo + 54))
    )|| ((y == SPo + 38)
    &&  ((x >= SCo +  3) && (x <= SCo + 57))
    )|| ((y == SPo + 39)
    &&  ((x >= SCo +  2) && (x <= SCo + 58))
    )||(((y >= SPo + 40) && (y <= SPo + 42))
    &&  ((x >= SCo +  1) && (x <= SCo + 59))
    )||( (y == SPo + 43)
    && (((x >= SCo +  0) && (x <= SCo + 33)) || ((x >= SCo + 38) && (x <= SCo + 60)))
    )||( (y == SPo + 44)
    && (((x >= SCo +  0) && (x <= SCo + 31)) || ((x >= SCo + 39) && (x <= SCo + 60)))
    )||( (y == SPo + 45)
    && (((x >= SCo +  0) && (x <= SCo + 29)) || ((x >= SCo + 39) && (x <= SCo + 60)))
    )||( (y == SPo + 46)
    && (((x >= SCo +  0) && (x <= SCo + 27)) || ((x >= SCo + 39) && (x <= SCo + 60)))
    )||( (y == SPo + 47)
    && (((x >= SCo +  0) && (x <= SCo + 25)) || ((x >= SCo + 39) && (x <= SCo + 60)))
    )||( (y == SPo + 48)
    && (((x >= SCo +  0) && (x <= SCo + 23)) || ((x >= SCo + 39) && (x <= SCo + 60)))
    )||( (y == SPo + 49)
    && (((x >= SCo +  0) && (x <= SCo + 21)) || ((x >= SCo + 39) && (x <= SCo + 60)))
    )||( (y == SPo + 50)
    && (((x >= SCo +  0) && (x <= SCo + 20)) || ((x >= SCo + 39) && (x <= SCo + 60)))
    )||(((y >= SPo + 51) && (y <= SPo + 53))
    && (((x >= SCo +  0) && (x <= SCo + 19)) || ((x >= SCo + 39) && (x <= SCo + 60)))
    )||( (y == SPo + 54)
    && (((x >= SCo +  0) && (x <= SCo + 20)) || ((x >= SCo + 39) && (x <= SCo + 60)))
    )||( (y == SPo + 55)
    && (((x >= SCo +  0) && (x <= SCo + 21)) || ((x >= SCo + 39) && (x <= SCo + 60)))
    )||( (y == SPo + 56)
    && (((x >= SCo +  0) && (x <= SCo + 23)) || ((x >= SCo + 39) && (x <= SCo + 60)))
    )||( (y == SPo + 57)
    && (((x >= SCo +  0) && (x <= SCo + 25)) || ((x >= SCo + 39) && (x <= SCo + 60)))
    )||( (y == SPo + 58)
    && (((x >= SCo +  0) && (x <= SCo + 27)) || ((x >= SCo + 39) && (x <= SCo + 60)))
    )||( (y == SPo + 59)
    && (((x >= SCo +  0) && (x <= SCo + 29)) || ((x >= SCo + 39) && (x <= SCo + 60)))
    )||( (y == SPo + 60)
    && (((x >= SCo +  0) && (x <= SCo + 31)) || ((x >= SCo + 39) && (x <= SCo + 60)))
    )||( (y == SPo + 61)
    && (((x >= SCo +  0) && (x <= SCo + 33)) || ((x >= SCo + 38) && (x <= SCo + 60)))
    )||(((y >= SPo + 62) && (y <= SPo + 64))
    &&  ((x >= SCo +  1) && (x <= SCo + 59))
    )|| ((y == SPo + 65)
    &&  ((x >= SCo +  2) && (x <= SCo + 58))
    )|| ((y == SPo + 66)
    &&  ((x >= SCo +  3) && (x <= SCo + 57))
    )|| ((y == SPo + 67)
    &&  ((x >= SCo +  6) && (x <= SCo + 54))
    )|| ((y == SPo + 68)
    &&  ((x >= SCo + 11) && (x <= SCo + 50))
    ||  ((y == SPo + 69)
    &&  ((x >= SCo + 18) && (x <= SCo + 42)))
    )
    ) begin
      playButtonDetect =  1;
    end else begin
      playButtonDetect = 0;
    end
  end

  always_ff @(negedge nrst, posedge clk) begin
    if(!nrst) begin
      playButtonPixel <= 1'd0;
    end else begin
      playButtonPixel <= playButtonDetect;
    end
  end
endmodule
