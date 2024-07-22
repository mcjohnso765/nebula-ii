

module team_08_score_counter (
  input logic clk,
  input logic reset,
  input logic collision_detect, // if collision detected --> stop counting score
  input state_t state,
  output logic [3:0] bcd_ones, bcd_tens,
  output logic [6:0] score //7 bit score which can store up to 127 in max, score goes up to 99 max
);

  //internal signals;
  logic slow_clock, col, det;// 0.1 Hz clock signal from the clock_divider
  //clock divider to generate 1 Hz clock from main block which now assumed to be 12 MHz
  logic [6:0] n_score, deconcatenate;
  logic [3:0] n_bcd_ones, n_bcd_tens;
  state_t next_state;
  
  //instantiate the clock divider module
  clock_divider clock_div(.clk(clk), .nRst_i(reset), .slow_clk(slow_clock));
  
  //score counter logic
  always_ff @(posedge clk, negedge reset) begin
    if (!reset) begin
      score <= 10;
      bcd_ones <= 0;
      bcd_tens <= 1;
      col <= 0;
    end else begin
      col <= collision_detect;
      score <= n_score;
      bcd_ones <= n_bcd_ones;
      bcd_tens <= n_bcd_tens;
    end
  end
  

always_comb begin
  det = collision_detect && !col;
  next_state = state;
  n_score = score;
  n_bcd_ones = 0;
  n_bcd_tens = 1;
  deconcatenate = 0;
  

case(state)

IDLE: begin
n_score = 10;
n_bcd_ones = 0;
n_bcd_tens = 1;
deconcatenate = deconcatenate;
end

RUN: begin
  n_score = score;
  n_bcd_ones = bcd_ones;
  n_bcd_tens = bcd_tens;
  deconcatenate = 0;
if(det) begin
  n_score = score - 3;    
end
if(slow_clock) begin
  if(score < 99) begin
    n_score = score + 1;
  end
  else if(score == 99) begin
    n_score = score;
  end
end


  if(n_score > 89) begin
    deconcatenate = n_score - 90;
    n_bcd_ones = deconcatenate[3:0];
    n_bcd_tens = 9;
  end
  else if(n_score > 79) begin
    deconcatenate = n_score - 80;
    n_bcd_ones = deconcatenate[3:0];
    n_bcd_tens = 8;
  end
  else if(n_score > 69) begin
    deconcatenate = n_score - 70;
    n_bcd_ones = deconcatenate[3:0];
    n_bcd_tens = 7;
  end
  else if(n_score > 59) begin
    deconcatenate = n_score - 60;
    n_bcd_ones = deconcatenate[3:0];
    n_bcd_tens = 6;
  end
  if(n_score > 49) begin
    deconcatenate = n_score - 50;
    n_bcd_ones = deconcatenate[3:0];
    n_bcd_tens = 5;
  end
  else if(n_score > 39) begin
    deconcatenate = n_score - 40;
    n_bcd_ones = deconcatenate[3:0];
    n_bcd_tens = 4;
  end
  else if(n_score > 29) begin
    deconcatenate = n_score - 30;
    n_bcd_ones = deconcatenate[3:0];
    n_bcd_tens = 3;
  end
  else if(n_score > 19) begin
    deconcatenate = n_score - 20;
    n_bcd_ones = deconcatenate[3:0];
    n_bcd_tens = 2;
  end
  else if(n_score > 9) begin
    deconcatenate = n_score - 10;
    n_bcd_ones = deconcatenate[3:0];
    n_bcd_tens = 1;
  end
  else begin
    deconcatenate = n_score;
    n_bcd_ones = deconcatenate[3:0];
    n_bcd_tens = 0;
  end

end

WIN: begin
  n_score = score;
  n_bcd_ones = 9;
  n_bcd_tens = 9;
  deconcatenate = deconcatenate;
end

OVER: begin
  n_score = score;
  n_bcd_ones = bcd_ones;
  n_bcd_tens = bcd_tens;
  deconcatenate = deconcatenate;
end

default: begin
  n_score = 10;
  n_bcd_ones = 0;
  n_bcd_tens = 1;
  deconcatenate = deconcatenate;
end
endcase

end
endmodule


//updated Clock_divider module 
module clock_divider ( 
  input logic clk, 
  input logic nRst_i, 
  output logic slow_clk 
  // output logic [23:0] counter
); 

  logic [25:0] counter;//24 bit counter for 12 MHz clock 

always_ff @(posedge clk, negedge nRst_i) begin 

    if(!nRst_i) begin  
      counter <= 0; 
      slow_clk <= 0; 
    end 
    else if (counter >= 30000000 - 1) begin 
      counter <= 0; // 12 MHz, 100 cycles = 1 second, 100s = 10000 cycles --> 9999 cycles useless 
                    //12 MHz * 10 seconds = 1,000,000,000 cycles 
      slow_clk <= 1; 
    end 
    else begin 
      counter <= counter + 1; 
      slow_clk <= 0; 
    end 

end 

endmodule
