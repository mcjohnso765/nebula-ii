module Tx_external_shift(
    input logic clk,
    input logic nrst,
    input logic transmit_ready,
    input logic msg_sent_ctrl,
    input logic[127:0] msg,
    input logic STOP,
    output logic [7:0] data_send,
    output logic tx_ctrl
);

    //parameter logic START_BYTE = 8'h02;
    //parameter logic STOP_BYTE = 8'h03;

    logic [143:0] shift_register;
    logic [143:0] next_shift_register;
    logic [7:0] bit_counter;
    logic tx_active;

    always_ff @(posedge clk , negedge nrst) begin
        if (!nrst) begin
            shift_register <= '0;
        end else begin
            shift_register <= next_shift_register;
        end
    end
            
    always_comb begin   
        if(msg_sent_ctrl) begin
            
            next_shift_register = msg[127:0]; //shifting logic
            
        end else if (transmit_ready && !STOP) begin
                next_shift_register = shift_register << 8;
            end
            else begin
                next_shift_register = shift_register;
            end
    end

    always_comb begin
        if(transmit_ready) begin
            data_send = shift_register[143:136]; //output logic
            tx_ctrl = 1;
        end else begin
            tx_ctrl = 0;
            data_send = 8'h0;
        end
    end
endmodule