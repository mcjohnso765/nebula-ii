module t06_BorderGen (
	clk,
	nrst,
	enable_in,
	score,
	XMAX,
	XMIN,
	YMAX,
	YMIN
);
	reg _sv2v_0;
	input wire clk;
	input wire nrst;
	input wire enable_in;
	input wire [7:0] score;
	output reg [3:0] XMAX;
	output reg [3:0] XMIN;
	output reg [3:0] YMAX;
	output reg [3:0] YMIN;
	reg [3:0] xmax_n;
	reg [3:0] xmin_n;
	reg [3:0] ymax_n;
	reg [3:0] ymin_n;
	always @(posedge clk or negedge nrst)
		if (~nrst) begin
			XMAX = 4'd15;
			XMIN = 4'd0;
			YMAX = 4'd11;
			YMIN = 4'd0;
		end
		else if (enable_in) begin
			XMAX = xmax_n;
			XMIN = xmin_n;
			YMAX = ymax_n;
			YMIN = ymin_n;
		end
		else begin
			XMAX = 4'd15;
			XMIN = 4'd0;
			YMAX = 4'd11;
			YMIN = 4'd0;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		if (score > 100) begin
			xmax_n = 4'd15;
			xmin_n = 4'd0;
			ymax_n = 4'd11;
			ymin_n = 4'd0;
		end
		else if (score > 80) begin
			xmax_n = 4'd14;
			xmin_n = 4'd0;
			ymax_n = 4'd10;
			ymin_n = 4'd0;
		end
		else if (score > 60) begin
			xmax_n = 4'd13;
			xmin_n = 4'd0;
			ymax_n = 4'd9;
			ymin_n = 4'd0;
		end
		else if (score > 40) begin
			xmax_n = 4'd12;
			xmin_n = 4'd0;
			ymax_n = 4'd8;
			ymin_n = 4'd0;
		end
		else if (score > 20) begin
			xmax_n = 4'd10;
			xmin_n = 4'd0;
			ymax_n = 4'd7;
			ymin_n = 4'd0;
		end
		else if (score > 10) begin
			xmax_n = 4'd9;
			xmin_n = 4'd0;
			ymax_n = 4'd7;
			ymin_n = 4'd0;
		end
		else begin
			xmax_n = 4'd8;
			xmin_n = 4'd0;
			ymax_n = 4'd6;
			ymin_n = 4'd0;
		end
	end
	initial _sv2v_0 = 0;
endmodule
