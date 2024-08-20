module t01_instruction_memory (
    input   logic        clk, nRST, ihit, hold,
    input   logic [31:0] pc, FetchedInstr,
    output  logic [31:0] instruction, address_IM,
    output  logic        pc_enable
);
    logic [31:0] next_instruction;
    logic next_enable;

    always_ff @(posedge clk, negedge nRST) begin
        if (!nRST) begin
            instruction <= 32'b0;
            pc_enable   <= 1'b0;
        end else begin
            instruction <= next_instruction;
            pc_enable   <= next_enable;
        end
    end

    always_comb begin
        next_instruction = 32'b0;
        next_enable      = 1'b0;
        if (ihit) begin
            next_instruction = FetchedInstr;
            next_enable      = 1'b1;
        end else if (hold) begin
            next_instruction = instruction;
        end
    end

    assign address_IM = pc;

endmodule