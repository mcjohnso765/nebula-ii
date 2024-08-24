// FPGA Top Level

`default_nettype none

module t02_top (
	input logic clk, nrst, enable,
  output logic [31:0] ramaddr, ramstore, 
  output logic Ren, Wen, 
  input logic [31:0] ramload,
  input logic busy_o,
  output logic lcd_en, lcd_rw, lcd_rs,
  output logic [7:0] lcd_data,
  input logic [3:0] read_row,
  output logic [3:0] scan_col,
  output logic [3:0] sel_i

  // output logic [31:0][31:0] test_memory ,
  // output logic [31:0][31:0] test_nxt_memory 
);
 logic zero, negative, regWrite, aluSrc, d_ready, i_ready, memWrite, memRead;
 logic [3:0] aluOP;
 logic [4:0] regsel1, regsel2, w_reg;
 logic [5:0] cuOP;
 logic [19:0] imm;
 logic [31:0] memload, aluIn, aluOut, immOut, pc, writeData, regData1, regData2, instruction;
 logic [127:0] row1, row2;
 logic [15:0] halfData;
 logic [31:0] FPGAAdress, FPGADataOut;
 logic FPGAEnable, writeFPGA, CPUEnable;
 logic keyStrobe, enData, nrstFPGA, write_enable;

 t02_fpgaModule a1 (.clk(clk), .nrst(nrst), .instruction(instruction), .dataIn(memload), .buttons(read_row), .FPGAEnable(FPGAEnable), .writeFPGA(writeFPGA), .CPUEnable(CPUEnable), .address(FPGAAdress), 
 .dataOut(FPGADataOut), .writeData(writeData), .nrstFPGA(nrstFPGA), .row1(row1), .row2(row2), .keyStrobe(keyStrobe), 
 .halfData(halfData), .enData(enData));

logic [31:0] muxxedAddressOut, muxxedDataOut;
logic [31:0]intermedWriteEnable;

t02_mux enableWrite(.in1({31'b0, writeFPGA}), .in2({31'b0, memWrite}), .en(FPGAEnable), .out(intermedWriteEnable));
t02_mux enableFpgaData(.in1(FPGADataOut), .in2(regData2), .en(FPGAEnable), .out(muxxedDataOut));
t02_mux enableFpgaAddress(.in1(FPGAAdress), .in2(aluOut), .en(FPGAEnable), .out(muxxedAddressOut));
assign write_enable = intermedWriteEnable[0];

t02_mux aluMux(.in1(immOut), .in2(regData2), .en(aluSrc), .out(aluIn));

t02_alu arith(.aluOP(aluOP), .inputA(regData1), .inputB(aluIn), .ALUResult(aluOut), .zero(zero), .negative(negative));

t02_register_file DUT(.en(enable), .clk(clk), .nRST(nrst), .reg_write(regWrite), .read_index1(regsel1), .read_index2(regsel2), 
.read_data1(regData1), .read_data2(regData2), .write_index(w_reg), .write_data(writeData));

t02_control controller (.cuOP(cuOP), .instruction(instruction), 
.reg_1(regsel1), .reg_2(regsel2), .rd(w_reg),
.imm(imm), .aluOP(aluOP), .regWrite(regWrite), .memWrite(memWrite), .memRead(memRead), .aluSrc(aluSrc));

t02_pc testpc(.clk(clk), .nRST(nrst), .ALUneg(negative), .Zero(zero), .iready(i_ready), .PCaddr(pc), .cuOP(cuOP), .rs1Read(regData1), .signExtend(immOut), .enable(enable));

t02_writeToReg write(.cuOP(cuOP), .memload(memload), .aluOut(aluOut), .imm(immOut), .pc(pc), .writeData(writeData), .negative(negative));

t02_signExtender signex(.imm(imm), .immOut(immOut), .CUOp(cuOP));

t02_new_request_unit ru(.CLK(clk), .nRST(nrst), .DataAddress(aluOut), .InstrAddress(pc), .DatatoWrite(regData2),
.iready(i_ready), .dready(d_ready), 
.FetchedData(memload), .FetchedInstr(instruction), 
.cuOP(cuOP), .
busy_o(busy_o), 
.cpu_dat_o(ramload), 
.write_i(Wen), .read_i(Ren),
.adr_i(ramaddr), .cpu_data_i(ramstore),
.sel_i(sel_i)
);

t02_edgeDetector edg2(.clk(clk), .nRst_i(nrst), .button_i(~keyStrobe), .button_p(enData));
t02_keypad pad (.clk(clk), .rst(nrst), .receive_ready(keyStrobe), .data_received(halfData), .read_row(read_row), .scan_col(scan_col));
t02_lcd1602 lcd (.clk(clk), .rst(nrst), .row_1(row1), .row_2(row2), .lcd_en(lcd_en), .lcd_rw(lcd_rw), .lcd_rs(lcd_rs), .lcd_data(lcd_data));

//ru_ram rram (.clk(clk), .nRst(nrst), .write_enable(write_enable), .addr(addr), .data_in(datain), .data_out(dataout), .busy(busy_o));
//ram ra(.clk(clk), .nRst(nrst), .write_enable(memWrite), .read_enable(1), .address_DM(aluOut[5:0]), .address_IM(pc[5:0]), .data_in(regData2), .data_out(memload), .instr_out(instruction), .pc_enable(i_ready), .CUOp(cuOP));
//assign instruction_out = instruction;
endmodule
