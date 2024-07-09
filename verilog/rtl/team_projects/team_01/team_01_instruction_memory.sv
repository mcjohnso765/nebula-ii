/*
    Module Name: instruction_memory
    Author: Ivan Usynin
    Description: Stores all the prefetch instructions for access by program counter to instruction
*/


module instruction_memory 
(
    input logic [31:0] address, instr,
    output logic [31:0] instruction, address_IM
);

    assign instruction = instr;       // instruction from request unit
    assign address_IM = address;       // instruction PC address for request unit

endmodule
