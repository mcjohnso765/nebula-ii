module apple_sprite(
    input logic [9:0] count, // 10-bit input to cover the range of indices (0 to 799)
    output logic apple_rgb // 1-bit output to represent the value at the index
);

    always_comb begin
        if ((count <= 799)) begin
            apple_rgb = 1;
        end else begin
            apple_rgb = 0;
        end
    end

endmodule
