/*
* This is a template for your top level test bench!
* You are responsible for having a test bench for your top
* level design. Otherwise, your design will not be part
* of the tape-out.
*
* Please also include test benches for your team_04_WB
* and team_04_Wrapper modules, if needed to verify
* interfacing with the Wishbone Bus.
*
* The command to run this test bench is:
* make tbsim-source-team_04-team_04
*/

`timescale 1 ns / 1 ps

module team_04_tb();

    logic tb_clk, nrst; //clock and reset signals

    logic [31:0] instruction, //instruction code
        nextInstruction, exp_nextInstruction, //address of next instruction, to be outputted to Data Memory
        alu_result, exp_alu_result, //result of numerical/logical operation from ALU
        addr_to_mem, exp_addr_to_mem, //address sent to Data Memory/VGA 
        data_to_mem, exp_data_to_mem, //
        data_from_mem;

    logic err_flag, exp_err_flag,

endmodule