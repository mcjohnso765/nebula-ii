module t09_fsm_direction (
	direction_a,
	clk,
	nrst,
	sync,
	pulse,
	direction
);
	reg _sv2v_0;
	input wire [3:0] direction_a;
	input wire clk;
	input wire nrst;
	input wire sync;
	input wire pulse;
	output wire [2:0] direction;
	reg [2:0] current;
	reg [2:0] temp;
	reg [2:0] temp_next;
	reg [2:0] next;
	always @(posedge clk or negedge nrst)
		if (~nrst) begin
			current <= 3'd4;
			temp <= 3'd4;
		end
		else begin
			current <= next;
			temp <= temp_next;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		if ((direction_a == 4'b0001) && (current != 3'd1))
			temp_next = 3'd0;
		else if ((direction_a == 4'b0010) && (current != 3'd0))
			temp_next = 3'd1;
		else if ((direction_a == 4'b0100) && (current != 3'd2))
			temp_next = 3'd3;
		else if ((direction_a == 4'b1000) && (current != 3'd3))
			temp_next = 3'd2;
		else if (sync)
			temp_next = 3'd4;
		else
			temp_next = temp;
		if (pulse)
			next = temp;
		else
			next = current;
	end
	assign direction = current;
	initial _sv2v_0 = 0;
endmodule
