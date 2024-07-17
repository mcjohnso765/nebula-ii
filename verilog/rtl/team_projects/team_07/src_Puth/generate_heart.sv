
module t07_generate_heart (
 // This module intakes coordinates of the blocks containing the heart and outputs the pixel the heart is on
 input  logic       clk, nrst,
 input  logic [8:0] x, // not needded since SCo1 and SPo1 is hardcoded
 input  logic [7:0] y, // not needded since SCo1 and SPo1 is hardcoded
 input  logic [1:0] lives,
 output logic       heartPixel
);
 logic [7:0] spacing =  30;
 logic [8:0] SCo1    = 260;                    // first heart x coordinates         <--- module's input x
 logic [7:0] SPo1    = 200;                    // top    heart y coordinates        <--- module's input y
 logic [7:0] SPo2    = SPo1 -  spacing;        // second heart y coordinates
 logic [7:0] SPo3    = SPo1 - (spacing * 2);   // third  heart y coordinates


// assign heartPixel = 0;
// endmodule

 logic heartDetect; // 1 bit since boolean 0 or 1
 //logic [1:0] death;


 always_comb begin


  if ((
  // heart 1 permpixel
     ((x == SCo1 + 10) && (y == SPo1 +  0))                         // row 0
  || (((x >= SCo1 +  9) && (x <= SCo1 + 11)) &&   (y == SPo1 +  1)) // row 1
  || (((x >= SCo1 +  8) && (x <= SCo1 + 12)) &&   (y == SPo1 +  2)) // row 2
  || (((x >= SCo1 +  7) && (x <= SCo1 + 13)) &&   (y == SPo1 +  3)) // row 3
  || (((x >= SCo1 +  6) && (x <= SCo1 + 14)) &&   (y == SPo1 +  4)) // row 4
  || (((x >= SCo1 +  5) && (x <= SCo1 + 15)) &&   (y == SPo1 +  5)) // row 5
  || (((x >= SCo1 +  4) && (x <= SCo1 + 16)) &&   (y == SPo1 +  6)) // row 6
  || (((x >= SCo1 +  3) && (x <= SCo1 + 17)) &&   (y == SPo1 +  7)) // row 7
  || (((x >= SCo1 +  2) && (x <= SCo1 + 18)) &&   (y == SPo1 +  8)) // row 8
  || ((((x >= SCo1 +  3) && (x <= SCo1 +  8)) || ((x >= SCo1 + 12) && (x <= SCo1 +  17))) && (y == SPo1 + 19)) // row 19
  || ((((x >= SCo1 +  5) && (x <= SCo1 +  7)) || ((x >= SCo1 + 13) && (x <= SCo1 +  15))) && (y == SPo1 + 20)) // row 20
  // heart 2 permpixel
  || (((x == SCo1 + 10) && (y == SPo2 +  0))                        // row 0
  || (((x >= SCo1 +  9) && (x <= SCo1 + 11)) &&   (y == SPo2 +  1)) // row 1
  || (((x >= SCo1 +  8) && (x <= SCo1 + 12)) &&   (y == SPo2 +  2)) // row 2
  || (((x >= SCo1 +  7) && (x <= SCo1 + 13)) &&   (y == SPo2 +  3)) // row 3
  || (((x >= SCo1 +  6) && (x <= SCo1 + 14)) &&   (y == SPo2 +  4)) // row 4
  || (((x >= SCo1 +  5) && (x <= SCo1 + 15)) &&   (y == SPo2 +  5)) // row 5
  || (((x >= SCo1 +  4) && (x <= SCo1 + 16)) &&   (y == SPo2 +  6)) // row 6
  || (((x >= SCo1 +  3) && (x <= SCo1 + 17)) &&   (y == SPo2 +  7)) // row 7
  || (((x >= SCo1 +  2) && (x <= SCo1 + 18)) &&   (y == SPo2 +  8)) // row 8
  || ((((x >= SCo1 +  3) && (x <= SCo1 +  8)) || ((x >= SCo1 + 12) && (x <= SCo1 +  17))) && (y == SPo2 + 19)) // row 19
  || ((((x >= SCo1 +  5) && (x <= SCo1 +  7)) || ((x >= SCo1 + 13) && (x <= SCo1 +  15))) && (y == SPo2 + 20)))// row 20
  // heart 3 permpixel
  || (((x == SCo1 + 10) && (y == SPo3 +  0))                        // row 0
  || (((x >= SCo1 +  9) && (x <= SCo1 + 11)) &&   (y == SPo3 +  1)) // row 1
  || (((x >= SCo1 +  8) && (x <= SCo1 + 12)) &&   (y == SPo3 +  2)) // row 2
  || (((x >= SCo1 +  7) && (x <= SCo1 + 13)) &&   (y == SPo3 +  3)) // row 3
  || (((x >= SCo1 +  6) && (x <= SCo1 + 14)) &&   (y == SPo3 +  4)) // row 4
  || (((x >= SCo1 +  5) && (x <= SCo1 + 15)) &&   (y == SPo3 +  5)) // row 5
  || (((x >= SCo1 +  4) && (x <= SCo1 + 16)) &&   (y == SPo3 +  6)) // row 6
  || (((x >= SCo1 +  3) && (x <= SCo1 + 17)) &&   (y == SPo3 +  7)) // row 7
  || (((x >= SCo1 +  2) && (x <= SCo1 + 18)) &&   (y == SPo3 +  8)) // row 8
  || ((((x >= SCo1 +  3) && (x <= SCo1 +  8)) || ((x >= SCo1 + 12) && (x <= SCo1 +  17))) && (y == SPo3 + 19))   // row 19
  || ((((x >= SCo1 +  5) && (x <= SCo1 +  7)) || ((x >= SCo1 + 13) && (x <= SCo1 +  15))) && (y == SPo3 + 20)))) // row 20


  // all hearts uncracked
  || ((lives == 3)
     // heart 1 no crack
     && ((((x >= SCo1 +  1) && (x <= SCo1 + 19)) && (((y >= SPo1 +  9) && (y <= SPo1 + 10)) || ((y >= SPo1 + 16) && (y <= SPo1 + 17)))) // row 9, 10, 16, 17
     ||  (((x >= SCo1 +  0) && (x <= SCo1 + 20)) &&  ((y >= SPo1 + 11) && (y <= SPo1 + 15)))                                            // row 11, 12, 13, 14, 15
     || ((((x >= SCo1 +  2) && (x <= SCo1 +  9)) || ((x >= SCo1 + 11) && (x <= SCo1 +  18))) && (y == SPo1 + 18))                       // row 18
     // heart 2 no crack
     || (((x >= SCo1 +  1) && (x <= SCo1 + 19)) && (((y >= SPo2 +  9) && (y <= SPo2 + 10)) || ((y >= SPo2 + 16) && (y <= SPo2 + 17))))
     || (((x >= SCo1 +  0) && (x <= SCo1 + 20)) &&  ((y >= SPo2 + 11) && (y <= SPo2 + 15)))
     || ((((x >= SCo1 +  2) && (x <= SCo1 +  9)) || ((x >= SCo1 + 11) && (x <= SCo1 +  18))) && (y == SPo2 + 18))
     // heart 3 no crack
     || (((x >= SCo1 +  1) && (x <= SCo1 + 19)) && (((y >= SPo3 +  9) && (y <= SPo3 + 10)) || ((y >= SPo3 + 16) && (y <= SPo3 + 17))))
     || (((x >= SCo1 +  0) && (x <= SCo1 + 20)) &&  ((y >= SPo3 + 11) && (y <= SPo3 + 15)))
     || ((((x >= SCo1 +  2) && (x <= SCo1 +  9)) || ((x >= SCo1 + 11) && (x <= SCo1 +  18))) && (y == SPo3 + 18))))


 // bottom heart cracked
 || ((lives == 2)
    // heart 1 no crack
    && ((((x >= SCo1 +  1) && (x <= SCo1 + 19)) && (((y >= SPo1 +  9) && (y <= SPo1 + 10)) || ((y >= SPo1 + 16) && (y <= SPo1 + 17))))
    ||  (((x >= SCo1 +  0) && (x <= SCo1 + 20)) &&  ((y >= SPo1 + 11) && (y <= SPo1 + 15)))
    || ((((x >= SCo1 +  2) && (x <= SCo1 +  9)) || ((x >= SCo1 + 11) && (x <= SCo1 +  18))) && (y == SPo1 + 18))
    // heart 2 no crack
    || (((x >= SCo1 +  1) && (x <= SCo1 + 19)) && (((y >= SPo2 +  9) && (y <= SPo2 + 10)) || ((y >= SPo2 + 16) && (y <= SPo2 + 17))))
    || (((x >= SCo1 +  0) && (x <= SCo1 + 20)) &&  ((y >= SPo2 + 11) && (y <= SPo2 + 15)))
    || ((((x >= SCo1 +  2) && (x <= SCo1 +  9)) || ((x >= SCo1 + 11) && (x <= SCo1 +  18))) && (y == SPo2 + 18))
    // heart 3 crack
    || ((((x >= SCo1 +  1) && (x <= SCo1 + 10)) || ((x >= SCo1 + 12) && (x <= SCo1 +  19))) && (y == SPo3 +  9))   // row 9
    || ((((x >= SCo1 +  1) && (x <= SCo1 +  9)) || ((x >= SCo1 + 12) && (x <= SCo1 +  19))) && (y == SPo3 + 10))   // row 10
    || ((((x >= SCo1 +  0) && (x <= SCo1 +  9)) || ((x >= SCo1 + 11) && (x <= SCo1 +  20))) && (y == SPo3 + 11))   // row 11
    || ((((x >= SCo1 +  0) && (x <= SCo1 +  8)) || ((x >= SCo1 + 11) && (x <= SCo1 +  20))) && (y == SPo3 + 12))   // row 12
    || ((((x >= SCo1 +  0) && (x <= SCo1 +  7)) || ((x >= SCo1 + 10) && (x <= SCo1 +  20))) && (y == SPo3 + 13))   // row 13
    || ((((x >= SCo1 +  0) && (x <= SCo1 +  8)) || ((x >= SCo1 + 11) && (x <= SCo1 +  20))) && (y == SPo3 + 14))   // row 14
    || ((((x >= SCo1 +  0) && (x <= SCo1 +  9)) || ((x >= SCo1 + 12) && (x <= SCo1 +  20))) && (y == SPo3 + 15))   // row 15
    || ((((x >= SCo1 +  1) && (x <= SCo1 + 10)) || ((x >= SCo1 + 13) && (x <= SCo1 +  19))) && (y == SPo3 + 16))   // row 16
    || ((((x >= SCo1 +  1) && (x <= SCo1 +  9)) || ((x >= SCo1 + 12) && (x <= SCo1 +  19))) && (y == SPo3 + 17))   // row 17
    || ((((x >= SCo1 +  2) && (x <= SCo1 +  8)) || ((x >= SCo1 + 11) && (x <= SCo1 +  18))) && (y == SPo3 + 18)))) // row 18


 // middle heart also cracked
 || ((lives == 1)
    // heart 1 no crack
    && ((((x >= SCo1 +  1) && (x <= SCo1 + 19)) && (((y >= SPo1 +  9) && (y <= SPo1 + 10)) || ((y >= SPo1 + 16) && (y <= SPo1 + 17))))
    ||  (((x >= SCo1 +  0) && (x <= SCo1 + 20)) &&  ((y >= SPo1 + 11) && (y <= SPo1 + 15)))
    || ((((x >= SCo1 +  2) && (x <= SCo1 +  9)) || ((x >= SCo1 + 11) && (x <= SCo1 +  18))) && (y == SPo1 + 18))
    // heart 2 crack
    || ((((x >= SCo1 +  1) && (x <= SCo1 + 10)) || ((x >= SCo1 + 12) && (x <= SCo1 +  19))) && (y == SPo2 +  9))
    || ((((x >= SCo1 +  1) && (x <= SCo1 +  9)) || ((x >= SCo1 + 12) && (x <= SCo1 +  19))) && (y == SPo2 + 10))
    || ((((x >= SCo1 +  0) && (x <= SCo1 +  9)) || ((x >= SCo1 + 11) && (x <= SCo1 +  20))) && (y == SPo2 + 11))
    || ((((x >= SCo1 +  0) && (x <= SCo1 +  8)) || ((x >= SCo1 + 11) && (x <= SCo1 +  20))) && (y == SPo2 + 12))
    || ((((x >= SCo1 +  0) && (x <= SCo1 +  7)) || ((x >= SCo1 + 10) && (x <= SCo1 +  20))) && (y == SPo2 + 13))
    || ((((x >= SCo1 +  0) && (x <= SCo1 +  8)) || ((x >= SCo1 + 11) && (x <= SCo1 +  20))) && (y == SPo2 + 14))
    || ((((x >= SCo1 +  0) && (x <= SCo1 +  9)) || ((x >= SCo1 + 12) && (x <= SCo1 +  20))) && (y == SPo2 + 15))
    || ((((x >= SCo1 +  1) && (x <= SCo1 + 10)) || ((x >= SCo1 + 13) && (x <= SCo1 +  19))) && (y == SPo2 + 16))
    || ((((x >= SCo1 +  1) && (x <= SCo1 +  9)) || ((x >= SCo1 + 12) && (x <= SCo1 +  19))) && (y == SPo2 + 17))
    || ((((x >= SCo1 +  2) && (x <= SCo1 +  8)) || ((x >= SCo1 + 11) && (x <= SCo1 +  18))) && (y == SPo2 + 18))
    // heart 3 crack
    || ((((x >= SCo1 +  1) && (x <= SCo1 + 10)) || ((x >= SCo1 + 12) && (x <= SCo1 +  19))) && (y == SPo3 +  9))
    || ((((x >= SCo1 +  1) && (x <= SCo1 +  9)) || ((x >= SCo1 + 12) && (x <= SCo1 +  19))) && (y == SPo3 + 10))
    || ((((x >= SCo1 +  0) && (x <= SCo1 +  9)) || ((x >= SCo1 + 11) && (x <= SCo1 +  20))) && (y == SPo3 + 11))
    || ((((x >= SCo1 +  0) && (x <= SCo1 +  8)) || ((x >= SCo1 + 11) && (x <= SCo1 +  20))) && (y == SPo3 + 12))
    || ((((x >= SCo1 +  0) && (x <= SCo1 +  7)) || ((x >= SCo1 + 10) && (x <= SCo1 +  20))) && (y == SPo3 + 13))
    || ((((x >= SCo1 +  0) && (x <= SCo1 +  8)) || ((x >= SCo1 + 11) && (x <= SCo1 +  20))) && (y == SPo3 + 14))
    || ((((x >= SCo1 +  0) && (x <= SCo1 +  9)) || ((x >= SCo1 + 12) && (x <= SCo1 +  20))) && (y == SPo3 + 15))
    || ((((x >= SCo1 +  1) && (x <= SCo1 + 10)) || ((x >= SCo1 + 13) && (x <= SCo1 +  19))) && (y == SPo3 + 16))
    || ((((x >= SCo1 +  1) && (x <= SCo1 +  9)) || ((x >= SCo1 + 12) && (x <= SCo1 +  19))) && (y == SPo3 + 17))
    || ((((x >= SCo1 +  2) && (x <= SCo1 +  8)) || ((x >= SCo1 + 11) && (x <= SCo1 +  18))) && (y == SPo3 + 18))))


 // top heart also cracked
 || ((lives == 0)
    // heart 1 crack
    && (((((x >= SCo1 +  1) && (x <= SCo1 + 10)) || ((x >= SCo1 + 12) && (x <= SCo1 +  19))) && (y == SPo1 +  9))
    || ((((x >= SCo1 +  1) && (x <= SCo1 +  9)) || ((x >= SCo1 + 12) && (x <= SCo1 +  19))) && (y == SPo1 + 10))
    || ((((x >= SCo1 +  0) && (x <= SCo1 +  9)) || ((x >= SCo1 + 11) && (x <= SCo1 +  20))) && (y == SPo1 + 11))
    || ((((x >= SCo1 +  0) && (x <= SCo1 +  8)) || ((x >= SCo1 + 11) && (x <= SCo1 +  20))) && (y == SPo1 + 12))
    || ((((x >= SCo1 +  0) && (x <= SCo1 +  7)) || ((x >= SCo1 + 10) && (x <= SCo1 +  20))) && (y == SPo1 + 13))
    || ((((x >= SCo1 +  0) && (x <= SCo1 +  8)) || ((x >= SCo1 + 11) && (x <= SCo1 +  20))) && (y == SPo1 + 14))
    || ((((x >= SCo1 +  0) && (x <= SCo1 +  9)) || ((x >= SCo1 + 12) && (x <= SCo1 +  20))) && (y == SPo1 + 15))
    || ((((x >= SCo1 +  1) && (x <= SCo1 + 10)) || ((x >= SCo1 + 13) && (x <= SCo1 +  19))) && (y == SPo1 + 16))
    || ((((x >= SCo1 +  1) && (x <= SCo1 +  9)) || ((x >= SCo1 + 12) && (x <= SCo1 +  19))) && (y == SPo1 + 17))
    || ((((x >= SCo1 +  2) && (x <= SCo1 +  8)) || ((x >= SCo1 + 11) && (x <= SCo1 +  18))) && (y == SPo1 + 18))
    // heart 2 crack
    || ((((x >= SCo1 +  1) && (x <= SCo1 + 10)) || ((x >= SCo1 + 12) && (x <= SCo1 +  19))) && (y == SPo2 +  9))
    || ((((x >= SCo1 +  1) && (x <= SCo1 +  9)) || ((x >= SCo1 + 12) && (x <= SCo1 +  19))) && (y == SPo2 + 10))
    || ((((x >= SCo1 +  0) && (x <= SCo1 +  9)) || ((x >= SCo1 + 11) && (x <= SCo1 +  20))) && (y == SPo2 + 11))
    || ((((x >= SCo1 +  0) && (x <= SCo1 +  8)) || ((x >= SCo1 + 11) && (x <= SCo1 +  20))) && (y == SPo2 + 12))
    || ((((x >= SCo1 +  0) && (x <= SCo1 +  7)) || ((x >= SCo1 + 10) && (x <= SCo1 +  20))) && (y == SPo2 + 13))
    || ((((x >= SCo1 +  0) && (x <= SCo1 +  8)) || ((x >= SCo1 + 11) && (x <= SCo1 +  20))) && (y == SPo2 + 14))
    || ((((x >= SCo1 +  0) && (x <= SCo1 +  9)) || ((x >= SCo1 + 12) && (x <= SCo1 +  20))) && (y == SPo2 + 15))
    || ((((x >= SCo1 +  1) && (x <= SCo1 + 10)) || ((x >= SCo1 + 13) && (x <= SCo1 +  19))) && (y == SPo2 + 16))
    || ((((x >= SCo1 +  1) && (x <= SCo1 +  9)) || ((x >= SCo1 + 12) && (x <= SCo1 +  19))) && (y == SPo2 + 17))
    || ((((x >= SCo1 +  2) && (x <= SCo1 +  8)) || ((x >= SCo1 + 11) && (x <= SCo1 +  18))) && (y == SPo2 + 18))
    // heart 3 crack
    || ((((x >= SCo1 +  1) && (x <= SCo1 + 10)) || ((x >= SCo1 + 12) && (x <= SCo1 +  19))) && (y == SPo3 +  9))
    || ((((x >= SCo1 +  1) && (x <= SCo1 +  9)) || ((x >= SCo1 + 12) && (x <= SCo1 +  19))) && (y == SPo3 + 10))
    || ((((x >= SCo1 +  0) && (x <= SCo1 +  9)) || ((x >= SCo1 + 11) && (x <= SCo1 +  20))) && (y == SPo3 + 11))
    || ((((x >= SCo1 +  0) && (x <= SCo1 +  8)) || ((x >= SCo1 + 11) && (x <= SCo1 +  20))) && (y == SPo3 + 12))
    || ((((x >= SCo1 +  0) && (x <= SCo1 +  7)) || ((x >= SCo1 + 10) && (x <= SCo1 +  20))) && (y == SPo3 + 13))
    || ((((x >= SCo1 +  0) && (x <= SCo1 +  8)) || ((x >= SCo1 + 11) && (x <= SCo1 +  20))) && (y == SPo3 + 14))
    || ((((x >= SCo1 +  0) && (x <= SCo1 +  9)) || ((x >= SCo1 + 12) && (x <= SCo1 +  20))) && (y == SPo3 + 15))
    || ((((x >= SCo1 +  1) && (x <= SCo1 + 10)) || ((x >= SCo1 + 13) && (x <= SCo1 +  19))) && (y == SPo3 + 16))
    || ((((x >= SCo1 +  1) && (x <= SCo1 +  9)) || ((x >= SCo1 + 12) && (x <= SCo1 +  19))) && (y == SPo3 + 17))
    || ((((x >= SCo1 +  2) && (x <= SCo1 +  8)) || ((x >= SCo1 + 11) && (x <= SCo1 +  18))) && (y == SPo3 + 18))))


   ) begin
     heartDetect = 1;
   end else begin
     heartDetect = 0;
   end
 end


 always_ff @(negedge nrst, posedge clk) begin
   if(!nrst) begin
      heartPixel <= 1'd0;
   end else begin
      heartPixel <= heartDetect;
   end
 end
endmodule
