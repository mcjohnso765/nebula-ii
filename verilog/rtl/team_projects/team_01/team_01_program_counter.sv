// DONE

/*
    Module Name: program_counter
    Description: keeps track of where we are in the program, adding 4 bits every normal cycle and accounting for jumps and branches. Contains an enable flag, coming from the request unit, to make sure the instruction has been fetched before updating.
    Author: Johnny, Andrew
*/

module program_counter (
    input   logic        clk, nRST,
    input   logic        Jump, enable,
    input   logic [31:0] in1, in2,  
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
            next_pc = Jump ? in1 : in2;
        end
    end
endmodule