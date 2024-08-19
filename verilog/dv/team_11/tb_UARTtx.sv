`timescale 1ms/10ns

module tb_UART_Tx;
   localparam RESET_ACTIVE = 0;
   localparam RESET_INACTIVE = 1;
   localparam CLK_PERIOD = 10;

   integer test_num;
   string test_name; 
   
   //inputs
   logic clk;
   logic nrst;
   logic tx_ctrl;
   logic [7:0] data_send; 

   //output
   logic success;
   logic tx_dout;
   logic transmit_ready;
   

   UART_Tx DUT(.clk(clk), .nrst(nrst),.tx_ctrl(tx_ctrl), .data_send(data_send), .transmit_ready(transmit_ready), .success(success), .tx_dout(tx_dout));

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
      input logic ready_exp;
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
      if(transmit_ready == ready_exp)
         $info("Correct transmit_ready value");
      else
         $error("Incorrect transmit_ready value");
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
      logic ready_exp;

      $dumpfile ("sim.vcd");
      $dumpvars(0, tb_UART_Tx);

      // initialization
      tx_ctrl = 0; 
      data_send = 8'd0;
      nrst = 1'b1;
      test_num = -1; 
      test_name = "Test Bench starting"; 
      #(CLK_PERIOD);

      dout_exp = 0;
      success_exp = 0;
      ready_exp = 0; 
      #(CLK_PERIOD);

      check_output(dout_exp, success_exp, ready_exp);

      //Test # 0 
      test_num +=1;
      test_name = "Resetting everything manually";
      nrst = RESET_ACTIVE;
      #(CLK_PERIOD);

      nrst = RESET_INACTIVE;
      tx_ctrl = 0; 
      data_send = 8'd0;
      #(CLK_PERIOD);

      dout_exp = 0;
      success_exp = 0;
      ready_exp = 0; 
      #(CLK_PERIOD);

      check_output(dout_exp, success_exp, ready_exp);

      //Test # 1
      test_num += 1;
      test_name = "Test 1";
      reset_dut();

      tx_ctrl = 1;
      data_send = 8'b11010011; 
      #(CLK_PERIOD);

      tx_ctrl = 0; 
      #(CLK_PERIOD * 12);

      dout_exp = 1; 
      success_exp = 1;
      ready_exp = 1; 
      #(CLK_PERIOD);

      check_output(dout_exp, success_exp, ready_exp);


      //Test # 2
      tx_ctrl = 1;
      data_send = 8'b01011010; 
      #(CLK_PERIOD);

      tx_ctrl = 0; 
      #(CLK_PERIOD * 12);

      dout_exp = 0; 
      success_exp = 1;
      ready_exp = 1; 
      #(CLK_PERIOD);

      check_output(dout_exp, success_exp, ready_exp);

      $finish;
   end
endmodule

      
      
      
      
      
