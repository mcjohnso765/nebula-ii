
//BUFFER TESTBENCH
`timescale 1ms/10ns
  module tb_debouncer;
    localparam CLK_PERIOD         = 10;  // 400 MHz     
    localparam  RESET_OUTPUT_VALUE = 8'b0;
    
    logic keyvalid;
    logic receive_ready;


    // logic 
    
    // DUT Inputs
    logic tb_clk;
    logic tb_rst;

        always begin
        tb_clk = 1; // set clock initially to be 0 so that they are no time violations at the rising edge 
        #(CLK_PERIOD / 2);
        tb_clk = 0;
        #(CLK_PERIOD / 2);

    end
    
    
        debouncer dut(.clk(tb_clk), .rst(tb_rst), .keyvalid(keyvalid), .receive_ready(receive_ready));

      initial begin 
        $dumpfile("sim.vcd");
        $dumpvars(0,tb_debouncer);
        
        // TESTCASES
            //test 1: does receive ready output a 1 when keyvalid is 1?
        tb_rst = 1;
        keyvalid = 0;
        #(CLK_PERIOD * 1);
        tb_rst = 0;
        keyvalid = 0;
        #(CLK_PERIOD * 1);
        keyvalid = 1;
        $display("receive ready equals %b", receive_ready);
        #(CLK_PERIOD * 1);
        keyvalid = 0;
        #(CLK_PERIOD * 2);                  


       
        $finish;
      end 


  endmodule