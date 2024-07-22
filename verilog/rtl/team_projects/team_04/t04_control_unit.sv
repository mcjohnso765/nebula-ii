//output proper control signals according to given opcode
module t04_control_unit (
    input logic [6:0] opcode, //7 bit code dictating what signals to output
    output logic [1:0] RegWriteSource,  
    // 00: The value to be written to a register comes from the ALU, 01: The value to be written to a register comes from Memory, 
    // 10: The value to be written to a register comes from an immediate, 11: The value to be written to a register comes from the Program Counter, to Registers
    output logic 
    ALUSrc, //ON: ALU operates on one register value and one immediate value. OFF: ALU operates on two register values, to ALU
    RegWrite, //ON: the destination register will be written to, to Registers
    Jump, //ON: The next instruction should be taken from the address determined by the immediate value, to PC
    Branch, //ON: The next instruction should be taken from the address determined by the immediate value if some condition is fulfilled, to PC
    MemWrite, //ON: Memory will be written to, to Data Memory
    MemRead, //ON: Memory will be read from, to Data Memory
    Error, //ON: Invalid Opcode 
    AUIlink //ON: auipc instruction, requires 
);
    

always_comb begin
    case (opcode)
    7'b0110111: begin //lui
	    RegWrite = 1;
	    ALUSrc = 0;
        RegWriteSource = 2'b10;
	    MemWrite = 0;
	    MemRead = 0;
        Jump = 0;
        Branch = 0;
        Error = 0;
        AUIlink = 0;
    end

    7'b0010111: begin //(auipc)
        RegWrite = 1;
        ALUSrc = 1;
        RegWriteSource = 2'b11;
        MemWrite = 0;
        MemRead = 0;
        Jump = 0;
        Branch = 0;
        Error = 0;
        AUIlink = 1;
    end
    
    7'b1101111: begin //(jal)
        RegWrite = 1;
        ALUSrc = 1;
        RegWriteSource = 2'b11;
        MemWrite = 0;
        MemRead = 0;
        Jump = 1;
        Branch = 0;
        Error = 0;
        AUIlink = 0;
    end

    7'b1100111: begin //(jalr)
        
        RegWrite = 1;
        ALUSrc = 1;
        RegWriteSource = 2'b11;
        MemWrite = 0;
        MemRead = 0;
        Jump = 1;
        Branch = 0;
        Error = 0;
        AUIlink = 0;
    end

    7'b1100011: begin //(B-Type):
        RegWrite = 0;
        ALUSrc = 0;
        RegWriteSource = 2'b00;
        MemWrite = 0;
        MemRead = 0;
        Jump = 0;
        Branch = 1;
        Error = 0;
        AUIlink = 0;
    end

    7'b0000011: begin //(I-Type):
        RegWrite = 1;
        ALUSrc = 1;
        RegWriteSource = 2'b01;
        MemWrite = 0;
        MemRead = 1;
        Jump = 0;
        Branch = 0;
        Error = 0;
        AUIlink = 0;
    end

    7'b0100011: begin //(S-Type):
        RegWrite = 0;
        ALUSrc = 1;
        RegWriteSource = 2'b00;
        MemWrite = 1;
        MemRead = 0;
        Jump = 0;
        Branch = 0;
        Error = 0;
        AUIlink = 0;
    end

    7'b0010011: begin //(I-Type):
        RegWrite = 1;
        ALUSrc = 1;
        RegWriteSource = 2'b00;
        MemWrite = 0;
        MemRead = 0;
        Jump = 0;
        Branch = 0;
        Error = 0;
        AUIlink = 0;
    end

    7'b0110011: begin //(R-Type):    
        RegWrite = 1;
        ALUSrc = 0;
        RegWriteSource = 2'b00;
        MemWrite = 0;
        MemRead = 0;
        Jump = 0;
        Branch = 0;
        Error = 0;
        AUIlink = 0;
    end
     
    default: begin
        RegWrite = 0;
        ALUSrc = 0;
        RegWriteSource = 2'b00;
        MemWrite = 0;
        MemRead = 0;
        Jump = 0;
        Branch = 0;
        Error = 1;
        AUIlink = 0;
    end
    endcase
end

endmodule

//changes made include additional AUIlink signal