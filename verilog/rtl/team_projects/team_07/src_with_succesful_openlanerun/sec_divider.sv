module sec_divider (
    input logic clk,
    input logic nrst,
    input logic clear, 
    output logic s_strobe,
    output logic [23:0] count // used to be a initialized variable but an output for Luke's Random # generator
);
// initialize Variables
logic [23:0] nxt_cnt;  //
logic [23:0] clk_div;  // count up to 12 million 

assign clk_div = 24'd12000000;

always_comb begin
    if (clear) begin
        nxt_cnt = 24'd0;
        s_strobe = 0;
    end else if (count == clk_div) begin
        s_strobe = 1;
        nxt_cnt = '0;
    end else begin
        s_strobe = 0;
        nxt_cnt = count + 1;
    end
end

always_ff@ (posedge clk, negedge nrst) begin
    if (!nrst) begin
        count <= 0;
    end else begin 
        count <= nxt_cnt;
    end    
end

endmodule