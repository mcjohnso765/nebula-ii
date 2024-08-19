module t03_writeback(
    input logic [31:0] memory_value,
    input logic [31:0] ALU_value,
    input logic [31:0] pc_4_value,
    input logic mem_to_reg,
    input logic load_byte,
    input logic read_pc_4,
    input logic slt, ALU_neg_flag, ALU_overflow_flag,
    output logic [31:0] register_write
);

logic [31:0] register_value;

always_comb begin
    if(read_pc_4)
        register_value = pc_4_value;
    
    else if(load_byte)
        register_value = {24'b0,memory_value[7:0]};

    else if(slt) begin
        if ((ALU_neg_flag) && (!ALU_overflow_flag)) begin
            register_value = 32'd1;
        end
        else begin
            register_value = 32'b0;
        end
    end
    else if(~mem_to_reg)
        register_value = ALU_value;
    else
        register_value = memory_value;
end
assign register_write = register_value;

endmodule