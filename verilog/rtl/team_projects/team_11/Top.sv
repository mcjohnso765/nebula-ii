`include "source/Tx_external_shift.sv"
`include "source/Tx_extcounter.sv"
`include "source/Tx_ext_fsm.sv"
`include "source/keypad_control.sv"
`include "UART_Tx.sv"
//`include "src/lcd1602.sv"

module Top(
    input logic clk, nrst, transmit_ready,
    input logic [3:0]readrow, 

    //output logic  tx_dout, 
    output logic [3:0]scancol,
    output logic tx_ctrl, //success,
    output logic [7:0] data_send
);
    //keypad controller
        logic [127:0] msg_1;
        logic msg_tx_ctrl;
        
        keypad_control controls(.clk(clk), .nrst(nrst),.readrow(readrow),.scancol(scancol), .msg_1(msg_1),.msg_tx_ctrl(msg_tx_ctrl));

    //Tx external shift register 
        logic count_enable;
        logic stop;
        //logic transmit_ready;
        //logic [7:0] data_send;
        //logic tx_ctrl;

        Tx_ext_fsm fsm(.clk(clk), .nrst(nrst),.transmit_ready(transmit_ready), .msg_tx_ctrl(msg_tx_ctrl), .stop(stop),.tx_ctrl(tx_ctrl), .count_enable(count_enable));
        Tx_external_shift ext_shift(.clk(clk), .nrst(nrst),.msg_tx_ctrl(msg_tx_ctrl), .msg_1(msg_1), .stop(stop), .data_send(data_send));
        Tx_extcounter ext_count(.clk(clk), .nrst(nrst), .count_enable(count_enable), .max(5'd16), .stop(stop));


    // UART_TX  
        UART_Tx tx(.clk(clk), .nrst(nrst), .data_send(data_send), .tx_ctrl(tx_ctrl), .transmit_ready(transmit_ready), .success(success), .tx_dout(tx_dout));

    
    //Rx external shift register

    //lcd
       // lcd1602(.clk(clk), .nrst(nrst), .row_1(msg_1), .row_2(msg_2), .lcd_en(lcd_en), .lcd_rw(lcd_rw), .lcd_rs(lcd_rs), . lcd_data(lcd_data));

endmodule