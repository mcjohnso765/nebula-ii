module t04_UARTMem (
    input logic  clk, nRst, 
    input logic button, //uart input signal
    output logic [31:0] flag //uart output signal
);

always_ff @( posedge clk, negedge nRst) begin
    if(~nRst) begin
        flag <= 0;
    end else if (button) begin
        flag <= 32'hffffffff;
    end else begin
        flag <= 0;
    end
end
endmodule