module imm_gen (
	instruction,
	imm,
	flag
);
	reg _sv2v_0;
	input wire [31:0] instruction;
	output reg [31:0] imm;
	output reg flag;
	wire [31:0] imm_raw;
	reg fill;
	always @(*) begin
		if (_sv2v_0)
			;
		flag = 1'b0;
		fill = instruction[31];
		case (instruction[6:0])
			7'b0110111, 7'b0010111: begin
				imm[31:12] = {instruction[31:12]};
				imm[11:0] = 12'b000000000000;
			end
			7'b1101111: begin
				imm[0] = 0;
				imm[20:1] = {instruction[31], instruction[19:12], instruction[20], instruction[30:21]};
				imm[31:21] = {11 {fill}};
			end
			7'b1100111, 7'b0000011, 7'b0010011: begin
				imm[11:0] = instruction[31:20];
				imm[31:12] = {20 {fill}};
			end
			7'b0100011: begin
				imm[4:0] = instruction[11:7];
				imm[11:5] = instruction[31:25];
				imm[31:12] = {20 {fill}};
			end
			7'b1100011: begin
				imm[0] = 0;
				imm[4:1] = instruction[11:8];
				imm[10:5] = instruction[30:25];
				imm[11] = instruction[7];
				imm[12] = instruction[31];
				imm[31:13] = {19 {fill}};
			end
			default: begin
				imm = 32'b01010101010101010101010101010101;
				flag = 1'b1;
			end
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
