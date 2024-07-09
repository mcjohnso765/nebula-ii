/*
    Module: imageGenerator 
    Description:    
        take in the game_control_state and playing_state and the signal that control each components
    and output the x, y, and corresponding 16-bit color data to display to the tft display.
*/

`define MENU 3'b000
`define PLAY 3'b001
`define LOST 3'b010
`define WON 3'b011

`define MOD 3'b000
`define MAZE 3'b001

`define SELECT 6'b000001
`define UP 6'b000010
`define RIGHT 6'b000100
`define DOWN 6'b001000
`define LEFT 6'b010000
`define BACK 6'b100000
`define NO_PRESS 6'b000000

module imageGenerator (
    input logic clk,                          // system clock
    input logic nrst,                          // active low reset
    input logic tft_sdo,                      // NOT USED 

    // Items to draw on the LCD
    input logic [2:0] game_state,             // game state
    input logic [2:0] playing_state,
    input logic circlePixel, borderPixel, flagPixel, playerPixel, heartPixel, 
    input logic playButtonPixel, modSquaresPixel, modHighlightPixel, defusedPixel, boomPixel,
    output wire [8:0] x,                     // current x coordinate
    output wire [7:0] y,                     // current y coordinate

    // SPI LCD related signals
    output wire tft_sck, 
    output wire tft_sdi, 
	output wire tft_dc, 
    output wire tft_reset, 
    output wire tft_cs,
    output wire [2:0] tftstate
);
    logic [15:0] currentPixel;
    logic tft_clk;
	assign tft_clk = clk; // system clock

	// Use PLL to create a fast clock (~50 MHz):
    // wire clk_10khz;
    // pll pll_inst(clk, tft_clk, clk_10khz);  // 4x faster clock

    // TFT Module
	tft_ili9341 #(.INPUT_CLK_MHZ(12)) tft(tft_clk, tft_sdo, tft_sck, tft_sdi, tft_dc, tft_reset, tft_cs, currentPixel, fbClk, tftstate);

	// Framebuffer 
	reg[16:0] framebufferIndex = 17'd0;
	wire fbClk;
	initial framebufferIndex = 17'd0;

	always_ff @ (posedge fbClk) begin
        framebufferIndex <= (framebufferIndex + 1'b1) % 17'(320*240);
	end

    // X,Y calc
	assign x = 9'(32'(framebufferIndex) / 240);
	assign y = 8'(32'(framebufferIndex) % 240);

    // Output the images: cycle through all pixels and sets it to the correct color
    always_comb begin
        currentPixel = 16'h07ff;    // cyan
        if (game_state == `MENU) begin
            currentPixel = playButtonPixel ? 16'hD8D7 : 16'h0000;    // yellow
        end else if (game_state == `PLAY) begin
            if (playing_state == `MOD) begin
                currentPixel = modSquaresPixel ? 16'hf81f :     // yellow
                    modHighlightPixel ? 16'hFFFF:               // white
                    heartPixel ? 16'hF800 : 16'h0000;           // red   
            end else if (playing_state == `MAZE) begin
                // currentPixel = 16'hffe0;    // purple
                currentPixel = heartPixel ? 16'hF800 :  // red 
                    circlePixel ? 16'h47AB:             // green
                    flagPixel ? 16'hF800:               // red
                    playerPixel ? 16'hFFFF:             // white
                    borderPixel ? 16'hAD58 : 16'd0;     // grey : black
            end else begin
                currentPixel = 16'h001F;    // green
            end
        end else if (game_state == `WON) begin
            currentPixel = defusedPixel ? 16'hF800 : 16'h0000;  // red
        end else if (game_state == `LOST) begin
            currentPixel = boomPixel ? 16'hF800 : 16'h0000;     // red
        end
    end
	

endmodule
