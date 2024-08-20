module t03_byte_demux (
    input logic [31:0] reg_b,
    input logic store_byte_en,
    output logic [31:0]  b_out
);

    always_comb begin
      if(store_byte_en) begin
        b_out = {24'd0, reg_b[7:0]};
      end else begin
        b_out = reg_b;
      end
    
    end
endmodule