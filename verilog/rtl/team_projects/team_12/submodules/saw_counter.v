`default_nettype none
module saw_counter (
	MHz10,
	nrst,
	en,
	clear,
	start_note,
	end_note,
	sustain_in,
	new_max,
	velocity,
	new_note_velocity,
	current_velocity,
	current_max,
	current_count,
	available,
	current_ended_note,
	key_pressed
);
	reg _sv2v_0;
	input wire MHz10;
	input wire nrst;
	input wire en;
	input wire clear;
	input wire start_note;
	input wire end_note;
	input wire sustain_in;
	input wire [19:0] new_max;
	input wire [6:0] velocity;
	input wire [6:0] new_note_velocity;
	output reg [6:0] current_velocity;
	output reg [19:0] current_max;
	output reg [19:0] current_count;
	output reg available;
	output reg current_ended_note;
	output reg key_pressed;
	reg next_key_pressed;
	reg [19:0] next_max;
	reg [19:0] next_count;
	reg [6:0] next_velocity;
	reg current_sustaining;
	reg next_sustaining;
	reg ended_note;
	always @(posedge MHz10 or negedge nrst)
		if (!nrst) begin
			current_max <= 0;
			current_velocity <= 0;
			current_sustaining <= 0;
			key_pressed <= 0;
		end
		else begin
			current_max <= next_max;
			current_velocity <= next_velocity;
			current_sustaining <= next_sustaining;
			key_pressed <= next_key_pressed;
		end
	always @(posedge MHz10 or negedge nrst)
		if (~nrst)
			current_ended_note <= 0;
		else
			current_ended_note <= ended_note;
	always @(*) begin
		if (_sv2v_0)
			;
		next_max = current_max;
		next_sustaining = current_sustaining;
		available = current_max <= 'd16;
		ended_note = current_ended_note;
		next_key_pressed = key_pressed;
		next_velocity = new_note_velocity;
		if (en) begin
			if (sustain_in)
				ended_note = 0;
			if (current_velocity <= 'd16) begin
				available = 1;
				ended_note = 0;
				next_max = 0;
			end
			if (new_note_velocity == 0)
				next_velocity = current_velocity;
			if (clear) begin
				next_max = 0;
				next_velocity = 0;
			end
			else if (start_note) begin
				next_max = new_max;
				next_velocity = velocity;
				next_key_pressed = 1;
			end
			else if (end_note && (current_max == new_max)) begin
				next_key_pressed = 0;
				if (sustain_in) begin
					next_sustaining = 1;
					ended_note = 0;
				end
				else
					ended_note = 1;
			end
			if (current_sustaining && !sustain_in) begin
				next_sustaining = 0;
				ended_note = 1;
			end
		end
	end
	always @(posedge MHz10 or negedge nrst)
		if (!nrst)
			current_count <= 0;
		else
			current_count <= next_count;
	always @(*) begin
		if (_sv2v_0)
			;
		next_count = current_count;
		if (en) begin
			if (clear)
				next_count = 0;
			else begin
				next_count = current_count + 1;
				if (current_count >= current_max)
					next_count = 0;
			end
		end
	end
	initial _sv2v_0 = 0;
endmodule
