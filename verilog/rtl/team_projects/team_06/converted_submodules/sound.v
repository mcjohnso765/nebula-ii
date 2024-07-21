module t06_sound (
	note,
	max_in,
	ratio_lookup
);
	reg _sv2v_0;
	input wire [5:0] note;
	output reg [18:0] max_in;
	output reg [18:0] ratio_lookup;
	reg [18:0] max_inOFF = 19'd0;
	reg [18:0] goodSound = 19'd460000;
	reg [18:0] badSound = 19'd520000;
	reg [18:0] max_in0 = 19'd305000;
	reg [18:0] max_in1 = 19'd0;
	reg [18:0] max_in2 = 19'd482500;
	reg [18:0] max_in3 = 19'd0;
	reg [18:0] max_in4 = 19'd410000;
	reg [18:0] max_in5 = 19'd0;
	reg [18:0] max_in6 = 19'd482500;
	reg [18:0] max_in7 = 19'd0;
	reg [18:0] max_in8 = 19'd305000;
	reg [18:0] max_in9 = 19'd0;
	reg [18:0] max_in10 = 19'd482500;
	reg [18:0] max_in11 = 19'd0;
	reg [18:0] max_in12 = 19'd365000;
	reg [18:0] max_in13 = 19'd0;
	reg [18:0] max_in14 = 19'd482500;
	reg [18:0] max_in15 = 19'd0;
	reg [18:0] max_in16 = 19'd410000;
	reg [18:0] max_in17 = 19'd0;
	reg [18:0] max_in18 = 19'd482500;
	reg [18:0] max_in19 = 19'd0;
	reg [18:0] max_in20 = 19'd410000;
	reg [18:0] max_in21 = 19'd0;
	reg [18:0] max_in22 = 19'd482500;
	reg [18:0] max_in23 = 19'd0;
	reg [18:0] max_in24 = 19'd410000;
	reg [18:0] max_in25 = 19'd0;
	reg [18:0] max_in26 = 19'd482500;
	reg [18:0] max_in27 = 19'd0;
	reg [18:0] max_in28 = 19'd460000;
	reg [18:0] max_in29 = 19'd0;
	reg [18:0] max_in30 = 19'd482500;
	reg [18:0] max_in31 = 19'd0;
	reg [18:0] restArray = 19'd0;
	reg [18:0] soundArray = 19'd170402;
	always @(*) begin
		if (_sv2v_0)
			;
		case (note)
			6'd0: begin
				max_in = max_inOFF;
				ratio_lookup = restArray;
			end
			6'd1: begin
				max_in = max_in0;
				if (max_in == 0)
					ratio_lookup = restArray;
				else
					ratio_lookup = soundArray;
			end
			6'd2: begin
				max_in = max_in1;
				if (max_in == 0)
					ratio_lookup = restArray;
				else
					ratio_lookup = soundArray;
			end
			6'd3: begin
				max_in = max_in2;
				if (max_in == 0)
					ratio_lookup = restArray;
				else
					ratio_lookup = soundArray;
			end
			6'd4: begin
				max_in = max_in3;
				if (max_in == 0)
					ratio_lookup = restArray;
				else
					ratio_lookup = soundArray;
			end
			6'd5: begin
				max_in = max_in4;
				if (max_in == 0)
					ratio_lookup = restArray;
				else
					ratio_lookup = soundArray;
			end
			6'd6: begin
				max_in = max_in5;
				if (max_in == 0)
					ratio_lookup = restArray;
				else
					ratio_lookup = soundArray;
			end
			6'd7: begin
				max_in = max_in6;
				if (max_in == 0)
					ratio_lookup = restArray;
				else
					ratio_lookup = soundArray;
			end
			6'd8: begin
				max_in = max_in7;
				if (max_in == 0)
					ratio_lookup = restArray;
				else
					ratio_lookup = soundArray;
			end
			6'd9: begin
				max_in = max_in8;
				if (max_in == 0)
					ratio_lookup = restArray;
				else
					ratio_lookup = soundArray;
			end
			6'd10: begin
				max_in = max_in9;
				if (max_in == 0)
					ratio_lookup = restArray;
				else
					ratio_lookup = soundArray;
			end
			6'd11: begin
				max_in = max_in10;
				if (max_in == 0)
					ratio_lookup = restArray;
				else
					ratio_lookup = soundArray;
			end
			6'd12: begin
				max_in = max_in11;
				if (max_in == 0)
					ratio_lookup = restArray;
				else
					ratio_lookup = soundArray;
			end
			6'd13: begin
				max_in = max_in12;
				if (max_in == 0)
					ratio_lookup = restArray;
				else
					ratio_lookup = soundArray;
			end
			6'd14: begin
				max_in = max_in13;
				if (max_in == 0)
					ratio_lookup = restArray;
				else
					ratio_lookup = soundArray;
			end
			6'd15: begin
				max_in = max_in14;
				if (max_in == 0)
					ratio_lookup = restArray;
				else
					ratio_lookup = soundArray;
			end
			6'd16: begin
				max_in = max_in15;
				if (max_in == 0)
					ratio_lookup = restArray;
				else
					ratio_lookup = soundArray;
			end
			6'd17: begin
				max_in = max_in16;
				if (max_in == 0)
					ratio_lookup = restArray;
				else
					ratio_lookup = soundArray;
			end
			6'd18: begin
				max_in = max_in17;
				if (max_in == 0)
					ratio_lookup = restArray;
				else
					ratio_lookup = soundArray;
			end
			6'd19: begin
				max_in = max_in18;
				if (max_in == 0)
					ratio_lookup = restArray;
				else
					ratio_lookup = soundArray;
			end
			6'd20: begin
				max_in = max_in19;
				if (max_in == 0)
					ratio_lookup = restArray;
				else
					ratio_lookup = soundArray;
			end
			6'd21: begin
				max_in = max_in20;
				if (max_in == 0)
					ratio_lookup = restArray;
				else
					ratio_lookup = soundArray;
			end
			6'd22: begin
				max_in = max_in21;
				if (max_in == 0)
					ratio_lookup = restArray;
				else
					ratio_lookup = soundArray;
			end
			6'd23: begin
				max_in = max_in22;
				if (max_in == 0)
					ratio_lookup = restArray;
				else
					ratio_lookup = soundArray;
			end
			6'd24: begin
				max_in = max_in23;
				if (max_in == 0)
					ratio_lookup = restArray;
				else
					ratio_lookup = soundArray;
			end
			6'd25: begin
				max_in = max_in24;
				if (max_in == 0)
					ratio_lookup = restArray;
				else
					ratio_lookup = soundArray;
			end
			6'd26: begin
				max_in = max_in25;
				if (max_in == 0)
					ratio_lookup = restArray;
				else
					ratio_lookup = soundArray;
			end
			6'd27: begin
				max_in = max_in26;
				if (max_in == 0)
					ratio_lookup = restArray;
				else
					ratio_lookup = soundArray;
			end
			6'd28: begin
				max_in = max_in27;
				if (max_in == 0)
					ratio_lookup = restArray;
				else
					ratio_lookup = soundArray;
			end
			6'd29: begin
				max_in = max_in28;
				if (max_in == 0)
					ratio_lookup = restArray;
				else
					ratio_lookup = soundArray;
			end
			6'd30: begin
				max_in = max_in29;
				if (max_in == 0)
					ratio_lookup = restArray;
				else
					ratio_lookup = soundArray;
			end
			6'd31: begin
				max_in = max_in30;
				if (max_in == 0)
					ratio_lookup = restArray;
				else
					ratio_lookup = soundArray;
			end
			6'd32: begin
				max_in = max_in31;
				if (max_in == 0)
					ratio_lookup = restArray;
				else
					ratio_lookup = soundArray;
			end
			6'd34: begin
				max_in = goodSound;
				if (max_in == 0)
					ratio_lookup = restArray;
				else
					ratio_lookup = soundArray;
			end
			6'd35: begin
				max_in = badSound;
				if (max_in == 0)
					ratio_lookup = restArray;
				else
					ratio_lookup = soundArray;
			end
			default: begin
				max_in = max_inOFF;
				if (max_in == 0)
					ratio_lookup = restArray;
				else
					ratio_lookup = soundArray;
			end
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
