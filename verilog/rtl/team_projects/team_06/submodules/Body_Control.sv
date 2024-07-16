
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
  6  : {finalbody_x[7 :0], finalbody_y[7 :0]} = {nextbody_x[7 :0], nextbody_y[7 :0]};
  7  : {finalbody_x[8 :0], finalbody_y[8 :0]} = {nextbody_x[8 :0], nextbody_y[8 :0]};
  8  : {finalbody_x[9 :0], finalbody_y[9 :0]} = {nextbody_x[9 :0], nextbody_y[9 :0]};
  9  : {finalbody_x[10 :0], finalbody_y[10 :0]} = {nextbody_x[10 :0], nextbody_y[10 :0]};
  10 : {finalbody_x[11:0], finalbody_y[11:0]} = {nextbody_x[11:0], nextbody_y[11:0]};
  11 : {finalbody_x[12:0], finalbody_y[12:0]} = {nextbody_x[12:0], nextbody_y[12:0]};
  12 : {finalbody_x[13:0], finalbody_y[13:0]} = {nextbody_x[13:0], nextbody_y[13:0]};
  13 : {finalbody_x[14:0], finalbody_y[14:0]} = {nextbody_x[14:0], nextbody_y[14:0]};
  14 : {finalbody_x[15:0], finalbody_y[15:0]} = {nextbody_x[15:0], nextbody_y[15:0]};
  15 : {finalbody_x[16:0], finalbody_y[16:0]} = {nextbody_x[16:0], nextbody_y[16:0]};
  16 : {finalbody_x[17:0], finalbody_y[17:0]} = {nextbody_x[17:0], nextbody_y[17:0]};
  17 : {finalbody_x[18:0], finalbody_y[18:0]} = {nextbody_x[18:0], nextbody_y[18:0]};
  18 : {finalbody_x[19:0], finalbody_y[19:0]} = {nextbody_x[19:0], nextbody_y[19:0]};
  19 : {finalbody_x[20:0], finalbody_y[20:0]} = {nextbody_x[20:0], nextbody_y[20:0]};
  20 : {finalbody_x[21:0], finalbody_y[21:0]} = {nextbody_x[21:0], nextbody_y[21:0]};
  21 : {finalbody_x[22:0], finalbody_y[22:0]} = {nextbody_x[22:0], nextbody_y[22:0]};
  22 : {finalbody_x[23:0], finalbody_y[23:0]} = {nextbody_x[23:0], nextbody_y[23:0]};
  23 : {finalbody_x[24:0], finalbody_y[24:0]} = {nextbody_x[24:0], nextbody_y[24:0]};
  24 : {finalbody_x[25 :0], finalbody_y[25 :0]} = {nextbody_x[25 :0], nextbody_y[25 :0]};
  25 : {finalbody_x[26 :0], finalbody_y[26 :0]} = {nextbody_x[26 :0], nextbody_y[26 :0]};
  26 : {finalbody_x[27 :0], finalbody_y[27 :0]} = {nextbody_x[27 :0], nextbody_y[27 :0]};
  27 : {finalbody_x[28 :0], finalbody_y[28 :0]} = {nextbody_x[28 :0], nextbody_y[28 :0]};
  28 : {finalbody_x[29 :0], finalbody_y[29 :0]} = {nextbody_x[29 :0], nextbody_y[29 :0]};
  // 29 : {finalbody_x[30 :0], finalbody_y[30 :0]} = {nextbody_x[30 :0], nextbody_y[30 :0]};
  // 30 : {finalbody_x[31 :0], finalbody_y[31 :0]} = {nextbody_x[31 :0], nextbody_y[31 :0]};
  // 31 : {finalbody_x[32 :0], finalbody_y[32 :0]} = {nextbody_x[32 :0], nextbody_y[32 :0]};
  // 32 : {finalbody_x[33 :0], finalbody_y[33 :0]} = {nextbody_x[33 :0], nextbody_y[33 :0]};
  // 33 : {finalbody_x[34 :0], finalbody_y[34 :0]} = {nextbody_x[34 :0], nextbody_y[34 :0]};
  // 34 : {finalbody_x[35 :0], finalbody_y[35 :0]} = {nextbody_x[35 :0], nextbody_y[35 :0]};
  // 35 : {finalbody_x[36 :0], finalbody_y[36 :0]} = {nextbody_x[36 :0], nextbody_y[36 :0]};
  // 36 : {finalbody_x[37 :0], finalbody_y[37 :0]} = {nextbody_x[37 :0], nextbody_y[37 :0]};
  // 37 : {finalbody_x[38 :0], finalbody_y[38 :0]} = {nextbody_x[38 :0], nextbody_y[38 :0]};
  // 38 : {finalbody_x[39 :0], finalbody_y[39 :0]} = {nextbody_x[39 :0], nextbody_y[39 :0]};
  // 39 : {finalbody_x[40 :0], finalbody_y[40 :0]} = {nextbody_x[40 :0], nextbody_y[40 :0]};
  // 40 : {finalbody_x[41 :0], finalbody_y[41 :0]} = {nextbody_x[41 :0], nextbody_y[41 :0]};
  // 41 : {finalbody_x[42 :0], finalbody_y[42 :0]} = {nextbody_x[42 :0], nextbody_y[42 :0]};
  // 42 : {finalbody_x[43 :0], finalbody_y[43 :0]} = {nextbody_x[43 :0], nextbody_y[43 :0]};
  // 43 : {finalbody_x[44 :0], finalbody_y[44 :0]} = {nextbody_x[44 :0], nextbody_y[44 :0]};
  // 44 : {finalbody_x[45 :0], finalbody_y[45 :0]} = {nextbody_x[45 :0], nextbody_y[45 :0]};
  // 45 : {finalbody_x[46 :0], finalbody_y[46 :0]} = {nextbody_x[46 :0], nextbody_y[46 :0]};
  // 46 : {finalbody_x[47 :0], finalbody_y[47 :0]} = {nextbody_x[47 :0], nextbody_y[47 :0]};
  // 47 : {finalbody_x[48 :0], finalbody_y[48 :0]} = {nextbody_x[48 :0], nextbody_y[48 :0]};
  // 48 : {finalbody_x[49 :0], finalbody_y[49 :0]} = {nextbody_x[49 :0], nextbody_y[49 :0]};
  // 49 : {finalbody_x[50 :0], finalbody_y[50 :0]} = {nextbody_x[50 :0], nextbody_y[50 :0]};
  // 50 : {finalbody_x[51 :0], finalbody_y[51 :0]} = {nextbody_x[51 :0], nextbody_y[51 :0]};
  // 51 : {finalbody_x[52 :0], finalbody_y[52 :0]} = {nextbody_x[52 :0], nextbody_y[52 :0]};
  // 52 : {finalbody_x[53 :0], finalbody_y[53 :0]} = {nextbody_x[53 :0], nextbody_y[53 :0]};
  // 53 : {finalbody_x[54 :0], finalbody_y[54 :0]} = {nextbody_x[54 :0], nextbody_y[54 :0]};
  // 54 : {finalbody_x[55 :0], finalbody_y[55 :0]} = {nextbody_x[55 :0], nextbody_y[55 :0]};
  // 55 : {finalbody_x[56 :0], finalbody_y[56 :0]} = {nextbody_x[56 :0], nextbody_y[56 :0]};
  // 56 : {finalbody_x[57 :0], finalbody_y[57 :0]} = {nextbody_x[57 :0], nextbody_y[57 :0]};
  // 57 : {finalbody_x[58 :0], finalbody_y[58 :0]} = {nextbody_x[58 :0], nextbody_y[58 :0]};
  // 58 : {finalbody_x[59 :0], finalbody_y[59 :0]} = {nextbody_x[59 :0], nextbody_y[59 :0]};
  // 59 : {finalbody_x[60 :0], finalbody_y[60 :0]} = {nextbody_x[60 :0], nextbody_y[60 :0]};
  // 60 : {finalbody_x[61 :0], finalbody_y[61 :0]} = {nextbody_x[61 :0], nextbody_y[61 :0]};
  // 61 : {finalbody_x[62 :0], finalbody_y[62 :0]} = {nextbody_x[62 :0], nextbody_y[62 :0]};
  // 62 : {finalbody_x[63 :0], finalbody_y[63 :0]} = {nextbody_x[63 :0], nextbody_y[63 :0]};
  // 63 : {finalbody_x[64 :0], finalbody_y[64 :0]} = {nextbody_x[64 :0], nextbody_y[64 :0]};
  // 64 : {finalbody_x[65 :0], finalbody_y[65 :0]} = {nextbody_x[65 :0], nextbody_y[65 :0]};
  // 65 : {finalbody_x[66 :0], finalbody_y[66 :0]} = {nextbody_x[66 :0], nextbody_y[66 :0]};
  // 66 : {finalbody_x[67 :0], finalbody_y[67 :0]} = {nextbody_x[67 :0], nextbody_y[67 :0]};
  // 67 : {finalbody_x[68 :0], finalbody_y[68 :0]} = {nextbody_x[68 :0], nextbody_y[68 :0]};
  // 68 : {finalbody_x[ 69:0], finalbody_y[ 69:0]} = {nextbody_x[ 69:0], nextbody_y[ 69:0]};
  // 69 : {finalbody_x[70 :0], finalbody_y[70 :0]} = {nextbody_x[70 :0], nextbody_y[70 :0]};
  // 70 : {finalbody_x[71 :0], finalbody_y[71 :0]} = {nextbody_x[71 :0], nextbody_y[71 :0]};
  // 71 : {finalbody_x[72 :0], finalbody_y[72 :0]} = {nextbody_x[72 :0], nextbody_y[72 :0]};
  // 72 : {finalbody_x[73 :0], finalbody_y[73 :0]} = {nextbody_x[73 :0], nextbody_y[73 :0]};
  // 73 : {finalbody_x[74 :0], finalbody_y[74 :0]} = {nextbody_x[74 :0], nextbody_y[74 :0]};
  // 74 : {finalbody_x[75 :0], finalbody_y[75 :0]} = {nextbody_x[75 :0], nextbody_y[75 :0]};
  // 75 : {finalbody_x[76 :0], finalbody_y[76 :0]} = {nextbody_x[76 :0], nextbody_y[76 :0]};
  // 76 : {finalbody_x[77 :0], finalbody_y[77 :0]} = {nextbody_x[77 :0], nextbody_y[77 :0]};
  // 77 : {finalbody_x[78 :0], finalbody_y[78 :0]} = {nextbody_x[78 :0], nextbody_y[78 :0]};
  // 78 : {finalbody_x[79 :0], finalbody_y[79 :0]} = {nextbody_x[79 :0], nextbody_y[79 :0]};
  // 79 : {finalbody_x[80 :0], finalbody_y[80 :0]} = {nextbody_x[80 :0], nextbody_y[80 :0]};
  // 80 : {finalbody_x[81 :0], finalbody_y[81 :0]} = {nextbody_x[81 :0], nextbody_y[81 :0]};
  // 81 : {finalbody_x[82 :0], finalbody_y[82 :0]} = {nextbody_x[82 :0], nextbody_y[82 :0]};
  // 82 : {finalbody_x[83 :0], finalbody_y[83 :0]} = {nextbody_x[83 :0], nextbody_y[83 :0]};
  // 83 : {finalbody_x[84 :0], finalbody_y[84 :0]} = {nextbody_x[84 :0], nextbody_y[84 :0]};
  // 84 : {finalbody_x[85 :0], finalbody_y[85 :0]} = {nextbody_x[85 :0], nextbody_y[85 :0]};
  // 85 : {finalbody_x[86 :0], finalbody_y[86 :0]} = {nextbody_x[86 :0], nextbody_y[86 :0]};
  // 86 : {finalbody_x[87 :0], finalbody_y[87 :0]} = {nextbody_x[87 :0], nextbody_y[87 :0]};
  // 87 : {finalbody_x[88 :0], finalbody_y[88 :0]} = {nextbody_x[88 :0], nextbody_y[88 :0]};
  // 88 : {finalbody_x[89 :0], finalbody_y[89 :0]} = {nextbody_x[89 :0], nextbody_y[89 :0]};
  // 89 : {finalbody_x[90 :0], finalbody_y[90 :0]} = {nextbody_x[90 :0], nextbody_y[90 :0]};
  // 90 : {finalbody_x[91 :0], finalbody_y[91 :0]} = {nextbody_x[91 :0], nextbody_y[91 :0]};
  // 91 : {finalbody_x[92 :0], finalbody_y[92 :0]} = {nextbody_x[92 :0], nextbody_y[92 :0]};
  // 92 : {finalbody_x[93 :0], finalbody_y[93 :0]} = {nextbody_x[93 :0], nextbody_y[93 :0]};
  // 93 : {finalbody_x[94 :0], finalbody_y[94 :0]} = {nextbody_x[94 :0], nextbody_y[94 :0]};
  // 94 : {finalbody_x[95 :0], finalbody_y[95 :0]} = {nextbody_x[95 :0], nextbody_y[95 :0]};
  // 95 : {finalbody_x[96 :0], finalbody_y[96 :0]} = {nextbody_x[96 :0], nextbody_y[96 :0]};
  // 96 : {finalbody_x[97 :0], finalbody_y[97 :0]} = {nextbody_x[97 :0], nextbody_y[97 :0]};
  // 97 : {finalbody_x[98 :0], finalbody_y[98 :0]} = {nextbody_x[98 :0], nextbody_y[98 :0]};
  // 98 : {finalbody_x[99 :0], finalbody_y[99 :0]} = {nextbody_x[99 :0], nextbody_y[99 :0]};
  // 99 : {finalbody_x[100 :0], finalbody_y[100 :0]} = {nextbody_x[100 :0], nextbody_y[100 :0]};
  // 100 : {finalbody_x[101:0], finalbody_y[101:0]} = {nextbody_x[101:0], nextbody_y[101:0]};
  // 101 : {finalbody_x[102:0], finalbody_y[102:0]} = {nextbody_x[102:0], nextbody_y[102:0]};
  // 102 : {finalbody_x[103:0], finalbody_y[103:0]} = {nextbody_x[103:0], nextbody_y[103:0]};
  // 103 : {finalbody_x[104:0], finalbody_y[104:0]} = {nextbody_x[104:0], nextbody_y[104:0]};
  // 104 : {finalbody_x[105:0], finalbody_y[105:0]} = {nextbody_x[105:0], nextbody_y[105:0]};
  // 105 : {finalbody_x[106:0], finalbody_y[106:0]} = {nextbody_x[106:0], nextbody_y[106:0]};
  // 106 : {finalbody_x[107:0], finalbody_y[107:0]} = {nextbody_x[107:0], nextbody_y[107:0]};
  // 107 : {finalbody_x[108:0], finalbody_y[108:0]} = {nextbody_x[108:0], nextbody_y[108:0]};
  // 108 : {finalbody_x[109:0], finalbody_y[109:0]} = {nextbody_x[109:0], nextbody_y[109:0]};
  // 109 : {finalbody_x[110:0], finalbody_y[110:0]} = {nextbody_x[110:0], nextbody_y[110:0]};
  // 110 : {finalbody_x[111:0], finalbody_y[111:0]} = {nextbody_x[111:0], nextbody_y[111:0]};
  // 111 : {finalbody_x[112:0], finalbody_y[112:0]} = {nextbody_x[112:0], nextbody_y[112:0]};
  // 112 : {finalbody_x[113:0], finalbody_y[113:0]} = {nextbody_x[113:0], nextbody_y[113:0]};
  // 113 : {finalbody_x[114:0], finalbody_y[114:0]} = {nextbody_x[114:0], nextbody_y[114:0]};
  // 114 : {finalbody_x[115:0], finalbody_y[115:0]} = {nextbody_x[115:0], nextbody_y[115:0]};
  // 115 : {finalbody_x[116:0], finalbody_y[116:0]} = {nextbody_x[116:0], nextbody_y[116:0]};
  // 116 : {finalbody_x[117:0], finalbody_y[117:0]} = {nextbody_x[117:0], nextbody_y[117:0]};
  // 117 : {finalbody_x[118:0], finalbody_y[118:0]} = {nextbody_x[118:0], nextbody_y[118:0]};
  // 118 : {finalbody_x[119:0], finalbody_y[119:0]} = {nextbody_x[119:0], nextbody_y[119:0]};
  // 119 : {finalbody_x[120:0], finalbody_y[120:0]} = {nextbody_x[120:0], nextbody_y[120:0]};
  // 120 : {finalbody_x[121:0], finalbody_y[121:0]} = {nextbody_x[121:0], nextbody_y[121:0]};
  // 121 : {finalbody_x[122:0], finalbody_y[122:0]} = {nextbody_x[122:0], nextbody_y[122:0]};
  // 122 : {finalbody_x[123:0], finalbody_y[123:0]} = {nextbody_x[123:0], nextbody_y[123:0]};
  // 123 : {finalbody_x[124:0], finalbody_y[124:0]} = {nextbody_x[124:0], nextbody_y[124:0]};
  // 124 : {finalbody_x[125:0], finalbody_y[125:0]} = {nextbody_x[125:0], nextbody_y[125:0]};
  // 125 : {finalbody_x[126:0], finalbody_y[126:0]} = {nextbody_x[126:0], nextbody_y[126:0]};
  // 126 : {finalbody_x[127:0], finalbody_y[127:0]} = {nextbody_x[127:0], nextbody_y[127:0]};
  // 127 : {finalbody_x[128:0], finalbody_y[128:0]} = {nextbody_x[128:0], nextbody_y[128:0]};
  // 128 : {finalbody_x[129:0], finalbody_y[129:0]} = {nextbody_x[129:0], nextbody_y[129:0]};
  // 129 : {finalbody_x[130:0], finalbody_y[130:0]} = {nextbody_x[130:0], nextbody_y[130:0]};
  // 130 : {finalbody_x[131:0], finalbody_y[131:0]} = {nextbody_x[131:0], nextbody_y[131:0]};
  // 131 : {finalbody_x[132:0], finalbody_y[132:0]} = {nextbody_x[132:0], nextbody_y[132:0]};
  // 132 : {finalbody_x[133:0], finalbody_y[133:0]} = {nextbody_x[133:0], nextbody_y[133:0]};
  // 133 : {finalbody_x[134:0], finalbody_y[134:0]} = {nextbody_x[134:0], nextbody_y[134:0]};
  // 134 : {finalbody_x[135:0], finalbody_y[135:0]} = {nextbody_x[135:0], nextbody_y[135:0]};
  // 135 : {finalbody_x[136:0], finalbody_y[136:0]} = {nextbody_x[136:0], nextbody_y[136:0]};
  // 136 : {finalbody_x[137:0], finalbody_y[137:0]} = {nextbody_x[137:0], nextbody_y[137:0]};
  // 137 : {finalbody_x[138:0], finalbody_y[138:0]} = {nextbody_x[138:0], nextbody_y[138:0]};
  // 138 : {finalbody_x[139:0], finalbody_y[139:0]} = {nextbody_x[139:0], nextbody_y[139:0]};
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
