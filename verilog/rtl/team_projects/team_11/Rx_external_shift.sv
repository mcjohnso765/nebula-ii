module sr_rx(
    input logic clk,
    input logic nrst,
    input logic new_clk,
    input logic receive_ready,
    input logic [7:0] data_receive,
    output logic [127:0] msg
  );

    logic [127:0] shift_register;
    logic [127:0] shift_register_buffer;

    always_ff @(posedge clk or negedge nrst) begin 
        if (!nrst) begin
            shift_register <= 128'd0;
            shift_register_buffer <= 128'd0;
        end else begin
            if(receive_ready && new_clk) begin
                shift_register <= (shift_register << 8) | {120'b0,data_receive};
            end
            else begin 
                shift_register <= shift_register;
            end
            shift_register_buffer <= shift_register;
        end
    end

    always_comb begin
        msg = shift_register_buffer;
    end
endmodule