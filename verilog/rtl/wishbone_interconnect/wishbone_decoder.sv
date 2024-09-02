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
//    team_0C/team_01/samp/la/gpio/sram
//

module wishbone_decoder #(
    parameter NUM_TEAMS = 6
)(
    `ifdef USE_POWER_PINS
        inout vccd1,	// User area 1 1.8V supply
        inout vssd1,	// User area 1 digital ground
    `endif

    input logic CLK,
    input logic nRST,

    //muxxing signals that go to manager
    input logic [NUM_TEAMS + 3:0]       wbs_ack_i_periph, 
    input logic [(32 * (NUM_TEAMS + 4)) - 1:0] wbs_dat_i_periph, //flat signal

    output logic                        wbs_ack_o_m,
    output logic                 [31:0] wbs_dat_o_m,

    //muxxing signals that come from manager
    input logic                     wbs_cyc_i_m,  
    input logic                     wbs_stb_i_m,
    input logic                     wbs_we_i_m,
    input logic              [31:0] wbs_adr_i_m, 
    input logic              [31:0] wbs_dat_i_m,
    input logic              [3:0]  wbs_sel_i_m,      

    output logic [NUM_TEAMS + 3:0]      wbs_cyc_o_periph,
    output logic [NUM_TEAMS + 3:0]      wbs_stb_o_periph, 
    output logic [NUM_TEAMS + 3:0]      wbs_we_o_periph, 
    output logic [(32 * (NUM_TEAMS + 4)) - 1:0] wbs_adr_o_periph, //flat signal
    output logic [(32 * (NUM_TEAMS + 4)) - 1:0] wbs_dat_o_periph, //flat signal
    output logic [(4 * (NUM_TEAMS + 4)) - 1:0] wbs_sel_o_periph  //flat signal
);

logic [31:0] wbs_adr_o_periph_2D [NUM_TEAMS+3: 0];
logic [31:0] wbs_dat_o_periph_2D [NUM_TEAMS+3: 0];
logic [3:0]  wbs_sel_o_periph_2D [NUM_TEAMS+3: 0];
logic [31:0] wbs_dat_i_periph_2D [NUM_TEAMS+3: 0];

// Flattening / Unflattening of port signals
integer i;
always @* begin
    for (i = 0; i <= NUM_TEAMS+3; i = i + 1) begin
        wbs_adr_o_periph[i*32 +: 32] = wbs_adr_o_periph_2D[i];
        wbs_dat_o_periph[i*32 +: 32] = wbs_dat_o_periph_2D[i];
        wbs_sel_o_periph[i*4 +: 4] = wbs_sel_o_periph_2D[i];

        wbs_dat_i_periph_2D[i] = wbs_dat_i_periph[i*32 +: 32];
    end
end

logic [NUM_TEAMS + 4:0] curr_state;
logic [NUM_TEAMS + 4:0] next_state;

logic ack_reg, next_ack_reg;
logic [31:0] dat_reg, next_dat_reg;


integer state_idx;

always_ff @ (posedge CLK, negedge nRST) begin
    if(~nRST) begin
        curr_state <= 1;
        ack_reg    <= '0;
        dat_reg    <= '0;
    end
    else begin
        curr_state <= next_state;
        ack_reg    <= next_ack_reg;
        dat_reg    <= next_dat_reg;
    end
end

assign wbs_ack_o_m = ack_reg;
assign wbs_dat_o_m = dat_reg;

    integer i2;


