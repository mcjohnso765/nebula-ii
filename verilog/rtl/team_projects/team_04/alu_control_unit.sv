`default_nettype none

//FIXME: comment following typedef when using tb_alu
typedef enum logic [3:0] {
    ADD=0, SUB=1, SLL=2, SLT=3, SLTU=4, XOR=5, SRL=6, SRA=7,OR=8, AND=9,
    //ADDI=10, XORI=13, ORI=14, ANDI=15, SLLI=16, SLTI=11, SRLI=17, SRAI=18, SLTIU=12, 
    BEQ=10, BNE=11, BLT=12, BGE=13, BLTU=14, BGEU=15, ERR = 4'bxxxx
    //LB=16, LH=17, LW=18, LBU=19, LHU=20, LW=21, SB=22, SH=23, SW=24 (just add)
    } operation_t;

module alu_control_unit(
input logic [6:0] opcode,
input logic [2:0] alu_op,
input logic [6:0] func7,
output logic ctrl_err, 
output operation_t alu_control_input
);
//operation_t x;   //??(will this value be 0 by default?)
always_comb begin
    alu_control_input = ERR;
    ctrl_err = 1'b0;
    if (opcode  == 7'b0110011) //R-type
    begin
        if(alu_op == 3'b000) // ADD/SUB
        begin
            if(func7 == 7'b0000000) 
            begin
                alu_control_input = ADD;
            end
            else if (func7 == 7'b0100000)
            begin
                alu_control_input = SUB;
            end
            else //FIXME
            begin
                alu_control_input = ERR;//invalid operation;
                ctrl_err = 1'b1;
            end

        end //alu_op

        else if (alu_op == 3'b001)
        begin
            alu_control_input = SLL;
        end
        else if (alu_op == 3'b010)
        begin
            alu_control_input = SLT;
        end
        else if (alu_op == 3'b011)
        begin
            alu_control_input = SLTU;
        end
        else if (alu_op == 3'b100)
        begin
            alu_control_input = XOR;
        end
        else if(alu_op == 3'b101) // SRL/SRA
        begin
            if(func7 == 7'b0000000) 
            begin
                alu_control_input = SRL;
            end
            else if(func7 == 7'b0100000)
            begin
                alu_control_input = SRA;
            end
            else //FIXME
            begin
                alu_control_input = ERR;//invalid operation;
                ctrl_err = 1'b1;
            end

        end //alu_op
        else if (alu_op == 3'b110)
        begin
            alu_control_input = OR;
        end
        else if (alu_op == 3'b111)
        begin
            alu_control_input = AND;
        end
        else //FIXME
        begin
            alu_control_input = ERR;//invalid operation;
            ctrl_err = 1'b1;
        end

    end //opcode
    else if (opcode  == 7'b0010011) //I-type
    begin
        if (alu_op == 3'b000)
        begin
            alu_control_input = ADD; //optimizing?
        end
        else if (alu_op == 3'b010)
        begin
            alu_control_input = SLT;
        end
        else if (alu_op == 3'b011)
        begin
            alu_control_input = SLTU;
        end
        else if (alu_op == 3'b100)
        begin
            alu_control_input = XOR;
        end
        else if (alu_op == 3'b110)
        begin
            alu_control_input = OR;
        end
        else if (alu_op == 3'b111)
        begin
            alu_control_input = AND;
        end
        else if (alu_op == 3'b001)
        begin
            alu_control_input = SLL;
        end
        else if (alu_op == 3'b101) //SRA/SRL
        begin
            if(func7 == 7'b0000000) 
            begin
                alu_control_input = SRL;
            end
            else if(func7 == 7'b0100000)
            begin
                alu_control_input = SRA;
            end
            else //FIXME
            begin
                alu_control_input = ERR;//invalid operation;
                ctrl_err = 1'b1;
            end
        end //alu_op
        else //FIXME
        begin
            alu_control_input = ERR;//invalid operation;
            ctrl_err = 1'b1;
        end

    end //opcode
    else if (opcode  == 7'b1100011) //B-type
    begin
        if (alu_op == 3'b000)
        begin
            alu_control_input = BEQ;
        end
        else if (alu_op == 3'b001)
        begin
            alu_control_input = BNE;
        end
        else if (alu_op == 3'b100)
        begin
            alu_control_input = BLT;
        end
        else if (alu_op == 3'b101)
        begin
            alu_control_input = BGE;
        end
        else if (alu_op == 3'b110)
        begin
            alu_control_input =  BLTU;
        end
        else if (alu_op == 3'b111)
        begin
            alu_control_input = BGEU;
        end
        else //FIXME
        begin
            alu_control_input = ERR;//invalid operation;
            ctrl_err = 1'b1;
        end

    end //opcode
        
    else if (opcode  == 7'b0100011) //S-type
    begin
        alu_control_input = ADD; //optimizing?
        // if (alu_op == 3'b000)
        // begin
        //     alu_control_input = ADD; 
        // end
        // else if (alu_op == 3'b010)
        // begin
        //     alu_control_input = ADD;
        // end
        // else if (alu_op == 3'b001)
        // begin
        //     alu_control_input = ADD;
        // end
    end //opcode

    else if (opcode  == 7'b0000011) //I-type(load)
    begin
        alu_control_input = ADD; //optimizing?
    end

    else //FIXME
    begin
        alu_control_input = ERR;//invalid operation;
        ctrl_err = 1'b1;
    end
end //always_comb
endmodule
