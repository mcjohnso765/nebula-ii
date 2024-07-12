
module team_08_imageGenerator (
    input clk,                          // system clock
    input rst,                          // active low reset
    // Items to draw on the LCD
    
    input r_cactus, r_dino,r_floor, r_cloud, r_idle, r_over, r_win,

    output [8:0] x,                     // current x coordinate
    output [7:0] y,                     // current y coordinate

    // SPI LCD related signals
    output wire tft_sck, 
    output wire tft_sdi, 
	output wire tft_dc, 
    output wire tft_reset, 
    output wire tft_cs);
    
    logic [2:0] tftstate;

    // Use PLL to create a fast clock (~50 MHz)
    wire tft_clk;
	wire clk_10khz;
	// pll pll_inst(clk, tft_clk, clk_10khz);  // 4x faster clock
    assign tft_clk = clk; // system clock

	// *************************** Framebuffer ************************
	reg[16:0] framebufferIndex = 17'd0;
	wire fbClk;
	initial framebufferIndex = 17'd0;

	always @ (posedge fbClk) begin
		framebufferIndex <= (framebufferIndex + 1'b1) % 17'(320*240);
	end

    // X,Y calc
	assign x = 9'(framebufferIndex / 240);
	assign y = 8'(framebufferIndex % 240);

    // Output the images
    // Cycles through all pixels and sets it to the correct color
    // wire [15:0] currentPixel = rectangle_pixel ? 16'b011111_01101_01011 : fatalCollision ? 16'b111111_00000_00000 : gameComplete ? 16'b000000_00000_11111 : ((snakeHead | snakeBody) ? 16'b000000_00000_11111 : 16'd0 | 
    // apple ? 16'b111111_00000_00000 : 16'd0 | 
    // border ? 16'b011111_01111_01111 : 16'd0);
	 wire [15:0] currentPixel = r_floor ? 16'd0: r_cactus ? 16'b0000000000011111 : r_dino ? 16'b0000011111100000 : r_cloud ? 16'd0 : r_win ? 16'd0 : r_idle ? 16'd0 : r_over ? 16'd0 : 16'b111111_1111_1111;
	// *************************** TFT Module ************************
	team_08_tft_ili9341 #(.INPUT_CLK_MHZ(12)) tft(tft_clk, tft_sck, tft_sdi, tft_dc, tft_reset, tft_cs, currentPixel, fbClk, tftstate);

endmodule
