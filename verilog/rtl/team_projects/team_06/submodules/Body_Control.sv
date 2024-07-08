
module body_control (
input logic main_clk, body_clk, pause_clk,
input logic nrst,
input logic goodCollision,
input logic badCollision,
input logic enable,
input DIRECTION Direction,
output logic [3:0] head_x,
output logic [3:0] head_y,
output logic [MAX_LENGTH - 1:0] [3:0] body_x,
output logic [MAX_LENGTH - 1:0] [3:0] body_y,
output logic [7:0] score
);

logic [3:0] innerhead_x;       // 4 bits
logic [3:0] innerhead_y;       // 4 bits
logic [MAX_LENGTH - 1:0] [3:0] nextbody_x;       // 560 bits
logic [MAX_LENGTH - 1:0] [3:0] nextbody_y;       // 560 bits
logic [MAX_LENGTH - 1:0] [3:0] finalbody_x; // 560 bits
logic [MAX_LENGTH - 1:0] [3:0] finalbody_y; // 560 bits
logic [7:0] innerscore;
parameter MAX_LENGTH = 30;

// integer idx;

//Snake head and tail control
always_comb begin

innerhead_x = head_x;
innerhead_y = head_y;
nextbody_x = body_x;
nextbody_y = body_y;
finalbody_x = nextbody_x;
finalbody_y = nextbody_y;
innerscore = score;

