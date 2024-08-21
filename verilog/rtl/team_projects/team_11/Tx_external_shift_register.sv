module Tx_external_shift_register(

    input logic clk, nrst, msg_tx_ctrl, transmit_ready,
    input logic[127:0] msg_1, 
    input logic  stop,

    output logic [7:0] data_send
);

    logic [127:0] shift_register;
    logic [127:0] next_shift_register;

    always_ff @(posedge clk, negedge nrst) begin
        if (!nrst) begin
            shift_register <= 128'b1;
        end 
        else begin
            shift_register <= next_shift_register;
        end

    end

    always_comb begin   
        if(msg_tx_ctrl) begin
            next_shift_register = msg_1; //shifting logic
            data_send = shift_register[127:120];
        end 
        else if (!stop && transmit_ready) begin
            next_shift_register = {shift_register[119:0], 8'b11111111};
            data_send = shift_register[127:120];
        end
        else begin
            next_shift_register = shift_register;
            data_send = shift_register[127:120];
        end
    end

    //assign data_send = shift_register[127:120];

endmodule