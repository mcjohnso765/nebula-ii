module t02_mux(
	input logic [31:0] in1, in2, 
	input logic en,
	output logic [31:0] out);

	always_comb begin
		if(en) 
			out = in1;
		else
			out = in2;
	end
endmodule