if (enable == 1'b1) begin
case(Direction)
UP: begin //Up
innerhead_y = head_y - 1;
//  innertail_y = tail_y - 1;
end
DOWN: begin //Down
innerhead_y = head_y + 1;
//  innertail_y = tail_y + 1;
end
RIGHT: begin //Right
innerhead_x = head_x + 1;
//  innertail_x = tail_x + 1;
end
LEFT: begin //Left
innerhead_x = head_x - 1;
//  innertail_x = tail_x - 1;
end
default: {innerhead_x, innerhead_y} = {head_x, head_y};
endcase

//These two lines updates the new head location into the body array
nextbody_x = {body_x[(MAX_LENGTH - 2):0], innerhead_x};
nextbody_y = {body_y[(MAX_LENGTH - 2):0], innerhead_y};

if (goodCollision == 0 && badCollision == 0) begin //If the snape is moving normally without bumping into an apple or wall

//  if (innerbody_x[139:136] != 4'b0 && innerbody_y[139:136] != 4'b0) begin //The game will be finished here if the snake has reached rthis length
//This section chops off the last four bit of the old head location because we want the snake to keep moving and not increasing its length
case(score)

  0  : {finalbody_x[1:0], finalbody_y[1:0]} = {nextbody_x[1:0], nextbody_y[1:0]};
  1  : {finalbody_x[2 :0], finalbody_y[2 :0]} = {nextbody_x[2 :0], nextbody_y[2 :0]};
  2  : {finalbody_x[3 :0], finalbody_y[3 :0]} = {nextbody_x[3 :0], nextbody_y[3 :0]};
  3  : {finalbody_x[4 :0], finalbody_y[4 :0]} = {nextbody_x[4 :0], nextbody_y[4 :0]};
  4  : {finalbody_x[5 :0], finalbody_y[5 :0]} = {nextbody_x[5 :0], nextbody_y[5 :0]};
  5  : {finalbody_x[6 :0], finalbody_y[6 :0]} = {nextbody_x[6 :0], nextbody_y[6 :0]};
  6  : {finalbody_x[6 :0], finalbody_y[6 :0]} = {nextbody_x[6 :0], nextbody_y[6 :0]};
  7  : {finalbody_x[7 :0], finalbody_y[7 :0]} = {nextbody_x[7 :0], nextbody_y[7 :0]};
  8  : {finalbody_x[8 :0], finalbody_y[8 :0]} = {nextbody_x[8 :0], nextbody_y[8 :0]};
  9  : {finalbody_x[9 :0], finalbody_y[9 :0]} = {nextbody_x[9 :0], nextbody_y[9 :0]};
  10 : {finalbody_x[10:0], finalbody_y[10:0]} = {nextbody_x[10:0], nextbody_y[10:0]};
  11 : {finalbody_x[11:0], finalbody_y[11:0]} = {nextbody_x[11:0], nextbody_y[11:0]};
  12 : {finalbody_x[12:0], finalbody_y[12:0]} = {nextbody_x[12:0], nextbody_y[12:0]};
  13 : {finalbody_x[13:0], finalbody_y[13:0]} = {nextbody_x[13:0], nextbody_y[13:0]};
  14 : {finalbody_x[14:0], finalbody_y[14:0]} = {nextbody_x[14:0], nextbody_y[14:0]};
  15 : {finalbody_x[15:0], finalbody_y[15:0]} = {nextbody_x[15:0], nextbody_y[15:0]};
  16 : {finalbody_x[16:0], finalbody_y[16:0]} = {nextbody_x[16:0], nextbody_y[16:0]};
  17 : {finalbody_x[17:0], finalbody_y[17:0]} = {nextbody_x[17:0], nextbody_y[17:0]};
  // 18 : {finalbody_x[18:0], finalbody_y[18:0]} = {nextbody_x[18:0], nextbody_y[18:0]};
  // 19 : {finalbody_x[19:0], finalbody_y[19:0]} = {nextbody_x[19:0], nextbody_y[19:0]};
  // 20 : {finalbody_x[20:0], finalbody_y[20:0]} = {nextbody_x[20:0], nextbody_y[20:0]};
  // 21 : {finalbody_x[21:0], finalbody_y[21:0]} = {nextbody_x[21:0], nextbody_y[21:0]};
  // 22 : {finalbody_x[22:0], finalbody_y[22:0]} = {nextbody_x[22:0], nextbody_y[22:0]};
  // 23 : {finalbody_x[23:0], finalbody_y[23:0]} = {nextbody_x[23:0], nextbody_y[23:0]};
  // 24 : {finalbody_x[24 :0], finalbody_y[24 :0]} = {nextbody_x[24 :0], nextbody_y[24 :0]};
  // 25 : {finalbody_x[25 :0], finalbody_y[25 :0]} = {nextbody_x[25 :0], nextbody_y[25 :0]};
  // 26 : {finalbody_x[26 :0], finalbody_y[26 :0]} = {nextbody_x[26 :0], nextbody_y[26 :0]};
  // 27 : {finalbody_x[27 :0], finalbody_y[27 :0]} = {nextbody_x[27 :0], nextbody_y[27 :0]};
  // 28 : {finalbody_x[28 :0], finalbody_y[28 :0]} = {nextbody_x[28 :0], nextbody_y[28 :0]};
  // 29 : {finalbody_x[29 :0], finalbody_y[29 :0]} = {nextbody_x[29 :0], nextbody_y[29 :0]};
  // 30 : {finalbody_x[30 :0], finalbody_y[30 :0]} = {nextbody_x[30 :0], nextbody_y[30 :0]};
  // 31 : {finalbody_x[31 :0], finalbody_y[31 :0]} = {nextbody_x[31 :0], nextbody_y[31 :0]};
  // 32 : {finalbody_x[32 :0], finalbody_y[32 :0]} = {nextbody_x[32 :0], nextbody_y[32 :0]};
  // 33 : {finalbody_x[33 :0], finalbody_y[33 :0]} = {nextbody_x[33 :0], nextbody_y[33 :0]};
  // 34 : {finalbody_x[34 :0], finalbody_y[34 :0]} = {nextbody_x[34 :0], nextbody_y[34 :0]};
  // 35 : {finalbody_x[35 :0], finalbody_y[35 :0]} = {nextbody_x[35 :0], nextbody_y[35 :0]};
  // 36 : {finalbody_x[36 :0], finalbody_y[36 :0]} = {nextbody_x[36 :0], nextbody_y[36 :0]};
  // 37 : {finalbody_x[37 :0], finalbody_y[37 :0]} = {nextbody_x[37 :0], nextbody_y[37 :0]};
  // 38 : {finalbody_x[38 :0], finalbody_y[38 :0]} = {nextbody_x[38 :0], nextbody_y[38 :0]};
  // 39 : {finalbody_x[39 :0], finalbody_y[39 :0]} = {nextbody_x[39 :0], nextbody_y[39 :0]};
  // 40 : {finalbody_x[40 :0], finalbody_y[40 :0]} = {nextbody_x[40 :0], nextbody_y[40 :0]};
  // 41 : {finalbody_x[41 :0], finalbody_y[41 :0]} = {nextbody_x[41 :0], nextbody_y[41 :0]};
  // 42 : {finalbody_x[42 :0], finalbody_y[42 :0]} = {nextbody_x[42 :0], nextbody_y[42 :0]};
  // 43 : {finalbody_x[43 :0], finalbody_y[43 :0]} = {nextbody_x[43 :0], nextbody_y[43 :0]};
  // 44 : {finalbody_x[44 :0], finalbody_y[44 :0]} = {nextbody_x[44 :0], nextbody_y[44 :0]};
  // 45 : {finalbody_x[45 :0], finalbody_y[45 :0]} = {nextbody_x[45 :0], nextbody_y[45 :0]};
  // 46 : {finalbody_x[46 :0], finalbody_y[46 :0]} = {nextbody_x[46 :0], nextbody_y[46 :0]};
  // 47 : {finalbody_x[47 :0], finalbody_y[47 :0]} = {nextbody_x[47 :0], nextbody_y[47 :0]};
  // 48 : {finalbody_x[48 :0], finalbody_y[48 :0]} = {nextbody_x[48 :0], nextbody_y[48 :0]};
  // 49 : {finalbody_x[49 :0], finalbody_y[49 :0]} = {nextbody_x[49 :0], nextbody_y[49 :0]};
  // 50 : {finalbody_x[50 :0], finalbody_y[50 :0]} = {nextbody_x[50 :0], nextbody_y[50 :0]};
  // 51 : {finalbody_x[51 :0], finalbody_y[51 :0]} = {nextbody_x[51 :0], nextbody_y[51 :0]};
  // 52 : {finalbody_x[52 :0], finalbody_y[52 :0]} = {nextbody_x[52 :0], nextbody_y[52 :0]};
  // 53 : {finalbody_x[53 :0], finalbody_y[53 :0]} = {nextbody_x[53 :0], nextbody_y[53 :0]};
  // 54 : {finalbody_x[54 :0], finalbody_y[54 :0]} = {nextbody_x[54 :0], nextbody_y[54 :0]};
  // 55 : {finalbody_x[55 :0], finalbody_y[55 :0]} = {nextbody_x[55 :0], nextbody_y[55 :0]};
  // 56 : {finalbody_x[56 :0], finalbody_y[56 :0]} = {nextbody_x[56 :0], nextbody_y[56 :0]};
  // 57 : {finalbody_x[57 :0], finalbody_y[57 :0]} = {nextbody_x[57 :0], nextbody_y[57 :0]};
  // 58 : {finalbody_x[58 :0], finalbody_y[58 :0]} = {nextbody_x[58 :0], nextbody_y[58 :0]};
  // 59 : {finalbody_x[59 :0], finalbody_y[59 :0]} = {nextbody_x[59 :0], nextbody_y[59 :0]};
  // 60 : {finalbody_x[60 :0], finalbody_y[60 :0]} = {nextbody_x[60 :0], nextbody_y[60 :0]};
  // 61 : {finalbody_x[61 :0], finalbody_y[61 :0]} = {nextbody_x[61 :0], nextbody_y[61 :0]};
  // 62 : {finalbody_x[62 :0], finalbody_y[62 :0]} = {nextbody_x[62 :0], nextbody_y[62 :0]};
  // 63 : {finalbody_x[63 :0], finalbody_y[63 :0]} = {nextbody_x[63 :0], nextbody_y[63 :0]};
  // 64 : {finalbody_x[64 :0], finalbody_y[64 :0]} = {nextbody_x[64 :0], nextbody_y[64 :0]};
  // 65 : {finalbody_x[65 :0], finalbody_y[65 :0]} = {nextbody_x[65 :0], nextbody_y[65 :0]};
  // 66 : {finalbody_x[66 :0], finalbody_y[66 :0]} = {nextbody_x[66 :0], nextbody_y[66 :0]};
  // 67 : {finalbody_x[67 :0], finalbody_y[67 :0]} = {nextbody_x[67 :0], nextbody_y[67 :0]};
  // 68 : {finalbody_x[279:0], finalbody_y[279:0]} = {nextbody_x[279:0], nextbody_y[279:0]};
  // 69 : {finalbody_x[283:0], finalbody_y[283:0]} = {nextbody_x[283:0], nextbody_y[283:0]};
  // 70 : {finalbody_x[287:0], finalbody_y[287:0]} = {nextbody_x[287:0], nextbody_y[287:0]};
  // 71 : {finalbody_x[291:0], finalbody_y[291:0]} = {nextbody_x[291:0], nextbody_y[291:0]};
  // 72 : {finalbody_x[295:0], finalbody_y[295:0]} = {nextbody_x[295:0], nextbody_y[295:0]};
  // 73 : {finalbody_x[299:0], finalbody_y[299:0]} = {nextbody_x[299:0], nextbody_y[299:0]};
  // 74 : {finalbody_x[303:0], finalbody_y[303:0]} = {nextbody_x[303:0], nextbody_y[303:0]};
  // 75 : {finalbody_x[307:0], finalbody_y[307:0]} = {nextbody_x[307:0], nextbody_y[307:0]};
  // 76 : {finalbody_x[311:0], finalbody_y[311:0]} = {nextbody_x[311:0], nextbody_y[311:0]};
  // 77 : {finalbody_x[315:0], finalbody_y[315:0]} = {nextbody_x[315:0], nextbody_y[315:0]};
  // 78 : {finalbody_x[319:0], finalbody_y[319:0]} = {nextbody_x[319:0], nextbody_y[319:0]};
  // 79 : {finalbody_x[323:0], finalbody_y[323:0]} = {nextbody_x[323:0], nextbody_y[323:0]};
  // 80 : {finalbody_x[327:0], finalbody_y[327:0]} = {nextbody_x[327:0], nextbody_y[327:0]};
  // 81 : {finalbody_x[331:0], finalbody_y[331:0]} = {nextbody_x[331:0], nextbody_y[331:0]};
  // 82 : {finalbody_x[335:0], finalbody_y[335:0]} = {nextbody_x[335:0], nextbody_y[335:0]};
  // 83 : {finalbody_x[339:0], finalbody_y[339:0]} = {nextbody_x[339:0], nextbody_y[339:0]};
  // 84 : {finalbody_x[343:0], finalbody_y[343:0]} = {nextbody_x[343:0], nextbody_y[343:0]};
  // 85 : {finalbody_x[347:0], finalbody_y[347:0]} = {nextbody_x[347:0], nextbody_y[347:0]};
  // 86 : {finalbody_x[351:0], finalbody_y[351:0]} = {nextbody_x[351:0], nextbody_y[351:0]};
  // 87 : {finalbody_x[355:0], finalbody_y[355:0]} = {nextbody_x[355:0], nextbody_y[355:0]};
  // 88 : {finalbody_x[359:0], finalbody_y[359:0]} = {nextbody_x[359:0], nextbody_y[359:0]};
  // 89 : {finalbody_x[363:0], finalbody_y[363:0]} = {nextbody_x[363:0], nextbody_y[363:0]};
  // 90 : {finalbody_x[367:0], finalbody_y[367:0]} = {nextbody_x[367:0], nextbody_y[367:0]};
  // 91 : {finalbody_x[371:0], finalbody_y[371:0]} = {nextbody_x[371:0], nextbody_y[371:0]};
  // 92 : {finalbody_x[375:0], finalbody_y[375:0]} = {nextbody_x[375:0], nextbody_y[375:0]};
  // 93 : {finalbody_x[379:0], finalbody_y[379:0]} = {nextbody_x[379:0], nextbody_y[379:0]};
  // 94 : {finalbody_x[383:0], finalbody_y[383:0]} = {nextbody_x[383:0], nextbody_y[383:0]};
  // 95 : {finalbody_x[387:0], finalbody_y[387:0]} = {nextbody_x[387:0], nextbody_y[387:0]};
  // 96 : {finalbody_x[391:0], finalbody_y[391:0]} = {nextbody_x[391:0], nextbody_y[391:0]};
  // 97 : {finalbody_x[395:0], finalbody_y[395:0]} = {nextbody_x[395:0], nextbody_y[395:0]};
  // 98 : {finalbody_x[399:0], finalbody_y[399:0]} = {nextbody_x[399:0], nextbody_y[399:0]};
  // 99 : {finalbody_x[403:0], finalbody_y[403:0]} = {nextbody_x[403:0], nextbody_y[403:0]};
  // 100 : {finalbody_x[407:0], finalbody_y[407:0]} = {nextbody_x[407:0], nextbody_y[407:0]};
  // 101 : {finalbody_x[411:0], finalbody_y[411:0]} = {nextbody_x[411:0], nextbody_y[411:0]};
  // 102 : {finalbody_x[415:0], finalbody_y[415:0]} = {nextbody_x[415:0], nextbody_y[415:0]};
  // 103 : {finalbody_x[419:0], finalbody_y[419:0]} = {nextbody_x[419:0], nextbody_y[419:0]};
  // 104 : {finalbody_x[423:0], finalbody_y[423:0]} = {nextbody_x[423:0], nextbody_y[423:0]};
  // 105 : {finalbody_x[427:0], finalbody_y[427:0]} = {nextbody_x[427:0], nextbody_y[427:0]};
  // 106 : {finalbody_x[431:0], finalbody_y[431:0]} = {nextbody_x[431:0], nextbody_y[431:0]};
  // 107 : {finalbody_x[435:0], finalbody_y[435:0]} = {nextbody_x[435:0], nextbody_y[435:0]};
  // 108 : {finalbody_x[439:0], finalbody_y[439:0]} = {nextbody_x[439:0], nextbody_y[439:0]};
  // 109 : {finalbody_x[443:0], finalbody_y[443:0]} = {nextbody_x[443:0], nextbody_y[443:0]};
  // 110 : {finalbody_x[447:0], finalbody_y[447:0]} = {nextbody_x[447:0], nextbody_y[447:0]};
  // 111 : {finalbody_x[451:0], finalbody_y[451:0]} = {nextbody_x[451:0], nextbody_y[451:0]};
  // 112 : {finalbody_x[455:0], finalbody_y[455:0]} = {nextbody_x[455:0], nextbody_y[455:0]};
  // 113 : {finalbody_x[459:0], finalbody_y[459:0]} = {nextbody_x[459:0], nextbody_y[459:0]};
  // 114 : {finalbody_x[463:0], finalbody_y[463:0]} = {nextbody_x[463:0], nextbody_y[463:0]};
  // 115 : {finalbody_x[467:0], finalbody_y[467:0]} = {nextbody_x[467:0], nextbody_y[467:0]};
  // 116 : {finalbody_x[471:0], finalbody_y[471:0]} = {nextbody_x[471:0], nextbody_y[471:0]};
  // 117 : {finalbody_x[475:0], finalbody_y[475:0]} = {nextbody_x[475:0], nextbody_y[475:0]};
  // 118 : {finalbody_x[479:0], finalbody_y[479:0]} = {nextbody_x[479:0], nextbody_y[479:0]};
  // 119 : {finalbody_x[483:0], finalbody_y[483:0]} = {nextbody_x[483:0], nextbody_y[483:0]};
  // 120 : {finalbody_x[487:0], finalbody_y[487:0]} = {nextbody_x[487:0], nextbody_y[487:0]};
  // 121 : {finalbody_x[491:0], finalbody_y[491:0]} = {nextbody_x[491:0], nextbody_y[491:0]};
  // 122 : {finalbody_x[495:0], finalbody_y[495:0]} = {nextbody_x[495:0], nextbody_y[495:0]};
  // 123 : {finalbody_x[499:0], finalbody_y[499:0]} = {nextbody_x[499:0], nextbody_y[499:0]};
  // 124 : {finalbody_x[503:0], finalbody_y[503:0]} = {nextbody_x[503:0], nextbody_y[503:0]};
  // 125 : {finalbody_x[507:0], finalbody_y[507:0]} = {nextbody_x[507:0], nextbody_y[507:0]};
  // 126 : {finalbody_x[511:0], finalbody_y[511:0]} = {nextbody_x[511:0], nextbody_y[511:0]};
  // 127 : {finalbody_x[515:0], finalbody_y[515:0]} = {nextbody_x[515:0], nextbody_y[515:0]};
  // 128 : {finalbody_x[519:0], finalbody_y[519:0]} = {nextbody_x[519:0], nextbody_y[519:0]};
  // 129 : {finalbody_x[523:0], finalbody_y[523:0]} = {nextbody_x[523:0], nextbody_y[523:0]};
  // 130 : {finalbody_x[527:0], finalbody_y[527:0]} = {nextbody_x[527:0], nextbody_y[527:0]};
  // 131 : {finalbody_x[531:0], finalbody_y[531:0]} = {nextbody_x[531:0], nextbody_y[531:0]};
  // 132 : {finalbody_x[535:0], finalbody_y[535:0]} = {nextbody_x[535:0], nextbody_y[535:0]};
  // 133 : {finalbody_x[539:0], finalbody_y[539:0]} = {nextbody_x[539:0], nextbody_y[539:0]};
  // 134 : {finalbody_x[543:0], finalbody_y[543:0]} = {nextbody_x[543:0], nextbody_y[543:0]};
  // 135 : {finalbody_x[547:0], finalbody_y[547:0]} = {nextbody_x[547:0], nextbody_y[547:0]};
  // 136 : {finalbody_x[551:0], finalbody_y[551:0]} = {nextbody_x[551:0], nextbody_y[551:0]};
  // 137 : {finalbody_x[555:0], finalbody_y[555:0]} = {nextbody_x[555:0], nextbody_y[555:0]};
  // 138 : {finalbody_x[559:0], finalbody_y[559:0]} = {nextbody_x[559:0], nextbody_y[559:0]};
  default : {finalbody_x, finalbody_y} = {nextbody_x, nextbody_y};
endcase
end
//  for (integer i = 0; i <= (MAX_LENGTH - 1); i++) begin
//    if (score == i) begin
//      {finalbody_x[1 + i:0], finalbody_y[1 + i:0]} = {nextbody_x[1 + i:0], nextbody_y[1 + i:0]};
//    end
//  end
// {finalbody_x[7 + (i * 4):0], finalbody_y[7 + (i * 4):0]} = {nextbody_x[7 + (i * 4):0], nextbody_y[7 + (i * 4):0]};

//This section keep the last four bit of the old head location because we want the snake to keep moving and not increasing its length
else if (goodCollision == 1) begin

finalbody_x = nextbody_x;
finalbody_y = nextbody_y;

innerscore = score + 1;
// idx = 0;
end


else  begin // BAD COLLISION LOGIC
finalbody_x <= 120'h44; // Starting Tail X,Y
finalbody_y <= 120'h34;

end

end
end

always_ff @(posedge main_clk, negedge nrst) begin

if (nrst == 1'b0) begin
head_x <= 4'd4;
head_y <= 4'd4;
body_x <= 120'h34; // Starting Tail X,Y
body_y <= 120'h44;
score <= 0;
end

else if (pause_clk) begin 
    if (body_clk) begin

if (badCollision == 0) begin //If reset
head_x <= innerhead_x;
head_y <= innerhead_y;
body_x <= finalbody_x;
body_y <= finalbody_y;
score  <= innerscore;
end
else begin
head_x <= 4'd4;
head_y <= 4'd4;
body_x <= 120'h34; // Starting Tail X,Y
body_y <= 120'h44;
end
end
else begin 
   head_x = head_x;
 head_y = head_y;
 body_x = body_x;
 body_y = body_y;
 score = score;
end
end
else begin
 head_x = head_x;
 head_y = head_y;
 body_x = body_x;
 body_y = body_y;
 score = score;
end

end
endmodule
