module t04_vgaMem (
    input logic clk,
    nRst, 
    write_enable, //control signal enabling writing
    input logic [31:0] write_address, write_data, read_address, //address and values to be written
    output logic [31:0] read_data
);

    //instantiaate 384 32-bit registers    
    reg [31:0] memory [383:0];

    //write if write signal is HI, always read
    always_ff @( posedge clk, negedge nRst ) begin
        if(~nRst) begin
		for (integer i = 0; i < 384; i++) begin
                memory[i] = 32'b0;
            	end
        end else if (write_enable) begin
            memory[write_address] <= write_data;
        end  
        read_data <= memory[read_address];
    end
endmodule
