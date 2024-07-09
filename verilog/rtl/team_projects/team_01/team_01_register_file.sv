/*
    Module Name: register_file
    Description: allows the CPU to hold temporary memory. It holds the memory the CPU has to process immediately. 
    */


module register_file (
    input logic clk, nRst, regWrite,
    input logic [4:0] readReg1, readReg2, writeReg,
    input logic [31:0] write_data,
    output logic [31:0] readData1, readData2, output_reg
);
    // Write your code here!
    logic [31:0] registers [31:0];
    
    
    always_ff @(posedge clk, negedge nRst) begin
        if (~nRst) begin
            registers <= '{default:'0};    
        end else if (regWrite && writeReg != 0) begin
                registers[writeReg] <= write_data;
        end
    end
    
    assign output_reg = registers[5'd6];
    assign readData1 = registers[readReg1];
    assign readData2 = registers[readReg2];

endmodule