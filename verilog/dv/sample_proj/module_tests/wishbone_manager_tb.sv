// the _O and _I at the end of variables denotes inputs and outputs
// as viewed from the perspective of the wishbone bus manager that is 
// instatiated to be testbenched here


`timescale 1ms/10ps
module wishbone_manager_tb();
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
    $dumpfile ("wishbone_manager.vcd");
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

logic [37:0] tb_designs_gpio_out [12:0];
logic [37:0] tb_designs_gpio_oeb [12:0];

logic [37:0] tb_gpio_out;
logic [37:0] tb_gpio_oeb;


gpio_control_Wrapper peripheral(
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
    .designs_gpio_out(tb_designs_gpio_out),
    .designs_gpio_oeb(tb_designs_gpio_oeb),
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
    for(idx = 0; idx <= 12; idx++) begin
        tb_designs_gpio_oeb[idx] = '0;
        tb_designs_gpio_out[idx] = '0;
    end
    tb_designs_gpio_oeb[0][12] = 1'b1;
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

    reset();

    wb_write('0, 12);
    wb_write(32'h00000004, 8);
    wb_write(32'h00000008, 7);
    tb_WRITE_I = '0;
    #(CLK_PERIOD * 10);
    wb_read(32'h00000000, 12);
    wb_read(32'h00000004, 8);
    wb_read(32'h00000008, 7);
    
    $info("SDLFJSLKDFJKLSDFJLKSJDLFKSDF");
    #(CLK_PERIOD * 10);

    $finish;
end
endmodule

