// Top testbenching Level

`default_nettype none

module t01_team_01_cpu (
  // input logic[31:0] instruction,
  input logic clk, nRST, en,
  // input logic [31:0]store,
    //from wishbone
  input logic         busy_o,                     // Wishbone is busy with a transaction, low = transaction complete
  input logic [31:0]  cpu_dat_o,              // Data Fetched = Instruction or Data at adr_i
  //to kp
  input logic [3:0] rows,
  //to wishbone
  output logic [31:0] cpu_dat_i,
  output logic [31:0] adr_i,
  output logic [3:0]  sel_i,
  output logic        write_i,
  output logic        read_i,
  //to kp
  output logic [3:0] cols,
  //to lcd
  output logic lcd_en,
  output logic lcd_rw,
  output logic lcd_rs,
  output logic [7:0] lcd_data
);

//Counter Signals
logic [31:0] pc;

//Alu Signals
logic [31:0] Immediate, AluResult;
logic Negative, Zero, Overflow;

//Register File Signals
logic [31:0] instruction, WriteData, ReadData1, ReadData2;

//MUX Output Signals
logic [31:0] MemToReg_Out, JB_address;

//Request Unit Signals
logic [31:0] FetchedInstr, InstrAddress, FetchedData, DataAddress, DataToWrite, DataToReg;
logic DataRead, DataWrite, ru_busy_o, dhit;

//Control Signals
logic [3:0] AluOP;
logic [2:0] Branch;
logic [1:0] Jump, DataWidth;
logic MemRead, MemToReg, MemWrite, AluSRC, RegWrite, AUIPC, branch_enable;

//Sequential Signals
logic ihit;

//Keypad/LCD Signals
logic keyvalid, assembly_en;
logic [127:0] shift_reg, unsorted;
logic [7:0] data_received;
logic [7:0]lcd_display_data;

//Assembly File Signals
logic asm_read_i, asm_write_i;
logic [31:0] asm_write_data, asm_data_adr;

//FSM Signals
logic fsm_read_i, fsm_write_i;
logic [31:0] fsm_write_data, fsm_data_adr;
logic [3:0] fsm_state;

logic register_en;
logic dm_enable;

logic shift;
logic [31:0] num_int;

logic strobe;
// logic [31:0] ssdec_data;
logic [16:0] count;

logic [31:0] next_pc;
logic pc_enable;

// ALU : DONE
t01_alu ALU0 (.AluOP(AluOP),
          .Data1(AUIPC ? pc : ReadData1),
          .Data2(AluSRC ? Immediate : ReadData2),
          .Zero(Zero),
          .Negative(Negative),
          .Overflow(Overflow),
          .AluResult(AluResult)
);

// BRANCH LOGIC : DONE 
t01_branch_logic BL0 (.Branch(Branch),
                  .Negative(Negative),
                  .Zero(Zero),
                  .Enable(branch_enable)
);

// CONTROL UNIT : DONE
t01_control_unit CU0 (.opcode(instruction[6:0]), 
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

// COUNTER (for clock) : DONE
t01_counter c0(.clk(clk), 
           .nrst(nRST), 
           .enable(1'b1), 
           .clear(1'b0), 
           .wrap(1'b1), 
           .max(17'd99999), 
           .count(count), 
           .at_max(strobe));


// Data Memory
t01_data_memory DM0 (.clk(clk),
                 .nRST(nRST),
                 .address(AluResult),
                 .writedata(ReadData2),
                 .datawidth(DataWidth),
                 .MemWrite(MemWrite),
                 .MemRead(MemRead),
                 .data_i(FetchedData),
                 .readdata(DataToReg),
                 .address_DM(asm_data_adr),
                 .writedata_o(asm_write_data),
                 .DataRead(asm_read_i),
                 .DataWrite(asm_write_i),
                 .dhit(dhit),
                 .ihit(ihit),
                 .enable(dm_enable)
);

// FSM : DONE 
t01_fsm f0(.clk(clk),
       .nRST(nRST),
       .en(en),
       .data(data_received),
       .keyvalid(keyvalid),
       .done(dhit),
       .read_data(FetchedData),
       .Instruction(FetchedInstr),
       .write_i(fsm_write_i),
       .read_i(fsm_read_i),
       .write_data(fsm_write_data),
       .data_adr(fsm_data_adr),
       .read_adr(32'h33000400),
       .write_adr(32'h33000200),
       .num_adr(32'h33000300),
       .MemWrite(MemWrite),
       .pc_enable(assembly_en),
       .display(lcd_display_data),
       .fsm_state(fsm_state),
       .lcd_en(shift)
);

// IMMEDIATE GENERATOR : DONE
t01_immediate_generator IG0 (.Instr(instruction),
                         .Imm(Immediate)
);

// INSTRUCTION MEMORY
t01_instruction_memory IM0 (.clk(clk),
                        .nRST(nRST),
                        .ihit(ihit),
                        .hold(MemRead && !dm_enable),
                        .pc_enable(pc_enable),
                        .pc(pc),
                        .FetchedInstr(FetchedInstr),
                        .address_IM(InstrAddress),
                        .instruction(instruction)
);

// KEYPAD : DONE
t01_keypad K0 (.clk(clk),
           .nRST(nRST),
           .rows(rows),
           .cols(cols),
           .data(data_received),
           .keyvalid(keyvalid),
           .enable(strobe)
);

// LCD : DONE
t01_lcd1602 LCD0 (.clk(clk), 
              .rst(nRST), 
              .row_1(unsorted), 
              .row_2(shift_reg), 
              .lcd_en(lcd_en), 
              .lcd_rw(lcd_rw), 
              .lcd_rs(lcd_rs), 
              .lcd_data(lcd_data)
); 

// MUXES 
t01_mux M1 (.in1(MemToReg_Out), 
        .in2(pc + 32'd4), 
        .select(|Jump), 
        .out(WriteData)
);

t01_mux M2 (.in1(AluResult), 
        .in2(DataToReg), 
        .select(MemToReg), 
        .out(MemToReg_Out)
);

// PROGRAM COUNTER : DONE
t01_program_counter PC0 (.clk(clk),
                     .nRST(nRST),
                     .enable(pc_enable),
                     .new_pc(next_pc),
                     .pc(pc)
);

// REGISTER FILE : DONE
t01_register_file RF0 (.clk(clk), 
                   .nRST(nRST), 
                   .RegWrite(register_en), 
                   .ReadReg1(instruction[19:15]), 
                   .ReadReg2(instruction[24:20]),
                   .WriteReg(instruction[11:7]),
                   .WriteData(WriteData),
                   .ReadData1(ReadData1),
                   .ReadData2(ReadData2)
);

// REQUEST UNIT : DONE
t01_request_unit RU0 (.clk(clk),
                  .nRST(nRST),
                  .InstrRead(assembly_en),
                  .DataRead(DataRead),
                  .DataWrite(DataWrite),
                  .DataAddress(DataAddress),
                  .InstrAddress(InstrAddress),
                  .DataToWrite(DataToWrite),
                  .ihit(ihit),
                  .dhit(dhit),
                  .FetchedInstr(FetchedInstr),
                  .FetchedData(FetchedData),
                  .busy_o(busy_o),
                  .cpu_dat_o(cpu_dat_o),
                  .write_i(write_i),
                  .read_i(read_i),
                  .adr_i(adr_i),
                  .cpu_dat_i(cpu_dat_i),
                  .sel_i(sel_i)
);

// SHIFT REGISTER 1 (for LCD row 1) : DONE
t01_shift_reg SR0 (.clk(clk), 
               .nRST(nRST), 
               .char_in(DataToWrite[7:0]), 
               .shift_register(unsorted), 
               .enable(dhit && fsm_state == 4'b010)
);

// SHIFT REGISTER 2 (for LCD row 2) : DONE
t01_shift_reg SR1 (.clk(clk), 
               .nRST(nRST), 
               .char_in(lcd_display_data[7:0]), 
               .shift_register(shift_reg), 
               .enable(shift)
);

// ASSEMBLY OR FSM
always_comb begin
    if (assembly_en) begin
        DataRead    = asm_read_i;
        DataWrite   = asm_write_i;
        DataAddress = asm_data_adr;
        DataToWrite = asm_write_data;
    end else begin
        DataRead    = fsm_read_i;
        DataWrite   = fsm_write_i;
        DataAddress = fsm_data_adr;
        DataToWrite = fsm_write_data;
    end
end

// REGISTER ENABLE LOGIC
always_comb begin
    if (RegWrite) begin
        if (MemRead) begin
            register_en = dm_enable;
        end else begin
            register_en = 1'b1;
        end
    end else begin
        register_en = 1'b0;
    end
end

// Next PC based on current instruction
always_comb begin
    if (Jump[1]) begin
        next_pc = AluResult;
    end else if (Jump[0] || branch_enable) begin
        next_pc = pc + $signed(Immediate);
    end else begin
        next_pc = pc + 32'd4;
    end
end

endmodule