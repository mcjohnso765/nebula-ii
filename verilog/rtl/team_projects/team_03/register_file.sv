module t03_register_file(
    input logic clk, rst, en, 
    input logic [4:0] regA_address, regB_address, rd_address,
    input logic register_write_en,
    input logic [31:0] register_write_data,
    output logic [31:0] regA_data, regB_data

);

logic [31:0][31:0] registers_state;
logic [31:0][31:0] next_registers_state;

always_comb begin
    next_registers_state = registers_state;
    regA_data = registers_state[regA_address];
    regB_data = registers_state[regB_address];

    if (register_write_en && rd_address != 5'b0 && (rd_address != 5'd29) && (rd_address != 5'd30) && (rd_address != 5'd31)) begin
        next_registers_state[rd_address] = register_write_data;
    end
end


always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
        //for (integer i = 0; i < 32; i++) begin
        //    registers_state[i] <= 32'b0;
        //end
        //registers_state <= '{default:'0};
        registers_state <= '0;
        registers_state[29] <= 32'hFFFFFFFC;
        registers_state[30] <= 32'hFFFFFFFD;
        registers_state[31] <= 32'hFFFFFFFF;
    end

    else if (en & register_write_en) begin
        registers_state <= next_registers_state;
    end


end

endmodule