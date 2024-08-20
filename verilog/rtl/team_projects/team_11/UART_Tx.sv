`include "src/Tx_intcounter.sv"
`include "src/Tx_shift_register.sv"
`include "src/Tx_fsm.sv"
`include "src/Tx_clock_divider.sv"



module UART_Tx(
    input logic tx_ctrl,clk, nrst,
    input logic [7:0] data_send,
    output logic transmit_ready, 

    output logic success,
    output logic tx_dout,
    output logic[1:0] state

);
    logic bit_out; 
    logic [3:0] count;
    logic [3:0] max;
    logic enable_s; 
    logic enable_t; 
    logic ready_signal; // input to fsm from counter
    logic new_clk;
    logic [7:0]new_data;

    Tx_shift_register shifts(.clk(clk), .nrst(nrst), .tx_ctrl(tx_ctrl),.enable_s(enable_s & new_clk), .data_send(data_send), .bit_out(bit_out), .count(count));
     
    Tx_fsm states(.clk(clk), .nrst(nrst), .tx_ctrl(tx_ctrl), .bit_out(bit_out), .tx_dout(tx_dout), .enable_t(enable_t), .enable_s(enable_s), .success(success), .ready_signal(ready_signal), .transmit_ready(transmit_ready), .current_state(state));

    Tx_intcounter #(.N(4))  counts(.clk(clk), .nrst(nrst), .enable_t(enable_t & new_clk), .max(4'd11), .ready_signal(ready_signal), .count(count)); // where's wrap coming from? where's max coming from?  

    Tx_clock_divider #(.N(32)) divider (.clk(clk), .nrst(nrst), .new_clk(new_clk)); 

    // debouncer debounce(.clk(clk), .nrst(nrst), .new_clk(new_clk), .data_send(data_send), .new_data(new_data)); 

endmodule
 
 // max from clock divider comes from taking 2.4 Ghz( 2.4 x 10 ^9 ) divided by 2 then take all that and divide by the baud rate of 9600 to get max 