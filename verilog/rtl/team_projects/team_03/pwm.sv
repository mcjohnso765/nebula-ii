module pwm (
  input [31:0] duty,
  input [31:0] freq,
  input clk,
  input reset,
  output pwm_signal
);

  reg [31:0] counter;
  
  always_ff @(posedge clk, posedge reset) begin
    if(reset)
        counter = 0;
    else begin
        counter = counter < freq ? counter + 1 : 0;
    end
  end

  assign pwm_signal = counter < duty;

endmodule
