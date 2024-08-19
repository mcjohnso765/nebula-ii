typedef enum logic [3:0] {
    ADD=0, SUB=1, SLL=2, SLT=3, SLTU=4, XOR=5, SRL=6, SRA=7,OR=8, AND=9,
    BEQ=10, BNE=11, BLT=12, BGE=13, BLTU=14, BGEU=15
    } operation_t;

module t04_CPU (
    input logic [31:0] instruction, //instruction to CPU
    input logic clk, nrst, //timing & reset signals
    output logic [31:0] alu_result,  //numerical/logical output of ALU
    output logic [31:0] reg_window [31:0],
    // output logic ctrl_err, //error flag indicating invalid instruction (not w/in RISC-V 32I), from alu control
    output logic zero_flag, //ALU flag whenever output == 0
    err_flag, //ALU flag invalid operation, from ALU
    input logic [31:0] data_from_mem,
    output logic [31:0] addr_to_mem, data_to_mem
    
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
logic condJumpValue;

//from RegWrite mux
logic [31:0] DataWrite;


//from Regs
logic [31:0] regA, regB;

//from Mem Handler
logic [31:0] MemData;

//instantiation of modules

//decode data and addresses withing instruction
t04_decode decoder (
    .instruction(instruction), //32-bit instruction
    .rs1(rs1), //address of source register 1
    .rs2(rs2), //address of source register 2
    .rd(rd), //address of destination register
    .opcode(opcode), //7-bit Opcode (decoded from intrsuction)
    .ALUOp(func3), //3-bit function code (decoded from intrsuction)
    .func7(func7) //7-bit function code (decoded from intrsuction)
);

//genrate immediate value based on instruction format and values
t04_imm_gen make_imm (
    .instruction(instruction), //32-bit instruction
    .imm(imm), //32-bit genrated immediate value (signed)
    .flag() //error flag (ignore, used for tb)
    );

//generate control signals based on Opcode
t04_control_unit cntrl (
    .opcode(opcode), //7-bit Opcode (decoded from intrsuction)
    .RegWriteSource(RegWriteSrc), //2-bit control signal specifiying what is writing to the regs
    .ALUSrc(ALUSrc), //control signal indicating use of immediate
    .RegWrite(RegWrite), //control signal indicating writing to destination reg
    .Jump(Jump), //control signal indicating a Jump will take place
    .Branch(Branch), //control signal indicating a Branch, (conditional jump)
    .MemWrite(MemWrite), //control signal indicating Memory will be written to 
    .MemRead(MemRead), //control signal indicating memory will be read from
    .Error(Error) //testing signal indicating invalid Opcode
);

//decide whether a register value or immediate is used as the second operand in an operation
t04_aluop_mux ALUOpB(
    .regB(regB), //value from register
    .imm(imm), //immediate value
    .alu_src(ALUSrc), //control signal
    .opB(opB) //resulting second operand
); 

//perform arithmetic and logical operation
t04_alu ALU (
    .opcode(opcode), //control signals
    .alu_op(func3), 
    .func7(func7), 
    .opB(opB), //operands
    .opA(regA), 
    .alu_result(alu_result_wire), //results and flags
    .zero_flag(zero_flag), //indicate result == 0
    .err_flag(err_flag), //indicate invalid operation
    .condJumpValue(condJumpValue) //indicate branching condition is true
    );

//allow for easier display of alu result
assign alu_result = alu_result_wire;

//determine register write source
t04_reg_write_mux reg_write_control (
    .immData(imm), //immediate value
    .ALUData(alu_result_wire), //ALU result value
    .MemData(MemData), //memory value
    .PCData(32'b0), //program counter value
    .DataWrite(DataWrite), //chosen value
    .RegWriteSrc(RegWriteSrc) //control signal
    );

//read to and write from registers
t04_register_file regs (
    .read_addr_1(rs1), //read addresses
    .read_addr_2(rs2), 
    .write_addr(rd), //write address
    .reg_enable_write(RegWrite), //control signal enabling write
    .read_data_1(regA), //read values
    .read_data_2(regB), 
    .write_data(DataWrite), //value tobe written
    .clk(clk), 
    .nrst(nrst), 
    .reg_file(reg_window) //testbenching array
    );

t04_memory_handler mem (
    .addr(alu_result_wire), //alu result, used as address
    .read_data_2(regB), 
    .data_from_mem(data_from_mem), 
    .en_read(MemRead), 
    .en_write(MemWrite), 
    .size(func3), 
    .select(),//fixme to wishbone/request unit
    .data_to_reg(MemData),
    .addr_to_mem(addr_to_mem),
    .data_to_mem(data_to_mem),
    .mem_read(),
    .mem_write()
    );

endmodule

