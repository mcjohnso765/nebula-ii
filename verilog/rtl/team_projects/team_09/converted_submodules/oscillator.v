module t09_oscillator (
	clk,
	nRst,
	goodColl,
	badColl,
	at_max
);
	reg _sv2v_0;
	parameter N = 8;
	input wire clk;
	input wire nRst;
	input wire goodColl;
	input wire badColl;
	output reg at_max;
	reg [23:0] timer;
	reg [23:0] timer_nxt;
	reg [7:0] freq;
	reg [7:0] freq_nxt;
	reg [N - 1:0] count;
	reg [N - 1:0] count_nxt;
	reg [23:0] stayCount;
	reg [23:0] stayCount_nxt;
	reg at_max_nxt;
	reg keepCounting;
	reg keepCounting_nxt;
	always @(posedge clk or negedge nRst)
		if (~nRst) begin
			count <= 0;
			at_max <= 0;
			stayCount <= 0;
			keepCounting <= 0;
			freq <= 0;
			timer <= 0;
		end
		else begin
			count <= count_nxt;
			at_max <= at_max_nxt;
			stayCount <= stayCount_nxt;
			keepCounting <= keepCounting_nxt;
			freq <= freq_nxt;
			timer <= timer_nxt;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		at_max_nxt = at_max;
		count_nxt = count;
		keepCounting_nxt = keepCounting;
		stayCount_nxt = stayCount;
		timer_nxt = timer;
		freq_nxt = freq;
		if (goodColl && ~keepCounting) begin
			freq_nxt = 8'd89;
			timer_nxt = 3000000;
		end
		if (badColl && ~keepCounting) begin
			freq_nxt = 8'd156;
			timer_nxt = 10000000;
		end
		if (at_max == 1'b1)
			at_max_nxt = 1'b0;
		if (goodColl || badColl)
			keepCounting_nxt = 1'b1;
		if (keepCounting_nxt) begin
			if (stayCount < timer_nxt) begin
				if (count < freq_nxt)
					count_nxt = count + 1;
				else if (count >= freq_nxt) begin
					at_max_nxt = 1'b1;
					count_nxt = 0;
				end
				stayCount_nxt = stayCount + 1;
			end
			else begin
				keepCounting_nxt = 1'b0;
				stayCount_nxt = 0;
			end
		end
		else if (~keepCounting_nxt) begin
			count_nxt = 0;
			at_max_nxt = 0;
		end
	end
	initial _sv2v_0 = 0;
endmodule
