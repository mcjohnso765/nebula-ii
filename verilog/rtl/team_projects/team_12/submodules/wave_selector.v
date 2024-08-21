`default_nettype none
module wave_selector (
	MHz10,
	nrst,
	en,
	wave_mode_pb,
	wave_mode,
	lockstate
);
	reg _sv2v_0;
	input wire MHz10;
	input wire nrst;
	input wire en;
	input wire wave_mode_pb;
	output reg [2:0] wave_mode;
	output reg [2:0] lockstate;
	localparam SAWTOOTH = 0;
	localparam SQUARE = 1;
	localparam REVERSE_SAWTOOTH = 2;
	localparam TRIANGLE = 3;
	localparam SINE = 4;
	localparam TRUMPET = 5;
	localparam VIOLIN = 6;
	reg sync1;
	reg sync2;
	reg next_wave_mode_pb;
	always @(posedge MHz10 or negedge nrst)
		if (!nrst) begin
			sync1 <= 0;
			sync2 <= 0;
		end
		else begin
			sync1 <= next_wave_mode_pb;
			sync2 <= sync1;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		next_wave_mode_pb = sync1;
		if (en)
			next_wave_mode_pb = wave_mode_pb;
	end
	reg [1:0] edge1;
	always @(posedge MHz10 or negedge nrst)
		if (!nrst)
			edge1 <= 0;
		else begin
			edge1[1] <= edge1[0];
			edge1[0] <= sync2;
		end
	wire intermediate;
	assign intermediate = edge1[0] & ~edge1[1];
	reg [2:0] n_lockstate;
	always @(posedge MHz10 or negedge nrst) begin : synchronizer
		if (!nrst)
			lockstate <= SAWTOOTH;
		else
			lockstate <= n_lockstate;
	end
	always @(*) begin : state_machine
		if (_sv2v_0)
			;
		n_lockstate = lockstate;
		wave_mode = 0;
		if (en)
			case (lockstate)
				SAWTOOTH: begin
					wave_mode = 3'd0;
					if ((sync2 == 1) && intermediate)
						n_lockstate = SQUARE;
					else
						n_lockstate = SAWTOOTH;
				end
				SQUARE: begin
					wave_mode = 3'd1;
					if ((sync2 == 1) && intermediate)
						n_lockstate = REVERSE_SAWTOOTH;
					else
						n_lockstate = SQUARE;
				end
				REVERSE_SAWTOOTH: begin
					wave_mode = 3'd2;
					if ((sync2 == 1) && intermediate)
						n_lockstate = TRIANGLE;
					else
						n_lockstate = REVERSE_SAWTOOTH;
				end
				TRIANGLE: begin
					wave_mode = 3'd3;
					if ((sync2 == 1) && intermediate)
						n_lockstate = SINE;
					else
						n_lockstate = TRIANGLE;
				end
				SINE: begin
					wave_mode = 3'd4;
					if ((sync2 == 1) && intermediate)
						n_lockstate = TRUMPET;
					else
						n_lockstate = SINE;
				end
				TRUMPET: begin
					wave_mode = 3'd5;
					if ((sync2 == 1) && intermediate)
						n_lockstate = VIOLIN;
					else
						n_lockstate = TRUMPET;
				end
				VIOLIN: begin
					wave_mode = 3'd6;
					if ((sync2 == 1) && intermediate)
						n_lockstate = SAWTOOTH;
					else
						n_lockstate = VIOLIN;
				end
				default: begin
					wave_mode = 3'd0;
					n_lockstate = lockstate;
				end
			endcase
	end
	initial _sv2v_0 = 0;
endmodule
