// Top testbenching Level

`default_nettype none

module team_01_cpu (
  // input logic[31:0] instruction,
  input logic clk, nRst, 
  // input logic [31:0]store,
    //from wishbone
  input logic         busy_o,                     // Wishbone is busy with a transaction, low = transaction complete
  input logic [31:0]  cpu_dat_o,                  // Data Fetched = Instruction or Data at adr_i
  //to kp
  input logic [3:0] rows,
  //to wishbone
  output logic [31:0] cpu_dat_i,
  output logic [31:0] adr_i,
  output logic [3:0]  sel_i,
  output logic        write_i,
  output logic        read_i,
  //to kp
  output logic [3:0] columns,
  //to lcd
  output logic lcd_en,
  output logic lcd_rw,
  output logic lcd_rs,
  output logic [7:0] lcd_data
);

//Counter Signals
logic [31:0] pc, next_pc;

//Alu Signals
logic [31:0] Immediate, AluResult;
logic Negative, Zero, Overflow;

//Register File Signals
logic [31:0] instruction, WriteData, ReadData1, ReadData2;

//MUX Output Signals
logic [31:0] muxout2, muxout3;

//Request Unit Signals
logic [31:0] ru_instr_out, ru_instr_adr, ru_data_o, ru_data_adr, ru_writedata_i, ru_cpu_data_o, ru_cpu_data_i, ru_adr_o, data_DM_o;
logic ru_read_i, ru_write_i, ru_read_o, ru_write_o, ru_busy_o, ru_busy_i, dhit;
logic[3:0] ru_sel_o;

//Control Signals
logic [3:0] AluOP;
logic [2:0] Branch;
logic [1:0] Jump, DataWidth;
logic MemRead, MemToReg, MemWrite, AluSRC, RegWrite, AUIPC, branch_enable;

//Sequential Signals
logic ihit;

//Keypad/LCD Signals
logic keyvalid, pc_enable_kp;
logic [127:0] shift_reg, unsorted;
logic [15:0] data_received;
logic [7:0]lcd_display_data;

//Assembly File Signals
logic asm_read_i, asm_write_i;
logic [31:0] asm_write_data, asm_data_adr;

//FSM Signals
logic fsm_read_i, fsm_write_i;
logic [31:0] fsm_write_data, fsm_data_adr;

logic strobe;
logic [16:0] count;
counter c0(.clk(clk), .nrst(nRst), .enable(1'b1), .clear(1'b0), .wrap(1'b1), .max(17'd99999), .count(count), .at_max(strobe));

// Program Counter
program_counter PC0 (.next_pc(next_pc), 
                     .pc(pc), 
                     .clk(clk), 
                     .nRst(nRst)
);

// Instruction Memory
instruction_memory IM0 (.address(pc),
                        .instr(ru_instr_out),
                        .address_IM(ru_instr_adr),
                        .instruction(instruction)
);

// Control Unit
control_unit CU0 (.opcode(instruction[6:0]),
                  .funct3(instruction[14:12]),
                  .bit30(instruction[30]),
                  .datawidth(DataWidth),
                  .jump(Jump),
                  .branch(Branch),
                  .memread(MemRead),
                  .mem_to_reg(MemToReg),
                  .mem_write(MemWrite),
                  .alusrc(AluSRC),
                  .regwrite(RegWrite),
                  .aluop(AluOP),
                  .auipc(AUIPC)
);

// MUXES 
mux M1 (.in1(muxout2), .in2(pc + 32'd1), .select(|Jump), .out(WriteData));
mux M2 (.in2(data_DM_o), .in1(AluResult), .select(MemToReg), .out(muxout2));
mux M3 (.in1(pc + $signed(32'd1)), .in2(pc + $signed($signed(Immediate) >>> 1)), .select(Jump[0] | branch_enable), .out(muxout3));

// PC Enable Logic
always_comb begin
    if (ihit) begin
        next_pc = Jump[1] ? AluResult : muxout3;
    end else begin
        next_pc = pc;
    end
end
 
// Register File
register_file RF0 (.clk(clk), 
                   .nRst(nRst), 
                   .regWrite(register_en), 
                   .readReg1(instruction[19:15]), 
                   .readReg2(instruction[24:20]),
                   .writeReg(instruction[11:7]),
                   .write_data(WriteData),
                   .readData1(ReadData1),
                   .readData2(ReadData2),
                   .output_reg(output_reg)
);

// Immediate Generator
immediate_generator IG0 (.instr(instruction),
                         .imm(Immediate)
);

// ALU
alu ALU0 (.aluOp(AluOP),
          .readData1(AUIPC ? pc : ReadData1),
          .readData2(AluSRC ? Immediate : ReadData2),
          .zero(Zero),
          .negative(Negative),
          .overflow(Overflow),
          .aluResult(AluResult)
);
logic [1:0] dm_state;
// Data Memory
data_memory DM0 (.clk(clk),
                 .nRST(nRst),
                 .address(AluResult),
                 .writedata(ReadData2),
                 .datawidth(DataWidth),
                 .MemWrite(MemWrite),
                 .MemRead(MemRead),
                 .data_i(ru_data_o),
                 .readdata(data_DM_o),
                 .address_DM(asm_data_adr),
                 .writedata_o(asm_write_data),
                 .DataRead(asm_read_i),
                 .DataWrite(asm_write_i),
                 .dhit(dhit),
                 .ihit(ihit),
                 .enable(dm_enable),
                 .dm_state(dm_state)
);

// Branch Logic 
branch_logic BL0 (.branch(Branch),
                  .negative(Negative),
                  .zero(Zero),
                  .branch_enable(branch_enable)
);

// RAM 
ram R0 (.clk(clk), 
        .nRST(nRst),
        .read_i(ru_read_o),
        .write_i(ru_write_o),
        .adr_i(ru_adr_o[11:0]),
        .cpu_dat_i(ru_cpu_data_o),
        .cpu_dat_o(ru_cpu_data_i),
        .busy_o(ru_busy_i),
        .sel_i(ru_sel_o),
        .edge_det(edge_det),
        .ramstate(ramstate),
        .ack(ack),
        .data_i(demo),
        .dat_o(demo2)
);

// Request Unit
request_unit RU0 (.clk(clk),
                  .nRST(nRst),
                  .InstrRead(pc_enable_kp),
                  .DataRead(ru_read_i),
                  .DataWrite(ru_write_i),
                  .DataAddress(ru_data_adr),
                  .InstrAddress(ru_instr_adr),
                  .DataToWrite(ru_writedata_i),
                  .ihit(ihit),
                  .dhit(dhit),
                  .FetchedInstr(ru_instr_out),
                  .FetchedData(ru_data_o),
                  .busy_o(busy_o),
                  .cpu_dat_o(cpu_dat_o),
                  .write_i(write_i),
                  .read_i(read_i),
                  .adr_i(adr_i),
                  .cpu_dat_i(cpu_dat_i),
                  .sel_i(sel_i),
                  .rustate(rustate)
);


// logic strobe2;

always_comb begin
  if (pc_enable_kp) begin
    ru_read_i = asm_read_i;
    ru_write_i = asm_write_i;
    ru_data_adr = asm_data_adr;
    ru_writedata_i = asm_write_data;
  end else begin
    ru_read_i = fsm_read_i;
    ru_write_i = fsm_write_i;
    ru_data_adr = fsm_data_adr;
    ru_writedata_i = fsm_write_data;
  end
end



// // Keypad Module
keypad kp(.clk(clk),
             .nRST(nRst),
             .rows(rows),
             .cols(columns),
             .code(data_received[7:0]),
             .data(data_received[15:8]),
             .keyvalid(keyvalid),
             .enable(strobe)
);

// assign right[7] = keyvalid;

logic shift;
logic [31:0] num_int;
//FSM Module
fsm f0(.clk(clk),
       .nRST(nRst),
       .data(data_received[15:8]),
       .keyvalid(keyvalid),
       .done(dhit),
       .read_data(ru_data_o),
       .write_i(fsm_write_i),
       .read_i(fsm_read_i),
       .write_data(fsm_write_data),
       .data_adr(fsm_data_adr),
       .read_adr(32'h400),
       .write_adr(32'h200),
       .num_adr(32'h300),
       .MemWrite(MemWrite),
       .pc_enable(pc_enable_kp),
       .display(lcd_display_data),
       .fsm_state(fsm_state),
       .numbers(num_int),
       .lcd_en(shift)
       );

shift_reg sr0 (.clk(clk), .nrst(nRst), .char_in(ru_writedata_i[7:0]), .shift_register(unsorted), .enable(dhit && fsm_state == 3'b001));
shift_reg sr1 (.clk(clk), .nrst(nRst), .char_in(lcd_display_data[7:0]), .shift_register(shift_reg), .enable(shift));

lcd1602 lcd(.clk(hwclk), .rst(nRst), .row_1(unsorted), .row_2(shift_reg), .lcd_en(lcd_en), .lcd_rw(lcd_rw), .lcd_rs(lcd_rs), .lcd_data(lcd_data)); 

endmodule
