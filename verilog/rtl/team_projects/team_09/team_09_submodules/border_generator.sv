module border_generator(
    input logic [3:0] x, y,
    output logic isBorder
);
    
    always_comb begin
        isBorder = 1'b0;
        if (x == 4'b0 || x == 4'd15 || y == 4'b0 || y == 4'd11) begin
            isBorder = 1'b1;
        end
    end
endmodule
