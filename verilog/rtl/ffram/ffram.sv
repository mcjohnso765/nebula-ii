module ffram #(
    parameter WORD_NUM = 256, //number of words
    parameter WORD_W = 32, //word width in bits
    parameter AD_WIDTH = $clog2(WORD_NUM) //address width (word addressable)
)
(
    input  logic [WORD_W-1:0] d_in,     //data in
    input  logic [WORD_W-1:0] bit_en,   //bit enable, active high
    input  logic [AD_WIDTH-1:0] addr,     //word address
    input  logic              rst,     //synchronous active high reset
    input  logic              clk,      //clk
    input  logic              wb_en,    // enable from WB
    input  logic              r_en,       //read enable
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

        if (wb_en) begin
            if(~r_en) begin
                mstate_n[addr] = bit_en & d_in;
            end else begin
                d_out_n = bit_en & mstate[addr];
            end
        end

        if(rst) begin
            mstate_n = '0;
            d_out_n = '0;
        end
    end

endmodule