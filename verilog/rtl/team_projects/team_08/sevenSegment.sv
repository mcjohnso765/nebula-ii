// Module to output integers 0-9 on the 7 Segment Display

module sevenSegment(
    input clk,
    input rst,
    input [3:0] number,
    input load,
    output [6:0] sevenSeg
);

    reg [6:0] sevenSegReg;

    assign sevenSeg = sevenSegReg;

    always @(posedge clk) begin
        if (!rst) begin
            sevenSegReg <= 7'b0000001;
        end
        else begin
            if (load) begin
                case(number)
                    4'b0000 : sevenSegReg <= 7'b0000001;
                    4'b0001 : sevenSegReg <= 7'b1001111;
                    4'b0010 : sevenSegReg <= 7'b0010010;
                    4'b0011 : sevenSegReg <= 7'b0000110;
                    4'b0100 : sevenSegReg <= 7'b1001100;          
                    4'b0101 : sevenSegReg <= 7'b0100100;
                    4'b0110 : sevenSegReg <= 7'b0100000;
                    4'b0111 : sevenSegReg <= 7'b0001111;
                    4'b1000 : sevenSegReg <= 7'b0000000;
                    4'b1001 : sevenSegReg <= 7'b0000100;
                    4'b1010 : sevenSegReg <= 7'b0001000;
                    4'b1011 : sevenSegReg <= 7'b1100000;
                    4'b1100 : sevenSegReg <= 7'b0110001;
                    4'b1101 : sevenSegReg <= 7'b1000010;
                    4'b1110 : sevenSegReg <= 7'b0110000;
                    4'b1111 : sevenSegReg <= 7'b0111000;
                    default: sevenSegReg <= 7'b0000100;
                endcase
            end
        end
    end

endmodule