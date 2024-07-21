/*
    Module: ssdec_decoder
    Description: 
        take in four bits data input and generate eight bits data output
    to the seven segment display.
*/
module t07_timer_ssdec_decoder(
    input logic [3:0] in,
    output logic [7:0] out
);
    always_comb begin
        case(in)
            4'd0 : out = 8'b00111111;
            4'd1 : out = 8'b00000110;
            4'd2 : out = 8'b01011011;
            4'd3 : out = 8'b01001111;
            4'd4 : out = 8'b01100110;          
            4'd5 : out = 8'b01101101;
            4'd6 : out = 8'b01111101;
            4'd7 : out = 8'b00000111;
            4'd8 : out = 8'b01111111;
            4'd9 : out = 8'b01101111;
            default: out = 8'b01111111;
        endcase
    end
endmodule