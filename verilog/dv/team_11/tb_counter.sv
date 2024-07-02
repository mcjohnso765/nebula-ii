`timescale 1ms/10ns

module tb_counter;
   localparam RESET_ACTIVE = 0;
   localparam RESET_INACTIVE = 1;
   localparam CLK_PERIOD = 10;

   parameter N = 4;

   integer test_num;
   string test_name; 
   
   //inputs
   logic clk;
   logic nrst;
   logic enable_t;
   logic [N-1:0]max;

    //output
   logic [N-1:0]count;
   logic ready_signal;

   counter counts(.clk(clk), .nrst(nrst), .enable_t(enable_t), .max(max), .count(count), .ready_signal(ready_signal));
   
   task reset_dut;
   begin
      @(posedge clk);
      nrst = RESET_ACTIVE;

      @(posedge clk);
      nrst = RESET_INACTIVE;
   end
   endtask

   task check_output;
      input logic [N-1:0]count_exp;
      input logic ready_exp;
   begin 
      @(posedge clk)
      if(count == count_exp)
         $info("Correct count value");
      else
         $error("Incorrect count value");

      if(ready_signal == ready_exp)
         $info("Correct ready_signal value");
      else
         $error("Incorrect ready_signal value");
   end
   endtask
 
   always begin
      clk =0;
      #(CLK_PERIOD / 2);
      clk = 1;
      #(CLK_PERIOD / 2);
   end
                
   initial begin
      logic [3:0] count_exp;
      logic ready_exp;

      $dumpfile ("sim.vcd");
      $dumpvars (0, tb_counter);

      // initialization
      nrst = 1'b1;
      test_num = -1; 
      test_name = "Test Bench starting"; 
      #(0.1);

      test_num +=1;
      test_name = "Resetting everything manually";
      nrst = RESET_ACTIVE;
      #(0.1);

      nrst = RESET_INACTIVE;
      enable_t = 0; 
      max = 4'd8;
      #(0.5);

      count_exp = 0;
      ready_exp = 0;

      check_output(count_exp, ready_exp);

      //Test 1
      test_num += 1;
      test_name = "Test 1";
      reset_dut();

      enable_t = 1;
      max = 4'd8;

      #(CLK_PERIOD * 18);

      count_exp = 4'd8; 
      ready_exp = 1;

      check_output(count_exp, ready_exp);

      $finish;
   end
endmodule

      
      
      
      
      
