`default_nettype none
module vol_pipe (
	MHz10,
	nrst,
	en,
	start_vol,
	velocity,
	wave_table_output,
	volume_output,
	vol_done
);
	input wire MHz10;
	input wire nrst;
	input wire en;
	input wire start_vol;
	input wire [6:0] velocity;
	input wire [8:0] wave_table_output;
	output wire [15:0] volume_output;
	output wire vol_done;
	wire [15:0] volume2;
	wire [8:0] wave2;
	wire [6:0] velocity2;
	wire start2;
	vol1 vol1(
		.MHz10(MHz10),
		.nrst(nrst),
		.en(en),
		.start_vol(start_vol),
		.velocity(velocity),
		.current_velocity(velocity2),
		.wave_table_output(wave_table_output),
		.current_wave_table_output(wave2),
		.volume_output(volume2),
		.vol_done(start2)
	);
	vol2 vol2(
		.MHz10(MHz10),
		.nrst(nrst),
		.en(en),
		.start_vol(start2),
		.velocity(velocity2),
		.wave_table_output(wave2),
		.volume2(volume2),
		.volume_output(volume_output),
		.vol_done(vol_done)
	);
endmodule