always @(*) begin
// always @(curr_state, ack_reg, dat_reg, wbs_cyc_i_m, wbs_stb_i_m, wbs_we_i_m, wbs_adr_i_m, wbs_dat_i_m, wbs_sel_i_m, wbs_dat_i_periph, wbs_adr_i_m[19:6], wbs_dat_i_periph) begin
    //defaults
    next_state   = curr_state;
    next_ack_reg = ack_reg;
    next_dat_reg = dat_reg;

    wbs_cyc_o_periph = '0;
    wbs_stb_o_periph = '0;
    wbs_we_o_periph  = '0;

    // Below loop basically does: 
    // wbs_adr_o_periph_2D = '0;
    // wbs_dat_o_periph_2D = '0;
    // wbs_sel_o_periph_2D = '0;
    for (i2 = 0; i2 <= NUM_TEAMS+3; i2 = i2 + 1) begin
        wbs_adr_o_periph_2D[i2] = '0;
        wbs_dat_o_periph_2D[i2] = '0;
        wbs_sel_o_periph_2D[i2] = '0;
    end

    // wbs_ack_o_m = '0;
    // wbs_dat_o_m = '0;

    for(state_idx = 0; state_idx <= (NUM_TEAMS + 4); state_idx++) begin
        if(curr_state == '1) begin //SRAM special state
            next_state = 1 << 1;

            wbs_cyc_o_periph[0] = wbs_cyc_i_m;
            wbs_stb_o_periph[0] = wbs_stb_i_m;
            wbs_we_o_periph[0]  = wbs_we_i_m;
            wbs_adr_o_periph_2D[0] = wbs_adr_i_m;
            wbs_dat_o_periph_2D[0] = wbs_dat_i_m;
            wbs_sel_o_periph_2D[0] = wbs_sel_i_m;
            next_dat_reg        = wbs_dat_i_periph_2D[0]; 
            next_ack_reg        = 1'b1;           
        end
        else if(curr_state[state_idx]) begin
            if((state_idx == 0) && wbs_cyc_i_m && wbs_stb_i_m) begin
                //this means we're in IDLE so we look at the adress to decode
                casez(wbs_adr_i_m) 
                    32'h3100????: begin //LA address space
                        next_state = 1 << 3;
                        
                        wbs_cyc_o_periph[2] = wbs_cyc_i_m;
                        wbs_stb_o_periph[2] = wbs_stb_i_m;
                        wbs_we_o_periph[2]  = wbs_we_i_m;
                        wbs_adr_o_periph_2D[2] = wbs_adr_i_m;
                        wbs_dat_o_periph_2D[2] = wbs_dat_i_m;
                        wbs_sel_o_periph_2D[2] = wbs_sel_i_m;
                        next_dat_reg        = wbs_dat_i_periph_2D[2];
                        next_ack_reg        = 1'b1;
                    end
                    32'h3200????: begin //GPIO address space
                        next_state = 1 << 2;
                        
                        wbs_cyc_o_periph[1] = wbs_cyc_i_m;
                        wbs_stb_o_periph[1] = wbs_stb_i_m;
                        wbs_we_o_periph[1]  = wbs_we_i_m;
                        wbs_adr_o_periph_2D[1] = wbs_adr_i_m;
                        wbs_dat_o_periph_2D[1] = wbs_dat_i_m;
                        wbs_sel_o_periph_2D[1] = wbs_sel_i_m;
                        next_dat_reg        = wbs_dat_i_periph_2D[1];
                        next_ack_reg        = 1'b1;
                    end
                    32'h3300????: begin //SRAM address space
                        next_state = '1;
                        
                        wbs_cyc_o_periph[0] = wbs_cyc_i_m;
                        wbs_stb_o_periph[0] = wbs_stb_i_m;
                        wbs_we_o_periph[0]  = wbs_we_i_m;
                        wbs_adr_o_periph_2D[0] = wbs_adr_i_m;
                        wbs_dat_o_periph_2D[0] = wbs_dat_i_m;
                        wbs_sel_o_periph_2D[0] = wbs_sel_i_m;
                        next_dat_reg        = wbs_dat_i_periph_2D[0];
                        // next_ack_reg        = 1'b1;
                    end
                    32'h30??????: begin //user project address space
                        next_state = 1 << (4 + wbs_adr_i_m[19:16]); //0x30-X----
                        
                        wbs_cyc_o_periph[3 + wbs_adr_i_m[19:16]] = wbs_cyc_i_m;
                        wbs_stb_o_periph[3 + wbs_adr_i_m[19:16]] = wbs_stb_i_m;
                        wbs_we_o_periph[3 + wbs_adr_i_m[19:16]]  = wbs_we_i_m;
                        wbs_adr_o_periph_2D[3 + {28'd0, wbs_adr_i_m[19:16]}] = wbs_adr_i_m;
                        wbs_dat_o_periph_2D[3 + {28'd0, wbs_adr_i_m[19:16]}] = wbs_dat_i_m;
                        wbs_sel_o_periph_2D[3 + {28'd0, wbs_adr_i_m[19:16]}] = wbs_sel_i_m;
                        next_dat_reg        = wbs_dat_i_periph_2D[3 + {28'd0, wbs_adr_i_m[19:16]}];
                        next_ack_reg        = 1'b1;
                    end
                    default: begin
                        next_ack_reg        = 1'b1;
                    end
                endcase
            end
            else if(wbs_cyc_i_m && wbs_stb_i_m) begin
                wbs_cyc_o_periph[state_idx - 1] = wbs_cyc_i_m;
                wbs_stb_o_periph[state_idx - 1] = wbs_stb_i_m;
                wbs_we_o_periph[state_idx - 1]  = wbs_we_i_m;
                wbs_adr_o_periph_2D[state_idx - 1] = wbs_adr_i_m;
                wbs_dat_o_periph_2D[state_idx - 1] = wbs_dat_i_m;
                wbs_sel_o_periph_2D[state_idx - 1] = wbs_sel_i_m;

                // next_ack_reg = wbs_ack_i_periph[state_idx - 1];

                // wbs_ack_o_m = wbs_ack_i_periph[state_idx - 1];
                // wbs_ack_o_m = 1'b1;
                // wbs_dat_o_m = wbs_dat_i_periph_2D[state_idx - 1];

                // if(wbs_ack_i_periph[state_idx - 1]) begin
                next_state = 1;
                next_ack_reg = '0;
                next_dat_reg = '0;
                // end
            end
        end
    end
end

///////////////////////////////////////////////////
// new above
///////////////////////////////////////////////////
///////////////////////////////////////////////////
// old below
///////////////////////////////////////////////////

// reg next_ack;
// reg [31:0] next_dat;

// always_ff @(posedge CLK, negedge nRST) begin
//     if(~nRST) begin
//         wbs_ack_o_p <= '0;
//         wbs_dat_o_p <= '0;
//     end
//     else begin
//         wbs_ack_o_p <= next_ack;
//         wbs_dat_o_p <= next_dat;
//     end
// end

// always @(*) begin
//     //default cases
//     next_ack    = '0;
//     next_dat    = '0;
//     wbs_cyc_o_proj = '0;
//     wbs_cyc_o_la   = '0;
//     wbs_cyc_o_gpio = '0;
//     wbs_cyc_o_sram = '0;


//     casez(wbs_adr_i_p)
//         32'h3100????: begin //LA address space
//             next_ack = wbs_ack_i_la;
//             next_dat = wbs_dat_i_la;

//             wbs_cyc_o_la = wbs_cyc_i_p;
//         end
//         32'h3200????: begin //GPIO address space
//             next_ack = wbs_ack_i_gpio;
//             next_dat = wbs_dat_i_gpio;

//             wbs_cyc_o_gpio = wbs_cyc_i_p;            
//         end
//         32'h3300????: begin //SRAM address space
//             next_ack = wbs_ack_i_sram;
//             next_dat = wbs_dat_i_sram;

//             wbs_cyc_o_sram = wbs_cyc_i_p;   
//         end
//         32'h30??????: begin //user project address space
//             // if(wbs_adr_i_p[19:16] != 0) begin
//                 next_ack = wbs_ack_i_proj[wbs_adr_i_p[19:16]];
//                 next_dat = wbs_dat_i_proj[wbs_adr_i_p[19:16]];

//                 wbs_cyc_o_proj[wbs_adr_i_p[19:16]] = wbs_cyc_i_p;
//             // end
//         end
//         default: begin
//             next_ack    = '0;
//             next_dat    = '0;
//             wbs_cyc_o_proj = '0;
//             wbs_cyc_o_la   = '0;
//             wbs_cyc_o_gpio = '0;
//             wbs_cyc_o_sram = '0;
//         end
//     endcase
// end
endmodule
