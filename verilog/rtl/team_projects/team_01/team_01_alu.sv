/*
    Module Name: alu
    Author: Johnny
    Description: responsible for all arithmetic and logical operations in CPU.
*/


module alu (
    input logic [3:0] aluOp,
    input logic [31:0] readData1, readData2,
    output logic zero, negative, overflow,
    output logic [31:0] aluResult
);
    // Write your code here!
    typedef enum logic [3:0] {
        ADD = 4'b0000, SUB = 4'b1000, SLL = 4'b0001, SLT = 4'b0010, XOR = 4'b0100, SRL = 4'b0101, SRA = 4'b1101, OR = 4'b0110, AND = 4'b0111, LUI = 4'b0011 
    } aluLogic; //for BEQ, BNT, BGE, BLT the sub ALUop is sent


    assign negative = aluResult[31]; //flag to check when negative(31st bit in signed)
    assign zero = aluResult == 0; //flag to chekc when its value is zero

    always_comb begin
        case(aluOp)
            ADD: begin
                 aluResult = $signed(readData1) + $signed(readData2);
                 if((readData1[31] == 1 & readData2[31] == 1 & aluResult[31] == 0) | (readData1[31] == 0 & readData2[31] == 0 & aluResult[31] == 1)) begin
                    overflow = 1'b1;
                 end else begin
                    overflow = 1'b0;
                 end
            end    
            SLL: begin aluResult = readData1 << readData2[4:0]; overflow = 1'b0; end
            XOR: begin aluResult = readData1 ^ readData2; overflow = 1'b0; end
            SRL: begin aluResult = readData1 >> readData2[4:0]; overflow = 1'b0; end
            SRA: begin aluResult = $signed(readData1) >>> readData2[4:0]; overflow = 1'b0; end
            OR:  begin aluResult = readData1 | readData2; overflow = 1'b0; end
            SLT: begin aluResult = $signed(readData1) < $signed(readData2) ? 32'd1 : 32'd0; overflow = 1'b0; end
            AND: begin aluResult = readData1 & readData2; overflow = 1'b0; end
            SUB: begin 
                 aluResult = $signed(readData1) - $signed(readData2);
                 if((readData1[31] == 0 & readData2[31] == 1 & aluResult[31] == 1) | (readData1[31] == 1 & readData2[31] == 0 & aluResult[31] == 0)) begin
                    overflow = 1'b1;
                 end else begin
                    overflow = 1'b0;
                 end
            end
            LUI: begin aluResult = $signed(readData2); overflow = 1'b0; end
            default: begin 
                aluResult = 32'h0; 
                overflow = 1'b0; 
            end
        endcase 
    end

endmodule