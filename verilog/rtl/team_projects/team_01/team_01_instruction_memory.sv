// DONE

/*
    Module Name: instruction_memory
    Author: Ivan Usynin
    Description: Stores all the prefetch instructions for access by program counter to instruction
*/


// module instruction_memory 
// (
//     input logic [31:0] address, instr,
//     output logic [31:0] instruction, address_IM
// );

//     assign instruction = instr;       // instruction from request unit
//     assign address_IM = address;       // instruction PC address for request unit

// endmodule

module instruction_memory (
    input   logic        clk, nRST, ihit, hold,
    input   logic [31:0] pc, FetchedInstr,
    output  logic [31:0] instruction, address_IM
);
    logic [31:0] next_instruction;

    always_ff @(posedge clk, negedge nRST) begin
        if (!nRST) begin
            instruction <= 32'b0;
        end else begin
            instruction <= next_instruction;
        end
    end

    always_comb begin
        next_instruction = 32'b0;
        if (ihit) begin
            next_instruction = FetchedInstr;
        end else if (hold) begin
            next_instruction = instruction;
        end
    end

    assign address_IM = pc;

endmodule