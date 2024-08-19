module t06_PWM (
	clk,
	nrst,
	enable,
	goodCollision,
	badCollision,
	out
);
	reg _sv2v_0;
	input wire clk;
	input wire nrst;
	input wire enable;
	input wire goodCollision;
	input wire badCollision;
	output wire out;
	reg [8:0] state;
	wire [18:0] max_in;
	reg [18:0] ratio_in;
	wire [18:0] ratio_lookup;
	wire [5:0] note;
	t06_fsm f1(
		.clk(clk),
		.enable(enable),
		.goodCollision(goodCollision),
		.badCollision(badCollision),
		.nrst(nrst),
		.state(note)
	);
	t06_sound notes(
		.note(note),
		.max_in(max_in),
		.ratio_lookup(ratio_lookup)
	);
	t06_counter counter1(
		.clk(clk),
		.enable(enable),
		.nrst(nrst),
		.max(max_in),
		.ratio(ratio_in),
		.out(out)
	);
	always @(*) begin
		if (_sv2v_0)
			;
		ratio_in = ratio_lookup;
	end
	always @(posedge clk or negedge nrst)
		if (nrst == 1'b0)
			state <= 9'b000000000;
		else
			state <= state;
	initial _sv2v_0 = 0;
endmodule
