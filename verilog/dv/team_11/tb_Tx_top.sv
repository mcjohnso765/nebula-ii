`timescale 1ms/10ns

module tb_Tx_top;
   localparam RESET_ACTIVE = 0;
   localparam RESET_INACTIVE = 1;
   localparam CLK_PERIOD = 10;

   integer test_num;
   string test_name; 
   
   //inputs
   logic clk;
   logic nrst;
   logic msg_tx_ctrl;
   logic[127:0] msg_1;
   logic tx_dout;
   logic success;
   //output
   logic [7:0] data_send;
   logic tx_ctrl;
   logic [1:0] state;
   
   Tx_top DUT(.clk(clk), .nrst(nrst), .msg_tx_ctrl(msg_tx_ctrl), .msg_1(msg_1), .tx_dout(tx_dout), .transmit_ready(success), .state(state));

   task reset_dut;
   begin
      nrst = RESET_ACTIVE;

      #(CLK_PERIOD * 1);
      nrst = RESET_INACTIVE;
      #(CLK_PERIOD * 1);
   end
   endtask

//    task check_output;
//       input logic dout_exp;
//       input logic success_exp;
//    begin 
//       @(posedge clk)
//       if(tx_dout == dout_exp)
//          $info("Correct tx_dout value");
//       else
//          $error("Incorrect tx_dout value");

//       if(success == success_exp)
//          $info("Correct success value");
//       else
//          $error("Incorrect success value");
//    end
//    endtask
 
   always begin
      clk =1;
      #(CLK_PERIOD / 2);
      clk = 0;
      #(CLK_PERIOD / 2);
   end
                
   initial begin
    //   logic dout_exp;
    //   logic success_exp;

      $dumpfile ("sim.vcd");
      $dumpvars(0, tb_Tx_top);

      // initialization

    //   dout_exp = 0;
    //   success_exp = 0;
    //   #(CLK_PERIOD);

    //   check_output(dout_exp, success_exp);

      //Test # 1
      reset_dut();
      test_num += 1;
      msg_1 = "               ";
      msg_tx_ctrl = 1'b0;
      test_name = "Test 1";
      #(CLK_PERIOD);
      msg_tx_ctrl =  1;
      #(CLK_PERIOD * 100);
      msg_tx_ctrl = 0;
      #(CLK_PERIOD * 100);

      reset_dut();

      msg_1 = "1234567890123456";
      msg_tx_ctrl = 1'b1;
      #(CLK_PERIOD* 1250);
      msg_tx_ctrl = 1'b1;
      #(CLK_PERIOD);
      msg_tx_ctrl = 0;
      #(CLK_PERIOD * 1250 * 16 * 12);

     

      $finish;
   end
endmodule

      
      
      
      
      
