// module dff(

// input logic clk,nrst,new_clk,
// input logic [7:0] data_send,

// output logic [7:0] new_data

// );

// always_ff@(posedge clk, negedge nrst) begin 
//     if(!nrst) begin 
//         new_data <= '0;
//     end
//     else begin 
//         new_data <= data_send;
//     end

// end

// endmodule


// module debouncer(
// input data_send, clk, nrst,

// output new_data,

// );
//     clock_divider#(.N(32)) divider (.clk(clk), .nrst(nrst), .new_clk(new_clk)); 

// endmodule


module debouncer(
  input clk,
  input nrst,
  input logic keyvalid,
  output logic receive_ready
  );

  logic next_receive_ready;
  
  always_ff @(posedge clk, negedge nrst)

    if(!nrst)
      receive_ready <= 0;
    else 
      receive_ready <= next_receive_ready;
       
  always_comb begin
    if (keyvalid == 1)
    next_receive_ready = 1'b1;
    else if (keyvalid == 0)
    next_receive_ready = 1'b0;
    else 
    next_receive_ready = receive_ready;


  end
endmodule