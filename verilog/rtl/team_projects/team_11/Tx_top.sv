module Tx_top (
 // I/O ports
 input  logic hwclk, reset,
 input  logic [20:0] pb,
 output logic [7:0] left, right,
        ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0,
 output logic red, green, blue,

 // UART ports
 output logic [7:0] txdata,
 input  logic [7:0] rxdata,
 output logic txclk, rxclk,
 input  logic txready, rxready
);

    logic temp;
    logic succ; 
    assign green = succ;
    assign red = ~temp;

    
    UART_Tx DUT(.clk(hwclk), .nrst(reset),.tx_ctrl(pb[16]), .data_send(pb[7:0]), .transmit_ready(temp), .success(succ), .tx_dout(left[0]));
    //debouncer dff(.clk(hwclk), .nrst(reset), .new_clk(left[3]), .data_send(pb[7:0]), .new_data(right[7:0]));

endmodule