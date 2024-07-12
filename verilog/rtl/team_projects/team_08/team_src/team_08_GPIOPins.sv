module team_08_GPIOPins(
    input logic [33:0] in,
    output logic [33:0] out,
    input logic clk, reset
);

logic cs, cd, wr, rd;
logic tft_sck, tft_sdi, tft_dc, tft_reset, tft_cs;
logic [6:0] ones_score, tens_score;
logic up, collides;    
logic [7:0] data;
    
    team_08_dinoGame game(.clk(clk), .rst(~in[0] & reset), .up(in[1]), .collides(out[30]), 
    .cs(cs),
    .cd(cd),
    .wr(wr),
    .rd(rd),
    .data(data),

    .tft_sck(tft_sck), .tft_sdi(tft_sdi), .tft_dc(tft_dc), .tft_reset(tft_reset), .tft_cs(tft_cs),
   
   /*set pin values*/
    .ones_score(ones_score), 
    .tens_score(tens_score));

    assign out[33:31] = 0;
    assign out[2:0] = 0;

    assign out[22:16] = ones_score;
    assign out[29:23] = tens_score;
    assign out[15:8] = in[2] ? 0 : data;
    assign out[3] = in[2] ? tft_sck : cs;
    assign out[4] = in[2] ? tft_sdi : cd;
    assign out[5] = in[2] ? tft_dc : wr;
    assign out[6] = in[2] ? tft_reset : rd;
    assign out[7] = in[2] ? tft_cs : 0;


// always_comb begin
//         out[22:16] = ones_score;        
//         out[29:23] = tens_score;
      
//     if (in[2] == 1) begin
//         out[3] = tft_sck;
//         out[4] = tft_sdi;
//         out[5] = tft_dc;
//         out[6] = tft_reset;
//         out[7] = tft_cs;
//         out[15:8] = 0;
//     end
//     else begin
//         out[3] = cs;
//         out[4] = cd;
//         out[5] = wr;
//         out[6] = rd;
//         out[7] = 0; 
//         out[15:8] = data;
//     end
// end

endmodule
