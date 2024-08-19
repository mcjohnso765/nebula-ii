`timescale 1ms/10ns

module tb_shift_divide;
   localparam RESET_ACTIVE = 0;
   localparam RESET_INACTIVE = 1;
   localparam CLK_PERIOD = 10;

   integer test_num;
   string test_name; 
   
   //inputs
   logic clk;
   logic nrst;
   logic enable_s;
   logic tx_ctrl;
   logic [7:0] data_send; 

   //output
   logic bit_out;

   shift_divide check_divide(.clk(clk), .nrst(nrst), .enable_s(enable_s), .data_send(data_send),.tx_ctrl(tx_ctrl), .bit_out(bit_out));
   
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
      input logic bitout_exp;
   begin 
      @(posedge clk)
      if(bit_out== bitout_exp)
        $info("Correct bit_out value");
      else
        $error("Incorrect bit_out value");
   end
   endtask
 
   always begin
      clk =0;
      #(CLK_PERIOD / 2);
      clk = 1;
      #(CLK_PERIOD / 2);
   end
                
   initial begin
      logic bitout_exp;

      $dumpfile ("sim.vcd");
      $dumpvars(0, tb_shift_divide);

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
      enable_s = 0; 
      data_send = 8'd0;
      tx_ctrl = 0;
      @(posedge clk);
      @(posedge clk);

      bitout_exp = 0;

      check_output(bitout_exp);

      //Test 1
      test_num += 1;
      test_name = "Test 1";
      reset_dut();
      tx_ctrl = 1;
      data_send = 8'b11010011; 

      #(CLK_PERIOD);      
      enable_s = 1;

      tx_ctrl = 0;

      #(CLK_PERIOD);


      #(CLK_PERIOD);

      tx_ctrl = 0;

      #(CLK_PERIOD);

      bitout_exp = 1;

      check_output(bitout_exp);
      #(CLK_PERIOD * 30)

      enable_s = 0;

      $finish;
   end
endmodule

      
      
      
      
      
