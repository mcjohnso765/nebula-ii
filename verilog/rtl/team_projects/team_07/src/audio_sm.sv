/*
    Module: audio_SM
    Description: 
        Generate sound for every seconds and when the error is made
    second strobe sound: 
    error strobe sound: 
*/
module audio_sm (
    input logic clk,
    input logic nrst,
    input logic s_strobe,
    input logic error,
    output logic audio
);

    // initialize Variables
    logic nxt_audio;
    logic [3:0] nxt_count, count;
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
    logic [8:0] leng_ss_val;

    assign freq_err_val = 16'd48000;
    assign leng_err_val = 7'd125;
    assign freq_ss_val = 14'd15000;
    assign leng_ss_val = 9'd400;

    logic [24:0] nxt_count_delay,count_delay;
    initial count_delay = '0;

    logic [24:0] nxt_count_ss_delay,count_ss_delay;
    initial count_ss_delay = 0;

    typedef enum logic [1:0] { IDLE_e, PLAY_e } state_e;
    state_e error_state, nxt_error_state;

    typedef enum logic [1:0] { IDLE_ss, PLAY_ss } state_s;
    state_s ss_state, nxt_ss_state;

    always_comb begin
        nxt_cnt_e_freq = cnt_e_freq;
        nxt_cnt_s_freq = cnt_s_freq;
        nxt_cnt_e_leng = cnt_e_leng;
        nxt_cnt_s_leng = cnt_s_leng;
        nxt_audio = audio; 
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
        end else begin 
            if (error_state == IDLE_e) begin
                nxt_cnt_e_freq = '0;
                nxt_cnt_e_leng = '0;
                nxt_audio = '0;
            end  
        
            if (ss_state == PLAY_ss) begin
                if (nxt_cnt_s_freq == freq_ss_val) begin
                    nxt_cnt_s_freq = '0;
                    nxt_cnt_s_leng = cnt_s_leng +1; 
                    nxt_audio = ~audio;
                end else if (nxt_cnt_s_leng == leng_ss_val) begin 
                    nxt_cnt_s_freq = cnt_s_freq;
                    nxt_cnt_s_leng = '0;
                    nxt_audio = '0; 
                end else begin
                    nxt_cnt_s_freq = cnt_s_freq + 1;
                    nxt_cnt_s_leng = cnt_s_leng;
                    nxt_audio = audio;
                end
            end else if (ss_state == IDLE_ss) begin
                nxt_cnt_s_freq = '0;
                nxt_cnt_s_leng = '0;
                nxt_audio = '0; 
            end else begin
                nxt_cnt_s_freq = '0;
                nxt_cnt_s_leng = '0; 
                nxt_cnt_e_freq = '0;
                nxt_cnt_e_leng = '0; 
                nxt_audio = '0;
            end
        end

        nxt_count_ss_delay = count_ss_delay;
        nxt_ss_state = ss_state;
        if(count_ss_delay > 0)begin 
            nxt_count_ss_delay = count_ss_delay - 1;
        end else if(s_strobe)begin
            nxt_ss_state = PLAY_ss;
        end else if (cnt_s_leng == 140) begin  // How long the ss buzz sounds
            nxt_ss_state = IDLE_ss;
            nxt_count_ss_delay = 0;
        end else begin
            nxt_count_ss_delay = 0;
            nxt_ss_state = ss_state;
        end

        nxt_count_delay = count_delay;
        nxt_error_state = error_state;
        if(count_delay > '0) begin 
            nxt_count_delay = count_delay - 1;
        end else if (error) begin
            nxt_error_state = PLAY_e;
        end else if (cnt_e_leng == 100) begin  // How long the error buzz sounds
            nxt_error_state = IDLE_e;
            nxt_count_delay = '0;
        end else begin
            nxt_count_delay = '0;
            nxt_error_state = error_state;
        end
    end

    always_ff @ (posedge clk, negedge nrst) begin
        if (!nrst) begin
            audio <= '0;
            count <= '0;
            cnt_s_freq <= '0;
            cnt_s_leng <= '0; 
            cnt_e_freq <= '0;
            cnt_e_leng <= '0;
            ss_state <= IDLE_ss;
            count_ss_delay <= '0;
            error_state <= IDLE_e;
            count_delay <= '0;
        end else begin
            audio <= nxt_audio;
            count <= nxt_count;
            cnt_s_freq <= nxt_cnt_s_freq;
            cnt_s_leng <= nxt_cnt_s_leng; 
            cnt_e_freq <= nxt_cnt_e_freq;
            cnt_e_leng <= nxt_cnt_e_leng; 
            ss_state <= nxt_ss_state;
            count_ss_delay <= nxt_count_ss_delay;
            error_state <= nxt_error_state;
            count_delay <= nxt_count_delay;
        end
    end

endmodule
