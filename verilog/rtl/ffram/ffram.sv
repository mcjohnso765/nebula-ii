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

    logic [WORD_W-1:0] mstate [WORD_NUM-1:0];
    logic [WORD_W-1:0] mstate_n [WORD_NUM-1:0];

    integer i2;
    integer i3;

    // always_ff @ (posedge clk) begin
    //     for (i1 = 0; i1 < WORD_NUM; i1++)
    //     begin
    //         mstate[i1] <= mstate_n[i1];
    //     end
    // end

    genvar i;
    generate
        for (i = 0; i < WORD_NUM; i = i + 1) begin : assign_loop
            always_ff @ (posedge clk) begin
                mstate[i] <= mstate_n[i];
            end
        end
    endgenerate


    always_comb begin
        for(i2 = 0; i2 < WORD_NUM; i2++)
        begin
            mstate_n[i2] = mstate[i2];
        end
        d_out = 0;

        if (wb_en) begin
            if(~r_en) begin
                mstate_n[addr] = bit_en & d_in;
            end else begin
                d_out = bit_en & mstate[addr];
            end
        end

        for(i3 = 0; i3 < WORD_NUM; i3++)
        begin
            if(rst) begin
                mstate_n[i3] = '0;
            end
        end

        if(rst) begin
            d_out = '0;
        end
    end

endmodule