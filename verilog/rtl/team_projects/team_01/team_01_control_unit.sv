module t01_control_unit (
input logic [6:0] opcode,
input logic [2:0] funct3,
input logic bit30,
output logic [1:0] datawidth,
output logic [1:0] jump,
output logic [2:0] branch,
output logic memread,
output logic mem_to_reg,
output logic [3:0] aluop, // {bit[31],bit[30], bit[14:12]}
output logic mem_write,
output logic alusrc,
output logic regwrite,
output logic auipc
);

typedef enum logic [3:0] {ADD = 4'b0000, SUB = 4'b1000, SLL = 4'b0001, SLT = 4'b0010, XOR = 4'b0100, SRL = 4'b0101, SRA = 4'b1101, OR = 4'b0110, AND = 4'b0111, LUI = 4'b0011 } op;
typedef enum logic [6:0] {RTYPE = 7'b0110011, ITYPEL = 7'b0000011, ITYPER = 7'b0010011, ITYPEIW = 7'b0011011, STYPE = 7'b0100011, UTYPE = 7'b0110111, 
RTYPEW = 7'b0111011, SBTYPE = 7'b1100011, ITYPEJ = 7'b1100111, JTYPE = 7'b1101111, AUIPC = 7'b0010111 } opcodet;

always_comb begin
    auipc = 1'b0;
    case(opcode)
    RTYPE,RTYPEW: begin
    datawidth = 2'b0;
    jump = 2'b0;
    branch = 3'b0;
    memread = 1'b0;
    mem_to_reg = 1'b0;
    mem_write = 1'b0;
    alusrc = 1'b0;
    regwrite = 1'b1;
    aluop = {bit30, funct3};
 
    end
    ITYPEL: begin
    jump = 2'b0;
    branch = 3'b0;
    memread = 1'b1;
    mem_to_reg = 1'b1;
    mem_write = 1'b0;
    aluop = 4'b0;
    alusrc = 1'b1;
    regwrite = 1'b1;
    case(funct3)
        3'b000: datawidth = 2'b00; //load byte
        3'b001: datawidth = 2'b01;//load half
        default: datawidth = 2'b10; //load word
    endcase
    end

    ITYPER: begin
    datawidth =2'b0;
    jump = 2'b0;
    branch = 3'b0;
    memread = 1'b0;
    mem_to_reg = 1'b0;
    mem_write = 1'b0;
    alusrc = 1'b1;
    case(funct3)
        3'b000: aluop = ADD;
        3'b001: aluop = SLL;
        3'b010: aluop = SLT;
        3'b100: aluop = XOR;
        3'b101: begin
        if(bit30) begin
            aluop = SRA;
        end else begin
            aluop = SRL;
        end
        end
        3'b110: aluop = OR;
        3'b111: aluop = AND;
        default: aluop = 4'b1111;
    endcase

    regwrite = 1'b1;

    end
    ITYPEIW: begin
    datawidth =2'b0;
    jump = 2'b0;
    branch = 3'b0;
    memread = 1'b0;
    mem_to_reg = 1'b0;
    mem_write = 1'b0;
    alusrc = 1'b1;
    case(funct3)
        3'b000: aluop = ADD;
        3'b001: aluop = SLL;
        3'b101: begin
        if(bit30) begin
            aluop = SRA;
        end else begin
            aluop = SRL;
        end
        end
        default: aluop = 4'b1111;
    endcase
    regwrite = 1'b1;
    end 
    STYPE: begin
    jump = 2'b0;
    branch = 3'b0;
    memread = 1'b0;
    mem_to_reg = 1'b0;
    mem_write = 1'b1;
    aluop = ADD;
    alusrc = 1'b1;
    regwrite = 1'b0;
    case(funct3)
        3'b000: datawidth = 2'b00; //store byte
        3'b001: datawidth = 2'b01; //store half
        default: datawidth = 2'b10;
    endcase
    end
    UTYPE:begin    
    datawidth =2'b0;
    jump = 2'b0;
    branch = 3'b0;
    memread = 1'b0;
    mem_to_reg = 1'b0;
    mem_write = 1'b0;
    alusrc = 1'b1;
    aluop = 4'b0011;
    regwrite = 1'b1;
    end
    
    SBTYPE: begin
    datawidth = 2'b0;
    jump = 2'b0;
    memread = 1'b0;
    mem_to_reg = 1'b0;
    mem_write = 1'b0;
    alusrc = 1'b0;
    aluop = SUB;
    regwrite = 1'b0;
    case(funct3)
        3'b000: branch = 3'b100; //beq
        3'b001: branch = 3'b101; //bne
        3'b100: branch = 3'b110; //blt
        3'b101: branch = 3'b111; //bge
        default: branch = 3'b000;
    endcase
    end
    ITYPEJ: begin
    datawidth =2'b0;
    jump = 2'b10;
    branch = 3'b0;
    memread = 1'b0;
    mem_to_reg = 1'b0;
    mem_write = 1'b0;
    alusrc = 1'b1;
    aluop = ADD; //add
    regwrite = 1'b1;
    end
    JTYPE: begin
    datawidth =2'b0;
    jump = 2'b01;
    branch = 3'b0;
    memread = 1'b0;
    mem_to_reg = 1'b0;
    mem_write = 1'b0;
    alusrc = 1'b0;
    aluop = 4'b1111; //NO OP
    regwrite = 1'b1;
    end
    AUIPC: begin
    datawidth =2'b0;
    jump = 2'b0;
    branch = 3'b0;
    memread = 1'b0;
    mem_to_reg = 1'b0;
    mem_write = 1'b0;
    alusrc = 1'b1;
    aluop = ADD;
    regwrite = 1'b1;
    auipc = 1'b1;
    end
    default: begin
    datawidth =2'b0;
    jump = 2'b00;
    branch = 3'b0;
    memread = 1'b0;
    mem_to_reg = 1'b0;
    mem_write = 1'b0;
    alusrc = 1'b0;
    aluop = 4'b1111; //NO OP
    regwrite = 1'b0;
    end
    endcase
end
endmodule