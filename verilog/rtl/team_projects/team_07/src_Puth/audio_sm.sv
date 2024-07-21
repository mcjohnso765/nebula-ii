module t07_audio_sm (
input logic clk,
input logic nrst,
input logic s_strobe,
input logic s_strobe_fast,
input logic s_strobe_faster,
input logic [2:0] cnt_sec_ten,
input logic [2:0] cnt_min,
input logic [3:0] cnt_sec_one,
input logic error,
input logic submodule_clear_edge,
input logic game_clear,
// input logic say1,
// input logic say2,
// input logic say3,
// input logic say4,

output logic audio
);

// initialize Variables
logic nxt_audio;
logic [3:0] nxt_count, count;
assign nxt_count = '0;
logic [15:0] cnt_e_freq;
logic [15:0] nxt_cnt_e_freq;
logic [6:0] cnt_e_leng;
logic [6:0] nxt_cnt_e_leng;
logic [15:0] freq_err_val;
logic [6:0] leng_err_val;
logic [13:0] cnt_s_freq;
logic [13:0] nxt_cnt_s_freq;
logic [8:0] cnt_s_leng;
logic [8:0] nxt_cnt_s_leng;
logic [13:0] freq_ss_val;
logic [8:0] leng_ss_val_norm;
logic [15:0] cnt_pzl_freq;
logic [15:0] nxt_cnt_pzl_freq;
logic [8:0] cnt_pzl_leng;
logic [8:0] nxt_cnt_pzl_leng;
logic [15:0] freq_pzl_val;
logic [8:0] leng_pzl_val;
logic [20:0] cnt_bm_freq;
logic [20:0] nxt_cnt_bm_freq;
logic [8:0] cnt_bm_leng;
logic [8:0] nxt_cnt_bm_leng;
logic [20:0] freq_bm_val;
logic [8:0] leng_bm_val;

// logic [20:0] cnt_say_freq;
// logic [20:0] nxt_cnt_say_freq;
// logic [8:0] cnt_say_leng;
// logic [8:0] nxt_cnt_say_leng;
// logic [20:0] freq_say1_val;
// logic [20:0] freq_say2_val;
// logic [20:0] freq_say3_val;
// logic [20:0] freq_say4_val;
// logic [8:0] leng_say_val;


assign freq_err_val = 16'd48000;
assign leng_err_val = 7'd125;
assign freq_ss_val = 14'd15000;
assign leng_ss_val_norm = 9'd100; // was 400 changed by Abdulloh
assign freq_pzl_val = 16'd20000;
assign leng_pzl_val = 9'd100;
assign freq_bm_val = 21'd60000;
assign leng_bm_val = 9'd400;

// assign leng_say_val = 9'd400;
// assign freq_say1_val = 21'd160000;
// assign freq_say2_val = 21'd120000;
// assign freq_say3_val = 21'd96000;
// assign freq_say4_val = 21'd80000;


logic strobe;
assign strobe = (cnt_min == 0 && (cnt_sec_ten <= 1)) ? s_strobe_faster : ((cnt_min == 0 && cnt_sec_ten <= 3)) ? s_strobe_fast : s_strobe; // play fast at 30, faster at 20

//(cnt_min == 0 && cnt_sec_ten == 0 && cnt_sec_one == 1) ? 0 : 

