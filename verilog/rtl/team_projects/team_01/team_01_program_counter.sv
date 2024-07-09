module program_counter (
    input   logic        clk, nRST,
    input   logic        Jump, enable,
    input   logic [31:0] new_pc,  
    output  logic [31:0] pc
);
    logic [31:0] next_pc;

    always_ff @(posedge clk, negedge nRST) begin
        if(~nRST)
            pc <= 32'b0;
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