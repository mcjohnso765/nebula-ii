typedef enum logic [3:0] {
    ADD=0, SUB=1, SLL=2, SLT=3, SLTU=4, XOR=5, SRL=6, SRA=7,OR=8, AND=9,
    BEQ=10, BNE=11, BLT=12, BGE=13, BLTU=14, BGEU=15, ERR = 4'bxxxx
    } operation_t;

module top (
    input logic [31:0] instruction, //instruction to CPU
    input logic clk, nrst, //timing & reset signals
    output logic [31:0] alu_result,  //numerical/logical output of ALU
    output logic [31:0] reg_window [31:0],
    // output logic ctrl_err, //error flag indicating invalid instruction (not w/in RISC-V 32I), from alu control
    output logic zero_flag, //ALU flag whenever output == 0
    eq_flag, //ALU branch flag used for beq, bge, and bgeu
    less_flag, //ALU flag used for blt, bltu
    err_flag //ALU flag invalid operation, from ALU
    
);

//wires 
//from decoder
logic [4:0] rs1, rs2, rd; 
logic [6:0] opcode, func7;
logic [2:0] func3;

//from imm_gen
logic [31:0] imm;

//from control_unit
logic [1:0] RegWriteSrc;
logic ALUSrc, RegWrite, Jump, Branch, MemWrite, MemRead, Error;

//from ALU mux
logic [31:0] opB;

//from ALU
logic [31:0] alu_result_wire;

//from RegWrite mux
logic [31:0] DataWrite;


//from Regs
logic [31:0] regA, regB;


//instantiation of modules
decode decoder (
    .instruction(instruction),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .opcode(opcode),
    .ALUOp(func3),
    .func7(func7)
);

imm_gen make_imm (.instruction(instruction), .imm(imm), .flag());

control_unit cntrl (.opcode(opcode),
    .RegWriteSource(RegWriteSrc),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
    .Jump(Jump),
    .Branch(Branch),
    .MemWrite(MemWrite),
    .MemRead(MemRead),
    .Error(Error)
);


aluop_mux ALUOpB(.regB(regB), .imm(imm), .alu_src(ALUSrc), .opB(opB)); 

alu ALU (.opcode(opcode), .alu_op(func3), .func7(func7), .opB(opB), .opA(regA), .alu_result(alu_result_wire), .zero_flag(zero_flag), .eq_flag(eq_flag), .less_flag(less_flag), .err_flag(err_flag));
assign alu_result = alu_result_wire;

reg_write_mux reg_write_control (.immData(imm), .ALUData(alu_result_wire), .MemData(32'b0), .PCData(32'b0), .DataWrite(DataWrite), .RegWriteSrc(RegWriteSrc));

register_file regs (.read_addr_1(rs1), .read_addr_2(rs2), .write_addr(rd), .reg_enable_write(RegWrite), .read_data_1(regA), .read_data_2(regB), .write_data(DataWrite), .clk(clk), .nrst(nrst), .reg_file(reg_window));

endmodule