always_comb begin
  nxt_cnt_e_freq = cnt_e_freq;
  nxt_cnt_s_freq = cnt_s_freq;
  nxt_cnt_pzl_freq = cnt_pzl_freq;
  nxt_cnt_bm_freq = cnt_bm_freq;
  // nxt_cnt_say_freq = cnt_say_freq;

  nxt_cnt_e_leng = cnt_e_leng;
  nxt_cnt_s_leng = cnt_s_leng;
  nxt_cnt_pzl_leng = cnt_pzl_leng;
  nxt_cnt_bm_leng = cnt_bm_leng;
  // nxt_cnt_say_leng = cnt_say_leng;


  nxt_audio = audio; 
    // Error
    if (error_state == PLAY_e) begin
      if (nxt_cnt_e_freq == freq_err_val) begin
        nxt_cnt_e_freq = '0;
        nxt_cnt_e_leng = cnt_e_leng + 1; 
        nxt_audio = ~audio;
      end else if (nxt_cnt_e_leng == leng_err_val) begin 
        nxt_cnt_e_freq = cnt_e_freq;
        nxt_cnt_e_leng = '0;
        nxt_audio = '0; 
      end else begin
        nxt_cnt_e_freq = cnt_e_freq + 1;
        nxt_cnt_e_leng = cnt_e_leng;
        nxt_audio = audio;
      end 
    end 
    // Bomb Boom
    else if (bm_state == PLAY_bm) begin
        if (nxt_cnt_bm_freq == freq_bm_val) begin
        nxt_cnt_bm_freq = '0;
        nxt_cnt_bm_leng = cnt_bm_leng + 1; 
        nxt_audio = ~audio;
      end else if (nxt_cnt_bm_leng == leng_bm_val) begin 
        nxt_cnt_bm_freq = cnt_bm_freq;
        nxt_cnt_bm_leng = '0;
        nxt_audio = '0; 
      end else begin
        nxt_cnt_bm_freq = cnt_bm_freq + 1;
        nxt_cnt_bm_leng = cnt_bm_leng;
        nxt_audio = audio;
      end 
    end 
    // Puzzle Clear
    else if (pzl_state == PLAY_pzl) begin
        if (nxt_cnt_pzl_freq == freq_pzl_val) begin
        nxt_cnt_pzl_freq = '0;
        nxt_cnt_pzl_leng = cnt_pzl_leng + 1; 
        nxt_audio = ~audio;
      end else if (nxt_cnt_pzl_leng == leng_pzl_val) begin 
        nxt_cnt_pzl_freq = cnt_pzl_freq;
        nxt_cnt_pzl_leng = '0;
        nxt_audio = '0; 
      end else begin
        nxt_cnt_pzl_freq = cnt_pzl_freq + 1;
        nxt_cnt_pzl_leng = cnt_pzl_leng;
        nxt_audio = audio;
      end 
    end 

  // // simon says 1 - 4
  // else if (say1_state == PLAY_say1) begin
  //       if (nxt_cnt_say_freq == freq_say1_val) begin
  //       nxt_cnt_say_freq = '0;
  //       nxt_cnt_say_leng = cnt_say_leng + 1; 
  //       nxt_audio = ~audio;
  //     end else if (nxt_cnt_say_leng == leng_say_val) begin 
  //       nxt_cnt_say_freq = cnt_say_freq;
  //       nxt_cnt_say_leng = '0;
  //       nxt_audio = '0; 
  //     end else begin
  //       nxt_cnt_say_freq = cnt_say_freq + 1;
  //       nxt_cnt_say_leng = cnt_say_leng;
  //       nxt_audio = audio;
  //     end 
  //   end 
  //    else if (say2_state == PLAY_say2) begin
  //       if (nxt_cnt_say_freq == freq_say2_val) begin
  //       nxt_cnt_say_freq = '0;
  //       nxt_cnt_say_leng = cnt_say_leng + 1; 
  //       nxt_audio = ~audio;
  //     end else if (nxt_cnt_say_leng == leng_say_val) begin 
  //       nxt_cnt_say_freq = cnt_say_freq;
  //       nxt_cnt_say_leng = '0;
  //       nxt_audio = '0; 
  //     end else begin
  //       nxt_cnt_say_freq = cnt_say_freq + 1;
  //       nxt_cnt_say_leng = cnt_say_leng;
  //       nxt_audio = audio;
  //     end 
  //   end  else if (say3_state == PLAY_say3) begin
  //       if (nxt_cnt_say_freq == freq_say3_val) begin
  //       nxt_cnt_say_freq = '0;
  //       nxt_cnt_say_leng = cnt_say_leng + 1; 
  //       nxt_audio = ~audio;
  //     end else if (nxt_cnt_say_leng == leng_say_val) begin 
  //       nxt_cnt_say_freq = cnt_say_freq;
  //       nxt_cnt_say_leng = '0;
  //       nxt_audio = '0; 
  //     end else begin
  //       nxt_cnt_say_freq = cnt_say_freq + 1;
  //       nxt_cnt_say_leng = cnt_say_leng;
  //       nxt_audio = audio;
  //     end 
  //   end  else if (say4_state == PLAY_say4) begin
  //       if (nxt_cnt_say_freq == freq_say4_val) begin
  //       nxt_cnt_say_freq = '0;
  //       nxt_cnt_say_leng = cnt_say_leng + 1; 
  //       nxt_audio = ~audio;
  //     end else if (nxt_cnt_say_leng == leng_say_val) begin 
  //       nxt_cnt_say_freq = cnt_say_freq;
  //       nxt_cnt_say_leng = '0;
  //       nxt_audio = '0; 
  //     end else begin
  //       nxt_cnt_say_freq = cnt_say_freq + 1;
  //       nxt_cnt_say_leng = cnt_say_leng;
  //       nxt_audio = audio;
  //     end 
  //   end 

    // s_strobe sound
   else if (ss_state == PLAY_ss) begin
        if (nxt_cnt_s_freq == freq_ss_val) begin
          nxt_cnt_s_freq = '0;
          nxt_cnt_s_leng = cnt_s_leng +1; 
          nxt_audio = ~audio;
        end else if (nxt_cnt_s_leng == leng_ss_val_norm) begin 
          nxt_cnt_s_freq = cnt_s_freq;
          nxt_cnt_s_leng = '0;
          nxt_audio = '0; 
        end else begin
          nxt_cnt_s_freq = cnt_s_freq + 1;
          nxt_cnt_s_leng = cnt_s_leng;
          nxt_audio = audio;
        end
    end 
    else if (ss_state == IDLE_ss) begin
        nxt_cnt_s_freq = '0;
        nxt_cnt_s_leng = '0;
        nxt_audio = '0; 
    end else if (error_state == IDLE_e) begin
        nxt_cnt_e_freq = '0;
        nxt_cnt_e_leng = '0;
        nxt_audio = '0;
    end else if (pzl_state == IDLE_pzl) begin
        nxt_cnt_pzl_freq = '0;
        nxt_cnt_pzl_leng = '0;
        nxt_audio = '0;
    end else begin
      nxt_cnt_s_freq = '0;
      nxt_cnt_s_leng = '0; 
      nxt_cnt_e_freq = '0;
      nxt_cnt_e_leng = '0; 
      nxt_cnt_pzl_freq = '0;
      nxt_cnt_pzl_leng = '0;
      nxt_audio = '0;

    end
  end

