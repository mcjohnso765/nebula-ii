module Tx_top_shift(
    input logic clk,
    input logic nrst,
    output logic [7:0] data_send,
    output logic tx_ctrl,
    output logic STOP
);

logic transmit_ready;
logic [127:0] msg;

Tx_extcounter counter(
    .clk(clk),
    .nrst(nrst),
    .transmit_ready(transmit_ready),
    .STOP(STOP)
);

Tx_external_shift sr(
    .clk(clk),
    .nrst(nrst),
    .msg(msg),
    .transmit_ready(transmit_ready),
    .data_send(data_send),
    .tx_ctrl(tx_ctrl)
);

always_ff @(posedge clk, negedge nrst) begin
    if (!nrst) begin
        msg <= 128'h0;
        transmit_ready <= 0;
    end else begin
        msg <= 128'hAABBCCDDEEFF00112233445566778899;
        transmit_ready <= (STOP);
    end
end

endmodule