`timescale 1ms/10ns

module tb_Tx_ext_fsm;
   localparam RESET_ACTIVE = 0;
   localparam RESET_INACTIVE = 1;
   localparam CLK_PERIOD = 10;

   integer test_num;
   string test_name; 
   
   //inputs
   logic clk;
   logic nrst;
   logic msg_sent_ctrl;
   logic transmit_ready;
   logic stop;

   //output
   logic tx_ctrl;
   logic count_enable;
   

   Tx_ext_fsm unit(.clk(clk), .nrst(nrst), .transmit_ready(transmit_ready), .msg_sent_ctrl(msg_sent_ctrl), .stop(stop), .tx_ctrl(tx_ctrl), .count_enable(count_enable));
   
   task reset_dut;
   begin
      @(posedge clk);
      nrst = RESET_ACTIVE;

      @(posedge clk);
      nrst = RESET_INACTIVE;
      @(posedge clk);
   end
   endtask

   task check_output;
      input logic ctrl_exp;
      input logic enable_exp;
   begin 
      @(posedge clk)
      if(tx_ctrl == ctrl_exp)
        $info("Correct tx_ctrl value");
      else
        $error("Incorrect tx_ctrl value");
      if(count_enable == enable_exp)
        $info("Correct count_enable value");
      else
        $error("Incorrect count_enable value");
   end
   endtask
 
   always begin
      clk =0;
      #(CLK_PERIOD / 2);
      clk = 1;
      #(CLK_PERIOD / 2);
   end
                
   initial begin
      logic ctrl_exp;
      logic enable_exp;

      $dumpfile ("sim.vcd");
      $dumpvars(0, tb_Tx_ext_fsm);

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
      msg_sent_ctrl = 1; 
      transmit_ready = 1;
      stop = 0;
      @(posedge clk);
      @(posedge clk);

      enable_exp = '0;
      ctrl_exp = 0;

      check_output(ctrl_exp, enable_exp);

      //Test 1
      test_num += 1;
      test_name = "Test 1";
      reset_dut();

      // count = 1
      #(CLK_PERIOD);

      transmit_ready = 0;
      stop = 0;   
      msg_sent_ctrl = 0; 
      #(CLK_PERIOD * 10); 

      // count = 2
      transmit_ready = 1;  
      #(CLK_PERIOD);

      transmit_ready = 0;
      stop = 0;   
      msg_sent_ctrl = 0; 
      #(CLK_PERIOD * 10); 

      // count = 3
      transmit_ready = 1;  
      #(CLK_PERIOD);

      transmit_ready = 0;
      stop = 0;   
      msg_sent_ctrl = 0; 
      #(CLK_PERIOD * 10); 

      // count = 4
      transmit_ready = 1;  
      #(CLK_PERIOD);

      transmit_ready = 0;
      stop = 0;   
      msg_sent_ctrl = 0; 
      #(CLK_PERIOD * 10); 

      // count = 5
      transmit_ready = 1;  
      #(CLK_PERIOD);

      transmit_ready = 0;
      stop = 0;   
      msg_sent_ctrl = 0; 
      #(CLK_PERIOD * 10);

      // count = 6
      transmit_ready = 1;  
      #(CLK_PERIOD);

      transmit_ready = 0;
      stop = 0;   
      msg_sent_ctrl = 0; 
      #(CLK_PERIOD * 10); 

      // count = 7
      transmit_ready = 1;  
      #(CLK_PERIOD);

      transmit_ready = 0;
      stop = 0;   
      msg_sent_ctrl = 0; 
      #(CLK_PERIOD * 10);

      // count = 8
      transmit_ready = 1;  
      #(CLK_PERIOD);

      transmit_ready = 0;
      stop = 0;   
      msg_sent_ctrl = 0; 
      #(CLK_PERIOD * 10);

      // count = 9
      transmit_ready = 1;  
      #(CLK_PERIOD);

      transmit_ready = 0;
      stop = 0;   
      msg_sent_ctrl = 0; 
      #(CLK_PERIOD * 10);
      
      // count = 10
      transmit_ready = 1;  
      #(CLK_PERIOD);

      transmit_ready = 0;
      stop = 0;   
      msg_sent_ctrl = 0; 
      #(CLK_PERIOD * 10);

      // count = 11
      transmit_ready = 1;  
      #(CLK_PERIOD);

      transmit_ready = 0;
      stop = 0;   
      msg_sent_ctrl = 0; 
      #(CLK_PERIOD * 10);

      // count = 12
      transmit_ready = 1;  
      #(CLK_PERIOD);

      transmit_ready = 0;
      stop = 0;   
      msg_sent_ctrl = 0; 
      #(CLK_PERIOD * 10);

      // count = 13
      transmit_ready = 1;  
      #(CLK_PERIOD);

      transmit_ready = 0;
      stop = 0;   
      msg_sent_ctrl = 0; 
      #(CLK_PERIOD * 10);

      // count = 14
      transmit_ready = 1;  
      #(CLK_PERIOD);

      transmit_ready = 0;
      stop = 0;   
      msg_sent_ctrl = 0; 
      #(CLK_PERIOD * 10);

      // count = 15
      transmit_ready = 1;  
      #(CLK_PERIOD);

      transmit_ready = 0;
      stop = 0;   
      msg_sent_ctrl = 0; 
      #(CLK_PERIOD * 10);

      // count = 16
      transmit_ready = 1;  
      #(CLK_PERIOD);

      transmit_ready = 0;
      stop = 0;   
      msg_sent_ctrl = 0; 
      #(CLK_PERIOD * 10);

      stop = 1;
      #(CLK_PERIOD);


      enable_exp = '1;
      ctrl_exp = 0;
      #(CLK_PERIOD * 2)

      check_output(ctrl_exp, enable_exp);

     

      $finish;
   end
endmodule

      
      
      
      
      
