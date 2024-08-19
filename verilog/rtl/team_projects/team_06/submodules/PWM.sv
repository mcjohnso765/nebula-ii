
typedef enum logic [5:0] {
OPEN = 0, LS0=1, LS1=2, LS2=3, LS3=4, LS4=5, LS5=6, LS6=7, LS7=8, LS8=9, LS9=10, LS10=11, LS11=12, LS12=13, LS13=14, LS14=15, LS15=16, LS16=17, LS17=18,
LS18=19, LS19=20, LS20=21, LS21=22, LS22=23, LS23=24, LS24=25, LS25=26, LS26=27, LS27=28, LS28=29, LS29=30, LS30=31, LS31=32, LS32 = 33,
GOOD=34, BAD=35
} state_t;

module PWM (
input logic clk,
input logic nrst,
input logic enable,
input logic goodCollision,
input logic badCollision,
output logic out
);

logic [8:0] state;
logic [18:0] max_in, ratio_in;
logic [18:0] ratio_lookup;
// logic [18:0] count;
state_t note;

fsm f1 (.clk(clk), .enable(enable), .goodCollision(goodCollision), .badCollision(badCollision), .nrst(nrst), .state(note));
sound notes (.note(note), .max_in(max_in), .ratio_lookup(ratio_lookup));
counter counter1 (.clk(clk), .enable(enable), .nrst(nrst), .max(max_in), .ratio(ratio_in), .out(out));

always_comb begin
//        for (integer i = 0; i < 100; i++) begin
//            if (state_n == i[8:0]) begin
    //max_in = max_lookup[i];
//                ratio_in = ratio_lookup[i];
//            end 
//            else begin
               ratio_in = ratio_lookup;
//            end
//        end

end

