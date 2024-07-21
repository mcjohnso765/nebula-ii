module t09_border_generator (
	x,
	y,
	isBorder
);
	reg _sv2v_0;
	input wire [3:0] x;
	input wire [3:0] y;
	output reg isBorder;
	always @(*) begin
		if (_sv2v_0)
			;
		isBorder = 1'b0;
		if ((((x == 4'b0000) || (x == 4'd15)) || (y == 4'b0000)) || (y == 4'd11))
			isBorder = 1'b1;
	end
	initial _sv2v_0 = 0;
endmodule
