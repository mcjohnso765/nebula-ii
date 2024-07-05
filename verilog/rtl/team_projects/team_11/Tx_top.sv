`include "src/Tx_extcounter.sv"
`include "src/Tx_ext_fsm.sv"
`include "src/Tx_external_shift.sv"

module Tx_top( 
    input logic [127:0] msg_1,
    input logic msg_tx_ctrl, clk, nrst, transmit_ready,

    output logic [7:0] data_send, 
    output tx_ctrl 

);
    logic count_enable; 
    logic [4:0]max;
    logic stop;

    Tx_extcounter counter(.clk(clk), .nrst(nrst),.count_enable(count_enable), .max(5'd16), .stop(stop));
    Tx_ext_fsm fsm(.clk(clk), .nrst(nrst), .transmit_ready(transmit_ready), .msg_tx_ctrl(msg_tx_ctrl), .stop(stop), .tx_ctrl(tx_ctrl), .count_enable(count_enable));
    Tx_external_shift shift(.clk(clk), .nrst(nrst), .msg_tx_ctrl(msg_tx_ctrl), .msg_1(msg_1), .stop(stop), .data_send(data_send));

endmodule

















// module Tx_top (
//  // I/O ports
//  input  logic hwclk, reset,
//  input  logic [20:0] pb,
//  output logic [7:0] left, right,
//         ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0,
//  output logic red, green, blue,

//  // UART ports
//  output logic [7:0] txdata,
//  input  logic [7:0] rxdata,
//  output logic txclk, rxclk,
//  input  logic txready, rxready
// );

//     logic temp;
//     logic succ; 
//     assign green = succ;
//     assign red = ~temp;

    
//     UART_Tx DUT(.clk(hwclk), .nrst(reset),.tx_ctrl(pb[16]), .data_send(pb[7:0]), .transmit_ready(temp), .success(succ), .tx_dout(left[0]));
//     //debouncer dff(.clk(hwclk), .nrst(reset), .new_clk(left[3]), .data_send(pb[7:0]), .new_data(right[7:0]));

// endmodule