always_ff @ (posedge clk, negedge nrst) begin
   if (!nrst) begin
      audio <= '0;
      // count <= '0;
      cnt_s_freq <= '0;
      cnt_s_leng <= '0; 
      cnt_e_freq <= '0;
      cnt_e_leng <= '0;
      cnt_pzl_freq <= '0;
      cnt_pzl_leng <= '0;
      cnt_bm_freq <= '0;
      cnt_bm_leng <= '0;
      // cnt_say_freq <= '0;
      // cnt_say_leng <= '0;
    end else begin
      audio <= nxt_audio;
      // count <= nxt_count;
      cnt_s_freq <= nxt_cnt_s_freq;
      cnt_s_leng <= nxt_cnt_s_leng; 
      cnt_e_freq <= nxt_cnt_e_freq;
      cnt_e_leng <= nxt_cnt_e_leng; 
      cnt_pzl_freq <= nxt_cnt_pzl_freq;
      cnt_pzl_leng <= nxt_cnt_pzl_leng;
      cnt_bm_freq <= nxt_cnt_bm_freq;
      cnt_bm_leng <= nxt_cnt_bm_leng;
      // cnt_say_freq <= nxt_cnt_say_freq;
      // cnt_say_leng <= nxt_cnt_say_leng;
    end
end

typedef enum logic [1:0] { IDLE_e, PLAY_e } state_e;

  state_e error_state, nxt_error_state;

always_ff @(posedge clk, negedge nrst) begin
  if(~nrst) begin
    error_state <= IDLE_e;
  end else begin
    error_state <= nxt_error_state;
    // count_delay <= nxt_count_delay;
  end
