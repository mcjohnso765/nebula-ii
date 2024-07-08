`default_nettype none
module volume_multiplier (
	velocity,
	wave_table_output,
	volume_output
);
	reg _sv2v_0;
	input wire [6:0] velocity;
	input wire [8:0] wave_table_output;
	output reg [15:0] volume_output;
	always @(*) begin
		if (_sv2v_0)
			;
		volume_output = wave_table_output * velocity;
	end
	initial _sv2v_0 = 0;
endmodule
