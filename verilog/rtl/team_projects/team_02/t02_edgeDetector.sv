module t02_edgeDetector (
    input logic clk, nRst_i,
    input logic button_i,
    output logic button_p
);

 logic flip1, flip2;
//Edge Detector
    always_ff@(posedge clk, negedge nRst_i) begin
        if (nRst_i == 0) begin
            flip1 <= 0;
            flip2 <= 0;
        end
        else begin
            flip2 <= flip1;
            flip1 <= button_i;
        end
    end
    //make sure this is the correct edge detector (should be rising edge)
    always_comb begin
        button_p = flip1 && ~flip2;
    end

endmodule