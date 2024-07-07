//decoder to route the important wishbone signals to their respective peripheral
//
// the structure I imagine is 
//  
//  Master1,    Master2,     Master3
//      |           |           |
//      V           V           V
//     --------Arbitrator--------
//                  |           
//                  V
//               Decoder
//                | | |
//                V V V
//           gpio/la/user projects/sram
//


module wishbone_decoder #(
    parameter NUM_TEAMS = 12
)(
    `ifdef USE_POWER_PINS
        inout vccd1,	// User area 1 1.8V supply
        inout vssd1,	// User area 1 digital ground
    `endif

    input logic CLK,
    input logic nRST,

    input logic [31:0] wbs_adr_i_p, //we need the address to determine where to send signals

    //muxxing signals that go to manager
    input logic [NUM_TEAMS:0] wbs_ack_i_proj, //block of acks that must be multiplxed for the arbitrator
    input logic                   wbs_ack_i_la,
    input logic                   wbs_ack_i_gpio,
    input logic                   wbs_ack_i_sram,
    output logic                  wbs_ack_o_p,

    input logic [NUM_TEAMS:0][31:0] wbs_dat_i_proj, //block of dat_o that must be multiplxed for the arbitrator
    input logic              [31:0] wbs_dat_i_la,
    input logic              [31:0] wbs_dat_i_gpio,
    input logic              [31:0] wbs_dat_i_sram,
    output logic             [31:0] wbs_dat_o_p,

    //muxxing signals that come from manager
    input logic                    wbs_cyc_i_p,  //input to be muxxed to the correct output
    output logic [NUM_TEAMS:0]     wbs_cyc_o_proj,
    output logic                   wbs_cyc_o_la,
    output logic                   wbs_cyc_o_gpio,
    output logic                   wbs_cyc_o_sram
);

reg next_ack;
reg [31:0] next_dat;

always_ff @(posedge CLK, negedge nRST) begin
    if(~nRST) begin
        wbs_ack_o_p <= '0;
        wbs_dat_o_p <= '0;
    end
    else begin
        wbs_ack_o_p <= next_ack;
        wbs_dat_o_p <= next_dat;
    end
end


always @(*) begin
    //default cases
    next_ack    = '0;
    next_dat    = '0;
    wbs_cyc_o_proj = '0;
    wbs_cyc_o_la   = '0;
    wbs_cyc_o_gpio = '0;
    wbs_cyc_o_sram = '0;


    casez(wbs_adr_i_p)
        32'h3100????: begin //LA address space
            next_ack = wbs_ack_i_la;
            next_dat = wbs_dat_i_la;

            wbs_cyc_o_la = wbs_cyc_i_p;
        end
        32'h3200????: begin //GPIO address space
            next_ack = wbs_ack_i_gpio;
            next_dat = wbs_dat_i_gpio;

            wbs_cyc_o_gpio = wbs_cyc_i_p;            
        end
        32'h3300????: begin //SRAM address space
            next_ack = wbs_ack_i_sram;
            next_dat = wbs_dat_i_sram;

            wbs_cyc_o_sram = wbs_cyc_i_p;   
        end
        32'h30??????: begin //user project address space
            // if(wbs_adr_i_p[19:16] != 0) begin
                next_ack = wbs_ack_i_proj[wbs_adr_i_p[19:16]];
                next_dat = wbs_dat_i_proj[wbs_adr_i_p[19:16]];

                wbs_cyc_o_proj[wbs_adr_i_p[19:16]] = wbs_cyc_i_p;
            // end
        end
        default: begin
            next_ack    = '0;
            next_dat    = '0;
            wbs_cyc_o_proj = '0;
            wbs_cyc_o_la   = '0;
            wbs_cyc_o_gpio = '0;
            wbs_cyc_o_sram = '0;
        end
    endcase
end
endmodule