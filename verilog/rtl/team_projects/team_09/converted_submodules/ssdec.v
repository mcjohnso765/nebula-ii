module t09_ssdec (
	in,
	enable,
	out
);
	reg _sv2v_0;
	input wire [3:0] in;
	input wire enable;
	output wire [6:0] out;
	reg [6:0] code;
	always @(*) begin
		if (_sv2v_0)
			;
		case ({in})
			4'd0: {code} = 7'b0111111;
			4'd1: {code} = 7'b0000110;
			4'd2: {code} = 7'b1011011;
			4'd3: {code} = 7'b1001111;
			4'd4: {code} = 7'b1100110;
			4'd5: {code} = 7'b1101101;
			4'd6: {code} = 7'b1111101;
			4'd7: {code} = 7'b0000111;
			4'd8: {code} = 7'b1111111;
			4'd9: {code} = 7'b1100111;
			4'd10: {code} = 7'b1110111;
			4'd11: {code} = 7'b1111100;
			4'd12: {code} = 7'b0111001;
			4'd13: {code} = 7'b1011110;
			4'd14: {code} = 7'b1111001;
			4'd15: {code} = 7'b1110001;
		endcase
	end
	assign out = code & {7 {enable}};
	initial _sv2v_0 = 0;
endmodule
