//decode instruction into register addresses and Opcode
module t04_decode (
    input logic [31:0] instruction, //32 bit instruction signal, from Program Memory
    output logic [4:0] rs1, rs2, rd, //5 bit register addresses, to registers 
    output logic [6:0] opcode, //7 bit Opcode, to Control Unit
    output logic [2:0] ALUOp, //3-bit code (func-3), used to further specify operations. to ALU, & memory handler
    output logic [6:0] func7 //7-bit code, used to further specify operations, to ALU
);

assign opcode = instruction[6:0];
assign rd = instruction[11:7];
assign rs1 = instruction[19:15];
assign rs2 = instruction[24:20];
assign ALUOp = instruction[14:12];
assign func7 = instruction[31:25];

endmodule