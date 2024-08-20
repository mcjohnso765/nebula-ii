
`timescale 1ms/10ns

module tb_Tx_external_shift;

   localparam RESET_ACTIVE = 0;
   localparam RESET_INACTIVE = 1;
   localparam CLK_PERIOD = 10;

   integer test_num;
   string test_name; 
   
   //inputs
   logic clk;
   logic nrst;
   logic msg_tx_ctrl;
   logic [127:0] msg_1;
   logic stop; 

   //output
   logic [7:0] data_send;
   

   Tx_external_shift shifts(.clk(clk), .nrst(nrst), .msg_tx_ctrl(msg_tx_ctrl), .msg_1(msg_1), .stop(stop), .data_send(data_send)); 
   
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
      //input logic [N-1:0] count_exp;
      input logic stop_exp;
   begin 
      @(posedge clk)
    //   if(count == count_exp)
    //     $info("Correct count value");
    //   else
    //     $error("Incorrect count value");
      if(stop == stop_exp)
        $info("Correct stop value");
      else
        $error("Incorrect stop value");
   end
   endtask
 
   always begin
      clk =0;
      #(CLK_PERIOD / 2);
      clk = 1;
      #(CLK_PERIOD / 2);
   end
                
   initial begin
    //   logic ctrl_exp;
    //   logic enable_exp;

      $dumpfile ("sim.vcd");
      $dumpvars(0, tb_Tx_external_shift);

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
      msg_1 = 128'd0;
      msg_tx_ctrl = 1'b0;
      stop = 0;
      @(posedge clk);
      @(posedge clk);

    //   enable_exp = '0;
    //   ctrl_exp = 0;

    //   check_output(ctrl_exp, enable_exp);

      //Test 1
      test_num += 1;
      test_name = "Test 1";
      reset_dut();

      // count = 1
      #(CLK_PERIOD);

      msg_1 = 128'd479762576;
      msg_tx_ctrl = 1'b1;
      stop = 0;
      #(CLK_PERIOD ); 

      msg_tx_ctrl = 1'b0;
      #(CLK_PERIOD * 110); 

     

      $finish;
   end
endmodule

      
      
      
      
      
