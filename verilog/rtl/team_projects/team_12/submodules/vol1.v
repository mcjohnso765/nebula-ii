module vol1 (
	MHz10,
	nrst,
	en,
	start_vol,
	velocity,
	wave_table_output,
	volume_output,
	current_wave_table_output,
	current_velocity,
	vol_done
);
	reg _sv2v_0;
	input wire MHz10;
	input wire nrst;
	input wire en;
	input wire start_vol;
	input wire [6:0] velocity;
	input wire [8:0] wave_table_output;
	output reg [15:0] volume_output;
	output reg [8:0] current_wave_table_output;
	output reg [6:0] current_velocity;
	output reg vol_done;
	reg [6:0] next_current_velocity;
	reg [15:0] next_volume_output;
	reg [2:0] count;
	reg [2:0] next_count;
	reg enable;
	reg next_vol_done;
	reg next_enable;
	always @(posedge MHz10 or negedge nrst)
		if (!nrst) begin
			volume_output <= 0;
			vol_done <= 0;
			current_velocity <= 0;
			current_wave_table_output <= 0;
			count <= 0;
			enable <= 0;
		end
		else if (en) begin
			if (start_vol) begin
				current_velocity <= velocity;
				current_wave_table_output <= wave_table_output;
				enable <= 1;
				count <= 0;
				volume_output <= 0;
			end
			else begin
				enable <= next_enable;
				current_velocity <= next_current_velocity;
				count <= next_count;
				volume_output <= next_volume_output;
			end
			vol_done <= next_vol_done;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		next_volume_output = volume_output;
		next_vol_done = 0;
		next_current_velocity = current_velocity;
		next_enable = enable;
		next_count = count;
		if (enable) begin
			if (current_velocity[6])
				next_volume_output = next_volume_output + {7'b0000000, current_wave_table_output};
			next_current_velocity = {current_velocity[5:0], 1'b0};
			next_volume_output = {next_volume_output[14:0], 1'b0};
			next_count = count + 1;
			if (count >= 2) begin
				next_vol_done = 1;
				next_enable = 0;
			end
		end
	end
	initial _sv2v_0 = 0;
endmodule
