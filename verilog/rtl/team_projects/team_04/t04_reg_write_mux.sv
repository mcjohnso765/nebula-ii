`default_nettype none

//this module will be integrated in the top or regfile module
module t04_reg_write_mux (
input logic [31:0] immData, //from imm_gen
                ALUData, //from ALU
                MemData, //from Memory Handler
                PCData, //from PC
input logic [1:0] RegWriteSrc, //from control unit

output logic [31:0] DataWrite
);
    //00: The value to be written to a register comes from the ALU, 
    //01: The value to be written to a register comes from Memory, 
    //10: The value to be written to a register comes from an immediate, 
    //11: The value to be written to a register comes from the Program Counter

always_comb begin
    DataWrite = 0;

    if(RegWriteSrc == 0)
    begin
        DataWrite = ALUData;
    end else if (RegWriteSrc == 2'b01)
    begin
        DataWrite = MemData;
    end else if (RegWriteSrc == 2'b10)
    begin
        DataWrite = immData;
    end else if (RegWriteSrc == 2'b11)
    begin
        DataWrite = PCData;
    end
end

endmodule
