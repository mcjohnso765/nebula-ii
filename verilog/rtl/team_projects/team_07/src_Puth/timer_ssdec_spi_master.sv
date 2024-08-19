/*
    Module: SPI_Master_2
    Description:
        Set the SPI communication for the Sparkfun seven segment display
*/
module t07_timer_ssdec_spi_master (
    input logic clk, nrst,          // System clk, reset 
    input logic [2:0] cnt_min,      // Counts input minutes
    input logic [2:0] cnt_sec_ten,  // Count input tens place seu
    input logic [3:0] cnt_sec_one,  // Count input secounds
    input logic enable,             // Counter enable
    input logic sck_rs_enable,      // SCK Clk rising edge signal divider input
    input logic sck_fl_enable,      // SCK Clk falling edge signal divider input
    input logic clear,              // System clear
    output logic sck_clear,         // Output to sck_divider, divider runs when sck_clear low
    output logic ss,                // SPI Slave Select
    output logic sdi,               // SPI MOSI (Master Output Slave Input)
    output logic sck                // SPI Clk
);
    typedef enum logic [4:0] {
        IDLE = 5'd0, LOAD_1 = 5'd1, 
        SENT_RST_1 = 5'd2, WAIT_RST_1 = 5'd3,
        SENT_CLN_1 = 5'd4, WAIT_CLN_1 = 5'd5,
        SENT_CLN_2 = 5'd6, WAIT_CLN_2 = 5'd7,
        SENT_CMD_2 = 5'd8, WAIT_CMD_2 = 5'd9,
        SENT_DIG_2 = 5'd10, WAIT_DIG_2 = 5'd11,
        SENT_CMD_3 = 5'd12, WAIT_CMD_3 = 5'd13,
        SENT_DIG_3 = 5'd14, WAIT_DIG_3 = 5'd15,
        SENT_CMD_4 = 5'd16, WAIT_CMD_4 = 5'd17,
        SENT_DIG_4 = 5'd18, WAIT_DIG_4 = 5'd19,
        LOAD_2 = 5'd20
    } state_t;

    logic nxt_sdi;
    logic nxt_ss;
    logic nxt_sck;
    state_t state, nxt_state;
    logic [5:0] sck_sent, nxt_sck_sent;
    logic [47:0] ssdec_data;
    logic [7:0] ssdec_cnt_min, ssdec_cnt_sec_ten, ssdec_cnt_sec_one;
    logic [47:0] reg_data, nxt_reg_data;
    logic [7:0] rst_cmd, nxt_rst_cmd;
    logic [15:0] cln_cmd, nxt_cln_cmd;

    t07_timer_ssdec_decoder decoder_min({1'b0, cnt_min}, ssdec_cnt_min);
    t07_timer_ssdec_decoder decoder_sec_ten({1'b0, cnt_sec_ten}, ssdec_cnt_sec_ten);
    t07_timer_ssdec_decoder decoder_sec_one(cnt_sec_one, ssdec_cnt_sec_one);

    always_ff @(posedge clk, negedge nrst) begin
        if (!nrst) begin
            ss <= 1'd1;
            sdi <= 1'd0;
            sck <= 1'd0;
            reg_data <= 48'd0;
            sck_sent <= 6'd0;
            state <= IDLE;
            rst_cmd <= 8'h76;
            cln_cmd <= 16'h7710;
        end else begin
            ss <= nxt_ss;
            sdi <= nxt_sdi;
            sck <= nxt_sck;
            reg_data <= nxt_reg_data;
            sck_sent <= nxt_sck_sent;
            state <= nxt_state;
            rst_cmd <= nxt_rst_cmd;
            cln_cmd <= nxt_cln_cmd;
        end 
    end

    always_comb begin
        ssdec_data = {
            8'h7c,              // digit 2 command
            ssdec_cnt_min,      // cnt_min data
            8'h7d,              // digit 3 command
            ssdec_cnt_sec_ten,  // cnt_sec_ten data
            8'h7e,              // digit 4 command
            ssdec_cnt_sec_one   // cnt_sec_one data
        };

        if (clear) begin
            sck_clear = 1; 
            nxt_ss = 1;
            nxt_sck = 0;
            nxt_sdi = 0;
            nxt_reg_data = 48'd0;
            nxt_sck_sent = 6'd0;
            nxt_state = IDLE;  
            nxt_rst_cmd = 8'd0; 
            nxt_cln_cmd = 16'd0;     
        end else begin
            nxt_ss = ss;
            nxt_sck = sck;
            nxt_sdi = sdi;
            nxt_reg_data = reg_data;
            nxt_sck_sent = sck_sent;
            nxt_state = state; 
            nxt_rst_cmd = rst_cmd;
            nxt_cln_cmd = cln_cmd;
            case (state)
                IDLE: begin
                    sck_clear = 1;
                    nxt_ss = 1;
                    nxt_sck = 0;
                    nxt_sdi = 0;
                    nxt_reg_data = 48'd0;
                    nxt_sck_sent = 6'd0;
                    if (enable) begin
                        nxt_state = LOAD_1;
                    end else begin
                        nxt_state = state;
                    end
                end
                LOAD_1: begin
                    sck_clear = 1;
                    nxt_ss = 1;
                    nxt_sck = 0;
                    nxt_sdi = 0;
                    nxt_reg_data = ssdec_data;
                    nxt_rst_cmd = 8'h76;
                    nxt_cln_cmd = 16'h7710;
                    nxt_sck_sent = 0;
                    nxt_state = SENT_RST_1;
                end
                SENT_RST_1: begin
                    sck_clear = 0;
                    nxt_ss = 0;
                    if (sck_fl_enable) begin
                        nxt_sck = 0;
                        if (sck_sent == 6'd8) begin
                            nxt_state = WAIT_RST_1;
                            nxt_sck_sent = 6'd0;
                        end else begin
                            nxt_sck_sent = sck_sent + 1;
                            nxt_sdi = rst_cmd[7];
                            nxt_rst_cmd = {rst_cmd[6:0], 1'd0};
                        end 
                    end else if (sck_rs_enable && sck_sent != 6'd0) begin
                        nxt_sck = 1;
                    end else begin
                        nxt_sck = sck;
                    end
                end
                SENT_CLN_1, SENT_CLN_2: begin
                    sck_clear = 0;
                    nxt_ss = 0;
                    if (sck_fl_enable) begin
                        nxt_sck = 0;
                        if (sck_sent == 6'd8) begin
                            if (state == SENT_CLN_1) begin
                                nxt_state = WAIT_CLN_1;
                            end else begin
                                nxt_state = WAIT_CLN_2;
                            end
                            // nxt_state = (state == SENT_CLN_1) ? WAIT_CLN_1 : WAIT_CLN_2;
                            nxt_sck_sent = 6'd0;
                        end else begin
                            nxt_sck_sent = sck_sent + 1;
                            nxt_sdi = cln_cmd[15];
                            nxt_cln_cmd = {cln_cmd[14:0], 1'd0};
                        end 
                    end else if (sck_rs_enable && sck_sent != 6'd0) begin
                        nxt_sck = 1;
                    end else begin
                        nxt_sck = sck;
                    end
                end
                SENT_CMD_2, SENT_DIG_2, SENT_CMD_3, SENT_DIG_3, SENT_CMD_4, SENT_DIG_4: begin
                    sck_clear = 0;
                    nxt_ss = 0;
                    if (sck_fl_enable) begin
                        nxt_sck = 0;
                        if (sck_sent == 6'd8) begin
                            if (state == SENT_CMD_2) begin
                                nxt_state = WAIT_CMD_2;
                            end else if (state == SENT_DIG_2) begin
                                nxt_state = WAIT_DIG_2;
                            end else if (state == SENT_CMD_3) begin
                                nxt_state = WAIT_CMD_3;
                            end else if (state == SENT_DIG_3) begin
                                nxt_state = WAIT_DIG_3;
                            end else if (state == SENT_CMD_4) begin
                                nxt_state = WAIT_CMD_4;
                            end else begin
                                nxt_state = WAIT_DIG_4;
                            end
                            // nxt_state = (state == SENT_CMD_2) ? WAIT_CMD_2 :
                            //     (state == SENT_DIG_2) ? WAIT_DIG_2 :
                            //     (state == SENT_CMD_3) ? WAIT_CMD_3 :
                            //     (state == SENT_DIG_3) ? WAIT_DIG_3 :
                            //     (state == SENT_CMD_4) ? WAIT_CMD_4 : WAIT_DIG_4;
                            nxt_sck_sent = 6'd0;
                        end else begin
                            nxt_sck_sent = sck_sent + 1;
                            nxt_sdi = reg_data[47];
                            nxt_reg_data = {reg_data[46:0], 1'd0};
                        end 
                    end else if (sck_rs_enable && sck_sent != 6'd0) begin
                        nxt_sck = 1;
                    end else begin
                        nxt_sck = sck;
                    end
                end
                WAIT_RST_1, WAIT_CLN_1, WAIT_CLN_2, WAIT_DIG_2, WAIT_DIG_3, WAIT_DIG_4, WAIT_CMD_2, WAIT_CMD_3, WAIT_CMD_4: begin
                    case (state) 
                        WAIT_CLN_1, WAIT_CMD_2, WAIT_CMD_3, WAIT_CMD_4: begin
                            sck_clear = 0;
                            nxt_ss = 0;
                            nxt_sdi = 0;
                        end 
                        default: begin
                            sck_clear = 0;
                            nxt_ss = 1;
                            nxt_sdi = 0;
                        end
                    endcase
                    if (sck_fl_enable) begin
                        if (sck_sent == 6'd15) begin
                            nxt_sck_sent = 6'd0;
                            if (state == WAIT_DIG_4) begin
                                nxt_state = LOAD_2;
                            end else begin
                                if (state == WAIT_RST_1) begin
                                    nxt_state = SENT_CLN_1;
                                end else if (state == WAIT_CLN_1) begin
                                    nxt_state = SENT_CLN_2;
                                end else if (state == WAIT_CLN_2) begin
                                    nxt_state = SENT_CMD_2;
                                end else if (state == WAIT_CMD_2) begin
                                    nxt_state = SENT_DIG_2;
                                end else if (state == WAIT_DIG_2) begin
                                    nxt_state = SENT_CMD_3;
                                end else if (state == WAIT_CMD_3) begin
                                    nxt_state = SENT_DIG_3;
                                end else if (state == WAIT_DIG_3) begin
                                    nxt_state = SENT_CMD_4;
                                end else if (state == WAIT_CMD_4) begin
                                    nxt_state = SENT_DIG_4;
                                end else begin
                                    nxt_state = SENT_CLN_2;
                                end 
                                // nxt_state = (state == WAIT_RST_1) ? SENT_CLN_1 :
                                //     (state == WAIT_CLN_1) ? SENT_CLN_2 :
                                //     (state == WAIT_CLN_2) ? SENT_CMD_2 :
                                //     (state == WAIT_CMD_2) ? SENT_DIG_2 :
                                //     (state == WAIT_DIG_2) ? SENT_CMD_3 :
                                //     (state == WAIT_CMD_3) ? SENT_DIG_3 :
                                //     (state == WAIT_DIG_3) ? SENT_CMD_4 :
                                //     (state == WAIT_CMD_4) ? SENT_DIG_4 : SENT_CLN_2;
                            end
                        end else begin
                            nxt_sck_sent = sck_sent + 1;
                        end
                    end
                end
                LOAD_2: begin
                    sck_clear = 1;
                    nxt_ss = 1;
                    nxt_sck = 0;
                    nxt_sdi = 0;
                    nxt_reg_data = ssdec_data;
                    nxt_sck_sent = 0;
                    nxt_state = SENT_CMD_2;
                end

                default: begin
                    sck_clear = 1; 
                    nxt_ss = ss;
                    nxt_sck = sck;
                    nxt_sdi = sdi;
                    nxt_reg_data = reg_data;
                    nxt_sck_sent = sck_sent;
                    nxt_state = state;  
                end
            endcase
        end
    end
endmodule