
//BUFFER TESTBENCH
`timescale 1ms/10ns
  module tb_keypad_control;
    localparam CLK_PERIOD         = 10;  // 400 MHz     
    localparam  RESET_OUTPUT_VALUE = 8'b0;
    logic [3:0]readrow;
    logic [3:0]scancol;
    logic [7:0]keycode;
    logic keyvalid;
    logic receive_ready;
    logic [7:0]keycode_previous;
    logic upper;
    logic mode;
    logic [1:0]key_count;
    logic [127:0]msg;
    logic msg_tx_ctrl;

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
    
    
keypad_control dut(.clk(tb_clk), .rst(tb_rst), .readrow(readrow), .scancol(scancol), .msg_tx_ctrl(msg_tx_ctrl), .msg(msg));

      initial begin 
        $dumpfile("sim.vcd");
        $dumpvars(0,tb_keypad_control);
        
        // TESTCASES

          //test 1: 911
          tb_rst = 1;
          // keycode = 8'b0;
          keyvalid = 0;
          receive_ready = 0;
          // keycode_previous = 8'b0;
          // upper = 0;
          // mode = 0;
          // key_count = 2'b0;
          readrow = 0;

          #(CLK_PERIOD * 3);
          tb_rst = 0;
          #(CLK_PERIOD * 2);
          readrow = 4'b0100; //9
          #(CLK_PERIOD * 3);
          readrow = 4'b0;
          #(CLK_PERIOD *1);
          readrow = 4'b0100; //C
          #(CLK_PERIOD * 2);         
          readrow = 4'b0001; //1
          #(CLK_PERIOD * 1);
          readrow = 4'b0100; //C        
          #(CLK_PERIOD * 1);
          readrow = 4'b0;
          #(CLK_PERIOD *1);
          readrow = 4'b0001; //1
          #(CLK_PERIOD * 1);
          readrow = 4'b0100; //C                            
          #(CLK_PERIOD * 20); 

          readrow = 4'b1000; //D



        $finish;
      end 


  endmodule