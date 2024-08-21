
//BUFFER TESTBENCH
`timescale 1ms/10ns
  module tb_buffer;
    localparam CLK_PERIOD         = 10;  // 400 MHz     
    localparam  RESET_OUTPUT_VALUE = 8'b0;
    logic [7:0]keycode;
    logic receive_ready;
    logic [7:0]keycode_previous;
    logic [7:0]nextkeycode;


    // logic 
    
    // DUT Inputs
    logic tb_clk;
    logic tb_nrst;

        always begin
        tb_clk = 0; // set clock initially to be 0 so that they are no time violations at the rising edge 
        #(CLK_PERIOD / 2);
        tb_clk = 1;
        #(CLK_PERIOD / 2);
    end
    
    

    
    buffer dut(.keycode(keycode), .clk(tb_clk), .rst(tb_nrst), .receive_ready(receive_ready), .keycode_previous(keycode_previous));
      initial begin 
        $dumpfile("sim.vcd");
        $dumpvars(0,tb_buffer);
        
        // TESTCASES
            //test 1: Remembers Keycode and keycode previous
            // tb_nrst = 1;
            // @(posedge tb_clk);
            // tb_nrst = 0;
            // @(posedge tb_clk);

            
            receive_ready = 1'b1;
            keycode = 8'b10001000;
            $display(keycode_previous);

            receive_ready = 1'b0;
            @(posedge tb_clk);

            receive_ready = 1'b1;
            keycode = 8'b01000010;
            $display(keycode_previous);           
            #(CLK_PERIOD * 1);
            receive_ready = 1'b0;   
            #(CLK_PERIOD * 1);         

            receive_ready = 1'b1;
            keycode = 8'b00101000;
            $display(keycode_previous);   
            #(CLK_PERIOD * 1);
            receive_ready = 1'b0;
            #(CLK_PERIOD * 1);    

            receive_ready = 1'b1;
            keycode = 8'b00010010;
            $display(keycode_previous);    
            #(CLK_PERIOD * 1);
            receive_ready = 1'b0;   
            #(CLK_PERIOD * 1);    

       
        $finish;
      end 


  endmodule