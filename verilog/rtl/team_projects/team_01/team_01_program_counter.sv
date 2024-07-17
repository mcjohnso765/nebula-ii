module t01_program_counter (
    input   logic        clk, nRST,
    input   logic        enable,
    input   logic [31:0] new_pc,  
    output  logic [31:0] pc
);
    logic [31:0] next_pc;

    always_ff @(posedge clk, negedge nRST) begin
        if(~nRST)
            pc <= 32'h33000000;
        else begin
            pc <= next_pc;
        end
    end

    always_comb begin
        next_pc = pc;
        if (enable) begin
            next_pc = new_pc;
        end
    end
endmodule