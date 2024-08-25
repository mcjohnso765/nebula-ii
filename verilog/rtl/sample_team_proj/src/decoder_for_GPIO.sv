// $Id: $
// File name:   decoder_for_GPIO.sv
// Created:     5/23/2024
// Author:      Miguel Isrrael Teran
// Description: Decoder for GPIO outputs

module decoder_for_GPIO (
    input logic [5:0] in,
    output logic [33:0] out
);
    // Decoder Logic
    always_comb begin
        out = '0;
        if (in > '0 && in < 6'd35)
            out[in - 1] = 1'b1;
    end
endmodule