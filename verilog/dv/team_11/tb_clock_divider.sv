`timescale 1ms/10ns

module tb_clock_divider;
   localparam RESET_ACTIVE = 0;
   localparam RESET_INACTIVE = 1;
   localparam CLK_PERIOD = 10;

   integer test_num;
   string test_name; 
   
   //inputs
   logic clk;
   logic nrst;

    //output
   logic new_clk;

   clock_divider divide(.clk(clk), .nrst(nrst), .new_clk(new_clk));

   task reset_dut;
   begin
      @(posedge clk);
      nrst = RESET_ACTIVE;

      @(posedge clk);
      nrst = RESET_INACTIVE;
   end
   endtask

 
   always begin
      clk =0;
      #(CLK_PERIOD / 2);
      clk = 1;
      #(CLK_PERIOD / 2);
   end
                
   initial begin
      $dumpfile ("sim.vcd");
      $dumpvars(0, tb_clock_divider); // added testbench specidications

      // initialization
      nrst = 1'b1;
      test_num = -1; 
      test_name = "Test Bench starting"; 
      #(CLK_PERIOD);

      //Test 1
      test_num += 1;
      test_name = "Resetting Manually";
      reset_dut();
      #(CLK_PERIOD * 100);


      $finish;
   end
endmodule

      
      
      
      
      
