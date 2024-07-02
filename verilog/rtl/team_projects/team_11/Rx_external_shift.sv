module Rx_external_shift(
    input logic clk,
    input logic nrst,
    input logic receive_ready,
    input logic [7:0] data_receive,
    output logic [127:0] msg,
    output logic rx_start
);

    logic [127:0] shift_register;
    logic [127:0] shift_register_buffer;

    always_ff @(posedge clk, negedge nrst) begin 
        if (!nrst) begin
            shift_register <= 128'd0;
            shift_register_buffer <= 128'd0;
            rx_start <= 0;
        end 
        else begin 
            rx_start <= receive_ready;
            
            if(receive_ready) begin
                shift_register <= (shift_register << 8) | data_receive;
            end
            else begin
                shift_register_buffer <= shift_register;
            end
        end
    end

    //always_ff @(posedge clk or negedge nrst) begin 
      //  if (!nrst) 
        //    rx_start <= 0;
        //else 
        //    rx_start <= receive_ready;
    //end

    always_comb begin
        msg = shift_register_buffer;
    end
endmodule