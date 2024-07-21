module t07_generate_boom (
// This module intakes coordinates of the blocks containing the boom and outputs the pixel the boom is on
input logic clk, nrst,
input logic [8:0] x,
input logic [7:0] y,
output logic boomPixel
);
logic boomDetect; // 1 bit since boolean 0 or 1


logic [8:0] array_horX [15:0] ;
logic [7:0] array_horY [15:0];
logic [8:0] array_verX[16] ; 
logic [7:0] array_verY [16] ;
logic [8:0] SCo;
logic [7:0] SPo;

logic [8:0] startX;
logic [7:0] startY;

logic [8:0] topBx;
logic [7:0] topBy;
logic [8:0] midBx;
logic [7:0] midBy;
logic [8:0] botBx;
logic [7:0] botBy;
// assign boomPixel = 0;
// endmodule

// toprigM toplefM botrigO toprigO botlefO toplefO botB topB
initial begin
  startX = 82;
  startY = 96;
array_horX[0] = 9'd004;
array_horX[1] = 9'd027;
array_horX[2] = 9'd060;
array_horX[3] = 9'd060;
array_horX[4] = 9'd093;
array_horX[5] = 9'd093;
array_horX[6] = 9'd126;
array_horX[7] = 9'd126;
// Initialize remaining elements if necessary
array_horX[8] = 9'd0;
array_horX[9] = 9'd0;
array_horX[10] = 9'd0;
array_horX[11] = 9'd0;
array_horX[12] = 9'd0;
array_horX[13] = 9'd0;
array_horX[14] = 9'd0;
array_horX[15] = 9'd0;
end
//initial array_horY = {8'd042, 8'd042, 8'd000, 8'd042, 8'd000, 8'd042, 8'd000, 8'd042};
// botrigM toprigM botcenM topcenM botlefM toplefM botrigO toprigO botlefO toplefO botrigO toprigO botlefO toplefO botrigB toprigB
initial begin
array_horY[0] = 8'd042;
array_horY[1] = 8'd042;
array_horY[2] = 8'd000;
array_horY[3] = 8'd042;
array_horY[4] = 8'd000;
array_horY[5] = 8'd042;
array_horY[6] = 8'd000;
array_horY[7] = 8'd042;
// Initialize remaining elements if necessary
array_horY[8] = 8'd0;
array_horY[9] = 8'd0;
array_horY[10] = 8'd0;
array_horY[11] = 8'd0;
array_horY[12] = 8'd0;
array_horY[13] = 8'd0;
array_horY[14] = 8'd0;
array_horY[15] = 8'd0;
end
initial begin
// Initialize array_verX
array_verX[0] = 9'd000;
array_verX[1] = 9'd000;
array_verX[2] = 9'd023;
array_verX[3] = 9'd023;
array_verX[4] = 9'd046;
array_verX[5] = 9'd046;
array_verX[6] = 9'd056;
array_verX[7] = 9'd056;
array_verX[8] = 9'd079;
array_verX[9] = 9'd079;
array_verX[10] = 9'd089;
array_verX[11] = 9'd089;
array_verX[12] = 9'd112;
array_verX[13] = 9'd112;
array_verX[14] = 9'd122;
array_verX[15] = 9'd122;
end

// initial array_verX = {9'd000, 9'd000, 9'd023, 9'd023, 9'd046, 9'd046, 9'd056, 9'd056, 9'd079, 9'd079, 9'd089, 9'd089, 9'd112, 9'd112, 9'd122, 9'd122};
// initial array_verY = {8'd003, 8'd024, 8'd003, 8'd024, 8'd003, 8'd024, 8'd003, 8'd024, 8'd003, 8'd024, 8'd003, 8'd024, 8'd003, 8'd024, 8'd003, 8'd024};
initial begin
// Initialize array_verY
array_verY[0] = 8'd003;
array_verY[1] = 8'd024;
array_verY[2] = 8'd003;
array_verY[3] = 8'd024;
array_verY[4] = 8'd003;
array_verY[5] = 8'd024;
array_verY[6] = 8'd003;
array_verY[7] = 8'd024;
array_verY[8] = 8'd003;
array_verY[9] = 8'd024;
array_verY[10] = 8'd003;
array_verY[11] = 8'd024;
array_verY[12] = 8'd003;
array_verY[13] = 8'd024;
array_verY[14] = 8'd003;
array_verY[15] = 8'd024;
end

always_comb begin
boomDetect = 0;

for (integer i = 0; i < 8; i++) begin
SCo = startX + array_horX[i];
SPo = startY + array_horY[i];
if
( 
(
((y == SPo + 0) || (y == SPo + 4))
&&((x >= SCo + 2) && (x <= SCo + 17))
)
||(
((y == SPo + 1) || (y == SPo + 3))
&&((x >= SCo + 1) && (x <= SCo + 18))
)
||(
(y == SPo + 2)
&&((x >= SCo + 0) && (x <= SCo + 19))
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
((x == SCo + 0) || (x == SCo + 4))
&&((y >= SPo + 2) && (y <= SPo + 17))
)
||(
((x == SCo + 1) || (x == SCo + 3))
&&((y >= SPo + 1) && (y <= SPo + 18))
)
||(
(x == SCo + 2)
&&((y >= SPo + 0) && (y <= SPo + 19))
)
) begin
boomDetect = 1;
end 
end

// top left B
topBx = startX + 137;
topBy = startY + 24;
if
( 
(
((x == topBx + 0) || (x == topBx + 4))
&&((y >= topBy + 2) && (y <= topBy + 16))
)
||(
((x == topBx + 1) || (x == topBx + 3))
&&((y >= topBy + 1) && (y <= topBy + 16))
)
||(
(x == topBx + 2)
&&((y >= topBy + 0) && (y <= topBy + 16))
)
) begin
boomDetect = 1;
end

// middle center B
midBx = startX + 126;
midBy = startY + 21;
if
( 
(
((x >= midBx + 2) && (x <= midBx + 9))
&&((y == midBy + 0) || (y == midBy + 4))
)
||(
((x >= midBx + 1) && (x <= midBx + 10))
&&((y == midBy + 1) || (y == midBy + 3))
)
||(
((x >= midBx + 0) && (x <= midBx + 11))
&& (y == midBy + 2)
)
) begin
boomDetect = 1;
end

// bottom left B
botBx = startX + 137;
botBy = startY + 6;
if
( 
(
((x == botBx + 0) || (x == botBx + 4))
&&((y >= botBy + 0) && (y <= botBy + 14))
)
||(
((x == botBx + 1) || (x == botBx + 3))
&&((y >= botBy + 0) && (y <= botBy + 15))
)
||(
(x == botBx + 2)
&&((y >= botBy + 0) && (y <= botBy + 16))
)
) begin
boomDetect = 1;
end
end

always_ff @(negedge nrst, posedge clk) begin
  if(!nrst) begin
    boomPixel <= 1'd0;
  end else begin
    boomPixel <= boomDetect;
  end
end
endmodule
