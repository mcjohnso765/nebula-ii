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
    
    team_08_dinoGame game(.clk(clk), .rst(in[20]), .up(in[21]), .collides(out[33]), 
    .cs(cs),
    .cd(cd),
    .wr(wr),
    .rd(rd),
    .data(data),

    .tft_sck(tft_sck), .tft_sdi(tft_sdi), .tft_dc(tft_dc), .tft_reset(tft_reset), .tft_cs(tft_cs),
   
   /*set pin values*/
    .ones_score(ones_score), 
    .tens_score(tens_score));

assign out[32:27] = 0;


always_comb begin
        out[11:5] = ones_score;        
        out[18:12] = tens_score;
      
    if (in[22] == 1) begin
        out[0] = tft_sck;
        out[1] = tft_sdi;
        out[2] = tft_dc;
        out[3] = tft_reset;
        out[4] = tft_cs;
        out[26:19] = 0;
    end
    else begin
        out[0] = cs;
        out[1] = cd;
        out[2] = wr;
        out[3] = rd;
        out[4] = 0; 
        out[26:19] = data;
    end
end

endmodule
