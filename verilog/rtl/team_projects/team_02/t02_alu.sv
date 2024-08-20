module t02_alu(
    input logic signed[31:0]inputA, inputB,
    input logic[3:0] aluOP,
    output logic[31:0]ALUResult,
    output logic negative, zero
);
	typedef enum logic [3:0] {
		ALU_ADD = 0, 
		ALU_SUB = 1,
		ALU_OR = 2, 
		ALU_XOR = 3, 
		ALU_AND = 4, 
		ALU_SLL = 5, 
		ALU_SRA = 6, 
		ALU_SLTU = 7, 
		ALU_SLT = 8,
		ALU_SRL = 9
	}aluOPType;	

//input A and B must be signed!
logic [31:0] unsignedA, unsignedB;
assign unsignedA = inputA;
assign unsignedB = inputB;
always_comb begin
    //will this zero cause an issue?
    zero = 0;
    case (aluOP)
    ALU_SLL: begin
        ALUResult = inputA << inputB[4:0];
        negative = ALUResult[31];
            if (ALUResult == 0)
            zero = 1;
        else
            zero = 0;
    end
    ALU_SRA: begin
        ALUResult = inputA >>> inputB[4:0];
        negative = ALUResult[31];
        if (ALUResult == 0)
            zero = 1;
        else
            zero = 0;
    end
    ALU_SRL: begin
        ALUResult = inputA >> inputB[4:0];
        negative = ALUResult[31];
            if (ALUResult == 0)
            zero = 1;
        else
            zero = 0;
    end
    ALU_ADD: begin
        ALUResult = inputA + inputB;
        negative = ALUResult[31];
            if (ALUResult == 0)
            zero = 1;
        else
            zero = 0;
    end
    ALU_SUB: begin
        ALUResult = inputA - inputB;
        if (ALUResult == 0)
            zero = 1;
        else
            zero = 0;
        negative = ALUResult[31];
    end
    ALU_OR: begin
        ALUResult = inputA | inputB;
        negative = ALUResult[31];
            if (ALUResult == 0)
            zero = 1;
        else
            zero = 0;
    end
    ALU_XOR: begin
        ALUResult = inputA ^ inputB;
        negative = ALUResult[31];
            if (ALUResult == 0)
            zero = 1;
        else
            zero = 0;
    end
    ALU_AND: begin
        ALUResult = inputA & inputB;
        negative = ALUResult[31];
            if (ALUResult == 0)
            zero = 1;
        else
            zero = 0;
    end
    ALU_SLT: begin
        if (inputA < inputB)
            ALUResult = 32'd1;
        else
            ALUResult = 32'd0; 
        negative = ALUResult[31];
    end
    ALU_SLTU: begin
        if (unsignedA < unsignedB)
            ALUResult = 32'd1;
        else
            ALUResult = 32'd0;
        negative = ALUResult[31];
             end
    //do I need a defualt case?
    default: begin
        ALUResult = 32'd0;
        negative = 0;
        zero = 0;
    end
    endcase
end
endmodule   