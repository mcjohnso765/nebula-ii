module osc_sel (
	ended_note,
	key_pressed,
	osc_num,
	count,
	max,
	current_velocity,
	single_new_note_velocity,
	count_sel,
	max_sel,
	velocity_sel,
	new_note_velocity,
	ended_note_sel,
	key_pressed_sel
);
	reg _sv2v_0;
	parameter N = 24;
	input wire [N - 1:0] ended_note;
	input wire [N - 1:0] key_pressed;
	input wire [6:0] osc_num;
	input wire [(N * 20) - 1:0] count;
	input wire [(N * 20) - 1:0] max;
	input wire [(N * 7) - 1:0] current_velocity;
	input wire [6:0] single_new_note_velocity;
	output reg [19:0] count_sel;
	output reg [19:0] max_sel;
	output reg [6:0] velocity_sel;
	output reg [(N * 7) - 1:0] new_note_velocity;
	output reg ended_note_sel;
	output reg key_pressed_sel;
	always @(*) begin
		if (_sv2v_0)
			;
		count_sel = count[osc_num * 20+:20];
		max_sel = max[osc_num * 20+:20];
		velocity_sel = (osc_num == N ? 0 : current_velocity[osc_num * 7+:7]);
		ended_note_sel = (osc_num == N ? 0 : ended_note[osc_num]);
		key_pressed_sel = (osc_num == N ? 0 : key_pressed[osc_num]);
		new_note_velocity = 0;
		new_note_velocity[osc_num * 7+:7] = single_new_note_velocity;
		if (osc_num == N) begin
			count_sel = 0;
			max_sel = 0;
		end
	end
	initial _sv2v_0 = 0;
endmodule
