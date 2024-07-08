// the _O and _I at the end of variables denotes inputs and outputs
// as viewed from the perspective of the wishbone bus manager that is 
// instatiated to be testbenched here


`timescale 1ms/10ps
module wishbone_arbitrator_tb();
    parameter CLK_PERIOD = 100;
    logic tb_CLK;
    logic tb_nRST;

    //manager ports:
    //module inputs
    logic [31:0] tb_DAT_I_1, tb_DAT_I_2, tb_DAT_I_P;
    logic        tb_ACK_I_1, tb_ACK_I_2, tb_ACK_I_P;
    
    logic        tb_WRITE_I_1,   tb_WRITE_I_2;
    logic        tb_READ_I_1,    tb_READ_I_2;
    logic [31:0] tb_ADR_I_1,     tb_ADR_I_2;
    logic [31:0] tb_CPU_DAT_I_1, tb_CPU_DAT_I_2;
    logic [3:0]  tb_SEL_I_1,     tb_SEL_I_2;

    //module outputs
    // _1 indicates manager_1, _2 indicates manager_2, and _P indicates peripheral
    logic [31:0] tb_ADR_O_1, tb_ADR_O_2, tb_ADR_O_P; 
    logic [31:0] tb_DAT_O_1, tb_DAT_O_2, tb_DAT_O_P;
    logic [3:0]  tb_SEL_O_1, tb_SEL_O_2, tb_SEL_O_P;
    logic        tb_WE_O_1,  tb_WE_O_2,  tb_WE_O_P;
    logic        tb_STB_O_1, tb_STB_O_2, tb_STB_O_P;
    logic        tb_CYC_O_1, tb_CYC_O_2, tb_CYC_O_P;

    logic [31:0] tb_CPU_DAT_O_1, tb_CPU_DAT_O_2;
    logic        tb_BUSY_O_1,    tb_BUSY_O_2;

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
    $dumpfile ("wishbone_arbitrator.vcd");
    $dumpvars;
end

wishbone_manager manager_1(
    .CLK(tb_CLK),
    .nRST(tb_nRST),

    .DAT_I(tb_DAT_I_1),
    .ACK_I(tb_ACK_I_1),

    .WRITE_I(tb_WRITE_I_1),
    .READ_I(tb_READ_I_1),
    .ADR_I(tb_ADR_I_1),
    .CPU_DAT_I(tb_CPU_DAT_I_1),
    .SEL_I(tb_SEL_I_1),

    //outputs
    .ADR_O(tb_ADR_O_1),
    .DAT_O(tb_DAT_O_1),
    .SEL_O(tb_SEL_O_1),
    .WE_O(tb_WE_O_1),
    .STB_O(tb_STB_O_1),
    .CYC_O(tb_CYC_O_1),

    .CPU_DAT_O(tb_CPU_DAT_O_1),
    .BUSY_O(tb_BUSY_O_1)
);

wishbone_manager manager_2(
    .CLK(tb_CLK),
    .nRST(tb_nRST),

    .DAT_I(tb_DAT_I_2),
    .ACK_I(tb_ACK_I_2),

    .WRITE_I(tb_WRITE_I_2),
    .READ_I(tb_READ_I_2),
    .ADR_I(tb_ADR_I_2),
    .CPU_DAT_I(tb_CPU_DAT_I_2),
    .SEL_I(tb_SEL_I_2),

    //outputs
    .ADR_O(tb_ADR_O_2),
    .DAT_O(tb_DAT_O_2),
    .SEL_O(tb_SEL_O_2),
    .WE_O(tb_WE_O_2),
    .STB_O(tb_STB_O_2),
    .CYC_O(tb_CYC_O_2),

    .CPU_DAT_O(tb_CPU_DAT_O_2),
    .BUSY_O(tb_BUSY_O_2)
);

//attaching the two managers and the periferal together with the arbitrator
wishbone_arbitrator #(
    .NUM_MANAGERS(2)
) arbitrator (
    .CLK(tb_CLK),
    .nRST(tb_nRST),

    //manager to arbitrator, input
    .A_ADR_I({tb_ADR_O_2, tb_ADR_O_1}),
    .A_DAT_I({tb_DAT_O_2, tb_DAT_O_1}),
    .A_SEL_I({tb_SEL_O_2, tb_SEL_O_1}),
    .A_WE_I({tb_WE_O_2, tb_WE_O_1}),
    .A_STB_I({tb_STB_O_2, tb_STB_O_1}),
    .A_CYC_I({tb_CYC_O_2, tb_CYC_O_1}),

    //arbitrator to manager, output
    .A_DAT_O({tb_DAT_I_2, tb_DAT_I_1}),
    .A_ACK_O({tb_ACK_I_2, tb_ACK_I_1}),

    //arbitrator to peripheral, input
    .DAT_I(tb_DAT_I_P),
    .ACK_I(tb_ACK_I_P),

    //arbitrator to peripheral, output
    .ADR_O(tb_ADR_O_P),
    .DAT_O(tb_DAT_O_P),
    .SEL_O(tb_SEL_O_P),
    .WE_O(tb_WE_O_P),
    .STB_O(tb_STB_O_P),
    .CYC_O(tb_CYC_O_P)
);

logic [37:0] tb_designs_gpio_out [12:0];
logic [37:0] tb_designs_gpio_oeb [12:0];

logic [37:0] tb_gpio_out;
logic [37:0] tb_gpio_oeb;


gpio_control_Wrapper peripheral(
    //wishbone input
    .wb_clk_i(tb_CLK),
    .wb_rst_i(~tb_nRST),
    .wbs_stb_i(tb_STB_O_P), 
    .wbs_cyc_i(tb_CYC_O_P),
    .wbs_we_i(tb_WE_O_P),
    .wbs_sel_i(tb_SEL_O_P),
    .wbs_dat_i(tb_DAT_O_P),
    //.wbs_dat_i(32'h0),

    .wbs_adr_i(tb_ADR_O_P),
    //wishbone output
    .wbs_ack_o(tb_ACK_I_P),
    .wbs_dat_o(tb_DAT_I_P),

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

logic tb_write_occur; //test bench signal to indicate a write is occuring
logic tb_read_occur;  //test bench signal to indicate a read is occuring

task wb_write_1_SEL_dif(
    input logic [31:0] addr,
    input logic [31:0] data,
    input logic [3:0] sel_i
);
begin
    tb_write_occur = 1'b1;
    @(negedge tb_CLK);
    
    tb_WRITE_I_1   = '1;
    tb_SEL_I_1     = sel_i;
    tb_ADR_I_1     = addr;
    tb_CPU_DAT_I_1 = data;

    @(negedge tb_BUSY_O_1);

    tb_WRITE_I_1   = '0;
    tb_SEL_I_1     = '0;
    tb_ADR_I_1     = '0;
    tb_CPU_DAT_I_1 = '0;

    tb_write_occur = 1'b0;
end
endtask

//task to initiate a write using manager 1
task wb_write_1(
    input logic [31:0] addr,
    input logic [31:0] data
);
begin
    tb_write_occur = 1'b1;
    @(negedge tb_CLK);
    
    tb_WRITE_I_1   = '1;
    tb_SEL_I_1     = '1;
    tb_ADR_I_1     = addr;
    tb_CPU_DAT_I_1 = data;

    @(negedge tb_BUSY_O_1);

    tb_WRITE_I_1   = '0;
    tb_SEL_I_1     = '0;
    tb_ADR_I_1     = '0;
    tb_CPU_DAT_I_1 = '0;

    tb_write_occur = 1'b0;
end
endtask
//task to initiate a write using manager 2
task wb_write_2(
    input logic [31:0] addr,
    input logic [31:0] data
);
begin
    tb_write_occur = 1'b1;
    @(negedge tb_CLK);
    
    tb_WRITE_I_2   = '1;
    tb_SEL_I_2     = '1;
    tb_ADR_I_2     = addr;
    tb_CPU_DAT_I_2 = data;

    @(negedge tb_BUSY_O_2);

    tb_WRITE_I_2   = '0;
    tb_SEL_I_2     = '0;
    tb_ADR_I_2     = '0;
    tb_CPU_DAT_I_2 = '0;

    tb_write_occur = 1'b0;
end
endtask
//task to initiate a read using manager 1
task wb_read_1(
    input logic [31:0] addr,
    input logic [31:0] data
);
begin
    tb_read_occur = 1'b1;
    @(negedge tb_CLK);
    
    tb_READ_I_1   = '1;
    tb_SEL_I_1     = '1;
    tb_ADR_I_1     = addr;

    @(negedge tb_BUSY_O_1);

    tb_READ_I_1   = '0;
    tb_SEL_I_1     = '0;
    tb_ADR_I_1     = '0;

    tb_read_occur = 1'b0;

    if(data != tb_CPU_DAT_O_1) begin
        $error("data was: %h expected: %h", data, tb_CPU_DAT_O_1);
    end
    else begin
        $info("read data was good");
    end
end
endtask
//task to initiate a read using manager 2
task wb_read_2(
    input logic [31:0] addr,
    input logic [31:0] data
);
begin
    tb_read_occur = 1'b1;
    @(negedge tb_CLK);
    
    tb_READ_I_2   = '1;
    tb_SEL_I_2     = '1;
    tb_ADR_I_2     = addr;

    @(negedge tb_BUSY_O_2);

    tb_READ_I_2   = '0;
    tb_SEL_I_2     = '0;
    tb_ADR_I_2     = '0;

    tb_read_occur = 1'b0;

    if(data != tb_CPU_DAT_O_2) begin
        $error("data was: %h expected: %h", data, tb_CPU_DAT_O_2);
    end
    else begin
        $info("read data was good");
    end
end
endtask

task simultanious_write_req(
    input logic [31:0] addr_1,
    input logic [31:0] data_1,
    input logic [31:0] addr_2,
    input logic [31:0] data_2
);
begin
    tb_write_occur = 1'b1;
    @(negedge tb_CLK);

    //signals for manager 1 write request
    tb_WRITE_I_1   = '1;
    tb_SEL_I_1     = '1;
    tb_ADR_I_1     = addr_1;
    tb_CPU_DAT_I_1 = data_1;

    //signals for manager 2 write request
    tb_WRITE_I_2   = '1;
    tb_SEL_I_2     = '1;
    tb_ADR_I_2     = addr_2;
    tb_CPU_DAT_I_2 = data_2;

    //the rest of the write will occur for manager 1
    @(negedge tb_BUSY_O_1);

    tb_WRITE_I_1   = '0;
    tb_SEL_I_1     = '0;
    tb_ADR_I_1     = '0;
    tb_CPU_DAT_I_1 = '0;
    //end of manager 1 write

    //the rest of the write will occur for manager 2
    @(negedge tb_BUSY_O_2);

    tb_WRITE_I_2   = '0;
    tb_SEL_I_2     = '0;
    tb_ADR_I_2     = '0;
    tb_CPU_DAT_I_2 = '0;

    tb_write_occur = 1'b0;
    //end of manager 2 write
end
endtask

task delayed_simultanious_write_req(
    input logic [31:0] addr_1,
    input logic [31:0] data_1,
    input logic [31:0] addr_2,
    input logic [31:0] data_2
);
begin
    tb_write_occur = 1'b1;
    @(negedge tb_CLK);

    //signals for manager 2 write request
    tb_WRITE_I_2   = '1;
    tb_SEL_I_2     = '1;
    tb_ADR_I_2     = addr_2;
    tb_CPU_DAT_I_2 = data_2;

    //the rest of the write will occur for manager 1
    #(CLK_PERIOD/2); //DELAY

    //delaying the assertion of a higher priority request
    //signals for manager 1 write request
    tb_WRITE_I_1   = '1;
    tb_SEL_I_1     = '1;
    tb_ADR_I_1     = addr_1;
    tb_CPU_DAT_I_1 = data_1;

    @(negedge tb_BUSY_O_2);

    tb_WRITE_I_2   = '0;
    tb_SEL_I_2     = '0;
    tb_ADR_I_2     = '0;
    tb_CPU_DAT_I_2 = '0;
    //end of manager 2 write

    //the rest of the write will occur for manager 1
    @(negedge tb_BUSY_O_1);

    tb_WRITE_I_1   = '0;
    tb_SEL_I_1     = '0;
    tb_ADR_I_1     = '0;
    tb_CPU_DAT_I_1 = '0;

    tb_write_occur = 1'b0;
    //end of manager 2 write
end
endtask

initial begin
    tb_write_occur = 1'b0;
    tb_read_occur  = 1'b0;

    tb_nRST = 1'b1;
    tb_WRITE_I_1 = '0;
    tb_READ_I_1 = '0;
    tb_ADR_I_1 = '0;
    tb_CPU_DAT_I_1 = '0;
    tb_SEL_I_1 = '0;

    tb_WRITE_I_2 = '0;
    tb_READ_I_2 = '0;
    tb_ADR_I_2 = '0;
    tb_CPU_DAT_I_2 = '0;
    tb_SEL_I_2 = '0;
    //zero the inputs to the slave peripheral 
    zero_inputs();

    //reset all designs
    reset();

    //test writes and reads with manager 1
    wb_write_1('0, 12);
    wb_write_1(32'h00000004, 8);
    wb_write_1(32'h00000008, 7);
    tb_WRITE_I_1 = '0;
    #(CLK_PERIOD * 10);
    wb_read_1(32'h00000000, 12);
    wb_read_1(32'h00000004, 8);
    wb_read_1(32'h00000008, 7);

    //test writes and reads with manager 2
    #(CLK_PERIOD * 5);
    wb_write_2('0, 9);
    wb_write_2(32'h00000004, 4);
    wb_read_2(32'h00000004, 4);

    //test simultanious raising or write requests from both managers
    #(CLK_PERIOD * 5);
    simultanious_write_req('0, 2, '0, 3);

    //a repeat of the previous test except manager1's request is delayed a single clock cycle behind manager 2
    #(CLK_PERIOD * 5);
    delayed_simultanious_write_req('0, 4, '0, 5);

    //test of the sel line to see that individual lanes can be turned on and off during writes from manager 1
    #(CLK_PERIOD * 5);
    wb_write_1_SEL_dif('0, 32'h11111111, 4'b0000);
    //it would appear the sel line in the wishbone bus is unresponsive

    $info("TEST BENCH IS ALIVE");
    #(CLK_PERIOD * 10);

    $finish;
end
endmodule

