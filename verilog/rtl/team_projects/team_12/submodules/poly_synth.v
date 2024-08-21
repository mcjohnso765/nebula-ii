`default_nettype none
module poly_synth (
	MHz10,
	nrst,
	en,
	serIn,
	wave_mode_pb,
	clear,
	latch_output
);
	input wire MHz10;
	input wire nrst;
	input wire en;
	input wire serIn;
	input wire wave_mode_pb;
	input wire clear;
	output wire [15:0] latch_output;
	localparam N = 75;
	wire baudClk;
	wire done;
	wire [7:0] uart_out;
	uart_in uart_in(
		.MHz10(MHz10),
		.nrst(nrst),
		.en(en),
		.serIn(serIn),
		.baudClk(baudClk),
		.dataOut(uart_out),
		.beginRx(),
		.done(done)
	);
	wire start_note_b;
	wire end_note_b;
	reg sustain_in_p;
	wire start_note;
	wire end_note;
	wire sustain_in;
	wire [7:0] status;
	wire [7:0] note;
	wire [7:0] velocity;
	wire [1:0] current_state;
	reg [3:0] current_pedal_depth;
	wire [3:0] next_pedal_depth;
	wire [2:0] wave_mode;
	midi_decoder midi_decoder(
		.MHz10(MHz10),
		.nrst(nrst),
		.en(en),
		.uart_output(uart_out),
		.clear(clear),
		.done(done),
		.output_note(note),
		.output_velocity(velocity),
		.output_status(status),
		.current_state(current_state),
		.next_state(),
		.start_pulse(start_note)
	);
	assign start_note_b = status[7:4] == 4'h9;
	assign end_note_b = status[7:4] == 4'h8;
	always @(posedge MHz10 or negedge nrst)
		if (!nrst) begin
			sustain_in_p <= 0;
			current_pedal_depth <= 0;
		end
		else if ((status[7:4] == 4'hb) && (note == 8'h40)) begin
			if (velocity >= 8'h40) begin
				sustain_in_p <= 1;
				current_pedal_depth <= velocity[5:2];
			end
			else
				sustain_in_p <= 0;
		end
	sync syncend(
		.MHz10(MHz10),
		.nrst(nrst),
		.en(en),
		.in(end_note_b),
		.out(end_note)
	);
	sync syncsus(
		.MHz10(MHz10),
		.nrst(nrst),
		.en(en),
		.in(sustain_in_p),
		.out(sustain_in)
	);
	wave_selector wave_selector(
		.MHz10(MHz10),
		.nrst(nrst),
		.en(en),
		.wave_mode_pb(wave_mode_pb),
		.wave_mode(wave_mode),
		.lockstate()
	);
	wire samp_enable;
	wire [74:0] avail;
	wire [74:0] start_out;
	wire [19:0] max;
	wire [1499:0] current_max;
	wire [1499:0] current_count;
	wire [524:0] current_velocity;
	wire [524:0] new_note_velocity;
	wire [6:0] velocity_sel;
	wire ready;
	wire start;
	wire start_vol;
	wire [15:0] volume_output;
	wire accumulate;
	wire store_samp;
	wire clear_accumulator;
	wire [6:0] osc_num;
	wire [19:0] selected_count;
	wire [19:0] selected_max;
	wire [7:0] normalized_out;
	wire [8:0] wave_table_output;
	wire [15:0] accumulator_sum;
	wire [6:0] table_output;
	wire envelope_pulse;
	wire [74:0] ended_note;
	wire ended_note_sel;
	wire [6:0] single_new_note_velocity;
	wire [74:0] key_pressed;
	wire key_pressed_sel;
	sample_clock_div scd(
		.MHz10(MHz10),
		.nrst(nrst),
		.en(en),
		.samp_enable(samp_enable)
	);
	start_arbitrator #(.N(N)) arbitrator(
		.MHz10(MHz10),
		.nrst(nrst),
		.start_in(start_note),
		.avail(avail),
		.start_out(start_out)
	);
	note_div_table note_table(
		.note(note[6:0] - 11),
		.max(max)
	);
	genvar _gv_i_1;
	generate
		for (_gv_i_1 = 0; _gv_i_1 < N; _gv_i_1 = _gv_i_1 + 1) begin : genblk1
			localparam i = _gv_i_1;
			saw_counter saw_count(
				.key_pressed(key_pressed[i]),
				.current_ended_note(ended_note[i]),
				.MHz10(MHz10),
				.nrst(nrst),
				.en(en),
				.clear(clear),
				.new_note_velocity(new_note_velocity[i * 7+:7]),
				.current_velocity(current_velocity[i * 7+:7]),
				.velocity(velocity[6:0]),
				.start_note(start_out[i]),
				.end_note(end_note),
				.sustain_in(sustain_in),
				.new_max(max),
				.current_max(current_max[i * 20+:20]),
				.current_count(current_count[i * 20+:20]),
				.available(avail[i])
			);
		end
	endgenerate
	poly_ctrl #(.N(N)) poly_control(
		.MHz10(MHz10),
		.nrst(nrst),
		.en(en),
		.ready(ready),
		.samp_enable(samp_enable),
		.start(start),
		.acc(accumulate),
		.store_samp(store_samp),
		.clr(clear_accumulator),
		.osc_num(osc_num)
	);
	osc_sel #(.N(N)) oscillator_selector(
		.key_pressed(key_pressed),
		.key_pressed_sel(key_pressed_sel),
		.ended_note_sel(ended_note_sel),
		.ended_note(ended_note),
		.new_note_velocity(new_note_velocity),
		.single_new_note_velocity(single_new_note_velocity),
		.current_velocity(current_velocity),
		.velocity_sel(velocity_sel),
		.osc_num(osc_num),
		.count(current_count),
		.max(current_max),
		.count_sel(selected_count),
		.max_sel(selected_max)
	);
	exp_table table_table(
		.MHz10(MHz10),
		.nrst(nrst),
		.ready(ready),
		.en(en),
		.in(velocity_sel[6:2]),
		.exp_out(table_output)
	);
	envelope_clk_div envelope_clk_div(
		.MHz10(MHz10),
		.nrst(nrst),
		.en(en),
		.samp_enable(samp_enable),
		.envelope_pulse(envelope_pulse)
	);
	envelope_gen envelope(
		.key_pressed(key_pressed_sel),
		.sustain(sustain_in),
		.pedal_depth(current_pedal_depth),
		.ended_note(ended_note_sel),
		.envelope_pulse(envelope_pulse),
		.poly_start(start),
		.velocity_sel(velocity_sel),
		.single_new_note_velocity(single_new_note_velocity)
	);
	norm_pipe normalizer(
		.MHz10(MHz10),
		.nrst(nrst),
		.en(en),
		.start(start),
		.count(selected_count),
		.max(selected_max),
		.count_nm(normalized_out),
		.ready(ready)
	);
	wave_shape_table wave_table(
		.sample(normalized_out),
		.mode(wave_mode),
		.digital_out(wave_table_output)
	);
	volume_multiplier volume_multiplier(
		.velocity(table_output),
		.wave_table_output(wave_table_output),
		.volume_output(volume_output)
	);
	accumulator accumulator(
		.MHz10(MHz10),
		.nrst(nrst),
		.en(en),
		.sample_mono(volume_output[15:7]),
		.accumulate(accumulate),
		.clear(clear_accumulator),
		.current_sum(accumulator_sum)
	);
	sample_register sample_register(
		.MHz10(MHz10),
		.nrst(nrst),
		.en(en),
		.samp_acc(accumulator_sum),
		.store_samp(store_samp),
		.samp_out(latch_output),
		.clear(clear)
	);
endmodule
