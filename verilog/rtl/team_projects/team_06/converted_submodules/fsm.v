module t06_fsm (
	clk,
	nrst,
	goodCollision,
	badCollision,
	state,
	enable
);
	reg _sv2v_0;
	input wire clk;
	input wire nrst;
	input wire goodCollision;
	input wire badCollision;
	output reg [5:0] state;
	input wire enable;
	reg [5:0] next_state;
	wire out_clk;
	wire out_enable;
	reg [18:0] length;
	reg [18:0] next_length;
	reg [18:0] REST = 30;
	t06_clk_div c1(
		.max_i(length),
		.clk(clk),
		.nrst(nrst),
		.atmax_o(out_clk)
	);
	t06_clk_enable a1(
		.max_i(16'd50000),
		.clk(clk),
		.nrst(nrst),
		.enable(enable),
		.out_enable(out_enable)
	);
	always @(*) begin
		if (_sv2v_0)
			;
		if (goodCollision == 1) begin
			next_state = 6'd34;
			next_length = 19'd31;
		end
		else if (badCollision == 1) begin
			next_state = 6'd35;
			next_length = 19'd31;
		end
		else begin
			case (state)
				6'd1: next_state = 6'd2;
				6'd2: next_state = 6'd3;
				6'd3: next_state = 6'd4;
				6'd4: next_state = 6'd5;
				6'd5: next_state = 6'd6;
				6'd6: next_state = 6'd7;
				6'd7: next_state = 6'd8;
				6'd8: next_state = 6'd9;
				6'd9: next_state = 6'd10;
				6'd10: next_state = 6'd11;
				6'd11: next_state = 6'd12;
				6'd12: next_state = 6'd13;
				6'd13: next_state = 6'd14;
				6'd14: next_state = 6'd15;
				6'd15: next_state = 6'd16;
				6'd16: next_state = 6'd17;
				6'd17: next_state = 6'd18;
				6'd18: next_state = 6'd19;
				6'd19: next_state = 6'd20;
				6'd20: next_state = 6'd21;
				6'd21: next_state = 6'd22;
				6'd22: next_state = 6'd23;
				6'd23: next_state = 6'd24;
				6'd24: next_state = 6'd25;
				6'd25: next_state = 6'd26;
				6'd26: next_state = 6'd27;
				6'd27: next_state = 6'd28;
				6'd28: next_state = 6'd29;
				6'd29: next_state = 6'd30;
				6'd30: next_state = 6'd31;
				6'd31: next_state = 6'd32;
				6'd32: next_state = 6'd1;
				default: next_state = 6'd2;
			endcase
			case (state)
				6'd1: next_length = 19'd25;
				6'd2: next_length = REST;
				6'd3: next_length = 19'd25;
				6'd4: next_length = REST;
				6'd5: next_length = 19'd25;
				6'd6: next_length = REST;
				6'd7: next_length = 19'd25;
				6'd8: next_length = REST;
				6'd9: next_length = 19'd25;
				6'd10: next_length = REST;
				6'd11: next_length = 19'd25;
				6'd12: next_length = REST;
				6'd13: next_length = 19'd25;
				6'd14: next_length = REST;
				6'd15: next_length = 19'd25;
				6'd16: next_length = REST;
				6'd17: next_length = 19'd25;
				6'd18: next_length = REST;
				6'd19: next_length = 19'd25;
				6'd20: next_length = REST;
				6'd21: next_length = 19'd25;
				6'd22: next_length = REST;
				6'd23: next_length = 19'd25;
				6'd24: next_length = REST;
				6'd25: next_length = 19'd25;
				6'd26: next_length = REST;
				6'd27: next_length = 19'd25;
				6'd28: next_length = REST;
				6'd29: next_length = 19'd25;
				6'd30: next_length = REST;
				6'd31: next_length = 19'd25;
				6'd32: next_length = REST;
				default: next_length = REST;
			endcase
		end
	end
	always @(posedge clk or negedge nrst)
		if (nrst == 1'b0) begin
			state <= 6'd0;
			length <= 19'd31;
		end
		else if (out_clk == 1'b1) begin
			if (out_enable == 1'b1) begin
				state <= next_state;
				length <= next_length;
			end
		end
		else begin
			state <= state;
			length <= length;
		end
	initial _sv2v_0 = 0;
endmodule
