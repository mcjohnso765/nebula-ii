// Module for button debouncing
module t02_button(
	input         clk,     // clock input from FPGA (12MHz)
	input         noisy,   // noisy button input
	output        btn_ctrl // debounced button output one cycle 
  );     
  parameter LIMIT = 100000; // set the bouncing threshold to 10ms, 10ms / (1/12MHz) = 120000 clock cycles
  
  reg    [16:0] r_counter;  // size need to be larger or equal to LIMIT
  reg           r_debounce;
  wire debounce;
	reg  debounce_dly;

  assign debounce = r_debounce;

  assign btn_ctrl = ~debounce_dly & debounce; 
	always @(posedge clk)
			debounce_dly <= debounce;

  always @ (posedge clk) begin
    if (noisy !== r_debounce && r_counter < LIMIT)
      r_counter <= r_counter + 1;
    else if (r_counter == LIMIT) begin
      r_debounce <= noisy;
      r_counter <= 17'b0;
    end
    else  
      r_counter <= 17'b0;
  end
  
endmodule