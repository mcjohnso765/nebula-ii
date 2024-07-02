`include "Tx_shift_register.sv"
`include "Tx_clock_divider.sv"

module Tx_shift_divide(
    input logic tx_ctrl,clk, nrst, enable_s, 
    input logic [7:0] data_send,

    output logic bit_out
);
    logic new_clk;

    Tx_shift_register shifts(.clk(clk), .nrst(nrst), .tx_ctrl(tx_ctrl),.enable_s(enable_s & new_clk), .data_send(data_send), .bit_out(bit_out));
     
    Tx_clock_divider #(.N(32)) divider (.clk(clk), .nrst(nrst), .new_clk(new_clk)); // where's wrap coming from? where's max coming from?  

endmodule
 