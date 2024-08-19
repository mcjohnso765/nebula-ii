module t03_IO_mod_enable(
     input logic clk, rst,
    input logic write_mem, read_mem,
    input logic [31:0] data_from_mem,
    input logic [31:0] data_address, data_to_write,
    output logic [31:0] data_read,
    output logic [31:0] IO_out, IO_enable,
    input logic [31:0] IO_in
);
 logic [31:0] output_reg, input_reg, enable_reg;
 logic [31:0] next_output_reg, next_input_reg, next_enable_reg;
 


always_ff @(posedge clk, posedge rst) begin
    if (rst) begin
        IO_out <= '0;
        input_reg <= '0;
        IO_enable <= '0;
    end

    else begin
        IO_out <= next_output_reg;
        input_reg <= IO_in;
        IO_enable <= next_enable_reg;

    end

end

always_comb begin

    next_output_reg = IO_out;
    next_enable_reg = IO_enable;
    data_read = data_from_mem;
    case(data_address)
        32'hFFFFFFFF: begin
           next_output_reg = (write_mem) ? data_to_write : IO_out;
        end
        32'hFFFFFFFD: begin
           next_enable_reg = (write_mem) ? data_to_write : IO_enable;
        end
        32'hFFFFFFFC: begin
           data_read = (read_mem) ? input_reg : data_from_mem;
        end
    endcase
end

endmodule