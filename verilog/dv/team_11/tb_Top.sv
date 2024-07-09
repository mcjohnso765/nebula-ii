
//BUFFER TESTBENCH
  `timescale 1ms/10ns
  module tb_Top();
    localparam CLK_PERIOD = 10;  // 400 MHz     
    localparam  RESET_OUTPUT_VALUE = 8'd0;

    //inputs
    logic clk;
    logic nrst;
    logic [3:0]readrow;
    logic transmit_ready;

    // logic [3:0]scancol;
    // logic [7:0]keycode;
    // logic keyvalid;
    // logic receive_ready;
    // logic [7:0]keycode_previous;
    // logic upper;
    // logic mode;
    // logic [1:0]key_count;
    // logic [127:0]msg;
    // logic msg_tx_ctrl;

    //outputs
    logic tx_ctrl; 
    logic [7:0] data_send;
    logic [3:0]scancol;
    
    always begin
        clk = 0; // set clock initially to be 0 so that they are no time violations at the rising edge 
        #(CLK_PERIOD / 2);
        clk = 1;
        #(CLK_PERIOD / 2);
    end
    
    Top all_tx(.clk(clk), .nrst(nrst),.readrow(readrow), .transmit_ready(transmit_ready), .scancol(scancol), .data_send(data_send), .tx_ctrl(tx_ctrl));

    initial begin 
        $dumpfile("dump.vcd");
        $dumpvars;
        
        // TESTCASES         
         //test 1: 911
          nrst = 0;
          readrow = 0;
          transmit_ready = 1;         

          #(CLK_PERIOD * 3);  
          nrst = 1;  
          #(CLK_PERIOD * 3);
          readrow = 4'b0100; //9
          #(CLK_PERIOD * 1);
          readrow = 4'd0; // 9
          #(CLK_PERIOD *3);
          readrow = 4'b0100; //C
          #(CLK_PERIOD * 2);
          readrow = 4'b0001; //1
          #(CLK_PERIOD * 1);
          readrow = 4'b0000;          

          #(CLK_PERIOD * 2);
          readrow = 4'b0100; //C          
          
          #(CLK_PERIOD *1);
          readrow = 4'b0001; //1
          #(CLK_PERIOD * 1);
          readrow = 4'd0;
          #(CLK_PERIOD * 2);
          readrow = 4'b0100; //C
          #(CLK_PERIOD * 1);
          readrow = 4'd0;
          #(CLK_PERIOD * 3);
          readrow = 4'd0;
          #(CLK_PERIOD * 4);
          readrow = 4'b1000; //D
          #(CLK_PERIOD * 1);


          readrow = 4'd0;
          transmit_ready = 0;
          #(CLK_PERIOD);
          transmit_ready = 1;
          #(CLK_PERIOD);

          transmit_ready = 0;
          #(CLK_PERIOD * 10);

          transmit_ready = 1;
          #(CLK_PERIOD);

          transmit_ready = 0;
          #(CLK_PERIOD * 10);

          transmit_ready = 1;
          #(CLK_PERIOD);

          transmit_ready = 0;
          #(CLK_PERIOD * 10);

          transmit_ready = 1;
          #(CLK_PERIOD);

          transmit_ready = 0;
          #(CLK_PERIOD * 10);

          transmit_ready = 1;
          #(CLK_PERIOD);

          transmit_ready = 0;
          #(CLK_PERIOD * 10);

          transmit_ready = 1;
          #(CLK_PERIOD);

          transmit_ready = 0;
          #(CLK_PERIOD * 10);

          //test 2: 128 bits of numbers
          
          //readrow = 4'b1000;
         // #(CLK_PERIOD * 5);
          //readrow = 4'b0100;
          //#(CLK_PERIOD * 5);
         // readrow = 4'b0100;
          //#(CLK_PERIOD * 5);
         // readrow = 4'b0010;
          //#(CLK_PERIOD * 5);
          //readrow = 4'b0100;
         // #(CLK_PERIOD * 5);
          //readrow = 4'b0100;
          //#(CLK_PERIOD * 5);
         // readrow = 4'b0100;
          //#(CLK_PERIOD * 5);
         // readrow = 4'b0100;
         // #(CLK_PERIOD * 5);
         // readrow = 4'b0100;
         // #(CLK_PERIOD * 5);
          //readrow = 4'b0100;
         // #(CLK_PERIOD * 5);
          //readrow = 4'b0100;
         // #(CLK_PERIOD * 5);
          //readrow = 4'b0100;
          //#(CLK_PERIOD * 5);
          //readrow = 4'b0100;
         // #(CLK_PERIOD * 5);
          //readrow = 4'b0100;
          //#(CLK_PERIOD * 5);
          //readrow = 4'b0100;
          //#(CLK_PERIOD * 5);
          //readrow = 4'b0100;
         // #(CLK_PERIOD * 5);
          //readrow = 4'b0100;
          //#(CLK_PERIOD *1);
          //readrow = 4'b1000; //D
          //#(CLK_PERIOD * 8);


          //transmit_ready = 0;
         // #(CLK_PERIOD);
          //transmit_ready = 1;
          //#(CLK_PERIOD);

         // transmit_ready = 0;
          //#(CLK_PERIOD * 10);

          //transmit_ready = 1;
          //#(CLK_PERIOD);

         // transmit_ready = 0;
         // #(CLK_PERIOD * 10);

          //transmit_ready = 1;
          //#(CLK_PERIOD);

          //transmit_ready = 0;
          //#(CLK_PERIOD * 10);

          //transmit_ready = 1;
          //#(CLK_PERIOD);

         // transmit_ready = 0;
          //#(CLK_PERIOD * 10);

          //transmit_ready = 1;
          //#(CLK_PERIOD);

          //transmit_ready = 0;
          //#(CLK_PERIOD * 10);

         // transmit_ready = 1;
          #(CLK_PERIOD);

         // transmit_ready = 0;
          //#(CLK_PERIOD * 10);

        $finish;
      end 


  endmodule