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
   
   Tx_top DUT(.clk(clk), .nrst(nrst), .msg_tx_ctrl(msg_tx_ctrl), .msg_1(msg_1), .tx_dout(tx_dout), .success(success));

   task reset_dut;
   begin
      @(posedge clk);
      nrst = RESET_ACTIVE;

      @(posedge clk);
      nrst = RESET_INACTIVE;
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
      clk =0;
      #(CLK_PERIOD / 2);
      clk = 1;
      #(CLK_PERIOD / 2);
   end
                
   initial begin
    //   logic dout_exp;
    //   logic success_exp;

      $dumpfile ("sim.vcd");
      $dumpvars(0, tb_Tx_top);

      // initialization
      msg_1 = 128'd0; 
      msg_tx_ctrl = '0;
      nrst = 1'b1;
      test_num = -1; 
      test_name = "Test Bench starting"; 
      #(CLK_PERIOD);

    //   dout_exp = 0;
    //   success_exp = 0;
    //   #(CLK_PERIOD);

    //   check_output(dout_exp, success_exp);

      //Test # 0 
      test_num +=1;
      test_name = "Resetting everything manually";
      nrst = RESET_ACTIVE;
      #(CLK_PERIOD);

      nrst = RESET_INACTIVE;
      msg_1 = "                "; 
      msg_tx_ctrl = '0;
      #(CLK_PERIOD);

    //   dout_exp = 0;
    //   success_exp = 0;
    //   #(CLK_PERIOD);

    //   check_output(dout_exp, success_exp);

      //Test # 1
      test_num += 1;
      test_name = "Test 1";
      reset_dut();

      msg_1 = "HEY TEST 1     ";
      msg_tx_ctrl = 1'b0;
      #(CLK_PERIOD * 1);
      msg_tx_ctrl = 1'b1;
      #(CLK_PERIOD * 1);
      msg_tx_ctrl = 1'b0;
      #(CLK_PERIOD * 1250 * 16 * 11);

     

      $finish;
   end
endmodule

      
      
      
      
      
