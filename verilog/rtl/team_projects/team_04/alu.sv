`default_nettype none

typedef enum logic [3:0] {
    ADD=0, SUB=1, SLL=2, SLT=3, SLTU=4, XOR=5, SRL=6, SRA=7,OR=8, AND=9,
    //ADDI=10, XORI=13, ORI=14, ANDI=15, SLLI=16, SLTI=11, SRLI=17, SRAI=18, SLTIU=12, 
    BEQ=10, BNE=11, BLT=12, BGE=13, BLTU=14, BGEU=15, ERR=4'bx
    //LB=16, LH=17, LW=18, LBU=19, LHU=20, LW=21, SB=22, SH=23, SW=24 (just add)
    } operation_t;

module alu (
input logic [6:0] opcode,
input logic [2:0] alu_op,
input logic [6:0] func7,
input logic [31:0] opA,
input logic [31:0] opB,
//input operation_t alu_control_input,
output logic [31:0] alu_result,
//output logic ctrl_err,
output logic zero_flag, eq_flag, less_flag, err_flag // dontcare_flag needed?
);

logic signed [31:0] opA_signed;
logic signed [31:0] opB_signed;

assign opA_signed = opA;
assign opB_signed = opB;

//logic [31:0] x;  //??(will this value be 0 by default?)
operation_t alu_control_input;

logic ctrl_err;
//INSTANTING alu_control_unit here
    alu_control_unit ex1 (.opcode(opcode), 
                         .alu_op(alu_op), 
                          .func7(func7), 
                          .ctrl_err(ctrl_err),
                         .alu_control_input(alu_control_input));

always_comb 
begin
        // err_flag =1'b1;
        // less_flag = 1'b0;
        // eq_flag = 1'b0;
        //zero_flag = 1'b0;
case(alu_control_input)

    //R-type
    ADD:
    begin
         alu_result = (opA + opB); //overflow bits are discarded (RISCV ISA)
         less_flag = 1'b0;
         eq_flag = 1'b0;
         err_flag =1'b0;      
    end
    SUB:
    begin
         alu_result = (opA - opB);
         less_flag = 1'b0;
         eq_flag = 1'b0;
         err_flag =1'b0;         
    end
    SLL: //DEFINE opB TO BE THE LEAST SIGNIFICANT 5 BITS OF rs2
    begin
         alu_result = (opA << opB[4:0]); 
         less_flag = 1'b0;
         eq_flag = 1'b0;
         err_flag =1'b0;        
    end
    SLT: //taking the signed integer value of opA and opB for comparision
    begin
         alu_result = ((opA_signed < opB_signed) ? 32'b1 : 32'b0); 
        // less_flag = (alu_result == 32'b1) ? 1 : 0; //if asserted, rd is set to 1, else, rd is set to 0       //IS THIS FLAG NEEDED here?
         less_flag = 1'b0;
         eq_flag = 1'b0;
         err_flag =1'b0; 
    end
    SLTU: //taking the unsigned value of opA and opB for comparision
    begin
         alu_result = ((opA < opB) ? 32'b1 : 32'b0); 
         less_flag = 1'b0;
         eq_flag = 1'b0;
         err_flag =1'b0; 
    end
    XOR:
    begin
         alu_result = (opA ^ opB); 
         less_flag = 1'b0;
         eq_flag = 1'b0;
         err_flag =1'b0; 
    end
    SRL: //DEFINE opB TO BE THE LEAST SIGNIFICANT 5 BITS OF rs2
    begin
        alu_result = (opA >> opB[4:0]); 
         less_flag = 1'b0;
         eq_flag = 1'b0;
         err_flag =1'b0; 
    end
    SRA: //DEFINE opB TO BE THE LEAST SIGNIFICANT 5 BITS OF rs2
    begin

         alu_result = (opA_signed >>> opB[4:0]); 
         less_flag = 1'b0;
         eq_flag = 1'b0;
         err_flag =1'b0; 
    end
    OR:
    begin
         alu_result = (opA | opB); 
         less_flag = 1'b0;
         eq_flag = 1'b0;
         err_flag =1'b0; 
    end
    AND:
    begin
         alu_result = (opA & opB); 
         less_flag = 1'b0;
         eq_flag = 1'b0;
         err_flag =1'b0; 
    end

    // //I-type
    // ADDI:
    // begin
    //      alu_result = (opA + opB); 
    // end
    // SLTI:
    // begin
    //      alu_result = ((opA < opB) ? 1 : 0); 
    //     // less_flag = (alu_result == 1) ? 1 : 0; 

    // end
    // SLTIU:
    // begin
    //      alu_result = ((opA < opB) ? 1 : 0); 
    //     // less_flag = (alu_result == 1) ? 1 : 0; 
    // end
    // XORI:
    // begin
    //      alu_result = (opA ^ opB); 
    // end
    // ORI: 
    // begin
    //      alu_result = (opA | opB); 
    // end
    // ANDI:
    // begin
    //      alu_result = (opA & opB); 
    // end
    // SLLI:
    // begin
    //      alu_result = (opA << opB); 
    // end
    // SRLI:
    // begin
    //      alu_result = (opA >> opB); 
    // end
    // SRAI:
    // begin
    //      alu_result = (opA >>> opB); 
    // end

    //B-type
    BEQ:
    begin
         //alu_result = ((opA == opB) ? 1 : 0); // how to implement don't care alu result
        eq_flag = (opA == opB) ? 1 : 0; //needed here cause alu_result is a don't care
         less_flag = 1'b0;
         //eq_flag = 1'b0;
         err_flag =1'b0; 
         alu_result=32'bx;
    end
    BNE:
    begin
         //alu_result = ((opA != opB) ? 1 : 0); 
        eq_flag = (opA != opB) ? 0 : 1; 
         less_flag = 1'b0;
         //eq_flag = 1'b0;
         err_flag =1'b0; 
         alu_result=32'bx;
    end
    BLT:
    begin
         //alu_result = ((opA < opB) ? 1 : 0); 
        less_flag = (opA_signed < opB_signed) ? 1 : 0; 
           //less_flag = 1'b0;
         eq_flag = 1'b0;
         err_flag =1'b0; 
         alu_result=32'bx;
    end
    BGE:
    begin
         //alu_result = ((opA >= opB) ? 1 : 0); 
        less_flag = (opA_signed > opB_signed) ? 0 : 1;
        eq_flag = (opA == opB) ? 1 : 0;  
        // less_flag = 1'b0;
         //eq_flag = 1'b0;
         err_flag =1'b0; 
         alu_result=32'bx;
    end
    BLTU: //difference btw signed and unsigned for alu?
    begin
         //alu_result = ((opA < opB) ? 1 : 0); 
        less_flag = (opA < opB) ? 1 : 0; 
       //  less_flag = 1'b0;
         eq_flag = 1'b0;
         err_flag =1'b0; 
         alu_result=32'bx;
    end
    BGEU:
    begin
         //alu_result = ((opA >= opB) ? 1 : 0); 
        less_flag = (opA > opB) ? 0 : 1; 
        eq_flag = (opA == opB) ? 1 : 0; 
         // less_flag = 1'b0;
         //eq_flag = 1'b0;
         err_flag =1'b0;
         alu_result=32'bx; 
    end

    default:
    begin
        //FIXME 
        alu_result=32'bx; //(invalid/no operations);
        less_flag = 1'b0;
        eq_flag = 1'b0;
        err_flag = 1'b1;
        zero_flag = 1'b0;
    end
endcase

    zero_flag = ((|alu_result) == 'b1) ? 'b0 :'b1;  //zero_flag

end //always_comb
endmodule
