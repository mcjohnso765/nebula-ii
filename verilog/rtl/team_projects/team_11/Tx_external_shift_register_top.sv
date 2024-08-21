`include "src/Tx_external_shift_register.sv"
`include "src/Tx_extcounter.sv"
`include "src/Tx_ext_fsm.sv"
//`include "src/lcd1602.sv"

module Tx_external_shift_register_top(
    input logic clk, nrst,
    input logic transmit_ready,
    input logic msg_tx_ctrl,
    input logic [127:0] msg_1,
    output logic [7:0]data_send,
    output logic tx_ctrl
);
    logic stop;
    logic count_enable;

    Tx_ext_fsm fsm(.clk(clk), .nrst(nrst),.transmit_ready(transmit_ready), .msg_tx_ctrl(msg_tx_ctrl), .stop(stop),.tx_ctrl(tx_ctrl), .count_enable(count_enable));
    Tx_external_shift_register ext_shift(.clk(clk), .nrst(nrst),.msg_tx_ctrl(msg_tx_ctrl), .msg_1(msg_1), .stop(stop), .transmit_ready(transmit_ready),.data_send(data_send));
    Tx_extcounter ext_count(.clk(clk), .nrst(nrst), .count_enable(count_enable), .max(5'd16), .stop(stop));


endmodule