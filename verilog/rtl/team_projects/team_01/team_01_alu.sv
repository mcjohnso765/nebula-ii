module t01_alu (
    input   logic [3:0]  AluOP,
    input   logic [31:0] Data1, Data2,
    output  logic        Zero, Negative, Overflow,
    output  logic [31:0] AluResult
);

    typedef enum logic [3:0] {
        ADD = 4'b0000, SUB = 4'b1000, SLL = 4'b0001, SLT = 4'b0010, XOR = 4'b0100, SRL = 4'b0101, SRA = 4'b1101, OR = 4'b0110, AND = 4'b0111, LUI = 4'b0011 
    } aluLogic; //for BEQ, BNT, BGE, BLT the sub ALUop is sent

    assign Negative = AluResult[31]; //flag to check when Negative(31st bit in signed)
    assign Zero = AluResult == 0; //flag to chekc when its value is Zero

    always_comb begin
        case(AluOP)
            ADD: begin
                 AluResult = $signed(Data1) + $signed(Data2);
                 if((Data1[31] == 1 & Data2[31] == 1 & AluResult[31] == 0) | (Data1[31] == 0 & Data2[31] == 0 & AluResult[31] == 1)) begin
                    Overflow = 1'b1;
                 end else begin
                    Overflow = 1'b0;
                 end
            end    
            SLL: begin AluResult = Data1 << Data2[4:0]; Overflow = 1'b0; end
            XOR: begin AluResult = Data1 ^ Data2; Overflow = 1'b0; end
            SRL: begin AluResult = Data1 >> Data2[4:0]; Overflow = 1'b0; end
            SRA: begin AluResult = $signed(Data1) >>> Data2[4:0]; Overflow = 1'b0; end
            OR:  begin AluResult = Data1 | Data2; Overflow = 1'b0; end
            SLT: begin AluResult = $signed(Data1) < $signed(Data2) ? 32'd1 : 32'd0; Overflow = 1'b0; end
            AND: begin AluResult = Data1 & Data2; Overflow = 1'b0; end
            SUB: begin 
                 AluResult = $signed(Data1) - $signed(Data2);
                 if((Data1[31] == 0 & Data2[31] == 1 & AluResult[31] == 1) | (Data1[31] == 1 & Data2[31] == 0 & AluResult[31] == 0)) begin
                    Overflow = 1'b1;
                 end else begin
                    Overflow = 1'b0;
                 end
            end
            LUI: begin AluResult = $signed(Data2); Overflow = 1'b0; end
            default: begin 
                AluResult = 32'h0; 
                Overflow = 1'b0; 
            end
        endcase 
    end

endmodule