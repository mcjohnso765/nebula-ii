`default_nettype none

//this module will be integrated in the top or regfile module
module t04_aluop_mux (
input logic [31:0] regB, //from regfile
input logic [31:0] imm, //from immgen
input logic alu_src, //from control unit
output logic [31:0] opB
);

always_comb begin
    if(alu_src == 1)
    begin
        opB = imm;
    end
    else
    begin
        opB = regB;
    end
end //always_comb

endmodule
