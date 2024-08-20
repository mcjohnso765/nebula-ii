module t01_branch_logic (
    input   logic [2:0] Branch,
    input   logic Negative, Zero,
    output  logic Enable
);
    always_comb begin
        if (Branch[2]) begin
            case(Branch[1:0])
            2'b00:  Enable = Zero;
            2'b01:  Enable = ~Zero;
            2'b10:  Enable = Negative;
            2'b11:  Enable = ~Negative;
            default: Enable = 1'b0;
        endcase
        end else begin
            Enable = 1'b0;
        end
        
    end
endmodule