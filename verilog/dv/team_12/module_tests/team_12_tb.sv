/*
* This is a template for your top level test bench!
* You are responsible for having a test bench for your top
* level design. Otherwise, your design will not be part
* of the tape-out.
*
* Please also include test benches for your team_12_WB
* and team_12_Wrapper modules, if needed to verify
* interfacing with the Wishbone Bus.
*
* The command to run this test bench is:
* make tbsim-source-team_12-team_12
*/

`timescale 1 ns / 1 ps

module team_12_tb();

    ///////////////////////////////////
    // Write your test bench code here!

    // the _O and _I at the end of variables denotes inputs and outputs
// as viewed from the perspective of the wishbone bus manager that is 
// instatiated to be testbenched here
    parameter CLK_PERIOD = 100;
    logic tb_CLK;
    logic tb_nRST;

    //manager ports:
    //module inputs
    logic [31:0] tb_DAT_I;
    logic        tb_ACK_I;
    
    logic        tb_WRITE_I;
    logic        tb_READ_I;
    logic [31:0] tb_ADR_I;
    logic [31:0] tb_CPU_DAT_I;
    logic [3:0]  tb_SEL_I;

    //module outputs
    logic [31:0] tb_ADR_O;
    logic [31:0] tb_DAT_O;
    logic [3:0]  tb_SEL_O;
    logic        tb_WE_O;
    logic        tb_STB_O;
    logic        tb_CYC_O;

    logic [31:0] tb_CPU_DAT_O;
    logic        tb_BUSY_O;

    //peripheral ports
    

//clock gen
always begin
    tb_CLK = 1'b0;
    #(CLK_PERIOD/2);
    tb_CLK = 1'b1;
    #(CLK_PERIOD/2);
end

// Signal Dump
initial begin
    $dumpfile ("team_12.vcd");
    $dumpvars;
end

wishbone_manager manager(
    .CLK(tb_CLK),
    .nRST(tb_nRST),

    .DAT_I(tb_DAT_I),
    .ACK_I(tb_ACK_I),

    .WRITE_I(tb_WRITE_I),
    .READ_I(tb_READ_I),
    .ADR_I(tb_ADR_I),
    .CPU_DAT_I(tb_CPU_DAT_I),
    .SEL_I(tb_SEL_I),

    //outputs
    .ADR_O(tb_ADR_O),
    .DAT_O(tb_DAT_O),
    .SEL_O(tb_SEL_O),
    .WE_O(tb_WE_O),
    .STB_O(tb_STB_O),
    .CYC_O(tb_CYC_O),

    .CPU_DAT_O(tb_CPU_DAT_O),
    .BUSY_O(tb_BUSY_O)
);

logic [37:0] tb_gpio_in;
logic [37:0] tb_gpio_out;
logic [37:0] tb_gpio_oeb;


team_12_Wrapper peripheral(
    //wishbone input
    .wb_clk_i(tb_CLK),
    .wb_rst_i(~tb_nRST),
    .wbs_stb_i(tb_STB_O), 
    .wbs_cyc_i(tb_CYC_O),
    .wbs_we_i(tb_WE_O),
    .wbs_sel_i(tb_SEL_O),
    .wbs_dat_i(tb_DAT_O),
    //.wbs_dat_i(32'h0),

    .wbs_adr_i(tb_ADR_O),
    //wishbone output
    .wbs_ack_o(tb_ACK_I),
    .wbs_dat_o(tb_DAT_I),
    //gpio input
    .gpio_in(tb_gpio_in),
    //gpio output
    .gpio_out(tb_gpio_out),
    .gpio_oeb(tb_gpio_oeb)
);

task reset;
begin
    @(posedge tb_CLK);
    tb_nRST = 1'b0;
    @(posedge tb_CLK);
    @(posedge tb_CLK);
    tb_nRST = 1'b1;
    @(posedge tb_CLK);
end
endtask

integer idx;
task zero_inputs;
begin
    tb_gpio_in = '0;
end
endtask

logic tb_write_occur;
logic tb_read_occur;

task wb_write(
    input logic [31:0] addr,
    input logic [31:0] data
);
begin
    tb_write_occur = 1'b1;
    @(negedge tb_CLK);
    
    tb_WRITE_I   = '1;
    tb_SEL_I     = '1;
    tb_ADR_I     = addr;
    tb_CPU_DAT_I = data;

    #(CLK_PERIOD);
    tb_WRITE_I   = '0;

    @(negedge tb_BUSY_O);

    tb_WRITE_I   = '0;
    tb_SEL_I     = '0;
    tb_ADR_I     = '0;
    tb_CPU_DAT_I = '0;

    tb_write_occur = 1'b0;
end
endtask

task wb_read(
    input logic [31:0] addr,
    input logic [31:0] data
);
begin
    tb_read_occur = 1'b1;
    @(negedge tb_CLK);
    
    tb_READ_I   = '1;
    tb_SEL_I     = '1;
    tb_ADR_I     = addr;

    #(CLK_PERIOD);
    tb_READ_I   = '0;

    @(negedge tb_BUSY_O);

    tb_READ_I   = '0;
    tb_SEL_I     = '0;
    tb_ADR_I     = '0;

    tb_read_occur = 1'b0;

    if(data != tb_CPU_DAT_O) begin
        $error("data was: %h expected: %h", data, tb_CPU_DAT_O);
    end
    else begin
        $info("praise be");
    end
end
endtask

initial begin
    tb_write_occur = 1'b0;
    tb_read_occur  = 1'b0;

    tb_nRST = 1'b1;
    tb_WRITE_I = '0;
    tb_READ_I = '0;
    tb_ADR_I = '0;
    tb_CPU_DAT_I = '0;
    tb_SEL_I = '0;
    zero_inputs();
    //$finish;
    reset();
    // $finish;
    wb_write('0, 'd1);
    // wb_write(32'h00000004, 8);
    // wb_write(32'h00000008, 7);
    tb_WRITE_I = '0;
    #(CLK_PERIOD * 10);
    wb_read('0, 'd1);
    // wb_read(32'h00000004, 8);
    // wb_read(32'h00000008, 7);
    
    $info("MPRJ IO Outputs: %x", tb_gpio_out);
    #(CLK_PERIOD * 10);

    $finish;
end
endmodule