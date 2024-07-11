`default_nettype none
module aluop_mux (
	regB,
	imm,
	alu_src,
	opB
);
	reg _sv2v_0;
	input wire [31:0] regB;
	input wire [31:0] imm;
	input wire alu_src;
	output reg [31:0] opB;
	always @(*) begin
		if (_sv2v_0)
			;
		if (alu_src == 1)
			opB = imm;
		else
			opB = regB;
	end
	initial _sv2v_0 = 0;
endmodule
