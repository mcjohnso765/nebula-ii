
module Tx_extcounter #( parameter N = 5)
(
input logic clk,nrst, count_enable,
input logic [N - 1:0] max,

output logic stop

);

logic [N-1:0] count;
logic [N - 1:0] next_count;

always_comb begin
  next_count = count; 
  stop = 0; 
  
  if(count_enable) begin
    stop = 0; 
    next_count = count + 1; 
    if(count == max) begin
        next_count = 0; 
        stop = 1; 
    end 
  end
end

always_ff @(posedge clk, negedge nrst) begin
    if(!nrst)
     count = 0;
     else
        count = next_count; 

end
endmodule




//tb


// `timescale 1ms/10ns

// module tb_Top;
//    parameter N = 5;

//    localparam RESET_ACTIVE = 0;
//    localparam RESET_INACTIVE = 1;
//    localparam CLK_PERIOD = 10;

//    integer test_num;
//    string test_name; 
   
//    //inputs
//    logic clk;
//    logic nrst;
//    logic count_enable;
//    logic [N-1:0]max;

//    //output
//    logic [N-1:0] count;
//    logic stop;
   

//    Top shift_fsm(.clk(clk), .nrst(nrst), .count_enable(count_enable), .count(count), .stop(stop));
   
//    task reset_dut;
//    begin
//       @(posedge clk);
//       nrst = RESET_ACTIVE;

//       @(posedge clk);
//       nrst = RESET_INACTIVE;
//       @(posedge clk);
//    end
//    endtask

//    task check_output;
//       input logic [N-1:0] count_exp;
//       input logic stop_exp;
//    begin 
//       @(posedge clk)
//       if(count == count_exp)
//         $info("Correct count value");
//       else
//         $error("Incorrect count value");
//       if(stop == stop_exp)
//         $info("Correct stop value");
//       else
//         $error("Incorrect stop value");
//    end
//    endtask
 
//    always begin
//       clk =0;
//       #(CLK_PERIOD / 2);
//       clk = 1;
//       #(CLK_PERIOD / 2);
//    end
                
//    initial begin
//       logic ctrl_exp;
//       logic enable_exp;

//       $dumpfile ("sim.vcd");
//       $dumpvars(0, tb_Top);

//       // initialization
//       nrst = 1'b1;
//       test_num = -1; 
//       test_name = "Test Bench starting"; 
//       @(posedge clk);

//       test_num +=1;
//       test_name = "Resetting everything manually";
//       nrst = RESET_ACTIVE;
//       @(posedge clk);

//       nrst = RESET_INACTIVE;
//       count_enable = 0;
//       max = 5'd16;
//       @(posedge clk);
//       @(posedge clk);

//       enable_exp = '0;
//       ctrl_exp = 0;

//       check_output(ctrl_exp, enable_exp);

//       //Test 1
//       test_num += 1;
//       test_name = "Test 1";
//       reset_dut();

//       // count = 1
//       #(CLK_PERIOD);

//       transmit_ready = 0;
//       stop = 0;   
//       msg_sent_ctrl = 0; 
//       #(CLK_PERIOD * 10); 

//       // count = 2
//       transmit_ready = 1;  
//       #(CLK_PERIOD);

//       transmit_ready = 0;
//       stop = 0;   
//       msg_sent_ctrl = 0; 
//       #(CLK_PERIOD * 10); 

//       // count = 3
//       transmit_ready = 1;  
//       #(CLK_PERIOD);

//       transmit_ready = 0;
//       stop = 0;   
//       msg_sent_ctrl = 0; 
//       #(CLK_PERIOD * 10); 

//       // count = 4
//       transmit_ready = 1;  
//       #(CLK_PERIOD);

//       transmit_ready = 0;
//       stop = 0;   
//       msg_sent_ctrl = 0; 
//       #(CLK_PERIOD * 10); 

//       // count = 5
//       transmit_ready = 1;  
//       #(CLK_PERIOD);

//       transmit_ready = 0;
//       stop = 0;   
//       msg_sent_ctrl = 0; 
//       #(CLK_PERIOD * 10);

//       // count = 6
//       transmit_ready = 1;  
//       #(CLK_PERIOD);

//       transmit_ready = 0;
//       stop = 0;   
//       msg_sent_ctrl = 0; 
//       #(CLK_PERIOD * 10); 

//       // count = 7
//       transmit_ready = 1;  
//       #(CLK_PERIOD);

//       transmit_ready = 0;
//       stop = 0;   
//       msg_sent_ctrl = 0; 
//       #(CLK_PERIOD * 10);

//       // count = 8
//       transmit_ready = 1;  
//       #(CLK_PERIOD);

//       transmit_ready = 0;
//       stop = 0;   
//       msg_sent_ctrl = 0; 
//       #(CLK_PERIOD * 10);

//       // count = 9
//       transmit_ready = 1;  
//       #(CLK_PERIOD);

//       transmit_ready = 0;
//       stop = 0;   
//       msg_sent_ctrl = 0; 
//       #(CLK_PERIOD * 10);
      
//       // count = 10
//       transmit_ready = 1;  
//       #(CLK_PERIOD);

//       transmit_ready = 0;
//       stop = 0;   
//       msg_sent_ctrl = 0; 
//       #(CLK_PERIOD * 10);

//       // count = 11
//       transmit_ready = 1;  
//       #(CLK_PERIOD);

//       transmit_ready = 0;
//       stop = 0;   
//       msg_sent_ctrl = 0; 
//       #(CLK_PERIOD * 10);

//       // count = 12
//       transmit_ready = 1;  
//       #(CLK_PERIOD);

//       transmit_ready = 0;
//       stop = 0;   
//       msg_sent_ctrl = 0; 
//       #(CLK_PERIOD * 10);

//       // count = 13
//       transmit_ready = 1;  
//       #(CLK_PERIOD);

//       transmit_ready = 0;
//       stop = 0;   
//       msg_sent_ctrl = 0; 
//       #(CLK_PERIOD * 10);

//       // count = 14
//       transmit_ready = 1;  
//       #(CLK_PERIOD);

//       transmit_ready = 0;
//       stop = 0;   
//       msg_sent_ctrl = 0; 
//       #(CLK_PERIOD * 10);

//       // count = 15
//       transmit_ready = 1;  
//       #(CLK_PERIOD);

//       transmit_ready = 0;
//       stop = 0;   
//       msg_sent_ctrl = 0; 
//       #(CLK_PERIOD * 10);

//       // count = 16
//       transmit_ready = 1;  
//       #(CLK_PERIOD);

//       transmit_ready = 0;
//       stop = 0;   
//       msg_sent_ctrl = 0; 
//       #(CLK_PERIOD * 10);

//       stop = 1;
//       #(CLK_PERIOD);


//       enable_exp = '1;
//       ctrl_exp = 0;
//       #(CLK_PERIOD * 2)

//       check_output(ctrl_exp, enable_exp);

     

//       $finish;
//    end
// endmodule

      
      
      
      
      
