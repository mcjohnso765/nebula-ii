// `include "src/UART_Tx.sv"
`include "src/Tx_extcounter.sv"
// `include "src/Tx_ext_fsm.sv"
`include "src/Tx_external_shift.sv"

module UART_extshift(
    input logic count_enable, 
    input logic [127:0] msg_1,
    input logic msg_tx_ctrl, clk, nrst,





    // input logic clk, nrst, 
    // input logic [127:0] msg_1,
    // input logic  msg_tx_ctrl,

    // output logic tx_dout, success
    output logic [7:0] data_send
);
    // logic transmit_ready; 
    // logic [7:0] data_send;
    // logic stop;
    // logic [4:0] max;
    // logic count_enable;
    // logic tx_ctrl;
    logic stop;

    //UART_Tx uart(.clk(clk), .nrst(nrst),.tx_ctrl(tx_ctrl), .data_send(data_send), .transmit_ready(transmit_ready), .success(success), .tx_dout(tx_dout));

    Tx_extcounter counter(.clk(clk), .nrst(nrst),.count_enable(count_enable), .max(5'd16), .stop(stop));
    //Tx_ext_fsm fsm(.clk(clk), .nrst(nrst), .transmit_ready(transmit_ready), .msg_tx_ctrl(msg_tx_ctrl), .stop(stop), .tx_ctrl(tx_ctrl), .count_enable(count_enable));
    Tx_external_shift shift(.clk(clk), .nrst(nrst), .msg_tx_ctrl(msg_tx_ctrl), .msg_1(msg_1), .stop(stop), .data_send(data_send));

endmodule