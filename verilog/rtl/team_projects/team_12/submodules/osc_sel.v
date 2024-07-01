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
	isprevzero,
	new_note_velocity,
	ended_note_sel,
	key_pressed_sel
);
	reg _sv2v_0;
	parameter N = 13;
	input wire [N - 1:0] ended_note;
	input wire [N - 1:0] key_pressed;
	input wire [$clog2(N) - 1:0] osc_num;
	input wire [(N * 20) - 1:0] count;
	input wire [(N * 20) - 1:0] max;
	input wire [(N * 7) - 1:0] current_velocity;
	input wire [6:0] single_new_note_velocity;
	output reg [19:0] count_sel;
	output reg [19:0] max_sel;
	output reg [6:0] velocity_sel;
	output reg isprevzero;
	output reg [(N * 7) - 1:0] new_note_velocity;
	output reg ended_note_sel;
	output reg key_pressed_sel;
	reg [$clog2(N) - 1:0] prev_osc;
	reg [$clog2(N) - 1:0] prev_osc2;
	reg [$clog2(N) - 1:0] prev_osc3;
	always @(*) begin
		if (_sv2v_0)
			;
		prev_osc = (osc_num == 0 ? N - 1 : osc_num - 1);
		prev_osc2 = (prev_osc == 0 ? N - 1 : prev_osc - 1);
		prev_osc3 = (prev_osc2 == 0 ? N - 1 : prev_osc2 - 1);
		count_sel = count[osc_num * 20+:20];
		max_sel = max[osc_num * 20+:20];
		velocity_sel = (prev_osc2 == N ? 0 : current_velocity[prev_osc2 * 7+:7]);
		ended_note_sel = (prev_osc2 == N ? 0 : ended_note[prev_osc2]);
		key_pressed_sel = (prev_osc2 == N ? 0 : key_pressed[prev_osc2]);
		new_note_velocity = 0;
		new_note_velocity[prev_osc2 * 7+:7] = single_new_note_velocity;
		if (prev_osc3 < N)
			isprevzero = !(|max[prev_osc3 * 20+:20]);
		else
			isprevzero = 1;
		if (osc_num == N) begin
			count_sel = 0;
			max_sel = 0;
		end
	end
	initial _sv2v_0 = 0;
endmodule
