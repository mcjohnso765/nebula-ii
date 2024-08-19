module t03_imm_generator (
    input logic [31:0] inst,
    input logic [2:0] type_i,
    output logic [31:0] imm_gen
);

    always_comb begin
        case (type_i)
            I : imm_gen = {{20{inst[31]}}, inst[31:20]};
            S : imm_gen = {{20{inst[31]}}, inst[31:25], inst[11:7]};
            SB : imm_gen = {{20{inst[31]}}, inst[7], inst[30:25], inst [11:8], 1'b0};
            U : imm_gen = {inst[31:12], 12'd0};
            UJ : imm_gen = {{12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0};
            default : imm_gen = '0;
        endcase
    end
endmodule