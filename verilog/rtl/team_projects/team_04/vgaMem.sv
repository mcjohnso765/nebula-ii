module vgaMem (
    input logic clk,
    nRst, 
    write_enable, //control signal enabling writing
    input logic [31:0] address, write_data, //address and values to be written
    output logic [31:0] read_data
);

    //instantiaate 384 32-bit registers    
    reg [31:0] memory [383:0];

    //write if write signal is HI, always read
    always_ff @( posedge clk, negedge nRst ) begin
        if(~nRst) begin
            memory = '{default:0}; //
        end else if (write_enable) begin
            memory[address] <= write_data;
        end  
        read_data <= memory[address];
    end
endmodule