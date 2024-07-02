module Tx_extcounter 
(
    input logic clk,nrst, transmit_ready,
    

    output logic [17:0] count,
    output logic STOP

);

logic [17:0] next_count;

always_comb begin
    STOP = 0;
    next_count = count;

    if(transmit_ready) begin
        next_count = count + 1;
        if (count == 18'd18) begin
            STOP = 1;
            next_count = 0;
        end
    end
end

always_ff @(posedge clk, negedge nrst) begin
    if(!nrst) begin
        count = 0;
    end else begin
        count = next_count;  
    end
end
endmodule  