//timescale
`timescale 1ms/10ps

module tb_control_unit_register_integration;
    localparam CLK_PERIOD = 10;
    reg[31:0] write_data, exp_read1, exp_read2;
    logic [4:0] rd, rs1, rs2;
    logic clk, rst, writeEnable;
    logic [31:0] reg1, reg2;
    
endmodule