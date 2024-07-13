
module buffer(
    input logic [7:0]keycode,
    input logic clk,
    input logic nrst,
    input logic receive_ready,
    output logic [7:0]keycode_previous
    );

  logic [7:0]nextkeycode;
    
  always_ff @(posedge clk, negedge nrst) 
    if (!nrst) 
      keycode_previous <= 8'b0;

    else 
      keycode_previous <= nextkeycode;
      


    always_comb begin
    nextkeycode = keycode_previous;
    if (receive_ready)
      nextkeycode = keycode;
    else 
      nextkeycode = keycode_previous;
    end
endmodule
