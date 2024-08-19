module t03_clock_controller (
	halt,
	cpu_clock,
	clock,
	reset
);
	input wire halt;
	output wire cpu_clock;
	input wire clock;
	input wire reset;
	reg enable_clock;
	always @(negedge clock or posedge reset)
		if (reset)
			enable_clock = 0;
		else
			enable_clock = ~halt;
	assign cpu_clock = clock && enable_clock;
endmodule
