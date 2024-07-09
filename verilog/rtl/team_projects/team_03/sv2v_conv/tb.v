module tb;
	reg clock = 0;
	reg reset = 0;
	core cpu(
		.clock(clock),
		.reset(reset)
	);
	initial begin
		$dumpfile("sim.vcd");
		$dumpvars(0, tb);
		#(2) reset = 1;
		#(2) reset = 0;
		#(1)
			$finish;
	end
endmodule
