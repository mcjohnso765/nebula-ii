module t07_generate_defused (
// This module intakes coordinates of the blocks containing the defused and outputs the pixel the defused is on
input logic clk, nrst,
input logic [8:0] x,
input logic [7:0] y,
output logic defusedPixel
);
logic defusedDetect; // 1 bit since boolean 0 or 1


logic [8:0] array_horX[15:0];
logic [7:0] array_horY[15:0];
logic [8:0] array_verX[15:0];
logic [7:0] array_verY[15:0];
logic [8:0] SCo;
logic [7:0] SPo;

logic [8:0] firBotDx;
logic [8:0] firTopDx;
logic [7:0] firBotDy;
logic [7:0] firTopDy;
logic [8:0] lasBotDx;
logic [8:0] lasTopDx;
logic [7:0] lasBotDy;
logic [7:0] lasTopDy;

// assign defusedPixel = 0;
// endmodule



initial begin
// Initialize array_horX
array_horX[0] = 9'd004;
array_horX[1] = 9'd004;
array_horX[2] = 9'd033;
array_horX[3] = 9'd033;
array_horX[4] = 9'd033;
array_horX[5] = 9'd066;
array_horX[6] = 9'd066;
array_horX[7] = 9'd066;
array_horX[8] = 9'd101;
array_horX[9] = 9'd128;
array_horX[10] = 9'd128;
array_horX[11] = 9'd157;
array_horX[12] = 9'd157;
array_horX[13] = 9'd157;
array_horX[14] = 9'd190;
array_horX[15] = 9'd190;
end
initial begin
// Initialize array_horY
array_horY[0] = 8'd042;
array_horY[1] = 8'd000;
array_horY[2] = 8'd000;
array_horY[3] = 8'd021;
array_horY[4] = 8'd042;
array_horY[5] = 8'd000;
array_horY[6] = 8'd021;
array_horY[7] = 8'd042;
array_horY[8] = 8'd000;
array_horY[9] = 8'd021;
array_horY[10] = 8'd042;
array_horY[11] = 8'd000;
array_horY[12] = 8'd021;
array_horY[13] = 8'd042;
array_horY[14] = 8'd000;
array_horY[15] = 8'd042;
end

initial begin
// Initialize array_verX
array_verX[0] = 9'd000;
array_verX[1] = 9'd000;
array_verX[2] = 9'd052;
array_verX[3] = 9'd052;
array_verX[4] = 9'd062;
array_verX[5] = 9'd085;
array_verX[6] = 9'd095;
array_verX[7] = 9'd095;
array_verX[8] = 9'd118;
array_verX[9] = 9'd118;
array_verX[10] = 9'd147;
array_verX[11] = 9'd147;
array_verX[12] = 9'd176;
array_verX[13] = 9'd176;
array_verX[14] = 9'd186;
array_verX[15] = 9'd186;
end
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
defusedDetect = 0;

for (integer i = 0; i < 16; i++) begin
SCo = 55 + array_horX[i];
SPo = 96 + array_horY[i];
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
defusedDetect = 1;
end
end


for (integer j = 0; j < 16; j++) begin
SCo = 55 + array_verX[j];
SPo = 96 + array_verY[j];
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
defusedDetect = 1;
end 
end

// first bottom D
firBotDx = 55 + 200;
firBotDy = 96 + 6;
if
( 
(
((x == firBotDx + 0) || (x == firBotDx + 4))
&&((y >= firBotDy + 0) && (y <= firBotDy + 14))
)
||(
((x == firBotDx + 1) || (x == firBotDx + 3))
&&((y >= firBotDy + 0) && (y <= firBotDy + 15))
)
||(
(x == firBotDx + 2)
&&((y >= firBotDy + 0) && (y <= firBotDy + 16))
)
) begin
defusedDetect = 1;
end

// last bottom D
lasBotDx = 55 + 14;
lasBotDy = 96 + 6;
if
( 
(
((x == lasBotDx + 0) || (x == lasBotDx + 4))
&&((y >= lasBotDy + 0) && (y <= lasBotDy + 14))
)
||(
((x == lasBotDx + 1) || (x == lasBotDx + 3))
&&((y >= lasBotDy + 0) && (y <= lasBotDy + 15))
)
||(
(x == lasBotDx + 2)
&&((y >= lasBotDy + 0) && (y <= lasBotDy + 16))
)
) begin
defusedDetect = 1;
end

// first top D
firTopDx = 55 + 200;
firTopDy = 96 + 24;
if
( 
(
((x == firTopDx + 0) || (x == firTopDx + 4))
&&((y >= firTopDy + 2) && (y <= firTopDy + 16))
)
||(
((x == firTopDx + 1) || (x == firTopDx + 3))
&&((y >= firTopDy + 1) && (y <= firTopDy + 16))
)
||(
(x == firTopDx + 2)
&&((y >= firTopDy + 0) && (y <= firTopDy + 16))
)
) begin
defusedDetect = 1;
end

// last top D
lasTopDx = 55 + 14;
lasTopDy = 96 + 24;
if
( 
(
((x == lasTopDx + 0) || (x == lasTopDx + 4))
&&((y >= lasTopDy + 2) && (y <= lasTopDy + 16))
)
||(
((x == lasTopDx + 1) || (x == lasTopDx + 3))
&&((y >= lasTopDy + 1) && (y <= lasTopDy + 16))
)
||(
(x == lasTopDx + 2)
&&((y >= lasTopDy + 0) && (y <= lasTopDy + 16))
)
) begin
defusedDetect = 1;
end
end

always_ff @(negedge nrst, posedge clk) begin
  if(!nrst) begin
    defusedPixel <= 1'd0;
  end else begin
    defusedPixel <= defusedDetect;
  end
end
endmodule
