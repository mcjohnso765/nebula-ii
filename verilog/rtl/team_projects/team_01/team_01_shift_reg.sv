module t01_shift_reg (
    input   logic         clk, nRST, enable,
    input   logic [7:0]   char_in, 
    output  logic [127:0] shift_register
);
    always_ff @(posedge clk, negedge nRST) begin
        if(~nRST) begin
            shift_register <= {16{8'd48}};
        end else if (enable) begin
            shift_register <= {shift_register[119:0], char_in};
        end
    end

endmodule