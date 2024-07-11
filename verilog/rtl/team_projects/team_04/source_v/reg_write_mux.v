`default_nettype none
module reg_write_mux (
	immData,
	ALUData,
	MemData,
	PCData,
	RegWriteSrc,
	DataWrite
);
	reg _sv2v_0;
	input wire [31:0] immData;
	input wire [31:0] ALUData;
	input wire [31:0] MemData;
	input wire [31:0] PCData;
	input wire [1:0] RegWriteSrc;
	output reg [31:0] DataWrite;
	always @(*) begin
		if (_sv2v_0)
			;
		DataWrite = 0;
		if (RegWriteSrc == 0)
			DataWrite = ALUData;
		else if (RegWriteSrc == 2'b01)
			DataWrite = MemData;
		else if (RegWriteSrc == 2'b10)
			DataWrite = immData;
		else if (RegWriteSrc == 2'b11)
			DataWrite = PCData;
	end
	initial _sv2v_0 = 0;
endmodule
