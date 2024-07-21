module toggle_screen (
    input logic clk, rst,
    input logic [3:0] bcd_ones, bcd_tens, bcd_hundreds,
    output logic [3:0] displayOut,
    output logic [1:0] blinkToggle
);
logic [1:0] nextBlinkToggle;
logic [3:0] nextDisplayOut;

always_ff @(posedge clk, negedge rst) begin
    if (~rst) begin
        blinkToggle <= 2'b0;
        displayOut <= 0;
    end else begin
        blinkToggle <= nextBlinkToggle;
        displayOut <= nextDisplayOut;
    end
end

always_comb begin
    nextBlinkToggle = 2'b0;
    nextDisplayOut = 4'b0;

    if (blinkToggle < 2'd2) begin
        nextBlinkToggle = blinkToggle + 2'b1;
    end else begin
        nextBlinkToggle = 2'b0;
    end
    
    if (blinkToggle == 0) begin
        nextDisplayOut = bcd_ones;
    end else if (blinkToggle == 1) begin
        nextDisplayOut = bcd_tens;
    end else begin
        nextDisplayOut = bcd_hundreds;
    end
end
endmodule
