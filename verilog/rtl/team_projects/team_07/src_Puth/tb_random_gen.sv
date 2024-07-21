`timescale 1ms / 100us


module t07_tb_random_generator ();
    //Timing 
    localparam CLK_PERIOD = 83.3; // 12 MHz clock (for FPGA)
    localparam PROPAGATION_DELAY = 5.5; // Allow for 5.5ns for FF propogation delay

    //DUT PORTS
    logic tb_clk;          // testbench clock
    logic tb_nrst;         // testbench active low reset
    logic [23:0] tb_random_seed = 24'd0; // testbench count
    logic tb_activate;
    logic [2:0]tb_rand_x;
    logic [2:0]tb_rand_y;

t07_random_gen DUT(
    .clk(tb_clk),
    .nrst(tb_nrst),
    .random_seed(tb_random_seed),
    .activate(tb_activate),
    .rand_x(tb_rand_x),
    .rand_y(tb_rand_y)
);
    

always begin
    tb_clk = 1'b0; #(CLK_PERIOD / 2);
    tb_clk = 1'b1; #(CLK_PERIOD / 2);
end
initial begin
    $dumpfile("dump.vcd");
    $dumpvars;


    // initialize the testbench input
    tb_nrst = 0;
    @(posedge tb_clk);

    tb_nrst = 1;
    tb_random_seed = 24'd123456;
    @(posedge tb_clk);
    tb_activate = 1;
    @(posedge tb_clk);
     @(posedge tb_clk);
    #(CLK_PERIOD * 100)


 //   for (integer i = 0; i < 24; i++) begin
 //       tb_random_seed = 24'(i);
 //       @(posedge tb_clk);
//
 //   end

    $display("rand_x = %d", tb_rand_x);
    $display("rand_y = %d", tb_rand_y);
    $finish;

end

endmodule