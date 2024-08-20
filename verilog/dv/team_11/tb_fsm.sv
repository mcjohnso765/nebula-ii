`timescale 1ms/10ns

module tb_fsm;
   localparam RESET_ACTIVE = 0;
   localparam RESET_INACTIVE = 1;
   localparam CLK_PERIOD = 10;

   integer test_num;
   string test_name; 
   
   //inputs
   logic clk;
   logic nrst;
   logic tx_ctrl;
   logic ready_signal;
   logic bit_out;

    //output
   logic success;
   logic tx_dout;
   logic transmit_ready;

   fsm tx(.clk(clk), .nrst(nrst), .tx_ctrl(tx_ctrl), .transmit_ready(transmit_ready),.ready_signal(ready_signal), .success(success), .bit_out(bit_out), .tx_dout(tx_dout));

   task reset_dut;
   begin
      @(posedge clk);
      nrst = RESET_ACTIVE;

      @(posedge clk);
      nrst = RESET_INACTIVE;
   end
   endtask

   task check_output;
      input logic dout_exp;
      input logic success_exp;
   begin 
      @(posedge clk)
      if(tx_dout == dout_exp)
         $info("Correct tx_dout value");
      else
         $error("Incorrect tx_dout value");

      if(success == success_exp)
         $info("Correct success value");
      else
         $error("Incorrect success value");
   end
   endtask
 
   always begin
      clk =0;
      #(CLK_PERIOD / 2);
      clk = 1;
      #(CLK_PERIOD / 2);
   end
                
   initial begin
      logic dout_exp;
      logic success_exp;

      $dumpfile ("sim.vcd");
      $dumpvars(0, tb_fsm); // added testbench specidications

      // initialization
      nrst = 1'b1;
      test_num = -1; 
      test_name = "Test Bench starting"; 
      @(posedge clk);

      test_num +=1;
      test_name = "Resetting everything manually";
      nrst = RESET_ACTIVE;
      @(posedge clk);

      nrst = RESET_INACTIVE;
      tx_ctrl = 0; 
      ready_signal = 1;
      bit_out = 0;
      @(posedge clk);
      @(posedge clk);

      dout_exp = 0;
      success_exp = 0;

      check_output(dout_exp, success_exp);

      //Test 1
      test_num += 1;
      test_name = "Test 1";
      reset_dut();
      #(CLK_PERIOD);

      tx_ctrl = 1;
      ready_signal = 0; 

      #(CLK_PERIOD);
      tx_ctrl = 0; 
      bit_out = 1;

      #(CLK_PERIOD);
      bit_out = 1;

      #(CLK_PERIOD);
      bit_out = 0;

      #(CLK_PERIOD);
      bit_out = 0;

      #(CLK_PERIOD);
      bit_out = 1;

      #(CLK_PERIOD);
      bit_out = 0;

      #(CLK_PERIOD);
      bit_out = 1;

      #(CLK_PERIOD);
      bit_out = 1;

      #(CLK_PERIOD);
      ready_signal = 1; 

      #(CLK_PERIOD * 2);
      

      dout_exp = 1; 
      success_exp = 0;

      check_output(dout_exp, success_exp);

      $finish;
   end
endmodule

      
      
      
      
      
