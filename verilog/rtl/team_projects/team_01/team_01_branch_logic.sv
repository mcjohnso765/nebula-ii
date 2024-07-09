/*
    Module Name: branch_logic
    Description: Takes the branch signals and ALU flag indicators to determine whether or not to branch the program counter.
    Author: Andrew
*/

module branch_logic (
    input logic [2:0]branch,
    input logic negative, zero,
    output logic branch_enable
);
    always_comb begin
        casez(branch)
            3'b0??: branch_enable = 1'b0;
            3'b100: branch_enable = zero;
            3'b101: branch_enable = ~zero;
            3'b110: branch_enable = negative;
            3'b111: branch_enable = ~negative;
        endcase
    end
endmodule