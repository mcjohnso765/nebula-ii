module exp_table (
	in,
	exp_out
);
	reg _sv2v_0;
	input wire [4:0] in;
	output reg [6:0] exp_out;
	always @(*) begin
		if (_sv2v_0)
			;
		case (in)
			0: exp_out = 7'b0000000;
			1: exp_out = 7'b0000000;
			2: exp_out = 7'b0000000;
			3: exp_out = 7'b0000001;
			4: exp_out = 7'b0000010;
			5: exp_out = 7'b0000011;
			6: exp_out = 7'b0000100;
			7: exp_out = 7'b0000110;
			8: exp_out = 7'b0001000;
			9: exp_out = 7'b0001010;
			10: exp_out = 7'b0001101;
			11: exp_out = 7'b0001111;
			12: exp_out = 7'b0010011;
			13: exp_out = 7'b0010110;
			14: exp_out = 7'b0011001;
			15: exp_out = 7'b0011101;
			16: exp_out = 7'b0100001;
			17: exp_out = 7'b0100110;
			18: exp_out = 7'b0101010;
			19: exp_out = 7'b0101111;
			20: exp_out = 7'b0110100;
			21: exp_out = 7'b0111010;
			22: exp_out = 7'b0111111;
			23: exp_out = 7'b1000101;
			24: exp_out = 7'b1001100;
			25: exp_out = 7'b1010010;
			26: exp_out = 7'b1011001;
			27: exp_out = 7'b1100000;
			28: exp_out = 7'b1100111;
			29: exp_out = 7'b1101111;
			30: exp_out = 7'b1110110;
			31: exp_out = 7'b1111111;
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
