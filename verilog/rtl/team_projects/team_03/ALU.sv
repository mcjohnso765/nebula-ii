module t03_ALU (
    input logic signed [31:0] srda, imm_gen, srdb,
    input logic unsigned [31:0] rda_u, rdb_u,
    input logic [3:0] fop,
    input logic alu_mux_en, u,
    output logic [31:0] result,
    output logic Z, N, V
);
  logic [31:0] rda, rdb;
  logic [31:0] rdb_mux;

  always_comb begin
    if (!u) begin
      rda = srda;
      rdb_mux = srdb;
    end
  else begin
      rda = rda_u;
      rdb_mux = rdb_u;
    end
  end

  // logic [31:0] rdb;
  assign rdb = (alu_mux_en) ? imm_gen : rdb_mux;

    always_comb begin
        case (fop)
            FOP_ADD : result = rda + rdb;
            FOP_SUB : result = rda - rdb;
            FOP_SLL : result = rda << rdb;
            FOP_SRL : result = rda >> rdb;
            FOP_SRA : result = rda >>> rdb;
            FOP_AND : result = rda & rdb;
            FOP_OR : result = rda | rdb;
            FOP_XOR : result = rda ^ rdb;
            FOP_IMM : result = imm_gen;
            default : result = '0;
        endcase
    end

    assign Z = (result == 0) ? 1'b1 : 1'b0;
    assign N = result[31];

    always_comb begin
        if (fop == FOP_ADD) begin
            if ((rda[31] && rdb[31] && !result[31]) || (!rda[31] && !rdb[31] && result[31]))
                V = 1'b1;
            else
                V = '0;
        end else if (fop == FOP_SUB) begin
            if ((rda[31] && !rdb[31] && !result[31]) || (!rda[31] && rdb[31] && result[31]))
                V = 1'b1;
            else
                V = '0;
        end
        else V = '0;
    end
endmodule