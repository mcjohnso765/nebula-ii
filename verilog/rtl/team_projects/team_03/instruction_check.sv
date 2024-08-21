module t03_instruction_check(
    input logic [31:0] instruction,
    output logic i_request
);

    always_comb begin
        if(instruction == 32'h00008067) begin
            i_request = 1'b0;
        end else begin
            i_request = 1'b1;
        end
    end

endmodule