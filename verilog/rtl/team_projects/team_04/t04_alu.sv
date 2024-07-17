`default_nettype none

//FIXME:comment when integrating with cpu
typedef enum logic [3:0] {
    ADD=0, SUB=1, SLL=2, SLT=3, SLTU=4, XOR=5, SRL=6, SRA=7,OR=8, AND=9, 
    BEQ=10, BNE=11, BLT=12, BGE=13, BLTU=14, BGEU=15, ERR=4'bxx
    } operation_t;

module t04_alu (
input logic [6:0] opcode,
input logic [2:0] alu_op,
input logic [6:0] func7,
input logic [31:0] opA,
input logic [31:0] opB,
output logic [31:0] alu_result,
output logic zero_flag, err_flag,     //send out condJumpValue instead
output logic condJumpValue  //send out condJumpValue instead of less_flag and eq_flag
);

logic signed [31:0] opA_signed;
logic signed [31:0] opB_signed;

assign opA_signed = opA;
assign opB_signed = opB;

operation_t alu_control_input;

logic ctrl_err;
//INSTANTING alu_control_unit here
    t04_alu_control_unit ex1 (.opcode(opcode), 
                          .alu_op(alu_op), 
                          .func7(func7), 
                          .ctrl_err(ctrl_err),
                          .alu_control_input(alu_control_input));

always_comb 
begin
case(alu_control_input)

    //R-type
    ADD:
    begin
         alu_result = (opA + opB); //overflow bits are discarded (RISCV ISA)
         err_flag =1'b0;
         condJumpValue = 1'b0;
    end
    SUB:
    begin
         alu_result = (opA - opB);
         err_flag =1'b0;
         condJumpValue = 1'b0;
    end
    SLL: 
    begin
         alu_result = (opA << opB[4:0]); //DEFINE opB TO BE THE LEAST SIGNIFICANT 5 BITS OF rs2
         err_flag =1'b0;  
        condJumpValue = 1'b0;      
    end
    SLT: //taking the signed integer value of opA and opB for comparision
    begin
         alu_result = ((opA_signed < opB_signed) ? 32'b1 : 32'b0); 
         err_flag =1'b0;
        condJumpValue = 1'b0;
    end
    SLTU: //taking the unsigned value of opA and opB for comparision
    begin
         alu_result = ((opA < opB) ? 32'b1 : 32'b0); 
         err_flag =1'b0; 
      condJumpValue = 1'b0;
    end
    XOR:
    begin
         alu_result = (opA ^ opB); 
         err_flag =1'b0; 
      condJumpValue = 1'b0;
    end
    SRL: 
    begin
        alu_result = (opA >> opB[4:0]); 
         err_flag =1'b0; 
      condJumpValue = 1'b0;
    end
    SRA: 
    begin

         alu_result = (opA_signed >>> opB[4:0]); 
         err_flag =1'b0; 
      condJumpValue = 1'b0;
    end
    OR:
    begin
         alu_result = (opA | opB); 
         err_flag =1'b0; 
      condJumpValue = 1'b0;
    end
    AND:
    begin
         alu_result = (opA & opB); 
         err_flag =1'b0; 
      condJumpValue = 1'b0;
    end

    //B-type
    BEQ:
    begin
         err_flag =1'b0; 
         alu_result= {32{opA==opB}};  //needed here cause alu_result is a don't care
      condJumpValue = alu_result[0];
    end
    BNE:
    begin
         err_flag =1'b0; 
         alu_result=32'b0;
        condJumpValue = (opA != opB) ? 1 : 0;
    end
    BLT:
    begin
         err_flag =1'b0; 
         alu_result=32'b0;
         condJumpValue = (opA_signed < opB_signed) ? 1 : 0;
    end
    BGE:
    begin
         err_flag =1'b0; 
         alu_result=32'b0;
      condJumpValue = (opA_signed >= opB_signed) ? 1 : 0;
    end
    BLTU:
    begin
         err_flag =1'b0; 
         alu_result=32'b0;
      condJumpValue = (opA < opB) ? 1 : 0;
    end
    BGEU:
    begin
         err_flag =1'b0;
         alu_result=32'b0; 
      condJumpValue = (opA >= opB) ? 1 : 0;
    end

    default:
    begin
        alu_result=32'b0; //(invalid/no operations);
        err_flag = 1'b1;
        zero_flag = 1'b0;
        condJumpValue = 1'b0;
    end
endcase

    zero_flag = ((|alu_result) == 'b1) ? 'b0 :'b1;  //zero_flag

end //always_comb
endmodule