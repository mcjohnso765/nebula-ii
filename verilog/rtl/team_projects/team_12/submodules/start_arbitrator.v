`default_nettype none
module start_arbitrator (
	MHz10,
	nrst,
	en,
	start_in,
	avail,
	start_out
);
	reg _sv2v_0;
	parameter N = 13;
	parameter STORE = 8;
	input wire MHz10;
	input wire nrst;
	input wire en;
	input wire start_in;
	input wire [N - 1:0] avail;
	output reg [N - 1:0] start_out;
	reg [N - 1:0] start_out_intmd;
	reg [(STORE * $clog2(N)) - 1:0] recent;
	reg [(STORE * $clog2(N)) - 1:0] next_recent;
	reg [2:0] pointer;
	reg [2:0] next_pointer;
	reg not_recent;
	always @(posedge MHz10 or negedge nrst)
		if (!nrst) begin
			recent <= 0;
			pointer <= 0;
		end
		else if (en) begin
			recent <= next_recent;
			pointer <= next_pointer;
		end
	always @(*) begin : fresher_code
		if (_sv2v_0)
			;
		next_recent = recent;
		next_pointer = pointer;
		start_out_intmd = 0;
		not_recent = 1;
		if (|avail) begin : sv2v_autoblock_1
			reg signed [31:0] i;
			for (i = N - 1; i >= 0; i = i - 1)
				if (avail[i])
					start_out_intmd = 1 << i;
		end
		else begin : sv2v_autoblock_2
			reg signed [31:0] i;
			for (i = N - 1; i >= 0; i = i - 1)
				begin
					not_recent = 1;
					begin : sv2v_autoblock_3
						reg signed [31:0] j;
						for (j = 0; j < STORE; j = j + 1)
							if (recent[j * $clog2(N)+:$clog2(N)] == i[$clog2(N) - 1:0])
								not_recent = 0;
					end
					if (not_recent)
						start_out_intmd = 1 << i;
				end
		end
		start_out = (start_in ? start_out_intmd : 0);
		if (|start_out) begin
			next_recent[pointer * $clog2(N)+:$clog2(N)] = start_out[$clog2(N) - 1:0];
			next_pointer = pointer + 1;
		end
	end
	initial _sv2v_0 = 0;
endmodule
