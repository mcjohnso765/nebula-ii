module team_08_score_display(
    input logic clk, reset,
    input logic [3:0] bcd_ones, bcd_tens,
    output logic [3:0] displayOut,
    output logic blinkToggle
);

    logic [3:0] nextDisplayOut;
    logic nextBlinkToggle;
    
    
    always_ff @(posedge clk, negedge reset) begin
        if(~reset) begin
            blinkToggle <= 0;
            displayOut <= 0;
        end
        else begin
            blinkToggle <= nextBlinkToggle;
            displayOut <= nextDisplayOut;
        end    
    end

    always_comb begin
        nextBlinkToggle = 0;
        nextDisplayOut = 0;

        nextBlinkToggle = ~blinkToggle;

        if(~blinkToggle) begin
            nextDisplayOut = bcd_ones;
        end
        else begin
            nextDisplayOut = bcd_tens;
        end
    end
    
endmodule