/*
* Address Space Description:
* DESIGNS => 0x 30 (01-NUM_TEAMS) XXXX
* LA      => 0x 3100 XXXX
* GPIO    => 0x 3200 XXXX
* 
* NOTE:
* Team 0 DOES NOT exist, so no design is
* selected when wbs_adr_i[23:16] is 0x00
*/

module wb_interconnect #(
    parameter NUM_TEAMS = 12
)
(
    // Wishbone Slave ports (only the ones we need)
    input logic wbs_stb_i,
    input logic [31:0] wbs_adr_i,
    output logic wbs_ack_o,
    output logic [31:0] wbs_dat_o,

    // Strobe Signals
    output logic designs_stb [NUM_TEAMS:0],
    output logic la_control_stb,
    output logic gpio_control_stb,

    // Truncated Address (use only last 16 bits)
    output logic [31:0] adr_truncated,

    // WB dat_o Signals
    input logic [31:0] designs_dat_o [NUM_TEAMS:0],
    input logic [31:0] la_control_dat_o,
    input logic [31:0] gpio_control_dat_o,

    // WB ack_o Signals
    input logic designs_ack_o [NUM_TEAMS:0],
    input logic la_control_ack_o,
    input logic gpio_control_ack_o
);

    // Truncated Address
    assign adr_truncated = {16'b0, wbs_adr_i[15:0]};
    
    // Multiplexing of strobe signals - LA and GPIO
    assign la_control_stb = (wbs_adr_i[31:16] == 16'h3100) ? wbs_stb_i : 'b0;
    assign gpio_control_stb = (wbs_adr_i[31:16] == 16'h3200) ? wbs_stb_i : 'b0;

    // Multiplexing of strobe signals - Team Designs
    always @(*) begin
        for (integer i = 0; i <= NUM_TEAMS; i += 1) begin
            designs_stb[i] = (wbs_adr_i[31:24] == 8'h30 && wbs_adr_i[23:16] == i[7:0]) ? wbs_stb_i : 'b0;
        end
    end

    // Multiplexing for wbs_dat_o
    always @(*) begin
        wbs_dat_o = '0;
        casez(wbs_adr_i[31:16])
            16'h30??: begin
                for (integer i = 0; i <= NUM_TEAMS; i += 1) begin
                    if (wbs_adr_i[23:16] == i[7:0]) wbs_dat_o = designs_dat_o[i];
                end
            end
            16'h3100: wbs_dat_o = la_control_dat_o;
            16'h3200: wbs_dat_o = gpio_control_dat_o;
        endcase
    end

    // Multiplexing for wbs_ack_o
    always @(*) begin
        wbs_ack_o = '0;
        casez(wbs_adr_i[31:16])
            16'h30??: begin
                for (integer i = 0; i <= NUM_TEAMS; i += 1) begin
                    if (wbs_adr_i[23:16] == i[7:0]) wbs_ack_o = designs_ack_o[i];
                end
            end
            16'h3100: wbs_ack_o = la_control_ack_o;
            16'h3200: wbs_ack_o = gpio_control_ack_o;
        endcase
    end

endmodule