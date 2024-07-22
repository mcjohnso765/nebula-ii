// SPI Module
// Set to operate at 1 MHz frequency - change the count parameter to set it to the correct frequency
// Sends and receives 16 bits at a time

module t07_spi #(
        parameter FREQ_COUNTER = 6,         // Counter for the clock divider - should be equal to (system clk freq/desired clk freq)/2
        parameter FREQ_COUNTER_WIDTH = 4    // Number of bits needed for the counter
    )(
        input sysclk,                       // System clock (12 MHz for ECP5)
        input [15:0] data_transmit,         // Data to send to the SPI device
        input start_transmit,               // Control signal to start the SPI transaction
        output reg transmit_complete,       // Status signal set when transaction is complete
        output [15:0] data_receive,         // Data received from the SPI device
        
        // SPI ports
        input miso,
        output sclk,
        output mosi,
        output reg cs
        );
	
	// --- Generate 1 MHz Clock -----
	reg	clk_1MHz;                           // New 1 MHz clock
	reg [FREQ_COUNTER_WIDTH:0] counter;     // Internal counter
		
	always @ (posedge sysclk) begin
	  if (counter==0) begin
		  counter <= FREQ_COUNTER;
		  clk_1MHz <= ~clk_1MHz;            // toggle the output clock
		end
	  else
		  counter <= counter - 1'b1;
    end

	// ---- FSM to detect rising edge of start_transmit and falling edge of cs
    /// Needed to start off the SPI transaction when the start_transmit signal is on for lower period

	reg [1:0] rise_fall_state;              // register to keep track of state of the FSM
	parameter IDLE  = 2'b00, WAIT_CSB_LOW = 2'b01, WAIT_CSB_HIGH = 2'b10;
	reg	spi_start;		                    // set if start_transmit is detected
    
    // Set next state
	always @ (posedge sysclk) begin
		case (rise_fall_state)
			IDLE:	if (start_transmit==1'b1) rise_fall_state <= WAIT_CSB_LOW;
			WAIT_CSB_LOW: if (cs==1'b0) rise_fall_state <= WAIT_CSB_HIGH;
			WAIT_CSB_HIGH: if (cs==1'b1) rise_fall_state <= IDLE;
			default: rise_fall_state <= IDLE;
		endcase
    end
	
    // What happens in each state
	always @ (*)
		case (rise_fall_state)
			IDLE: spi_start = 1'b0;
			WAIT_CSB_LOW: spi_start = 1'b1;
			WAIT_CSB_HIGH: spi_start = 1'b0;
			default: spi_start = 1'b0;
		endcase
		
	//------- End circuit to detect start and end of conversion	state machine

	//------- SPI controller FSM
	// 17 states: IDLE state, 16 states for shifting data
	reg [4:0] 	state;                      // register to keep track of the state of the FSM
		
	always @(posedge clk_1MHz)  begin       // FSM state transition
		case (state)
			5'd0:	if (spi_start == 1'b1)  // wait for start signal
						state <= state + 1'b1; 
					else 
						state <= 5'b0; 
			5'd17: 	state <= 5'd0;          // go back to idle state
			default: state <= state + 1'b1;	// default go to next state
		endcase
    end
	
	always @ (*)	begin			        // What to do in each state
		cs = 1'b0;
		case (state)
			5'd0: 	begin cs = 1'b1; transmit_complete = 1'b1; end
			5'd17: 	begin cs = 1'b1; transmit_complete = 1'b1; end
			default: begin cs = 1'b0; transmit_complete = 1'b0; end
			endcase
		end 
	// --------- END of SPI controller FSM
	
	// shift registers for data
	reg [15:0] mosi_reg;
    reg [15:0] miso_reg;

    // The output data is saved to data_receive
    // Only read it when transmission is complete
    assign data_receive = miso_reg;

	always @(posedge clk_1MHz) begin
		if((spi_start==1'b1)&&(cs==1'b1))		// load the data
			mosi_reg <= data_transmit;
		else 
			mosi_reg <= {mosi_reg[14:0],1'b0};  // shift the data
    end

    always @(negedge clk_1MHz) begin
		if(transmit_complete == 1)		        // hold the last transmitted data
			miso_reg <= miso_reg;
		else 									// else shift the data
			miso_reg <= {miso_reg[14:0], miso};
    end

	// Assign outputs to drive SPI interface
	assign sclk = !clk_1MHz&!cs;
	assign mosi = mosi_reg[15];


endmodule