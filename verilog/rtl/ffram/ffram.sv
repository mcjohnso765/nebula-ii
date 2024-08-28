module ffram #(
    parameter WORD_NUM = 256, 
    parameter WORD_W = 32
    parameter AD_SPACE = $clog2(WORD_NUM))
(
    input  logic [WORD_W-1:0] d_in,     //data in
    input  logic [WORD_W-1:0] bit_en,   //bit enable, active high
    input  logic [WORD_W-1:0] addr,     //address
    input  logic              r_wb,     //synchronous wb reset (active high I think)
    input  logic              clk,      //clk
    input  logic              en,       //I decided to implement this as "read not write"
    output logic [WORD_W-1:0] d_out     //data out
);

    logic [WORD_NUM-1:0][WORD_W-1:0] mstate, mstate_n;
    logic [WORD_W-1:0] d_out_n;
    always_ff @ (posedge clk) begin
        mstate <= mstate_n;
        d_out <= d_out_n;
    end

    always_comb begin
        mstate_n = mstate;
        d_out_n = d_out;

        if(~en) begin
            mstate_n[addr[AD_SPACE-1:0]] = d_in;
        end else begin
            d_out_n = bit_en & mstate[addr[AD_SPACE-1:0]];
        end

        if(r_wb) begin
            mstate_n = '0;
            d_out_n = '0;
        end
    end

endmodule