always_ff @(posedge clk, negedge nrst) begin
    if (nrst == 1'b0) begin
        state <= 9'b0;
    end
//      else if (count == max_in) begin
//        state <= state_n;
//    end 
        else begin
        state <= state;
end
end
endmodule

module counter (

input logic clk,
input logic nrst,
input logic [18:0] max,
input logic enable,
input logic [18:0] ratio,
output logic out
);

//logic [14:0] count;
logic [18:0] count_n, count;
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

typedef enum logic [18:0] {
BFLAT = 520000, BNOTE = 482500, CNOTE = 460000, CSHARP = 435000, DNOTE = 410000, EFLAT = 385000, ENOTE = 365000, FNOTE = 345000,
FSHARP = 325000, GNOTE = 305000, GSHARP = 285000, ANOTE = 265000, BFLAT1 = 245000, BNOTE1 = 225000, CNOTE1 = 205000, CSHARP1 = 185000, 
DNOTE1 = 165000, EFLAT1 = 145000, ENOTE1 = 125000, FNOTE1 = 105000, FSHARP1 = 85000, GNOTE1 = 65000, GSHARP1 = 45000, ANOTE1 = 25000, 
BFLAT2 = 5000, OFF = 0
} note_t;

module sound (
    input state_t note,
    output logic [18:0] max_in,
    output logic [18:0] ratio_lookup
);

logic [18:0] max_inOFF = 19'd0;
logic [18:0] goodSound = CNOTE;

//Losing Sound
logic [18:0] badSound =  BFLAT;

// //Music
// note_t max_in0 = GNOTE;
// note_t max_in1 = OFF;
// note_t max_in2 = ENOTE;
// note_t max_in3 = OFF;
// note_t max_in4 = DNOTE;
// note_t max_in5 = OFF;
// note_t max_in6 = ENOTE;
// note_t max_in7 = OFF;
// //
// note_t max_in8 = ANOTE;
// note_t max_in9 = OFF;
// note_t max_in10 = ENOTE;
// note_t max_in11 = OFF;
// note_t max_in12 = ENOTE;
// note_t max_in13 = OFF;
// note_t max_in14 = ENOTE;
// note_t max_in15 = OFF;
// //
// note_t max_in16 = BNOTE;
// note_t max_in17 = OFF;
// note_t max_in18 = ENOTE;
// note_t max_in19 = OFF;
// note_t max_in20 = FNOTE;
// note_t max_in21 = OFF;
// note_t max_in22 = ENOTE;
// note_t max_in23 = OFF;
// //
// note_t max_in24 = CNOTE;
// note_t max_in25 = OFF;
// note_t max_in26 = ENOTE;
// note_t max_in27 = OFF;
// note_t max_in28 = GNOTE;
// note_t max_in29 = OFF;
// note_t max_in30 = ENOTE;
// note_t max_in31 = OFF;

// //Music
// note_t max_in0 = BFLAT;
// note_t max_in1 = OFF;
// note_t max_in2 = CNOTE;
// note_t max_in3 = OFF;
// note_t max_in4 = DNOTE;
// note_t max_in5 = OFF;
// note_t max_in6 = ENOTE;
// note_t max_in7 = OFF;
// //
// note_t max_in8 = FSHARP;
// note_t max_in9 = OFF;
// note_t max_in10 = GSHARP;
// note_t max_in11 = OFF;
// note_t max_in12 = BFLAT;
// note_t max_in13 = OFF;
// note_t max_in14 = CNOTE;
// note_t max_in15 = OFF;
// //
// note_t max_in16 = DNOTE;
// note_t max_in17 = OFF;
// note_t max_in18 = ENOTE;
// note_t max_in19 = OFF;
// note_t max_in20 = FSHARP;
// note_t max_in21 = OFF;
// note_t max_in22 = GSHARP;
// note_t max_in23 = OFF;
// //
// note_t max_in24 = BFLAT;
// note_t max_in25 = OFF;
// note_t max_in26 = CNOTE;
// note_t max_in27 = OFF;
// note_t max_in28 = DNOTE;
// note_t max_in29 = OFF;
// note_t max_in30 = ENOTE;
// note_t max_in31 = OFF;

//Music
note_t max_in0 = GNOTE;
note_t max_in1 = OFF;
note_t max_in2 = BNOTE;
note_t max_in3 = OFF;
note_t max_in4 = DNOTE;
note_t max_in5 = OFF;
note_t max_in6 = BNOTE;
note_t max_in7 = OFF;
//
note_t max_in8 = GNOTE;
note_t max_in9 = OFF;
note_t max_in10 = BNOTE;
note_t max_in11 = OFF;
note_t max_in12 = ENOTE;
note_t max_in13 = OFF;
note_t max_in14 = BNOTE;
note_t max_in15 = OFF;
//
note_t max_in16 = DNOTE;
note_t max_in17 = OFF;
note_t max_in18 = BNOTE;
note_t max_in19 = OFF;
note_t max_in20 = DNOTE;
note_t max_in21 = OFF;
note_t max_in22 = BNOTE;
note_t max_in23 = OFF;
//
note_t max_in24 = DNOTE;
note_t max_in25 = OFF;
note_t max_in26 = BNOTE;
note_t max_in27 = OFF;
note_t max_in28 = CNOTE;
note_t max_in29 = OFF;
note_t max_in30 = BNOTE;
note_t max_in31 = OFF;


logic [18:0] restArray = 19'd0;    

logic [18:0] soundArray = 19'd170402;
    
always_comb begin
    case(note) 
     OPEN: begin
         max_in = max_inOFF;
         ratio_lookup = restArray;
        end
    LS0: begin
         max_in = max_in0;
         if (max_in == 0) begin
            ratio_lookup = restArray;
         end else begin
            ratio_lookup = soundArray;
         end
         end
    LS1: begin
         max_in = max_in1;
        if (max_in == 0) begin
            ratio_lookup = restArray;
         end else begin
            ratio_lookup = soundArray;
         end
        end
    LS2:begin
        max_in = max_in2;
        if (max_in == 0) begin
            ratio_lookup = restArray;
         end else begin
            ratio_lookup = soundArray;
         end       
        end
    LS3: begin
         max_in = max_in3;
        if (max_in == 0) begin
            ratio_lookup = restArray;
         end else begin
            ratio_lookup = soundArray;
         end       
        end
    LS4:begin
        max_in = max_in4;
        if (max_in == 0) begin
            ratio_lookup = restArray;
         end else begin
            ratio_lookup = soundArray;
         end              
        end
    LS5:begin
        max_in = max_in5;
        if (max_in == 0) begin
            ratio_lookup = restArray;
         end else begin
            ratio_lookup = soundArray;
         end       
        end
    LS6:begin
        max_in = max_in6;
        if (max_in == 0) begin
            ratio_lookup = restArray;
         end else begin
            ratio_lookup = soundArray;
         end       
        end
    LS7: begin
        max_in = max_in7;
        if (max_in == 0) begin
            ratio_lookup = restArray;
         end else begin
            ratio_lookup = soundArray;
         end       
        end
    LS8:begin
        max_in = max_in8;
        if (max_in == 0) begin
            ratio_lookup = restArray;
         end else begin
            ratio_lookup = soundArray;
         end       
        end
    LS9: begin
        max_in = max_in9;
        if (max_in == 0) begin
            ratio_lookup = restArray;
         end else begin
            ratio_lookup = soundArray;
         end       
        end
    LS10:begin
        //Note change1
        max_in = max_in10;
        if (max_in == 0) begin
            ratio_lookup = restArray;
         end else begin
            ratio_lookup = soundArray;
         end       
        end
    LS11: begin
        max_in = max_in11;
        if (max_in == 0) begin
            ratio_lookup = restArray;
         end else begin
            ratio_lookup = soundArray;
         end       
      end
 LS12: begin
      //Note change2
        max_in = max_in12;
        if (max_in == 0) begin
            ratio_lookup = restArray;
         end else begin
            ratio_lookup = soundArray;
         end       
       end
 LS13: begin
        max_in = max_in13;
        if (max_in == 0) begin
            ratio_lookup = restArray;
         end else begin
            ratio_lookup = soundArray;
         end       
        end
 LS14:  begin
      max_in = max_in14;
        if (max_in == 0) begin
            ratio_lookup = restArray;
         end else begin
            ratio_lookup = soundArray;
         end       
        end
LS15:  begin
       max_in = max_in15;
        if (max_in == 0) begin
            ratio_lookup = restArray;
         end else begin
            ratio_lookup = soundArray;
         end       
        end
LS16:  begin
      max_in = max_in16;
        if (max_in == 0) begin
            ratio_lookup = restArray;
         end else begin
            ratio_lookup = soundArray;
         end       
        end
LS17:  begin
       max_in = max_in17;
        if (max_in == 0) begin
            ratio_lookup = restArray;
         end else begin
            ratio_lookup = soundArray;
         end       
        end
 LS18:begin
        max_in = max_in18;
        if (max_in == 0) begin
            ratio_lookup = restArray;
         end else begin
            ratio_lookup = soundArray;
         end       
        end
    LS19: begin
        max_in = max_in19;
        if (max_in == 0) begin
            ratio_lookup = restArray;
         end else begin
            ratio_lookup = soundArray;
         end       
        end
    LS20:begin
        max_in = max_in20;
        if (max_in == 0) begin
            ratio_lookup = restArray;
         end else begin
            ratio_lookup = soundArray;
         end       
        end
    LS21: begin
        max_in = max_in21;
        if (max_in == 0) begin
            ratio_lookup = restArray;
         end else begin
            ratio_lookup = soundArray;
         end       
      end
 LS22: begin
        max_in = max_in22;
        if (max_in == 0) begin
            ratio_lookup = restArray;
         end else begin
            ratio_lookup = soundArray;
         end       
       end
 LS23: begin
        max_in = max_in23;
        if (max_in == 0) begin
            ratio_lookup = restArray;
         end else begin
            ratio_lookup = soundArray;
         end       
        end
 LS24:  begin
      max_in = max_in24;
        if (max_in == 0) begin
            ratio_lookup = restArray;
         end else begin
            ratio_lookup = soundArray;
         end       
        end
LS25:  begin
       max_in = max_in25;
        if (max_in == 0) begin
            ratio_lookup = restArray;
         end else begin
            ratio_lookup = soundArray;
         end       
        end
LS26:  begin
      max_in = max_in26;
        if (max_in == 0) begin
            ratio_lookup = restArray;
         end else begin
            ratio_lookup = soundArray;
         end       
        end
LS27:  begin
       max_in = max_in27;
        if (max_in == 0) begin
            ratio_lookup = restArray;
         end else begin
            ratio_lookup = soundArray;
         end       
        end
LS28:  begin
      max_in = max_in28;
        if (max_in == 0) begin
            ratio_lookup = restArray;
         end else begin
            ratio_lookup = soundArray;
         end       
        end
LS29:  begin
       max_in = max_in29;
        if (max_in == 0) begin
            ratio_lookup = restArray;
         end else begin
            ratio_lookup = soundArray;
         end       
        end
LS30:  begin
      max_in = max_in30;
        if (max_in == 0) begin
            ratio_lookup = restArray;
         end else begin
            ratio_lookup = soundArray;
         end       
        end
LS31:  begin
       max_in = max_in31;
        if (max_in == 0) begin
            ratio_lookup = restArray;
         end else begin
            ratio_lookup = soundArray;
         end       
        end
GOOD:  begin
      max_in = goodSound;
        if (max_in == 0) begin
            ratio_lookup = restArray;
         end else begin
            ratio_lookup = soundArray;
         end       
        end
BAD:  begin
      max_in = badSound;
        if (max_in == 0) begin
            ratio_lookup = restArray;
         end else begin
            ratio_lookup = soundArray;
         end       
        end
default: begin
        max_in = max_inOFF;
        if (max_in == 0) begin
            ratio_lookup = restArray;
         end else begin
            ratio_lookup = soundArray;
         end       
end 
    endcase
end
endmodule

module fsm (
  input logic clk, nrst,
  input logic goodCollision, badCollision,
  output state_t state,
  input logic enable
);

  state_t next_state;
  logic out_clk;
  logic out_enable;
  logic [18:0] length, next_length;
  logic [18:0] REST = 30;

  clk_div  c1 (.max_i(length), .clk(clk), .nrst(nrst), .atmax_o(out_clk));
  clk_enable a1 (.max_i(16'd50000), .clk(clk), .nrst(nrst), .enable(enable), .out_enable(out_enable));

  always_comb begin
    if (goodCollision == 1) begin
        next_state = GOOD;
        next_length = 19'd31;
    end else if (badCollision == 1) begin
        next_state = BAD;
        next_length = 19'd31;
    end
    else begin
    case(state)
        LS0: next_state = LS1;
        LS1: next_state = LS2;
        LS2: next_state = LS3;
        LS3: next_state = LS4;
        LS4: next_state = LS5;
        LS5: next_state = LS6;
        LS6: next_state = LS7;
        LS7: next_state = LS8;
        LS8: next_state = LS9;
        LS9: next_state = LS10;
        LS10: next_state = LS11;
        LS11: next_state = LS12;
        LS12: next_state = LS13;
        LS13: next_state = LS14;
        LS14: next_state = LS15;
        LS15: next_state = LS16;
        LS16: next_state = LS17;
        LS17: next_state = LS18;
        LS18: next_state = LS19;
        LS19: next_state = LS20;
        LS20: next_state = LS21;
        LS21: next_state = LS22;
        LS22: next_state = LS23;
        LS23: next_state = LS24;
        LS24: next_state = LS25; 
        LS25: next_state = LS26;
        LS26: next_state = LS27;
        LS27: next_state = LS28;
        LS28: next_state = LS29;
        LS29: next_state = LS30;
        LS30: next_state = LS31;
        LS31: next_state = LS0;
        default: next_state = LS1;
    endcase
    case(state)
    //Quarter = 50
        LS0: next_length = 19'd25;
        LS1: next_length = REST;
        LS2: next_length = 19'd25;
        LS3: next_length = REST;
        LS4: next_length = 19'd25;
        LS5: next_length = REST;
        LS6: next_length = 19'd25;
        LS7: next_length = REST;
        LS8: next_length = 19'd25;
        LS9: next_length = REST;
        LS10: next_length =  19'd25;
        LS11: next_length =  REST;
        LS12: next_length =  19'd25;
        LS13: next_length =  REST;
        LS14: next_length =  19'd25;
        LS15: next_length = REST;
        LS16: next_length =  19'd25;
        LS17: next_length =  REST;
        LS18: next_length =  19'd25;
        LS19: next_length =  REST;
        LS20: next_length =  19'd25;
        LS21: next_length =  REST;
        LS22: next_length =  19'd25;
        LS23: next_length =  REST;
        LS24: next_length =  19'd25; 
        LS25: next_length =  REST;
        LS26: next_length =  19'd25;
        LS27: next_length =  REST;
        LS28: next_length =  19'd25;
        LS29: next_length =  REST;
        LS30: next_length =  19'd25;
        LS31: next_length = REST;
        default: next_length = REST;
    endcase
    end
  end

    always_ff @(posedge clk, negedge nrst) begin
    if (nrst == 1'b0) begin
       state <= OPEN;
       length <= 19'd31;
    end
    else begin
        if (out_clk == 1'b1) begin
            if (out_enable == 1'b1) begin
                state <= next_state;
                length <= next_length;
            end
        end
        else begin
            state <= state;
            length <= length;
        end
    end
  end

endmodule

module clk_div (
input logic clk,
input logic nrst,
input logic [18:0]max_i,
output logic atmax_o
);


logic [18:0] innerCount, count;


always_comb begin


innerCount = count + 1;
if (count == max_i)
   innerCount = 19'b0;
   
atmax_o = (count == max_i);


end


always_ff @ (posedge clk, negedge nrst) begin
if (nrst == 1'b0) begin
  count <= 19'b0;
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
output logic out_enable
);


logic [15:0] innerCount, count;

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