module register_file(
    input logic [4:0] read_addr_1, read_addr_2, write_addr,
    input logic clk, nrst, reg_enable_write,
    input logic [31:0] write_data,
    output logic [31:0]  read_data_1, read_data_2
);
    logic [31:0] reg_file [31:0];
    logic [4:0] i;

    //assign reg_file[0] = 0;

    always_ff @(posedge clk, negedge nrst)
    if (~nrst) begin 
       for (i = 0; i < 32; i++) begin 
        reg_file[i] <= 32'b0;
       end
    end

    else if (write_addr != 5'd0) begin 
        if (reg_enable_write) begin
        reg_file[write_addr] <= write_data;
        end 
    end

    assign read_data_1 = reg_file[read_addr_1];
    assign read_data_2 = reg_file[read_addr_2];

endmodule

