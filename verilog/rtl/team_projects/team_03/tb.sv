`timescale 1ms/10ps

module tb;
    logic clock = 0;
    logic reset = 0;
    logic en = 1;

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

    //request unit signals

    // logic BUSY_O;
    // logic READ_I;
    // logic WRITE_I;
    // logic [31:0] CPU_DAT_O;
    // logic [31:0] CPU_DAT_I;
    // logic [31:0] ADR_I;
    // logic [3:0] SEL_I;
    //this is a test

     
    logic i_hit = 1'b1;
//   request_unit ru(.clk(clock), .rst(reset), .memread(read_mem), .memwrite(write_mem), 
//   .data_to_write(data_to_write), .instruction_address(program_counter), 
//   .data_address(result), .busy_o(BUSY_O), .cpu_dat_o(CPU_DAT_O), 
//   .read_i(READ_I), .write_i(WRITE_I), .cpu_dat_i(CPU_DAT_I), 
//   .instruction(inst), .adr_i(ADR_I), .data_read(data_read), 
//   .sel_i(SEL_I), .i_hit(i_hit));

    //clock_controller clock_controller(.halt(1'b0), .cpu_clock(cpu_clock), .clock(clock && en), .reset(reset));

    //ram ram(.clk(clock), .rst(reset), .data_address(result), .instruction_address(program_counter), .dm_read_en(read_mem), .dm_write_en(write_mem),
    //    .data_to_write(data_to_write), .instruction_read(inst), .data_read(data_read), .pc_enable(pc_en));

    t03_decoder decoder(.inst(inst), .rs1(regA), .rs2(regB), .rd(rd), .type_out(i_type), .control_out(instruction));

    t03_control_logic_unit control_logic(.i_type(i_type), .instruction(instruction), .alu_op(alu_op), .branch_type(branch_type), .reg_write_en(reg_write_en), .alu_mux_en(alu_mux_en), .store_byte(store_byte),
    .mem_to_reg(mem_to_reg), .pc_add_write_value(pc_add_write_value), .load_byte(load_byte), .read_next_pc(read_next_pc), .write_mem(write_mem), .read_mem(read_mem), .slt(slt), .u(u));

    t03_branch_logic branch_logic(.branch_type(branch_type), .ALU_neg_flag(N), .ALU_overflow_flag(V), .ALU_zero_flag(Z), .b_out(branch_choice));

    t03_pc pc(.en(en), .pc_out(program_counter), .pc_add_out(program_counter_out), .generated_immediate(imm_gen), .branch_decision(branch_choice), .pc_write_value(regA_data), .pc_add_write_value(pc_add_write_value), .in_en(i_hit), .auipc_in(alu_mux_en), .clock(clock), .reset(reset));

    t03_register_file register_file(.en(en), .clk(clock), .rst(reset), .regA_address(regA), .regB_address(regB), .rd_address(rd), .register_write_en(reg_write_en), .register_write_data(register_write_data), .regA_data(regA_data), .regB_data(regB_data));

    t03_writeback writeback(.memory_value(data_read), .ALU_value(result), .pc_4_value(program_counter_out), .mem_to_reg(mem_to_reg), .load_byte(load_byte), .read_pc_4(1'b0), .register_write(register_write_data), .slt(slt), .ALU_neg_flag(N), .ALU_overflow_flag(V));

    t03_byte_demux byte_demux(.reg_b(regB_data), .store_byte_en(store_byte), .b_out(data_to_write));

   // IO_mod_enable IO_mod(.clk(clock), .rst(reset), .write_mem(write_mem), .read_mem(read_mem), .data_from_mem(data_to_IO), .data_address(result), .data_to_write(data_to_write), .data_read(data_read), .IO_out(gpio_out[31:0]), .IO_enable(gpio_oeb[31:0]), .IO_in(gpio_in[31:0]));

    //byte_imm_gen byte_immediate_generator (.b_out(b_out_connect), .imm_gen_byte(data_to_write));

    t03_ALU ALU(.srda(regA_data), .fop(alu_op), .result(result), .Z(Z), .N(N), .V(V), .imm_gen(imm_gen), .srdb(regB_data), .alu_mux_en(alu_mux_en), .rda_u(regA_data), .rdb_u(regB_data), .u(u));

    t03_imm_generator imm_generator(.inst(inst), .type_i(i_type), .imm_gen(imm_gen));


string check_type;
integer exp_val;

task reset_module;
    reset = 1;
    #3; 
    reset = 0;
    #3;
endtask


always begin
    clock = 0;
    #3;
    clock = 1;
    #3;
end

task check_out;
    input logic [31:0] exp_val;
    input logic [31:0] actual_val;
    input string check_type;

    begin

    if (exp_val == actual_val) begin
        $info("Correct reg output. test: %s", check_type);
    end

    else begin
        $error("Incorrect reg output. test: %s", check_type);

    end  

    end
endtask
    
    initial begin
        // make sure to dump the signals so we can see them in the waveform
        $dumpfile("sim.vcd");
        $dumpvars(0, tb);
        reset_module;
        #6;
        
        check_type = "addi";
        inst = 32'h00700093;
        exp_val = 7;
        #6;
        check_out(exp_val,register_write_data);

        #6;

        check_type = "xori";
        inst = 32'h0040c413;
        exp_val = 3;
        #6;
        check_out(exp_val,register_write_data);
        #6;

        check_type = "ori";
        inst = 32'h0040e413;
        exp_val = 7;
        #6;
        check_out(exp_val,register_write_data);
        #6;

        check_type = "andi";
        inst = 32'h0040f413;
        exp_val = 4;
        #6;
        check_out(exp_val,register_write_data);
        #6;

        check_type = "slli";
        inst = 32'h00209413;
        exp_val = 28;
        #6;
        check_out(exp_val,register_write_data);
        #6;

        check_type = "srli";
        inst = 32'h0020d413;
        exp_val = 1;
        #6;
        check_out(exp_val,register_write_data);
        #6;

        check_type = "srai";
        inst = 32'h4010d413;
        exp_val = 3;
        #6;
        check_out(exp_val,register_write_data);
        #6;


        check_type = "slti";
        inst = 32'h0080a413;
        exp_val = 32'b1;
        #6;
        check_out(exp_val,register_write_data);
        #6;

        check_type = "sltiu";
        inst = 32'h0080b413;
        exp_val = 32'b1;
        #6;
        check_out(exp_val,register_write_data);
        #6;

        check_type = "xori";
        inst = 32'h00500193;
        exp_val = 7;
        #6;
        check_out(exp_val,register_write_data);
        #6;




        // finish the simulation
        #1 $finish;
    end


endmodule

