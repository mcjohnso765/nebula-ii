/** Simple frame-buffer based driver for the ILI9341 TFT module */
module team_08_tft_ili9341(
		input clk,
		output wire tft_sck, output wire tft_sdi, 
		output wire tft_dc, output reg tft_reset, output wire tft_cs,
		input[15:0] framebufferData, output wire framebufferClk, output [2:0] tftstate
	);
	
	parameter INPUT_CLK_MHZ = 12; /* recommended */
	
	// Initial assignments
	initial tft_reset = 1'b1;

	// Assign pins and modules
	reg[8:0] spiData; 
	reg spiDataSet = 1'b0;
	wire spiIdle;
	
	reg frameBufferLowNibble = 1'b1;
	assign framebufferClk = !frameBufferLowNibble;
	
	team_08_tft_ili9341_spi spi(
		.spiClk(clk), 
		.data(spiData), .dataAvailable(spiDataSet),
		.tft_sck(tft_sck), .tft_sdi(tft_sdi), .tft_dc(tft_dc), .tft_cs(tft_cs),
		.idle(spiIdle));
	
	// Init Sequence Data (based upon https://github.com/notro/fbtft/blob/master/fb_ili9341.c)
	localparam INIT_SEQ_LEN = 52;
	reg[5:0] initSeqCounter = 6'b0;
	reg[8:0] INIT_SEQ [0:INIT_SEQ_LEN-1];
    initial begin
        $readmemh("tft.mem", INIT_SEQ, 0, INIT_SEQ_LEN-1);
    end
	
	
	// state machine with delay + idle support (used for initialization)
	reg[23:0] remainingDelayTicks = 24'b0;
	enum logic[2:0] { START, HOLD_RESET, WAIT_FOR_POWERUP, SEND_INIT_SEQ, LOOP} state;
    initial state = START;

	assign tftstate = state;
	always @ (posedge clk) begin
		// clear data flag first
		spiDataSet <= 1'b0; 
		
		// always decrement delay ticks
		if (remainingDelayTicks > 0) begin
			remainingDelayTicks <= remainingDelayTicks - 1'b1;
		end
		else if (spiIdle && !spiDataSet) begin
			// advance state machine to next state, but only do this if we
			// didn't just clock in the last byte (since idle is not yet updated)
			case (state)
				// initialize all pins in START mode; reset the LCD
				START: begin
					tft_reset <= 1'b0;
					remainingDelayTicks <= 24'(INPUT_CLK_MHZ * 10); // min: 10us
					state <= HOLD_RESET;
				end
				
				// wait for RESET to kick in; then release pin & wait for power up
				HOLD_RESET: begin
					tft_reset <= 1'b1; // release pin
					remainingDelayTicks <= 24'(INPUT_CLK_MHZ * 120000); // min: 120ms
					state <= WAIT_FOR_POWERUP;
					frameBufferLowNibble <= 1'b0; // request first pixel
				end
				
				// if power up is completed -> sw reset
				WAIT_FOR_POWERUP: begin
					spiData <= {1'b0, 8'h11}; // take out of sleep mode
					spiDataSet <= 1'b1;
					remainingDelayTicks <= 24'(INPUT_CLK_MHZ * 5000); // min: 5ms
					state <= SEND_INIT_SEQ;
					frameBufferLowNibble <= 1'b1;
				end
				
				// setup the LCD by sending the init sequence
				SEND_INIT_SEQ: begin
					if (initSeqCounter < INIT_SEQ_LEN) begin
						spiData <= INIT_SEQ[initSeqCounter];
						spiDataSet <= 1'b1;
						initSeqCounter <= initSeqCounter + 1'b1;
					end else begin
						state <= LOOP;
						remainingDelayTicks <= 24'(INPUT_CLK_MHZ * 10000); // min: 10ms
					end
				end
				
				// frame buffer loop
				default: begin
					spiData <= !frameBufferLowNibble ? {1'b1, framebufferData[15:8]} :{1'b1, framebufferData[7:0]};
					spiDataSet <= 1'b1;
					frameBufferLowNibble <= !frameBufferLowNibble;
				end
			endcase
		end
	end
endmodule