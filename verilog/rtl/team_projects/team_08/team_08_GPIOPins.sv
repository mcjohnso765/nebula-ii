module GPIOPins(
    input logic [33:0] in,
    output logic [33:0] out,
    output logic blinkToggle,
    input logic clk, reset
);

logic cs, cd, wr, rd;
logic tft_sck, tft_sdi, tft_dc, tft_reset, tft_cs;
logic dac_sdi, dac_cs, dac_sck;
logic [6:0] ones_score, tens_score;
logic up, collides;    
logic [7:0] data;
    
    dinoGame game(.clk(clk), .rst(in[20]), .up(in[21]), .collides(out[33]), 
    .cs(cs),
    .cd(cd),
    .wr(wr),
    .rd(rd),
    .data(data),

    .tft_sck(tft_sck), .tft_sdi(tft_sdi), .tft_dc(tft_dc), .tft_reset(tft_reset), .tft_cs(tft_cs),
   
   /*set pin values*/
    .dac_sdi(dac_sdi),
    .dac_cs(dac_cs),
    .dac_sck(dac_sck),

    .ones_score(ones_score), 
    .tens_score(tens_score),
    .blinkToggle(blinkToggle));


always_comb begin
    if(!blinkToggle) begin
        out[11:5] = ones_score;
       
        
    end
    else begin
        out[11:5] = tens_score;
      
    end

    if (in[22] == 1) begin
        out[0] = tft_sck;
        out[1] = tft_sdi;
        out[2] = tft_dc;
        out[3] = tft_reset;
        out[4] = tft_cs;
        out[19:12] = 0;
    end
    else begin
        out[0] = cs;
        out[1] = cd;
        out[2] = wr;
        out[3] = rd;
        out[4] = 0; 
        out[19:12] = data;
    end
end

endmodule
