// FPGA Top Level

`default_nettype none

module t02_top (
	input logic clk, nrst, enable,
  output logic [31:0] ramaddr, ramstore, 
  output logic Ren, Wen, 
  input logic [31:0] ramload, start_addr,
  input logic busy_o
  // output logic lcd_en, lcd_rw, lcd_rs,
  // output logic [7:0] lcd_data,
  // input logic [3:0] read_row,
  // output logic [3:0] scan_col

  // output logic [31:0][31:0] test_memory ,
  // output logic [31:0][31:0] test_nxt_memory 
);
 logic zero, negative, regWrite, aluSrc, d_ready, i_ready, memWrite, memRead;
 logic [3:0] aluOP;
 logic [4:0] regsel1, regsel2, w_reg;
 logic [5:0] cuOP;
 logic [19:0] imm;
 logic [31:0] memload, aluIn, aluOut, immOut, pc, writeData, regData1, regData2, instruction;



t02_mux aluMux(.in1(immOut), .in2(regData2), .en(aluSrc), .out(aluIn));

t02_alu arith(.aluOP(aluOP), .inputA(regData1), .inputB(aluIn), .ALUResult(aluOut), .zero(zero), .negative(negative));

t02_register_file DUT(.clk(clk), .nRST(nrst), .reg_write(regWrite), .read_index1(regsel1), .read_index2(regsel2), 
.read_data1(regData1), .read_data2(regData2), .write_index(w_reg), .write_data(writeData));

t02_control controller (.cuOP(cuOP), .instruction(instruction), 
.reg_1(regsel1), .reg_2(regsel2), .rd(w_reg),
.imm(imm), .aluOP(aluOP), .regWrite(regWrite), .memWrite(memWrite), .memRead(memRead), .aluSrc(aluSrc));

t02_pc testpc(.clk(clk), .nRST(nrst), .ALUneg(negative), .Zero(zero), .iready(i_ready), .PCaddr(pc), .cuOP(cuOP), .rs1Read(regData1), .signExtend(immOut), .enable(enable), .start_addr(start_addr));

t02_writeToReg write(.cuOP(cuOP), .memload(memload), .aluOut(aluOut), .imm(immOut), .pc(pc), .writeData(writeData), .negative(negative));

t02_signExtender signex(.imm(imm), .immOut(immOut), .CUOp(cuOP));

t02_request ru(.CLK(clk), .nRST(nrst), .imemload(instruction), .imemaddr(pc), .dmmaddr(aluOut), .dmmstore(regData2), .ramaddr(ramaddr), .ramload(ramload), .ramstore(ramstore), 
.cuOP(cuOP), .Wen(Wen), .busy_o(busy_o), .dmmload(memload), .i_ready(i_ready), .d_ready(d_ready),.Ren(Ren), .en(enable));

// t02_edgeDetector edg2(.clk(clk), .nRst_i(nrst), .button_i(~keyStrobe), .button_p(enData));
// t02_keypad pad (.clk(clk), .rst(nrst), .receive_ready(keyStrobe), .data_received(halfData), .read_row(read_row), .scan_col(scan_col));
// t02_lcd1602 lcd (.clk(clk), .rst(nrst), .row_1(row1), .row_2(row2), .lcd_en(lcd_en), .lcd_rw(lcd_rw), .lcd_rs(lcd_rs), .lcd_data(lcd_data));

//ru_ram rram (.clk(clk), .nRst(nrst), .write_enable(write_enable), .addr(addr), .data_in(datain), .data_out(dataout), .busy(busy_o));
//ram ra(.clk(clk), .nRst(nrst), .write_enable(memWrite), .read_enable(1), .address_DM(aluOut[5:0]), .address_IM(pc[5:0]), .data_in(regData2), .data_out(memload), .instr_out(instruction), .pc_enable(i_ready), .CUOp(cuOP));
//assign instruction_out = instruction;
endmodule
