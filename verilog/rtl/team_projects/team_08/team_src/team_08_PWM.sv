typedef enum logic [18:0] {
OFF = 19'd0, DNOTEL = 410000, ENOTEL = 365000, FNOTEL = 345000, ANOTE = 265000, BNOTE = 225000, CNOTE = 205000, 
DNOTE = 165000 , ENOTE = 125000, FNOTE = 105000, GNOTE = 65000, BFLAT = 10000, LOW = 520000
} note_t;

module team_08_PWM (
input logic clk,
input logic nrst,
input logic enable,
input logic jump, gameover,
output logic out,
output logic light
);

logic [8:0] state;
logic [8:0] state_n;
logic [18:0] max_in, ratio_in;
logic [18:0] ratio_lookup [99:0];
logic [18:0] count;
logic [6:0] note;
logic innerlight;

fsm f1 (.clk(clk), .enable(enable), .over(gameover), .nrst(nrst), .state(note), .jump(jump));
counter counter1 (.clk(clk), .enable(enable), .nrst(nrst), .max(max_in), .ratio(ratio_in), .count(count), .out(out));

always_comb begin
   innerlight = enable;
       for (integer i = 0; i < 100; i++) begin
           if (state_n == i[8:0]) begin
               ratio_in = ratio_lookup[i];
           end 
           else begin
              ratio_in = ratio_lookup[0];
           end
       end

end

