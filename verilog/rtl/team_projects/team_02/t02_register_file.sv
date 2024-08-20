// module t02_register_file
// (
//     input logic clk, nRST, reg_write,
//     input logic [4:0] write_index, read_index1, read_index2,
//     input logic [31:0] write_data,
//     output logic [31:0] read_data1, read_data2
// );
// logic [31:0] register [31:0];
// logic [31:0] nxt_register [31:0];

// always_ff@(posedge clk, negedge nRST) begin
//     if (!nRST) begin
//         for (int i = 0; i<32;  i ++) begin
//             register[i][31:0] <= 32'b0;
//         end
//     end
//     else if(reg_write) begin
//         register[31:0][31:0] <= nxt_register[31:0][31:0];
//     end
// end
// always_comb begin
//     nxt_register[31:0][31:0] = register[31:0][31:0];
//     nxt_register [0] = 32'b0;
//     if(reg_write & (write_data != 32'b0)) begin
//         nxt_register [write_index][31:0]= write_data;
//     end
// end

// assign read_data1 = register [read_index1];
// assign read_data2 = register [read_index2];
// endmodule
module t02_register_file
(
    input logic clk, nRST, reg_write, en,
    input logic [4:0] write_index, read_index1, read_index2,
    input logic [31:0] write_data,
    output logic [31:0] read_data1, read_data2
);

    logic [31:0] register [31:0];
    logic [31:0] nxt_register [31:0];

    always_ff @(posedge clk or negedge nRST) begin
        if (!nRST) begin
            for (int i = 0; i < 32; i ++) begin
                for (int j = 0; j < 32; j++) begin
                    register[i][j] <= 1'b0;
                end
            end
        end
        else if(en & reg_write) begin
            for (int i = 1; i < 32; i++) begin
                register[i] <= nxt_register[i];
            end
        end
        else begin
          register[write_index] <= register[0];  
        end
    end

    always_comb begin
        for (int i = 0; i < 32; i++) begin
            nxt_register[i] = register[i];
        end
        
        if (reg_write && (write_index != 5'b0)) begin
            nxt_register[write_index] = write_data;
        end
        else begin
            nxt_register[write_index] = 32'b0;
        end
    end

    assign read_data1 = register[read_index1];
    assign read_data2 = register[read_index2];

endmodule
// module t02_register_file
// (
//     input logic clk, nRST, reg_write, en,
//     input logic [4:0] write_index, read_index1, read_index2,
//     input logic [31:0] write_data,
//     output logic [31:0] read_data1, read_data2
// );
 
//     logic [31:0] [31:0]register ;
//     logic [31:0] [31:0]nxt_register ;
//     always_comb begin
//         nxt_register = register;
//         read_data1 = register [read_index1];
//         read_data2 = register [read_index2];
 
 
//         if (reg_write && write_index != 5'b0) begin
//             nxt_register [write_index] = write_data;
//         end
//     end
//     always_ff @(posedge clk or negedge nRST) begin
//         if (!nRST) begin
//             register <= '0;
//         end
//         else if (reg_write & en)begin
//             register <= nxt_register;
//         end
//     end
 
 
// endmodule