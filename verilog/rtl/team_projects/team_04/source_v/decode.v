module decode (
	instruction,
	rs1,
	rs2,
	rd,
	opcode,
	ALUOp,
	func7
);
	input wire [31:0] instruction;
	output wire [4:0] rs1;
	output wire [4:0] rs2;
	output wire [4:0] rd;
	output wire [6:0] opcode;
	output wire [2:0] ALUOp;
	output wire [6:0] func7;
	assign opcode = instruction[6:0];
	assign rd = instruction[11:7];
	assign rs1 = instruction[19:15];
	assign rs2 = instruction[24:20];
	assign ALUOp = instruction[14:12];
	assign func7 = instruction[31:25];
endmodule
