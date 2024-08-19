module envelope_gen (
	envelope_pulse,
	poly_start,
	ended_note,
	sustain,
	key_pressed,
	velocity_sel,
	pedal_depth,
	single_new_note_velocity
);
	reg _sv2v_0;
	input wire envelope_pulse;
	input wire poly_start;
	input wire ended_note;
	input wire sustain;
	input wire key_pressed;
	input wire [6:0] velocity_sel;
	input wire [3:0] pedal_depth;
	output reg [6:0] single_new_note_velocity;
	always @(*) begin
		if (_sv2v_0)
			;
		single_new_note_velocity = 0;
		if ((envelope_pulse && poly_start) && (velocity_sel > 16)) begin
			single_new_note_velocity = velocity_sel;
			if (key_pressed)
				single_new_note_velocity = velocity_sel - 'd1;
			else if (ended_note)
				single_new_note_velocity = velocity_sel - 'd15;
			else
				single_new_note_velocity = velocity_sel - ((16 + ~{3'b000, pedal_depth}) + 1);
		end
	end
	initial _sv2v_0 = 0;
endmodule
