module t03_instruction_check (
	instruction,
	i_request
);
	reg _sv2v_0;
	input wire [31:0] instruction;
	output reg i_request;
	always @(*) begin
		if (_sv2v_0)
			;
		if (instruction == 32'h00008067)
			i_request = 1'b0;
		else
			i_request = 1'b1;
	end
	initial _sv2v_0 = 0;
endmodule
