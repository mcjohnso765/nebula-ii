module t03_decoder (
	inst,
	rs1,
	rs2,
	rd,
	type_out,
	control_out
);
	reg _sv2v_0;
	input wire [31:0] inst;
	output reg [4:0] rs1;
	output reg [4:0] rs2;
	output reg [4:0] rd;
	output reg [2:0] type_out;
	output reg [16:0] control_out;
	reg [6:0] opcode;
	reg [2:0] funct3;
	reg [6:0] funct7;
	reg [2:0] inst_t;
	always @(*) begin
		if (_sv2v_0)
			;
		opcode = inst[6:0];
		case (opcode)
			7'b0000011, 7'b0010011, 7'b0011011: inst_t = 3'd1;
			7'b0110011, 7'b0111011: inst_t = 3'b000;
			7'b0100011: inst_t = 3'd2;
			7'b1100011: inst_t = 3'd3;
			7'b1101111: inst_t = 3'd4;
			7'b0110111: inst_t = 3'd5;
			default: inst_t = 3'b000;
		endcase
		type_out = inst_t;
	end
	always @(*) begin
		if (_sv2v_0)
			;
		case (inst_t)
			3'b000: begin
				funct7 = inst[31:25];
				funct3 = inst[14:12];
				rs1 = inst[19:15];
				rs2 = inst[24:20];
				rd = inst[11:7];
			end
			3'd1: begin
				funct7 = 7'b0000000;
				funct3 = inst[14:12];
				rs1 = inst[19:15];
				rs2 = 5'b00000;
				rd = inst[11:7];
			end
			3'b010: begin
				funct7 = 7'b0000000;
				funct3 = inst[14:12];
				rs1 = inst[19:15];
				rs2 = inst[24:20];
				rd = 5'b00000;
			end
			3'd3: begin
				funct7 = 7'b0000000;
				funct3 = inst[14:12];
				rs1 = inst[19:15];
				rs2 = inst[24:20];
				rd = 5'b00000;
			end
			3'd5: begin
				funct7 = 7'b0000000;
				funct3 = 3'b000;
				rs1 = 5'b00000;
				rs2 = 5'b00000;
				rd = inst[11:7];
			end
			3'd4: begin
				funct7 = 7'b0000000;
				funct3 = 3'b000;
				rs1 = 5'b00000;
				rs2 = 5'b00000;
				rd = inst[11:7];
			end
			default: begin
				funct7 = 7'b0000000;
				funct3 = 3'b000;
				rs1 = 5'b00000;
				rs2 = 5'b00000;
				rd = 5'b00000;
			end
		endcase
		control_out = {funct7, funct3, inst[6:0]};
	end
	initial _sv2v_0 = 0;
endmodule
