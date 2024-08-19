typedef enum logic [2:0] {BEQ = 1, BNE = 2, BLT = 3, BGE = 4, BLTU = 5, BGEU = 6, JMP = 7, NONE = 0} b_t;

module t03_branch_logic(
    input b_t branch_type,
    input logic ALU_neg_flag, ALU_zero_flag, ALU_overflow_flag,
    output logic b_out
);

always_comb begin
    if ((branch_type == BEQ)&&(ALU_zero_flag) && (!ALU_overflow_flag)) begin
        b_out = 1'b1;

    end

    else if ((branch_type == BNE) && (!ALU_zero_flag)&& (!ALU_overflow_flag)) begin
        b_out = 1'b1;

    end

    else if ((branch_type == BLT) && (ALU_neg_flag)&& (!ALU_overflow_flag)) begin
        b_out = 1'b1;
    end
    
    else if((branch_type == BGE) && (!ALU_neg_flag) && (!ALU_overflow_flag)) begin
      b_out = 1'b1;
    end

    else if ((branch_type == BLTU) && (ALU_neg_flag)&& (!ALU_overflow_flag)) begin
        b_out = 1'b1;
    end
    
    else if((branch_type == BGEU) && (!ALU_neg_flag) && (!ALU_overflow_flag)) begin
        b_out = 1'b1;
    end

    else if(branch_type == JMP) begin
        b_out = 1'b1;
    end

    else if ((branch_type == NONE)) begin
        b_out = 1'b0;

    end

    else begin
        b_out = 1'b0;

    end

end

endmodule