
//BUFFER TESTBENCH
`timescale 1ms/10ns
  module tb_controls;
    localparam CLK_PERIOD         = 10;  // 400 MHz     
    localparam  RESET_OUTPUT_VALUE = 8'b0;
    logic[7:0]keycode_previous;
    logic[7:0]keycode;
    logic upper;
    logic mode;
    logic msg_tx_ctrl;    
    logic[1:0]key_count;



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
    
    
    controls dut(.clk(tb_clk), .rst(tb_rst), .keycode_previous(keycode_previous), .keycode(keycode), .upper(upper), 
                .mode(mode), .key_count(key_count), .msg_tx_ctrl(msg_tx_ctrl));

      initial begin 
        $dumpfile("sim.vcd");
        $dumpvars(0,tb_controls);
        
        // TESTCASES
            //test 1: Hello    checks for mode, upper, and key_count
        
        tb_rst = 1;    
        keycode = 8'b0;
        #(CLK_PERIOD * 1);
        tb_rst =0;
        #(CLK_PERIOD * 1);
        keycode = 8'b00101000; //button B
        keycode_previous = 8'b0;
        #(CLK_PERIOD * 1);
        keycode = 8'b10000100; //button # to activate shift
        keycode_previous = 8'b00101000;
        #(CLK_PERIOD * 1);
        keycode = 8'b00100001; //4 G
        keycode_previous = 8'b10000100;
        #(CLK_PERIOD * 1);
        keycode = 8'b00100001; //4 H
        keycode_previous = 8'b00100001;
        #(CLK_PERIOD * 1);
        keycode = 8'b01001000; //C 
        keycode_previous = 8'b00100001;
        #(CLK_PERIOD * 1);
        keycode = 8'b00010100; //3 d 
        keycode_previous = 8'b01001000;
        #(CLK_PERIOD * 1);
        keycode = 8'b00010100; //3 e 
        keycode_previous = 8'b00010100;
        #(CLK_PERIOD * 1);
        keycode = 8'b01001000; //C
        keycode_previous = 8'b00100001;        
        #(CLK_PERIOD * 1);
        keycode = 8'b00100010; //5   j 
        keycode_previous = 8'b00010100;        
        #(CLK_PERIOD * 1);        
        keycode = 8'b00100010; //5  k
        keycode_previous = 8'b00100010;
        #(CLK_PERIOD * 1);
        keycode = 8'b00100010; //5 l
        keycode_previous = 8'b00100010;
        #(CLK_PERIOD * 1);
        keycode = 8'b01001000; //C
        keycode_previous = 8'b00100010;
        #(CLK_PERIOD * 1);
        keycode = 8'b00100010; //5   j  
        keycode_previous = 8'b01000001;
        #(CLK_PERIOD * 1);        
        keycode = 8'b00100010; //5 k
        keycode_previous = 8'b00100010;
        #(CLK_PERIOD * 1);
        keycode = 8'b00100010; //5  l        
        keycode_previous = 8'b00100010;
        #(CLK_PERIOD * 1);
        keycode = 8'b01001000; //C  
        keycode_previous = 8'b00100010;
        #(CLK_PERIOD * 1);
        keycode = 8'b00100100; //6  m
        keycode_previous = 8'b01000001;
        #(CLK_PERIOD * 1);
        keycode = 8'b00100100; //6  n
        keycode_previous = 8'b00100100;
        #(CLK_PERIOD * 1);
        keycode = 8'b00100100; //6  o
        keycode_previous = 8'b00100100;
        #(CLK_PERIOD * 1);
        keycode = 8'b01001000; //C 
        keycode_previous = 8'b00100100;
        #(CLK_PERIOD * 1);
        keycode = 8'b10001000; //D
        keycode_previous  = 8'b01001000;

        #(CLK_PERIOD * 3);
        $finish;
      end 


  endmodule