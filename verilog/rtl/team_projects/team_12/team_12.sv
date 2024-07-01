// $Id: $
// File name:   team_12.sv
// Created:     MM/DD/YYYY
// Author:      Hassan Al-alawi
// Description: poly_synth

`default_nettype none

module team_12 (
    // HW
    input logic clk, nrst,
    
    input logic en, //This signal is an enable signal for your chip. Your design should disable if this is low.

    // Logic Analyzer - Grant access to all 128 LA
    input wire [127:0] la_data_in,
    output wire [127:0] la_data_out,
    input wire [127:0] la_oenb,

    // 34 out of 38 GPIOs (Note: if you need up to 38 GPIO, discuss with a TA)
    input  wire [33:0] gpio_in, // Breakout Board Pins
    output wire [33:0] gpio_out, // Breakout Board Pins
    output wire [33:0] gpio_oeb // Active Low Output Enable
    
    /*
    * Add other I/O ports that you wish to interface with the
    * Wishbone bus to the management core. For examples you can 
    * add registers that can be written to with the Wishbone bus
    */
);

    // All outputs must have a value even if not used
    assign la_data_out = 128'b0;
    assign gpio_oeb = 34'h000000007;// First 3 Pins input, rest are outputs
    
    logic MHz10,serIn,wave_mode_pb, clear;
	logic [11:0] latch_output;
    assign MHz10 = clk;


    assign gpio_out = {19'b0,latch_output,3'b0}; //DAC output routed to pins 7-18
    assign serIn = gpio_in[0]; //MIDI serial in mapped to GPIO 0
    assign clear = gpio_in[1]; //Clear mapped to GPIO 5
    assign wave_mode_pb = gpio_in[2]; //Wave mode button mapped to GPIO 6



    localparam N = 13;

	logic baudClk, done;
	logic [7:0] uart_out;
	uart_in uart_in (.MHz10(MHz10), .nrst(nrst), .en(en), .serIn(serIn), .baudClk(baudClk), .dataOut(uart_out), .beginRx(), .done(done));

	logic start_note_b, end_note_b, sustain_in_p;
	logic start_note, end_note, sustain_in;
	logic [7:0] status, note, velocity;
	logic [1:0] current_state;
	midi_decoder midi_decoder (.MHz10(MHz10), .nrst(nrst), .en(en), .uart_output(uart_out), .clear(0), .done(done), .output_note(note), .output_velocity(velocity), .output_status(status), .current_state(current_state), .next_state(), .start_pulse(start_note));
	assign start_note_b = (status[7:4] == 4'h9);
	assign end_note_b = (status[7:4] == 4'h8);
	always_ff @(posedge MHz10, negedge nrst) begin
		if (!nrst)
			sustain_in_p <= 0;
		else if (en) begin
			if ((status[7:4] == 4'hB) && (note == 8'h40)) begin
				if (velocity >= 8'h40)
					sustain_in_p <= 1;
				else
					sustain_in_p <= 0;
			end
		end
	end
	sync syncend (.MHz10(MHz10), .nrst(nrst), .en(en), .in(end_note_b), .out(end_note));
	sync syncsus (.MHz10(MHz10), .nrst(nrst), .en(en), .in(sustain_in_p), .out(sustain_in));

	wave_selector wave_selector (.MHz10(MHz10), .nrst(nrst), .en(en), .wave_mode_pb(wave_mode_pb), .wave_mode(wave_mode), .lockstate());

	logic samp_enable;
	logic [N-1:0] avail; // the parallel availibility of each of the oscilators
	logic [N-1:0] start_out; // the parallel start signal (output of the start arbitrator)
	logic [19:0] max; // the max count from the note division table
	logic [N-1:0] [19:0] current_max, current_count;
	logic [N-1:0] [6:0] current_velocity, new_note_velocity;
	logic [6:0] velocity_sel;
	logic ready; // when the normalizer is finished
	logic start; // tells the normalizer to begin dividing
	logic start_vol; // tells the volume multiplier to operate
	logic vol_done; // when the volume operation is finished
	logic [15:0] volume_output; // the result of the volume calculation
	logic accumulate; // tells the accumulator to accumulate
	logic isprevzero; // tells the accumulator to ignore accumulate signal
	logic store_samp; // tells the output latch to store the value of the accumulator
	logic clear_accumulator; // tells the accumulator to clear
	logic [5:0] osc_num; // tells the multiplexer which oscillator to pass through
	logic [19:0] selected_count; // the current count of the oscillator selected by the oscillator selector
	logic [19:0] selected_max; // the current max of the oscillator selected by the oscillator selector
	logic [7:0] normalized_out; // the normalized output of the normalizer
	logic [8:0] wave_table_output; // the digital output of the wave shape table
	logic [11:0] accumulator_sum; // the current sum stored in the accumulator
	logic [2:0] wave_mode;
	logic [6:0] table_output;
	logic envelope_pulse;
	logic [6:0] single_new_note_velocity;

	sample_clock_div scd (.MHz10(MHz10), .nrst(nrst), .en(en), .samp_enable(samp_enable));
	start_arbitrator #(.N(N)) arbitrator (.MHz10(MHz10), .nrst(nrst), .en(en), .start_in(start_note), .avail(avail), .start_out(start_out));
	note_div_table note_table (.note(note[6:0]-11), .max(max));

	generate
		for (genvar i = 0; i < N; i++) begin
			saw_counter saw_count (.MHz10(MHz10), .nrst(nrst), .en(en), .clear(clear), .new_note_velocity(new_note_velocity[i]), .current_velocity(current_velocity[i]), .velocity(velocity[6:0]), .start_note(start_out[i]), .end_note(end_note), .sustain_in(sustain_in), .new_max(max), .current_max(current_max[i]), .current_count(current_count[i]), .available(avail[i]));
		end
	endgenerate

	poly_ctrl #(.N(N)) poly_control (.MHz10(MHz10), .nrst(nrst), .en(en), .ready(ready), .samp_enable(samp_enable), .start(start), .acc(accumulate), .store_samp(store_samp), .clr(clear_accumulator), .osc_num(osc_num), .start_vol(start_vol), .vol_done(vol_done));
	osc_sel #(.N(N)) oscillator_selector (.new_note_velocity(new_note_velocity), .single_new_note_velocity(single_new_note_velocity), .current_velocity(current_velocity), .velocity_sel(velocity_sel), .osc_num(osc_num), .count(current_count), .max(current_max), .count_sel(selected_count), .max_sel(selected_max), .isprevzero(isprevzero));
	exp_table table_table (.in(velocity_sel[6:2]), .exp_out(table_output));
	envelope_clk_div envelope_clk_div (.MHz10(MHz10), .nrst(nrst), .en(en), .samp_enable(samp_enable), .envelope_pulse(envelope_pulse));
	envelope_gen envelope (.envelope_pulse(envelope_pulse), .poly_start(start), .velocity_sel(velocity_sel), .single_new_note_velocity(single_new_note_velocity));
	norm normalizer (.MHz10(MHz10), .nrst(nrst), .en(en), .start(start), .count(selected_count), .max(selected_max), .count_nm(normalized_out), .ready(ready));
	wave_shape_table wave_table (.sample(normalized_out), .mode(wave_mode), .digital_out(wave_table_output));
	volume_multiplier volume_multiplier (.MHz10(MHz10), .nrst(nrst), .en(en), .start_vol(start_vol), .velocity(table_output), .wave_table_output(wave_table_output), .volume_output(volume_output), .vol_done(vol_done));
	accumulator accumulator (.MHz10(MHz10), .nrst(nrst), .en(en), .sample_mono(volume_output[15:7]), .accumulate(accumulate), .clear(clear_accumulator), .isprevzero(isprevzero), .current_sum(accumulator_sum));
	sample_register sample_register (.MHz10(MHz10), .nrst(nrst), .en(en), .samp_acc(accumulator_sum), .store_samp(store_samp), .samp_out(latch_output), .clear(clear));


endmodule