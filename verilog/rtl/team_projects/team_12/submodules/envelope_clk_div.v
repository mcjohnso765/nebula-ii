module envelope_clk_div (
	MHz10,
	nrst,
	en,
	samp_enable,
	envelope_pulse
);
	reg _sv2v_0;
	input wire MHz10;
	input wire nrst;
	input wire en;
	input wire samp_enable;
	output reg envelope_pulse;
	reg [11:0] count;
	reg [11:0] next_count;
	reg next_envelope_pulse;
	always @(posedge MHz10 or negedge nrst)
		if (!nrst) begin
			count <= 0;
			envelope_pulse <= 0;
		end
		else begin
			count <= next_count;
			envelope_pulse <= next_envelope_pulse;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		next_count = count;
		next_envelope_pulse = envelope_pulse;
		if (en) begin
			if (samp_enable)
				next_count = count + 1;
			if (count == 2081)
				next_envelope_pulse = 1;
			else if (count >= 2082) begin
				next_count = 0;
				next_envelope_pulse = 0;
			end
		end
	end
	initial _sv2v_0 = 0;
endmodule
