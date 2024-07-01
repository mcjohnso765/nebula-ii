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
	reg [7:0] current_note;
	reg [7:0] current_velocity;
	reg [7:0] current_status;
	always @(posedge MHz10 or negedge nrst)
		if (!nrst) begin
			output_note <= 0;
			output_velocity <= 0;
			output_status <= 0;
		end
		else if (en) begin
			output_note <= next_output_note;
			output_velocity <= next_output_velocity;
			output_status <= next_output_status;
		end
	reg Q1;
	reg Q2;
	always @(posedge MHz10 or negedge nrst) begin : start_pulse_signal
		if (!nrst)
			Q1 <= 0;
		else if (en) begin
			if (current_state == 2'd0)
				Q1 <= 1;
			else
				Q1 <= 0;
		end
	end
	always @(posedge MHz10 or negedge nrst)
		if (!nrst)
			Q2 <= 0;
		else if (en)
			Q2 <= Q1;
	assign start_pulse = (Q1 && !Q2) && (output_status[7:4] == 4'h9);
	always @(*) begin
		if (_sv2v_0)
			;
		next_output_note = output_note;
		next_output_velocity = output_velocity;
		next_output_status = output_status;
		if (current_state == 2'd3) begin
			next_output_note = current_note;
			next_output_velocity = current_velocity;
			next_output_status = current_status;
		end
	end
	always @(posedge MHz10 or negedge nrst)
		if (!nrst)
			current_state <= 0;
		else if (en)
			current_state <= next_state;
	always @(*) begin
		if (_sv2v_0)
			;
		next_state = current_state;
		if (clear)
			next_state = 2'd0;
		if (done)
			next_state = current_state + 1;
		if (current_state == 2'd3)
			next_state = current_state + 1;
	end
	reg [7:0] next_note;
	always @(posedge MHz10 or negedge nrst)
		if (!nrst)
			current_note <= 0;
		else if (en)
			current_note <= next_note;
	always @(*) begin
		if (_sv2v_0)
			;
		if (done && (current_state == 2'd1))
			next_note = uart_output;
		else
			next_note = current_note;
	end
	reg [7:0] next_velocity;
	always @(posedge MHz10 or negedge nrst)
		if (!nrst)
			current_velocity <= 0;
		else if (en)
			current_velocity <= next_velocity;
	always @(*) begin
		if (_sv2v_0)
			;
		if (done && (current_state == 2'd2))
			next_velocity = uart_output;
		else
			next_velocity = current_velocity;
	end
	reg [7:0] next_status;
	always @(posedge MHz10 or negedge nrst)
		if (!nrst)
			current_status <= 0;
		else if (en)
			current_status <= next_status;
	always @(*) begin
		if (_sv2v_0)
			;
		if (done && (current_state == 2'd0))
			next_status = uart_output;
		else
			next_status = current_status;
	end
	initial _sv2v_0 = 0;
endmodule
