module t09_obstacleMode (
	sync_reset,
	obstacle_pb,
	clk,
	nrst,
	obstacleFlag
);
	reg _sv2v_0;
	input wire sync_reset;
	input wire obstacle_pb;
	input wire clk;
	input wire nrst;
	output reg obstacleFlag;
	wire osbtacle_pb_i;
	wire obstacle_pb_o;
	reg nextObstacleFlag;
	t09_obstacle_sync_edge sOBSMODE(
		.clk(clk),
		.nRst_i(nrst),
		.button_i(obstacle_pb),
		.pb_o(obstacle_pb_o)
	);
	always @(posedge clk or negedge nrst)
		if (~nrst)
			obstacleFlag <= 0;
		else
			obstacleFlag <= nextObstacleFlag;
	always @(*) begin
		if (_sv2v_0)
			;
		nextObstacleFlag = obstacleFlag;
		if (obstacle_pb_o == 1) begin
			if (obstacleFlag == 1)
				nextObstacleFlag = 0;
			else
				nextObstacleFlag = 1;
		end
	end
	initial _sv2v_0 = 0;
endmodule
