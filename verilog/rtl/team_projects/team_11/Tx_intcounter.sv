
module Tx_intcounter #( parameter N = 4)
(
input logic clk,nrst, enable_t,
input logic [N - 1:0] max,

output logic [N-1:0] count,
output logic ready_signal

);

logic [N - 1:0] next_count;

always_comb begin
  next_count = count; 
  ready_signal = 0; 
  
  if(enable_t) begin
    ready_signal = 0; 
    if(count == max) begin
        next_count = 0; 
        ready_signal = 1; 
    end 
    else begin
      next_count = count + 1;
      ready_signal = 0;
    end
  end
  else begin
    next_count = count;
    ready_signal = 0;
  end
end

always_ff @(posedge clk, negedge nrst) begin
    if(!nrst)
     count <= 0;
     else
        count <= next_count; 

end
endmodule