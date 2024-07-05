/////////////////////////////////////////////////////////////////////////////////////////
// This is score_display.sv with only instantiation instead of having other local modules
/////////////////////////////////////////////////////////////////////////////////////////

// integrates the score tracker module, ssdec, and display toggling
`default_nettype none
module score_display2 (
    // I/O ports
    input logic clk, rst, 
    input logic [3:0] bcd_ones, bcd_tens,
    output logic [3:0] displayOut, 
    output logic blinkToggle

);
    logic isGameComplete;
    logic [3:0] nextDisplayOut;
    logic button;

logic nextBlinkToggle;

// Clock divider for fast blinking
always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        blinkToggle <= 1'b0;
        displayOut <= 0;
    end else begin
        blinkToggle <= nextBlinkToggle;
        displayOut <= nextDisplayOut;
    end
end

always_comb begin
    nextBlinkToggle = 1'b0;
    nextDisplayOut = 4'b0;

    nextBlinkToggle = ~blinkToggle;

    if (~blinkToggle) begin
        nextDisplayOut = bcd_ones;
    end else begin
        nextDisplayOut = bcd_tens;
    end
end
endmodule