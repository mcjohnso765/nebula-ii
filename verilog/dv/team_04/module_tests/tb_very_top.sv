
`timescale 1ms/1ns
module tb_very_top ();

    // testbench parameters
    integer tb_test_num;
    string tb_test_case;
    localparam CLK_PERIOD = 10; // 100 Hz clk


    logic tb_clk, tb_nRst, tb_button;
    very_top vtop(
        .clk(tb_clk),
        .nRst(tb_nRst),
        .button(tb_button),

        .h_out(),
        .v_out(),
        .pixel_data()
    );

    // Clock generation block
    always begin
        tb_clk = 1'b0; 
        #(CLK_PERIOD / 2.0);
        tb_clk = 1'b1; 
        #(CLK_PERIOD / 2.0); 
    end

    // Reset DUT Task
    task reset_dut;  
        @(negedge tb_clk);
        tb_nRst = 1'b0; 
        @(negedge tb_clk);
        @(negedge tb_clk);
        tb_nRst = 1'b1;
        @(posedge tb_clk);
    endtask

    //main test bench process
    initial begin
	//signal dump
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_very_top); 
        reset_dut();

        #200000;

        $finish;
    end

endmodule
