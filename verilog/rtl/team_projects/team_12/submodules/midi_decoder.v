module midi_decoder (
	MHz10,
	nrst,
	en,
	clear,
	done,
	uart_output,
	output_note,
	output_velocity,
	output_status,
	current_state,
	next_state,
	start_pulse
);
	reg _sv2v_0;
	input wire MHz10;
	input wire nrst;
	input wire en;
	input wire clear;
	input wire done;
	input wire [7:0] uart_output;
	output reg [7:0] output_note;
	output reg [7:0] output_velocity;
	output reg [7:0] output_status;
	output reg [1:0] current_state;
	output reg [1:0] next_state;
	output wire start_pulse;
	reg [7:0] next_output_note;
	reg [7:0] next_output_velocity;
	reg [7:0] next_output_status;
	reg [7:0] next_note;
	reg [7:0] next_velocity;
	reg [7:0] next_status;
	reg [7:0] current_note;
	reg [7:0] current_velocity;
	reg [7:0] current_status;
	always @(posedge MHz10 or negedge nrst)
		if (!nrst) begin
			output_note <= 0;
			output_velocity <= 0;
			output_status <= 0;
			current_state <= 0;
			current_note <= 0;
			current_velocity <= 0;
			current_status <= 0;
		end
		else begin
			output_note <= next_output_note;
			output_velocity <= next_output_velocity;
			output_status <= next_output_status;
			current_state <= next_state;
			current_note <= next_note;
			current_velocity <= next_velocity;
			current_status <= next_status;
		end
	reg Q1;
	reg Q2;
	always @(posedge MHz10 or negedge nrst) begin : start_pulse_signal
		if (!nrst) begin
			Q1 <= 0;
			Q2 <= 0;
		end
		else begin
			if (current_state == 2'd0)
				Q1 <= 1;
			else
				Q1 <= 0;
			Q2 <= Q1;
		end
	end
	assign start_pulse = (Q1 && !Q2) && (output_status[7:4] == 4'h9);
	always @(*) begin
		if (_sv2v_0)
			;
		next_output_note = output_note;
		next_output_velocity = output_velocity;
		next_output_status = output_status;
		next_state = current_state;
		next_note = current_note;
		next_velocity = current_velocity;
		next_status = current_status;
		if (en) begin
			if (current_state == 2'd3) begin
				next_output_note = current_note;
				next_output_velocity = current_velocity;
				next_output_status = current_status;
			end
			if (clear)
				next_state = 2'd0;
			if (done) begin
				if ((current_state != 2'd0) && (uart_output[7] == 1))
					next_state = 2'd1;
				else
					next_state = current_state + 1;
			end
			if (current_state == 2'd3)
				next_state = current_state + 1;
			if (done && (current_state == 2'd1))
				next_note = uart_output;
			if (done && (current_state == 2'd2))
				next_velocity = uart_output;
			if (done && (current_state == 2'd0))
				next_status = uart_output;
		end
	end
	initial _sv2v_0 = 0;
endmodule
