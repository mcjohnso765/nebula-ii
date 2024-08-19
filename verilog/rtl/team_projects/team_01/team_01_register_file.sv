module t01_register_file (
    input   logic        clk, nRST, RegWrite,
    input   logic [4:0]  ReadReg1, ReadReg2, WriteReg,
    input   logic [31:0] WriteData,
    output  logic [31:0] ReadData1, ReadData2
);
    logic [31:0] registers [31:0];
    
    always_ff @(posedge clk, negedge nRST) begin
        if (~nRST) begin
            for(int i = 0; i < 32; i++) begin
                registers[i] <= 0;
            end     
        end else if (RegWrite && WriteReg != 0) begin
            registers[WriteReg] <= WriteData;
        end
    end
    
    assign ReadData1 = registers[ReadReg1];
    assign ReadData2 = registers[ReadReg2];

endmodule