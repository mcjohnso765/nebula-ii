module core(
  input logic clock, reset, en,
  input logic [31:0] CPU_DAT_O, 
  input logic BUSY_O,
  output logic [31:0] CPU_DAT_I, ADR_I, 
  output logic [3:0] SEL_I,
  output logic WRITE_I, READ_I,

  input logic [33:0] gpio_in,
  output logic [33:0] gpio_out, gpio_oeb
);

    logic [2:0] i_type; // instruction type (r, i, s, etc)
    logic [16:0] instruction; // shortened instruction from decoder to control logic
    logic [3:0] alu_op; // alu operation
    logic [2:0] branch_type; // branch command
    logic reg_write_en, alu_mux_en, store_byte, 
    mem_to_reg, pc_add_write_value, load_byte, read_next_pc,
    write_mem, read_mem;

    logic [31:0] inst; // full 32 bit instruction

    logic [31:0] imm_gen; // imm_gen output from control logic
    logic [4:0] regA, regB, rd; // for register file



    logic [31:0] register_write_data;
    logic [31:0] regA_data, regB_data;

    logic [31:0] program_counter;
    logic [31:0] program_counter_out;
    logic branch_choice;


    logic [31:0] result;
    logic Z, N, C, V;

    logic b_out;
    logic [31:0] data_to_write, data_read, data_to_IO;
    logic pc_en;
    logic slt;
    logic u;
    //this is a test

     
    logic i_ready, d_ready;
    request_unit ru(.en(en), .clk(clock), .nRST(reset), .D_fetch(read_mem), .D_write(write_mem), .I_fetch(1'b1), .data_adr(result), .instr_adr(program_counter), .writedata(data_to_write), .i_done(i_ready), .d_done(d_ready), .instr(inst), .data(data_to_IO), .busy_o(BUSY_O), .cpu_dat_o(CPU_DAT_O), .write_i(WRITE_I), .read_i(READ_I), .adr_i(ADR_I),  .cpu_dat_i(CPU_DAT_I), .sel_i(SEL_I));


    wire cpu_clock;
    //clock_controller clock_controller(.halt(1'b0), .cpu_clock(cpu_clock), .clock(clock && en), .reset(reset));

    //ram ram(.clk(clock), .rst(reset), .data_address(result), .instruction_address(program_counter), .dm_read_en(read_mem), .dm_write_en(write_mem),
    //    .data_to_write(data_to_write), .instruction_read(inst), .data_read(data_read), .pc_enable(pc_en));

    decoder decoder(.inst(inst), .rs1(regA), .rs2(regB), .rd(rd), .type_out(i_type), .control_out(instruction));

    control_logic_unit control_logic(.i_type(i_type), .instruction(instruction), .alu_op(alu_op), .branch_type(branch_type), .reg_write_en(reg_write_en), .alu_mux_en(alu_mux_en), .store_byte(store_byte),
    .mem_to_reg(mem_to_reg), .pc_add_write_value(pc_add_write_value), .load_byte(load_byte), .read_next_pc(read_next_pc), .write_mem(write_mem), .read_mem(read_mem), .slt(slt), .u(u));

    branch_logic branch_logic(.branch_type(branch_type), .ALU_neg_flag(N), .ALU_overflow_flag(V), .ALU_zero_flag(Z), .b_out(branch_choice));

    pc pc(.en(en), .pc_out(program_counter), .pc_add_out(program_counter_out), .generated_immediate(imm_gen), .branch_decision(branch_choice), .pc_write_value(regA_data), .pc_add_write_value(pc_add_write_value), .in_en(pc_en), .auipc_in(alu_mux_en), .clock(clock), .reset(reset));

    register_file register_file(.en(en), .clk(clock), .rst(reset), .regA_address(regA), .regB_address(regB), .rd_address(rd), .register_write_en(reg_write_en), .register_write_data(register_write_data), .regA_data(regA_data), .regB_data(regB_data));

    writeback writeback(.memory_value(data_read), .ALU_value(result), .pc_4_value(program_counter_out), .mem_to_reg(mem_to_reg), .load_byte(load_byte), .read_pc_4(1'b0), .register_write(register_write_data), .slt(slt), .ALU_neg_flag(N), .ALU_overflow_flag(V));

    byte_demux byte_demux(.reg_b(regB_data), .store_byte_en(store_byte), .b_out(data_to_write));

    IO_mod_enable IO_mod(.clk(clock), .rst(reset), .write_mem(write_mem), .read_mem(read_mem), .data_from_mem(data_to_IO), .data_address(result), .data_to_write(data_to_write), .data_read(data_read), .IO_out(gpio_out[31:0]), .IO_enable(gpio_oeb[31:0]), .IO_in(gpio_in[31:0]));

    //byte_imm_gen byte_immediate_generator (.b_out(b_out_connect), .imm_gen_byte(data_to_write));

    ALU ALU(.srda(regA_data), .fop(alu_op), .result(result), .Z(Z), .N(N), .V(V), .imm_gen(imm_gen), .srdb(regB_data), .alu_mux_en(alu_mux_en), .rda_u(regA_data), .rdb_u(regB_data), .u(u));

    imm_generator imm_generator(.inst(inst), .type_i(i_type), .imm_gen(imm_gen));

endmodule