always_ff @(posedge clk, negedge nrst) begin
   if (nrst == 1'b0) begin
       state <= 9'b0;
   end
     else if (count == max_in) begin
       state <= state_n;
       light <= innerlight;
   end 
       else begin
       state <= state;
       light <= innerlight;
end
end

logic [18:0] MAX_IN_VALUES [26:0];
 /*= {
   BNOTE, ENOTEL, GNOTE, ENOTEL, BNOTE, ENOTEL, GNOTE, ENOTEL,
   ANOTE, DNOTEL, FNOTEL, DNOTEL, ANOTE, DNOTEL, FNOTEL, DNOTEL, 
   BNOTE, DNOTEL, FNOTEL, DNOTEL, BNOTE, DNOTEL, DNOTE, CNOTE, BNOTE, ANOTE, BNOTE
};*/

logic [18:0] ZERO_LOOKUP [99:0];
initial begin
   for (int i = 0; i < 27; i++) begin
      MAX_IN_VALUES[i] = 19'b0;

   end
end
initial begin
   for (int i = 0; i < 100; i++) begin
      ZERO_LOOKUP[i] = 19'b0;

   end
end

logic [18:0] LS_LOOKUP [99:0];
assign LS_LOOKUP = {
   19'd181818, 19'd193234, 19'd204606, 19'd215887, 19'd227034, 19'd238003, 19'd248750, 19'd259232, 19'd269409, 19'd279241,
   19'd288688, 19'd297713, 19'd306281, 19'd314358, 19'd321911, 19'd328912, 19'd335332, 19'd341146, 19'd346332, 19'd350868,
   19'd354737, 19'd357924, 19'd360416, 19'd362202, 19'd363277, 19'd363636, 19'd363277, 19'd362202, 19'd360416, 19'd357924,
   19'd354737, 19'd350868, 19'd346332, 19'd341146, 19'd335332, 19'd328912, 19'd321911, 19'd314358, 19'd306281, 19'd297713,
   19'd288688, 19'd279241, 19'd269409, 19'd259232, 19'd248750, 19'd238003, 19'd227034, 19'd215887, 19'd204606, 19'd193234,
   19'd181818, 19'd170402, 19'd159030, 19'd147749, 19'd136602, 19'd125633, 19'd114886, 19'd104404, 19'd94227, 19'd84395,
   19'd74948, 19'd65923, 19'd57355, 19'd49278, 19'd41725, 19'd34724, 19'd28304, 19'd22490, 19'd17304, 19'd12768,
   19'd8899, 19'd5712, 19'd3220, 19'd1434, 19'd359, 19'd0, 19'd359, 19'd1434, 19'd3220, 19'd5712,
   19'd8899, 19'd12768, 19'd17304, 19'd22490, 19'd28304, 19'd34724, 19'd41725, 19'd49278, 19'd57355, 19'd65923,
   19'd74948, 19'd84395, 19'd94227, 19'd104404, 19'd114886, 19'd125633, 19'd136602, 19'd147749, 19'd159030, 19'd170402};

note_t max_inOFF = OFF;

always_comb begin
   case(note) 
        0: begin
         max_in = MAX_IN_VALUES[0];
         ratio_lookup[0] = LS_LOOKUP[0];
         ratio_lookup[1] = LS_LOOKUP[1];
         ratio_lookup[2] = LS_LOOKUP[2];
         ratio_lookup[3] = LS_LOOKUP[3];
         ratio_lookup[4] = LS_LOOKUP[4];
         ratio_lookup[5] = LS_LOOKUP[5];
         ratio_lookup[6] = LS_LOOKUP[6];
         ratio_lookup[7] = LS_LOOKUP[7];
         ratio_lookup[8] = LS_LOOKUP[8];
         ratio_lookup[9] = LS_LOOKUP[9];
         ratio_lookup[10] = LS_LOOKUP[10];
         ratio_lookup[11] = LS_LOOKUP[11];
         ratio_lookup[12] = LS_LOOKUP[12];
         ratio_lookup[13] = LS_LOOKUP[13];
         ratio_lookup[14] = LS_LOOKUP[14];
         ratio_lookup[15] = LS_LOOKUP[15];
         ratio_lookup[16] = LS_LOOKUP[16];
         ratio_lookup[17] = LS_LOOKUP[17];
         ratio_lookup[18] = LS_LOOKUP[18];
      end
        2: begin
         max_in = MAX_IN_VALUES[1];
         ratio_lookup[0] = LS_LOOKUP[0];
         ratio_lookup[1] = LS_LOOKUP[1];
         ratio_lookup[2] = LS_LOOKUP[2];
         ratio_lookup[3] = LS_LOOKUP[3];
         ratio_lookup[4] = LS_LOOKUP[4];
         ratio_lookup[5] = LS_LOOKUP[5];
         ratio_lookup[6] = LS_LOOKUP[6];
         ratio_lookup[7] = LS_LOOKUP[7];
         ratio_lookup[8] = LS_LOOKUP[8];
         ratio_lookup[9] = LS_LOOKUP[9];
         ratio_lookup[10] = LS_LOOKUP[10];
         ratio_lookup[11] = LS_LOOKUP[11];
         ratio_lookup[12] = LS_LOOKUP[12];
         ratio_lookup[13] = LS_LOOKUP[13];
         ratio_lookup[14] = LS_LOOKUP[14];
         ratio_lookup[15] = LS_LOOKUP[15];
         ratio_lookup[16] = LS_LOOKUP[16];
         ratio_lookup[17] = LS_LOOKUP[17];
         ratio_lookup[18] = LS_LOOKUP[18];
      end
        4: begin
         max_in = MAX_IN_VALUES[2];
         ratio_lookup[0] = LS_LOOKUP[0];
         ratio_lookup[1] = LS_LOOKUP[1];
         ratio_lookup[2] = LS_LOOKUP[2];
         ratio_lookup[3] = LS_LOOKUP[3];
         ratio_lookup[4] = LS_LOOKUP[4];
         ratio_lookup[5] = LS_LOOKUP[5];
         ratio_lookup[6] = LS_LOOKUP[6];
         ratio_lookup[7] = LS_LOOKUP[7];
         ratio_lookup[8] = LS_LOOKUP[8];
         ratio_lookup[9] = LS_LOOKUP[9];
         ratio_lookup[10] = LS_LOOKUP[10];
         ratio_lookup[11] = LS_LOOKUP[11];
         ratio_lookup[12] = LS_LOOKUP[12];
         ratio_lookup[13] = LS_LOOKUP[13];
         ratio_lookup[14] = LS_LOOKUP[14];
         ratio_lookup[15] = LS_LOOKUP[15];
         ratio_lookup[16] = LS_LOOKUP[16];
         ratio_lookup[17] = LS_LOOKUP[17];
         ratio_lookup[18] = LS_LOOKUP[18];
      end
        6: begin
         max_in = MAX_IN_VALUES[3];
         ratio_lookup[0] = LS_LOOKUP[0];
         ratio_lookup[1] = LS_LOOKUP[1];
         ratio_lookup[2] = LS_LOOKUP[2];
         ratio_lookup[3] = LS_LOOKUP[3];
         ratio_lookup[4] = LS_LOOKUP[4];
         ratio_lookup[5] = LS_LOOKUP[5];
         ratio_lookup[6] = LS_LOOKUP[6];
         ratio_lookup[7] = LS_LOOKUP[7];
         ratio_lookup[8] = LS_LOOKUP[8];
         ratio_lookup[9] = LS_LOOKUP[9];
         ratio_lookup[10] = LS_LOOKUP[10];
         ratio_lookup[11] = LS_LOOKUP[11];
         ratio_lookup[12] = LS_LOOKUP[12];
         ratio_lookup[13] = LS_LOOKUP[13];
         ratio_lookup[14] = LS_LOOKUP[14];
         ratio_lookup[15] = LS_LOOKUP[15];
         ratio_lookup[16] = LS_LOOKUP[16];
         ratio_lookup[17] = LS_LOOKUP[17];
         ratio_lookup[18] = LS_LOOKUP[18];
      end
        8: begin
         max_in = MAX_IN_VALUES[4];
         ratio_lookup[0] = LS_LOOKUP[0];
         ratio_lookup[1] = LS_LOOKUP[1];
         ratio_lookup[2] = LS_LOOKUP[2];
         ratio_lookup[3] = LS_LOOKUP[3];
         ratio_lookup[4] = LS_LOOKUP[4];
         ratio_lookup[5] = LS_LOOKUP[5];
         ratio_lookup[6] = LS_LOOKUP[6];
         ratio_lookup[7] = LS_LOOKUP[7];
         ratio_lookup[8] = LS_LOOKUP[8];
         ratio_lookup[9] = LS_LOOKUP[9];
         ratio_lookup[10] = LS_LOOKUP[10];
         ratio_lookup[11] = LS_LOOKUP[11];
         ratio_lookup[12] = LS_LOOKUP[12];
         ratio_lookup[13] = LS_LOOKUP[13];
         ratio_lookup[14] = LS_LOOKUP[14];
         ratio_lookup[15] = LS_LOOKUP[15];
         ratio_lookup[16] = LS_LOOKUP[16];
         ratio_lookup[17] = LS_LOOKUP[17];
         ratio_lookup[18] = LS_LOOKUP[18];
      end
        10: begin
         max_in = MAX_IN_VALUES[5];
         ratio_lookup[0] = LS_LOOKUP[0];
         ratio_lookup[1] = LS_LOOKUP[1];
         ratio_lookup[2] = LS_LOOKUP[2];
         ratio_lookup[3] = LS_LOOKUP[3];
         ratio_lookup[4] = LS_LOOKUP[4];
         ratio_lookup[5] = LS_LOOKUP[5];
         ratio_lookup[6] = LS_LOOKUP[6];
         ratio_lookup[7] = LS_LOOKUP[7];
         ratio_lookup[8] = LS_LOOKUP[8];
         ratio_lookup[9] = LS_LOOKUP[9];
         ratio_lookup[10] = LS_LOOKUP[10];
         ratio_lookup[11] = LS_LOOKUP[11];
         ratio_lookup[12] = LS_LOOKUP[12];
         ratio_lookup[13] = LS_LOOKUP[13];
         ratio_lookup[14] = LS_LOOKUP[14];
         ratio_lookup[15] = LS_LOOKUP[15];
         ratio_lookup[16] = LS_LOOKUP[16];
         ratio_lookup[17] = LS_LOOKUP[17];
         ratio_lookup[18] = LS_LOOKUP[18];
      end
        12: begin
         max_in = MAX_IN_VALUES[6];
         ratio_lookup[0] = LS_LOOKUP[0];
         ratio_lookup[1] = LS_LOOKUP[1];
         ratio_lookup[2] = LS_LOOKUP[2];
         ratio_lookup[3] = LS_LOOKUP[3];
         ratio_lookup[4] = LS_LOOKUP[4];
         ratio_lookup[5] = LS_LOOKUP[5];
         ratio_lookup[6] = LS_LOOKUP[6];
         ratio_lookup[7] = LS_LOOKUP[7];
         ratio_lookup[8] = LS_LOOKUP[8];
         ratio_lookup[9] = LS_LOOKUP[9];
         ratio_lookup[10] = LS_LOOKUP[10];
         ratio_lookup[11] = LS_LOOKUP[11];
         ratio_lookup[12] = LS_LOOKUP[12];
         ratio_lookup[13] = LS_LOOKUP[13];
         ratio_lookup[14] = LS_LOOKUP[14];
         ratio_lookup[15] = LS_LOOKUP[15];
         ratio_lookup[16] = LS_LOOKUP[16];
         ratio_lookup[17] = LS_LOOKUP[17];
         ratio_lookup[18] = LS_LOOKUP[18];
      end
        14: begin
         max_in = MAX_IN_VALUES[7];
         ratio_lookup[0] = LS_LOOKUP[0];
         ratio_lookup[1] = LS_LOOKUP[1];
         ratio_lookup[2] = LS_LOOKUP[2];
         ratio_lookup[3] = LS_LOOKUP[3];
         ratio_lookup[4] = LS_LOOKUP[4];
         ratio_lookup[5] = LS_LOOKUP[5];
         ratio_lookup[6] = LS_LOOKUP[6];
         ratio_lookup[7] = LS_LOOKUP[7];
         ratio_lookup[8] = LS_LOOKUP[8];
         ratio_lookup[9] = LS_LOOKUP[9];
         ratio_lookup[10] = LS_LOOKUP[10];
         ratio_lookup[11] = LS_LOOKUP[11];
         ratio_lookup[12] = LS_LOOKUP[12];
         ratio_lookup[13] = LS_LOOKUP[13];
         ratio_lookup[14] = LS_LOOKUP[14];
         ratio_lookup[15] = LS_LOOKUP[15];
         ratio_lookup[16] = LS_LOOKUP[16];
         ratio_lookup[17] = LS_LOOKUP[17];
         ratio_lookup[18] = LS_LOOKUP[18];
      end
        16: begin
         max_in = MAX_IN_VALUES[8];
         ratio_lookup[0] = LS_LOOKUP[0];
         ratio_lookup[1] = LS_LOOKUP[1];
         ratio_lookup[2] = LS_LOOKUP[2];
         ratio_lookup[3] = LS_LOOKUP[3];
         ratio_lookup[4] = LS_LOOKUP[4];
         ratio_lookup[5] = LS_LOOKUP[5];
         ratio_lookup[6] = LS_LOOKUP[6];
         ratio_lookup[7] = LS_LOOKUP[7];
         ratio_lookup[8] = LS_LOOKUP[8];
         ratio_lookup[9] = LS_LOOKUP[9];
         ratio_lookup[10] = LS_LOOKUP[10];
         ratio_lookup[11] = LS_LOOKUP[11];
         ratio_lookup[12] = LS_LOOKUP[12];
         ratio_lookup[13] = LS_LOOKUP[13];
         ratio_lookup[14] = LS_LOOKUP[14];
         ratio_lookup[15] = LS_LOOKUP[15];
         ratio_lookup[16] = LS_LOOKUP[16];
         ratio_lookup[17] = LS_LOOKUP[17];
         ratio_lookup[18] = LS_LOOKUP[18];
      end
        18: begin
         max_in = MAX_IN_VALUES[9];
         ratio_lookup[0] = LS_LOOKUP[0];
         ratio_lookup[1] = LS_LOOKUP[1];
         ratio_lookup[2] = LS_LOOKUP[2];
         ratio_lookup[3] = LS_LOOKUP[3];
         ratio_lookup[4] = LS_LOOKUP[4];
         ratio_lookup[5] = LS_LOOKUP[5];
         ratio_lookup[6] = LS_LOOKUP[6];
         ratio_lookup[7] = LS_LOOKUP[7];
         ratio_lookup[8] = LS_LOOKUP[8];
         ratio_lookup[9] = LS_LOOKUP[9];
         ratio_lookup[10] = LS_LOOKUP[10];
         ratio_lookup[11] = LS_LOOKUP[11];
         ratio_lookup[12] = LS_LOOKUP[12];
         ratio_lookup[13] = LS_LOOKUP[13];
         ratio_lookup[14] = LS_LOOKUP[14];
         ratio_lookup[15] = LS_LOOKUP[15];
         ratio_lookup[16] = LS_LOOKUP[16];
         ratio_lookup[17] = LS_LOOKUP[17];
         ratio_lookup[18] = LS_LOOKUP[18];
      end
        20: begin
         max_in = MAX_IN_VALUES[10];
         ratio_lookup[0] = LS_LOOKUP[0];
         ratio_lookup[1] = LS_LOOKUP[1];
         ratio_lookup[2] = LS_LOOKUP[2];
         ratio_lookup[3] = LS_LOOKUP[3];
         ratio_lookup[4] = LS_LOOKUP[4];
         ratio_lookup[5] = LS_LOOKUP[5];
         ratio_lookup[6] = LS_LOOKUP[6];
         ratio_lookup[7] = LS_LOOKUP[7];
         ratio_lookup[8] = LS_LOOKUP[8];
         ratio_lookup[9] = LS_LOOKUP[9];
         ratio_lookup[10] = LS_LOOKUP[10];
         ratio_lookup[11] = LS_LOOKUP[11];
         ratio_lookup[12] = LS_LOOKUP[12];
         ratio_lookup[13] = LS_LOOKUP[13];
         ratio_lookup[14] = LS_LOOKUP[14];
         ratio_lookup[15] = LS_LOOKUP[15];
         ratio_lookup[16] = LS_LOOKUP[16];
         ratio_lookup[17] = LS_LOOKUP[17];
         ratio_lookup[18] = LS_LOOKUP[18];
      end
        22: begin
         max_in = MAX_IN_VALUES[11];
         ratio_lookup[0] = LS_LOOKUP[0];
         ratio_lookup[1] = LS_LOOKUP[1];
         ratio_lookup[2] = LS_LOOKUP[2];
         ratio_lookup[3] = LS_LOOKUP[3];
         ratio_lookup[4] = LS_LOOKUP[4];
         ratio_lookup[5] = LS_LOOKUP[5];
         ratio_lookup[6] = LS_LOOKUP[6];
         ratio_lookup[7] = LS_LOOKUP[7];
         ratio_lookup[8] = LS_LOOKUP[8];
         ratio_lookup[9] = LS_LOOKUP[9];
         ratio_lookup[10] = LS_LOOKUP[10];
         ratio_lookup[11] = LS_LOOKUP[11];
         ratio_lookup[12] = LS_LOOKUP[12];
         ratio_lookup[13] = LS_LOOKUP[13];
         ratio_lookup[14] = LS_LOOKUP[14];
         ratio_lookup[15] = LS_LOOKUP[15];
         ratio_lookup[16] = LS_LOOKUP[16];
         ratio_lookup[17] = LS_LOOKUP[17];
         ratio_lookup[18] = LS_LOOKUP[18];
      end
        24: begin
         max_in = MAX_IN_VALUES[12];
         ratio_lookup[0] = LS_LOOKUP[0];
         ratio_lookup[1] = LS_LOOKUP[1];
         ratio_lookup[2] = LS_LOOKUP[2];
         ratio_lookup[3] = LS_LOOKUP[3];
         ratio_lookup[4] = LS_LOOKUP[4];
         ratio_lookup[5] = LS_LOOKUP[5];
         ratio_lookup[6] = LS_LOOKUP[6];
         ratio_lookup[7] = LS_LOOKUP[7];
         ratio_lookup[8] = LS_LOOKUP[8];
         ratio_lookup[9] = LS_LOOKUP[9];
         ratio_lookup[10] = LS_LOOKUP[10];
         ratio_lookup[11] = LS_LOOKUP[11];
         ratio_lookup[12] = LS_LOOKUP[12];
         ratio_lookup[13] = LS_LOOKUP[13];
         ratio_lookup[14] = LS_LOOKUP[14];
         ratio_lookup[15] = LS_LOOKUP[15];
         ratio_lookup[16] = LS_LOOKUP[16];
         ratio_lookup[17] = LS_LOOKUP[17];
         ratio_lookup[18] = LS_LOOKUP[18];
      end
        26: begin
         max_in = MAX_IN_VALUES[13];
         ratio_lookup[0] = LS_LOOKUP[0];
         ratio_lookup[1] = LS_LOOKUP[1];
         ratio_lookup[2] = LS_LOOKUP[2];
         ratio_lookup[3] = LS_LOOKUP[3];
         ratio_lookup[4] = LS_LOOKUP[4];
         ratio_lookup[5] = LS_LOOKUP[5];
         ratio_lookup[6] = LS_LOOKUP[6];
         ratio_lookup[7] = LS_LOOKUP[7];
         ratio_lookup[8] = LS_LOOKUP[8];
         ratio_lookup[9] = LS_LOOKUP[9];
         ratio_lookup[10] = LS_LOOKUP[10];
         ratio_lookup[11] = LS_LOOKUP[11];
         ratio_lookup[12] = LS_LOOKUP[12];
         ratio_lookup[13] = LS_LOOKUP[13];
         ratio_lookup[14] = LS_LOOKUP[14];
         ratio_lookup[15] = LS_LOOKUP[15];
         ratio_lookup[16] = LS_LOOKUP[16];
         ratio_lookup[17] = LS_LOOKUP[17];
         ratio_lookup[18] = LS_LOOKUP[18];
      end
        28: begin
         max_in = MAX_IN_VALUES[14];
         ratio_lookup[0] = LS_LOOKUP[0];
         ratio_lookup[1] = LS_LOOKUP[1];
         ratio_lookup[2] = LS_LOOKUP[2];
         ratio_lookup[3] = LS_LOOKUP[3];
         ratio_lookup[4] = LS_LOOKUP[4];
         ratio_lookup[5] = LS_LOOKUP[5];
         ratio_lookup[6] = LS_LOOKUP[6];
         ratio_lookup[7] = LS_LOOKUP[7];
         ratio_lookup[8] = LS_LOOKUP[8];
         ratio_lookup[9] = LS_LOOKUP[9];
         ratio_lookup[10] = LS_LOOKUP[10];
         ratio_lookup[11] = LS_LOOKUP[11];
         ratio_lookup[12] = LS_LOOKUP[12];
         ratio_lookup[13] = LS_LOOKUP[13];
         ratio_lookup[14] = LS_LOOKUP[14];
         ratio_lookup[15] = LS_LOOKUP[15];
         ratio_lookup[16] = LS_LOOKUP[16];
         ratio_lookup[17] = LS_LOOKUP[17];
         ratio_lookup[18] = LS_LOOKUP[18];
      end
        30: begin
         max_in = MAX_IN_VALUES[15];
         ratio_lookup[0] = LS_LOOKUP[0];
         ratio_lookup[1] = LS_LOOKUP[1];
         ratio_lookup[2] = LS_LOOKUP[2];
         ratio_lookup[3] = LS_LOOKUP[3];
         ratio_lookup[4] = LS_LOOKUP[4];
         ratio_lookup[5] = LS_LOOKUP[5];
         ratio_lookup[6] = LS_LOOKUP[6];
         ratio_lookup[7] = LS_LOOKUP[7];
         ratio_lookup[8] = LS_LOOKUP[8];
         ratio_lookup[9] = LS_LOOKUP[9];
         ratio_lookup[10] = LS_LOOKUP[10];
         ratio_lookup[11] = LS_LOOKUP[11];
         ratio_lookup[12] = LS_LOOKUP[12];
         ratio_lookup[13] = LS_LOOKUP[13];
         ratio_lookup[14] = LS_LOOKUP[14];
         ratio_lookup[15] = LS_LOOKUP[15];
         ratio_lookup[16] = LS_LOOKUP[16];
         ratio_lookup[17] = LS_LOOKUP[17];
         ratio_lookup[18] = LS_LOOKUP[18];
      end
        32: begin
         max_in = MAX_IN_VALUES[16];
         ratio_lookup[0] = LS_LOOKUP[0];
         ratio_lookup[1] = LS_LOOKUP[1];
         ratio_lookup[2] = LS_LOOKUP[2];
         ratio_lookup[3] = LS_LOOKUP[3];
         ratio_lookup[4] = LS_LOOKUP[4];
         ratio_lookup[5] = LS_LOOKUP[5];
         ratio_lookup[6] = LS_LOOKUP[6];
         ratio_lookup[7] = LS_LOOKUP[7];
         ratio_lookup[8] = LS_LOOKUP[8];
         ratio_lookup[9] = LS_LOOKUP[9];
         ratio_lookup[10] = LS_LOOKUP[10];
         ratio_lookup[11] = LS_LOOKUP[11];
         ratio_lookup[12] = LS_LOOKUP[12];
         ratio_lookup[13] = LS_LOOKUP[13];
         ratio_lookup[14] = LS_LOOKUP[14];
         ratio_lookup[15] = LS_LOOKUP[15];
         ratio_lookup[16] = LS_LOOKUP[16];
         ratio_lookup[17] = LS_LOOKUP[17];
         ratio_lookup[18] = LS_LOOKUP[18];
      end
        34: begin
         max_in = MAX_IN_VALUES[17];
         ratio_lookup[0] = LS_LOOKUP[0];
         ratio_lookup[1] = LS_LOOKUP[1];
         ratio_lookup[2] = LS_LOOKUP[2];
         ratio_lookup[3] = LS_LOOKUP[3];
         ratio_lookup[4] = LS_LOOKUP[4];
         ratio_lookup[5] = LS_LOOKUP[5];
         ratio_lookup[6] = LS_LOOKUP[6];
         ratio_lookup[7] = LS_LOOKUP[7];
         ratio_lookup[8] = LS_LOOKUP[8];
         ratio_lookup[9] = LS_LOOKUP[9];
         ratio_lookup[10] = LS_LOOKUP[10];
         ratio_lookup[11] = LS_LOOKUP[11];
         ratio_lookup[12] = LS_LOOKUP[12];
         ratio_lookup[13] = LS_LOOKUP[13];
         ratio_lookup[14] = LS_LOOKUP[14];
         ratio_lookup[15] = LS_LOOKUP[15];
         ratio_lookup[16] = LS_LOOKUP[16];
         ratio_lookup[17] = LS_LOOKUP[17];
         ratio_lookup[18] = LS_LOOKUP[18];
      end
        36: begin
         max_in = MAX_IN_VALUES[18];
         ratio_lookup[0] = LS_LOOKUP[0];
         ratio_lookup[1] = LS_LOOKUP[1];
         ratio_lookup[2] = LS_LOOKUP[2];
         ratio_lookup[3] = LS_LOOKUP[3];
         ratio_lookup[4] = LS_LOOKUP[4];
         ratio_lookup[5] = LS_LOOKUP[5];
         ratio_lookup[6] = LS_LOOKUP[6];
         ratio_lookup[7] = LS_LOOKUP[7];
         ratio_lookup[8] = LS_LOOKUP[8];
         ratio_lookup[9] = LS_LOOKUP[9];
         ratio_lookup[10] = LS_LOOKUP[10];
         ratio_lookup[11] = LS_LOOKUP[11];
         ratio_lookup[12] = LS_LOOKUP[12];
         ratio_lookup[13] = LS_LOOKUP[13];
         ratio_lookup[14] = LS_LOOKUP[14];
         ratio_lookup[15] = LS_LOOKUP[15];
         ratio_lookup[16] = LS_LOOKUP[16];
         ratio_lookup[17] = LS_LOOKUP[17];
         ratio_lookup[18] = LS_LOOKUP[18];
      end
        38: begin
         max_in = MAX_IN_VALUES[19];
         ratio_lookup[0] = LS_LOOKUP[0];
         ratio_lookup[1] = LS_LOOKUP[1];
         ratio_lookup[2] = LS_LOOKUP[2];
         ratio_lookup[3] = LS_LOOKUP[3];
         ratio_lookup[4] = LS_LOOKUP[4];
         ratio_lookup[5] = LS_LOOKUP[5];
         ratio_lookup[6] = LS_LOOKUP[6];
         ratio_lookup[7] = LS_LOOKUP[7];
         ratio_lookup[8] = LS_LOOKUP[8];
         ratio_lookup[9] = LS_LOOKUP[9];
         ratio_lookup[10] = LS_LOOKUP[10];
         ratio_lookup[11] = LS_LOOKUP[11];
         ratio_lookup[12] = LS_LOOKUP[12];
         ratio_lookup[13] = LS_LOOKUP[13];
         ratio_lookup[14] = LS_LOOKUP[14];
         ratio_lookup[15] = LS_LOOKUP[15];
         ratio_lookup[16] = LS_LOOKUP[16];
         ratio_lookup[17] = LS_LOOKUP[17];
         ratio_lookup[18] = LS_LOOKUP[18];
      end
        40: begin
         max_in = MAX_IN_VALUES[20];
         ratio_lookup[0] = LS_LOOKUP[0];
         ratio_lookup[1] = LS_LOOKUP[1];
         ratio_lookup[2] = LS_LOOKUP[2];
         ratio_lookup[3] = LS_LOOKUP[3];
         ratio_lookup[4] = LS_LOOKUP[4];
         ratio_lookup[5] = LS_LOOKUP[5];
         ratio_lookup[6] = LS_LOOKUP[6];
         ratio_lookup[7] = LS_LOOKUP[7];
         ratio_lookup[8] = LS_LOOKUP[8];
         ratio_lookup[9] = LS_LOOKUP[9];
         ratio_lookup[10] = LS_LOOKUP[10];
         ratio_lookup[11] = LS_LOOKUP[11];
         ratio_lookup[12] = LS_LOOKUP[12];
         ratio_lookup[13] = LS_LOOKUP[13];
         ratio_lookup[14] = LS_LOOKUP[14];
         ratio_lookup[15] = LS_LOOKUP[15];
         ratio_lookup[16] = LS_LOOKUP[16];
         ratio_lookup[17] = LS_LOOKUP[17];
         ratio_lookup[18] = LS_LOOKUP[18];
      end
        42: begin
         max_in = MAX_IN_VALUES[21];
         ratio_lookup[0] = LS_LOOKUP[0];
         ratio_lookup[1] = LS_LOOKUP[1];
         ratio_lookup[2] = LS_LOOKUP[2];
         ratio_lookup[3] = LS_LOOKUP[3];
         ratio_lookup[4] = LS_LOOKUP[4];
         ratio_lookup[5] = LS_LOOKUP[5];
         ratio_lookup[6] = LS_LOOKUP[6];
         ratio_lookup[7] = LS_LOOKUP[7];
         ratio_lookup[8] = LS_LOOKUP[8];
         ratio_lookup[9] = LS_LOOKUP[9];
         ratio_lookup[10] = LS_LOOKUP[10];
         ratio_lookup[11] = LS_LOOKUP[11];
         ratio_lookup[12] = LS_LOOKUP[12];
         ratio_lookup[13] = LS_LOOKUP[13];
         ratio_lookup[14] = LS_LOOKUP[14];
         ratio_lookup[15] = LS_LOOKUP[15];
         ratio_lookup[16] = LS_LOOKUP[16];
         ratio_lookup[17] = LS_LOOKUP[17];
         ratio_lookup[18] = LS_LOOKUP[18];
      end
        44: begin
         max_in = MAX_IN_VALUES[22];
         ratio_lookup[0] = LS_LOOKUP[0];
         ratio_lookup[1] = LS_LOOKUP[1];
         ratio_lookup[2] = LS_LOOKUP[2];
         ratio_lookup[3] = LS_LOOKUP[3];
         ratio_lookup[4] = LS_LOOKUP[4];
         ratio_lookup[5] = LS_LOOKUP[5];
         ratio_lookup[6] = LS_LOOKUP[6];
         ratio_lookup[7] = LS_LOOKUP[7];
         ratio_lookup[8] = LS_LOOKUP[8];
         ratio_lookup[9] = LS_LOOKUP[9];
         ratio_lookup[10] = LS_LOOKUP[10];
         ratio_lookup[11] = LS_LOOKUP[11];
         ratio_lookup[12] = LS_LOOKUP[12];
         ratio_lookup[13] = LS_LOOKUP[13];
         ratio_lookup[14] = LS_LOOKUP[14];
         ratio_lookup[15] = LS_LOOKUP[15];
         ratio_lookup[16] = LS_LOOKUP[16];
         ratio_lookup[17] = LS_LOOKUP[17];
         ratio_lookup[18] = LS_LOOKUP[18];
      end
        46: begin
         max_in = MAX_IN_VALUES[23];
         ratio_lookup[0] = LS_LOOKUP[0];
         ratio_lookup[1] = LS_LOOKUP[1];
         ratio_lookup[2] = LS_LOOKUP[2];
         ratio_lookup[3] = LS_LOOKUP[3];
         ratio_lookup[4] = LS_LOOKUP[4];
         ratio_lookup[5] = LS_LOOKUP[5];
         ratio_lookup[6] = LS_LOOKUP[6];
         ratio_lookup[7] = LS_LOOKUP[7];
         ratio_lookup[8] = LS_LOOKUP[8];
         ratio_lookup[9] = LS_LOOKUP[9];
         ratio_lookup[10] = LS_LOOKUP[10];
         ratio_lookup[11] = LS_LOOKUP[11];
         ratio_lookup[12] = LS_LOOKUP[12];
         ratio_lookup[13] = LS_LOOKUP[13];
         ratio_lookup[14] = LS_LOOKUP[14];
         ratio_lookup[15] = LS_LOOKUP[15];
         ratio_lookup[16] = LS_LOOKUP[16];
         ratio_lookup[17] = LS_LOOKUP[17];
         ratio_lookup[18] = LS_LOOKUP[18];
      end
        48: begin
         max_in = MAX_IN_VALUES[24];
         ratio_lookup[0] = LS_LOOKUP[0];
         ratio_lookup[1] = LS_LOOKUP[1];
         ratio_lookup[2] = LS_LOOKUP[2];
         ratio_lookup[3] = LS_LOOKUP[3];
         ratio_lookup[4] = LS_LOOKUP[4];
         ratio_lookup[5] = LS_LOOKUP[5];
         ratio_lookup[6] = LS_LOOKUP[6];
         ratio_lookup[7] = LS_LOOKUP[7];
         ratio_lookup[8] = LS_LOOKUP[8];
         ratio_lookup[9] = LS_LOOKUP[9];
         ratio_lookup[10] = LS_LOOKUP[10];
         ratio_lookup[11] = LS_LOOKUP[11];
         ratio_lookup[12] = LS_LOOKUP[12];
         ratio_lookup[13] = LS_LOOKUP[13];
         ratio_lookup[14] = LS_LOOKUP[14];
         ratio_lookup[15] = LS_LOOKUP[15];
         ratio_lookup[16] = LS_LOOKUP[16];
         ratio_lookup[17] = LS_LOOKUP[17];
         ratio_lookup[18] = LS_LOOKUP[18];
      end
        50: begin
         max_in = MAX_IN_VALUES[25];
         ratio_lookup[0] = LS_LOOKUP[0];
         ratio_lookup[1] = LS_LOOKUP[1];
         ratio_lookup[2] = LS_LOOKUP[2];
         ratio_lookup[3] = LS_LOOKUP[3];
         ratio_lookup[4] = LS_LOOKUP[4];
         ratio_lookup[5] = LS_LOOKUP[5];
         ratio_lookup[6] = LS_LOOKUP[6];
         ratio_lookup[7] = LS_LOOKUP[7];
         ratio_lookup[8] = LS_LOOKUP[8];
         ratio_lookup[9] = LS_LOOKUP[9];
         ratio_lookup[10] = LS_LOOKUP[10];
         ratio_lookup[11] = LS_LOOKUP[11];
         ratio_lookup[12] = LS_LOOKUP[12];
         ratio_lookup[13] = LS_LOOKUP[13];
         ratio_lookup[14] = LS_LOOKUP[14];
         ratio_lookup[15] = LS_LOOKUP[15];
         ratio_lookup[16] = LS_LOOKUP[16];
         ratio_lookup[17] = LS_LOOKUP[17];
         ratio_lookup[18] = LS_LOOKUP[18];
      end
        52: begin
         max_in = MAX_IN_VALUES[26];
         ratio_lookup[0] = LS_LOOKUP[0];
         ratio_lookup[1] = LS_LOOKUP[1];
         ratio_lookup[2] = LS_LOOKUP[2];
         ratio_lookup[3] = LS_LOOKUP[3];
         ratio_lookup[4] = LS_LOOKUP[4];
         ratio_lookup[5] = LS_LOOKUP[5];
         ratio_lookup[6] = LS_LOOKUP[6];
         ratio_lookup[7] = LS_LOOKUP[7];
         ratio_lookup[8] = LS_LOOKUP[8];
         ratio_lookup[9] = LS_LOOKUP[9];
         ratio_lookup[10] = LS_LOOKUP[10];
         ratio_lookup[11] = LS_LOOKUP[11];
         ratio_lookup[12] = LS_LOOKUP[12];
         ratio_lookup[13] = LS_LOOKUP[13];
         ratio_lookup[14] = LS_LOOKUP[14];
         ratio_lookup[15] = LS_LOOKUP[15];
         ratio_lookup[16] = LS_LOOKUP[16];
         ratio_lookup[17] = LS_LOOKUP[17];
         ratio_lookup[18] = LS_LOOKUP[18];
      end
      53: begin
         max_in = BFLAT;
         ratio_lookup[0] = LS_LOOKUP[0];
         ratio_lookup[1] = LS_LOOKUP[1];
         ratio_lookup[2] = LS_LOOKUP[2];
         ratio_lookup[3] = LS_LOOKUP[3];
         ratio_lookup[4] = LS_LOOKUP[4];
         ratio_lookup[5] = LS_LOOKUP[5];
         ratio_lookup[6] = LS_LOOKUP[6];
         ratio_lookup[7] = LS_LOOKUP[7];
         ratio_lookup[8] = LS_LOOKUP[8];
         ratio_lookup[9] = LS_LOOKUP[9];
         ratio_lookup[10] = LS_LOOKUP[10];
         ratio_lookup[11] = LS_LOOKUP[11];
         ratio_lookup[12] = LS_LOOKUP[12];
         ratio_lookup[13] = LS_LOOKUP[13];
         ratio_lookup[14] = LS_LOOKUP[14];
         ratio_lookup[15] = LS_LOOKUP[15];
         ratio_lookup[16] = LS_LOOKUP[16];
         ratio_lookup[17] = LS_LOOKUP[17];
         ratio_lookup[18] = LS_LOOKUP[18];
      end
      54: begin
         max_in = LOW;
         ratio_lookup[0] = LS_LOOKUP[0];
         ratio_lookup[1] = LS_LOOKUP[1];
         ratio_lookup[2] = LS_LOOKUP[2];
         ratio_lookup[3] = LS_LOOKUP[3];
         ratio_lookup[4] = LS_LOOKUP[4];
         ratio_lookup[5] = LS_LOOKUP[5];
         ratio_lookup[6] = LS_LOOKUP[6];
         ratio_lookup[7] = LS_LOOKUP[7];
         ratio_lookup[8] = LS_LOOKUP[8];
         ratio_lookup[9] = LS_LOOKUP[9];
         ratio_lookup[10] = LS_LOOKUP[10];
         ratio_lookup[11] = LS_LOOKUP[11];
         ratio_lookup[12] = LS_LOOKUP[12];
         ratio_lookup[13] = LS_LOOKUP[13];
         ratio_lookup[14] = LS_LOOKUP[14];
         ratio_lookup[15] = LS_LOOKUP[15];
         ratio_lookup[16] = LS_LOOKUP[16];
         ratio_lookup[17] = LS_LOOKUP[17];
         ratio_lookup[18] = LS_LOOKUP[18];
      end
      default:begin
         max_in = OFF;
         ratio_lookup[0] = ZERO_LOOKUP[0];
         ratio_lookup[1] = ZERO_LOOKUP[1];
         ratio_lookup[2] = ZERO_LOOKUP[2];
         ratio_lookup[3] = ZERO_LOOKUP[3];
         ratio_lookup[4] = ZERO_LOOKUP[4];
         ratio_lookup[5] = ZERO_LOOKUP[5];
         ratio_lookup[6] = ZERO_LOOKUP[6];
         ratio_lookup[7] = ZERO_LOOKUP[7];
         ratio_lookup[8] = ZERO_LOOKUP[8];
         ratio_lookup[9] = ZERO_LOOKUP[9];
         ratio_lookup[10] = ZERO_LOOKUP[10];
         ratio_lookup[11] = ZERO_LOOKUP[11];
         ratio_lookup[12] = ZERO_LOOKUP[12];
         ratio_lookup[13] = ZERO_LOOKUP[13];
         ratio_lookup[14] = ZERO_LOOKUP[14];
         ratio_lookup[15] = ZERO_LOOKUP[15];
         ratio_lookup[16] = ZERO_LOOKUP[16];
         ratio_lookup[17] = ZERO_LOOKUP[17];
         ratio_lookup[18] = ZERO_LOOKUP[18];
      end
   endcase
end 
endmodule

module counter (

input logic clk,
input logic nrst,
input logic [18:0] max,
input logic enable,
input logic [18:0] ratio,
output logic [18:0] count,
output logic out
);

//logic [14:0] count;
logic [18:0] count_n;
logic [18:0] count1;
logic [18:0] count1_n;




always_comb begin

       
   if (count < ratio) begin
       count_n = count + 10;
   end else begin
       count_n = 19'b0;
   end
   if (count1 < max) begin
       count1_n = count1 + 10;
   end else begin
       count1_n = 19'b0;
   end
end

always_ff @(posedge clk, negedge nrst) begin
   if (nrst == 1'b0) begin
       count <= 19'b0;
       count1 <= 19'b0;
   end 
   else if (enable == 1'b0) begin
       count <= 19'b0;
       count1 <= 19'b0;
   end
   else begin
       count <= count_n;
       count1 <= count1_n;
   end
end

always_comb begin
   if (count >= count1) begin
       out = 1'b1;
   end else begin
       out = 1'b0;
   end
end

endmodule



module fsm (
 input logic clk, nrst,
 input logic enable, jump, over,
 output logic [6:0] state
);
 logic [6:0] next_state, previous_s;
 logic out_clk;
 logic out_enable;

 clk_div  c1 (.max_i(5'd25), .count(), .clk(clk), .nrst(nrst), .atmax_o(out_clk));
 clk_enable a1 (.max_i(16'd50000), .clk(clk), .nrst(nrst), .enable(enable), .count(), .out_enable(out_enable));

 always_comb begin
        if (jump == 1) begin
            next_state = 53;
        end else begin
            next_state = state + 1;
            if (next_state >= 52) begin
                next_state = 0;
        end
        case(state)
            53: next_state = previous_s;
            endcase
        end
        if (next_state == 53 && previous_s == 53) begin
            next_state = 52;
        end
        if (over) begin
            next_state = 54;
        end
    end

   always_ff @(posedge clk, negedge nrst) begin
   if (nrst == 1'b0) begin
      state <= 0;
      previous_s <= 0;
   end else if (enable) begin
        if (out_clk == 1'b1) begin
            if (out_enable == 1'b1) begin
           state <= next_state;
           previous_s <= state;
            end
       end
    else begin
      state <= state;
      previous_s <= previous_s; 
    end
   end
 end

endmodule

module clk_div (
input logic clk,
input logic nrst,
input logic [4:0]max_i,
output logic [4:0] count,
output logic atmax_o
);


logic [4:0] innerCount;


always_comb begin


innerCount = count + 1;
if (count == max_i)
  innerCount = 5'b0;
  
atmax_o = (count == max_i);


end


always_ff @ (posedge clk, negedge nrst) begin
if (nrst == 1'b0) begin
 count <= 5'b0;
end
else begin
 count <= innerCount;
end
end


endmodule


module clk_enable (
input logic clk,
input logic nrst,
input logic [15:0] max_i,
input logic enable,
output logic [15:0] count,
output logic out_enable
);


logic [15:0] innerCount;

always_comb begin


innerCount = count + 1;
if (count == max_i)
  innerCount = 16'b0;
  
out_enable = (count == max_i);


end


always_ff @ (posedge clk, negedge nrst) begin
if (nrst == 1'b0) begin
 count <= 16'b0;
end
else begin
 if (enable == 1'b1) begin
 count <= innerCount;
 end
end
end


endmodule