end
// logic [24:0] nxt_count_delay,count_delay;
// initial count_delay = '0;
always_comb begin
    nxt_error_state = error_state;
  if(error)begin
    nxt_error_state = PLAY_e;
  end else if (cnt_e_leng == 100) begin  // How long the error buzz sounds
    nxt_error_state = IDLE_e;
  end else begin
    nxt_error_state = error_state;
  end
end

typedef enum logic [1:0] { IDLE_bm, PLAY_bm } state_bm;

  state_bm bm_state, nxt_bm_state;

always_ff @(posedge clk, negedge nrst) begin
  if(~nrst) begin
    bm_state <= IDLE_bm;
  end else begin
    bm_state <= nxt_bm_state;
    count_bm_delay <= nxt_count_bm_delay;
  end
end
logic [24:0] nxt_count_bm_delay,count_bm_delay;
initial count_bm_delay = '0;
always_comb begin
  nxt_count_bm_delay = count_bm_delay;
    nxt_bm_state = bm_state;
  if(count_bm_delay > '0)begin 
    nxt_count_bm_delay = count_bm_delay - 1;
  end
   else if(game_clear)begin
    nxt_bm_state = PLAY_bm;
  end else if (cnt_bm_leng == 400) begin  // How long the boom buzz sounds
    nxt_bm_state = IDLE_bm;
    nxt_count_bm_delay = '0;
  end else begin
    nxt_count_bm_delay = '0;
    nxt_bm_state = bm_state;
  end
end

// // simon says 1-4

// typedef enum logic [1:0] { IDLE_say1, PLAY_say1 } state_say1;

//   state_say1 say1_state, nxt_say1_state;

// always_ff @(posedge clk, negedge nrst) begin
//   if(~nrst) begin
//     say1_state <= IDLE_say1;
//   end else begin
//     say1_state <= nxt_say1_state;
//     count_say1_delay <= nxt_count_say1_delay;
//   end
// end
// logic [24:0] nxt_count_say1_delay,count_say1_delay;
// initial count_say1_delay = '0;
// always_comb begin
//   nxt_count_say1_delay = count_say1_delay;
//     nxt_say1_state = say1_state;
//   if(count_say1_delay > '0)begin 
//     nxt_count_say1_delay = count_say1_delay - 1;
//   end
//    else if(say1)begin
//     nxt_say1_state = PLAY_say1;
//   end else if (cnt_say_leng == 100) begin  // How long the error buzz sounds
//     nxt_say1_state = IDLE_say1;
//     nxt_count_say1_delay = '0;
//   end else begin
//     nxt_count_say1_delay = '0;
//     nxt_say1_state = say1_state;
//   end
// end

// typedef enum logic [1:0] { IDLE_say2, PLAY_say2 } state_say2;

//   state_say2 say2_state, nxt_say2_state;

// always_ff @(posedge clk, negedge nrst) begin
//   if(~nrst) begin
//     say2_state <= IDLE_say2;
//   end else begin
//     say2_state <= nxt_say2_state;
//     count_say2_delay <= nxt_count_say2_delay;
//   end
// end
// logic [24:0] nxt_count_say2_delay,count_say2_delay;
// initial count_say2_delay = '0;
// always_comb begin
//   nxt_count_say2_delay = count_say2_delay;
//     nxt_say2_state = say2_state;
//   if(count_say2_delay > '0)begin 
//     nxt_count_say2_delay = count_say2_delay - 1;
//   end
//    else if(say2)begin
//     nxt_say2_state = PLAY_say2;
//   end else if (cnt_say_leng == 100) begin  // How long the error buzz sounds
//     nxt_say2_state = IDLE_say2;
//     nxt_count_say2_delay = '0;
//   end else begin
//     nxt_count_say2_delay = '0;
//     nxt_say2_state = say2_state;
//   end
// end

// typedef enum logic [1:0] { IDLE_say3, PLAY_say3 } state_say3;

//   state_say3 say3_state, nxt_say3_state;

// always_ff @(posedge clk, negedge nrst) begin
//   if(~nrst) begin
//     say3_state <= IDLE_say3;
//   end else begin
//     say3_state <= nxt_say3_state;
//     count_say3_delay <= nxt_count_say3_delay;
//   end
// end
// logic [24:0] nxt_count_say3_delay,count_say3_delay;
// initial count_say3_delay = '0;
// always_comb begin
//   nxt_count_say3_delay = count_say3_delay;
//     nxt_say3_state = say3_state;
//   if(count_say3_delay > '0)begin 
//     nxt_count_say3_delay = count_say3_delay - 1;
//   end
//    else if(say3)begin
//     nxt_say3_state = PLAY_say3;
//   end else if (cnt_say_leng == 100) begin  // How long the error buzz sounds
//     nxt_say3_state = IDLE_say3;
//     nxt_count_say3_delay = '0;
//   end else begin
//     nxt_count_say3_delay = '0;
//     nxt_say3_state = say3_state;
//   end
// end

// typedef enum logic [1:0] { IDLE_say4, PLAY_say4 } state_say4;

//   state_say4 say4_state, nxt_say4_state;

// always_ff @(posedge clk, negedge nrst) begin
//   if(~nrst) begin
//     say4_state <= IDLE_say4;
//   end else begin
//     say4_state <= nxt_say4_state;
//     count_say4_delay <= nxt_count_say4_delay;
//   end
// end
// logic [24:0] nxt_count_say4_delay,count_say4_delay;
// initial count_say4_delay = '0;
// always_comb begin
//   nxt_count_say4_delay = count_say4_delay;
//     nxt_say4_state = say4_state;
//   if(count_say4_delay > '0)begin 
//     nxt_count_say4_delay = count_say4_delay - 1;
//   end
//    else if(say4)begin
//     nxt_say4_state = PLAY_say4;
//   end else if (cnt_say_leng == 100) begin  // How long the error buzz sounds
//     nxt_say4_state = IDLE_say4;
//     nxt_count_say4_delay = '0;
//   end else begin
//     nxt_count_say4_delay = '0;
//     nxt_say4_state = say4_state;
//   end
// end

// simon says ends

typedef enum logic [1:0] { IDLE_pzl, PLAY_pzl } state_pzl;

  state_pzl pzl_state, nxt_pzl_state;

always_ff @(posedge clk, negedge nrst) begin
  if(~nrst) begin
    pzl_state <= IDLE_pzl;
  end else begin
    pzl_state <= nxt_pzl_state;
  end
end
logic [24:0] nxt_count_pzl_delay,count_pzl_delay;
initial count_pzl_delay = '0;
always_comb begin
  nxt_count_pzl_delay = count_pzl_delay;
    nxt_pzl_state = pzl_state;
  if(count_pzl_delay > '0)begin 
    nxt_count_pzl_delay = count_pzl_delay - 1;
  end
   else if(submodule_clear_edge)begin
    nxt_pzl_state = PLAY_pzl;
  end else if (cnt_pzl_leng == leng_ss_val_norm) begin  // How long the puzzle buzz sounds
    nxt_pzl_state = IDLE_pzl;
    nxt_count_pzl_delay = '0;
  end else begin
    nxt_count_pzl_delay = '0;
    nxt_pzl_state = pzl_state;
  end
end

typedef enum logic [1:0] { IDLE_ss, PLAY_ss } state_s;

  state_s ss_state, nxt_ss_state;

always_ff @(posedge clk, negedge nrst) begin
  if(~nrst) begin
    ss_state <= IDLE_ss;
  end else begin
    ss_state <= nxt_ss_state;
    count_ss_delay <= nxt_count_ss_delay;
  end
end
logic [24:0] nxt_count_ss_delay,count_ss_delay;
initial count_ss_delay = 0;
always_comb begin
  nxt_count_ss_delay = count_ss_delay;
  nxt_ss_state = ss_state;
  if(count_ss_delay > 0)begin 
    nxt_count_ss_delay = count_ss_delay - 1;
  end
   else if(strobe)begin
    nxt_ss_state = PLAY_ss;
   end
    else if(nxt_cnt_s_leng == leng_ss_val_norm) begin
    nxt_ss_state = IDLE_ss;
    nxt_count_ss_delay = 0;
  end else begin
    nxt_count_ss_delay = 0;
    nxt_ss_state = ss_state;
  end
end

endmodule