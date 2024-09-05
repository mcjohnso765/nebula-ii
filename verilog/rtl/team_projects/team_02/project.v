module t02_alu (
	inputA,
	inputB,
	aluOP,
	ALUResult,
	negative,
	zero
);
	reg _sv2v_0;
	input wire signed [31:0] inputA;
	input wire signed [31:0] inputB;
	input wire [3:0] aluOP;
	output reg [31:0] ALUResult;
	output reg negative;
	output reg zero;
	wire [31:0] unsignedA;
	wire [31:0] unsignedB;
	assign unsignedA = inputA;
	assign unsignedB = inputB;
	always @(*) begin
		if (_sv2v_0)
			;
		zero = 0;
		case (aluOP)
			4'd5: begin
				ALUResult = inputA << inputB[4:0];
				negative = ALUResult[31];
				if (ALUResult == 0)
					zero = 1;
				else
					zero = 0;
			end
			4'd6: begin
				ALUResult = inputA >>> inputB[4:0];
				negative = ALUResult[31];
				if (ALUResult == 0)
					zero = 1;
				else
					zero = 0;
			end
			4'd9: begin
				ALUResult = inputA >> inputB[4:0];
				negative = ALUResult[31];
				if (ALUResult == 0)
					zero = 1;
				else
					zero = 0;
			end
			4'd0: begin
				ALUResult = inputA + inputB;
				negative = ALUResult[31];
				if (ALUResult == 0)
					zero = 1;
				else
					zero = 0;
			end
			4'd1: begin
				ALUResult = inputA - inputB;
				if (ALUResult == 0)
					zero = 1;
				else
					zero = 0;
				negative = ALUResult[31];
			end
			4'd2: begin
				ALUResult = inputA | inputB;
				negative = ALUResult[31];
				if (ALUResult == 0)
					zero = 1;
				else
					zero = 0;
			end
			4'd3: begin
				ALUResult = inputA ^ inputB;
				negative = ALUResult[31];
				if (ALUResult == 0)
					zero = 1;
				else
					zero = 0;
			end
			4'd4: begin
				ALUResult = inputA & inputB;
				negative = ALUResult[31];
				if (ALUResult == 0)
					zero = 1;
				else
					zero = 0;
			end
			4'd8: begin
				if (inputA < inputB)
					ALUResult = 32'd1;
				else
					ALUResult = 32'd0;
				negative = ALUResult[31];
			end
			4'd7: begin
				if (unsignedA < unsignedB)
					ALUResult = 32'd1;
				else
					ALUResult = 32'd0;
				negative = ALUResult[31];
			end
			default: begin
				ALUResult = 32'd0;
				negative = 0;
				zero = 0;
			end
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
module t02_control (
	instruction,
	reg_1,
	reg_2,
	rd,
	imm,
	aluOP,
	cuOP,
	regWrite,
	memWrite,
	memRead,
	aluSrc
);
	reg _sv2v_0;
	input wire [31:0] instruction;
	output reg [4:0] reg_1;
	output reg [4:0] reg_2;
	output reg [4:0] rd;
	output reg [19:0] imm;
	output reg [3:0] aluOP;
	output reg [5:0] cuOP;
	output reg regWrite;
	output reg memWrite;
	output reg memRead;
	output reg aluSrc;
	always @(*) begin
		if (_sv2v_0)
			;
		reg_1 = 0;
		reg_2 = 0;
		rd = 0;
		imm = 20'b00000000000000000000;
		regWrite = 0;
		memWrite = 0;
		memRead = 0;
		aluSrc = 0;
		aluOP = 1'sb0;
		if (instruction == 32'hffffffff)
			cuOP = 6'd39;
		else
			casez (instruction[6:0])
				7'b0110111: begin
					cuOP = 6'd0;
					imm = instruction[31:12];
					rd = instruction[11:7];
					regWrite = 1;
				end
				7'b0010111: begin
					cuOP = 6'd1;
					imm = instruction[31:12];
					rd = instruction[11:7];
					regWrite = 1;
				end
				7'b1101111: begin
					cuOP = 6'd2;
					imm = instruction[31:12];
					rd = instruction[11:7];
					regWrite = 1;
				end
				7'b1100111: begin
					cuOP = 6'd3;
					imm = {8'b00000000, instruction[31:20]};
					reg_1 = instruction[19:15];
					rd = instruction[11:7];
					regWrite = 1;
				end
				7'b1100011: begin
					reg_1 = instruction[19:15];
					reg_2 = instruction[24:20];
					imm = {8'b00000000, instruction[31:25], instruction[11:7]};
					aluOP = 4'd1;
					casez (instruction[14:12])
						3'b000: cuOP = 6'd4;
						3'b001: cuOP = 6'd5;
						3'b100: cuOP = 6'd6;
						3'b101: cuOP = 6'd7;
						3'b110: cuOP = 6'd8;
						3'b111: cuOP = 6'd9;
						default: cuOP = 6'd38;
					endcase
				end
				7'b0000011: begin
					reg_1 = instruction[19:15];
					rd = instruction[11:7];
					imm = {8'b00000000, instruction[31:20]};
					regWrite = 1;
					aluSrc = 1;
					memRead = 1;
					aluOP = 4'd0;
					casez (instruction[14:12])
						3'b000: cuOP = 6'd10;
						3'b001: cuOP = 6'd11;
						3'b010: cuOP = 6'd12;
						3'b100: cuOP = 6'd13;
						3'b101: cuOP = 6'd14;
						default: cuOP = 6'd38;
					endcase
				end
				7'b0100011: begin
					reg_1 = instruction[19:15];
					reg_2 = instruction[24:20];
					imm = {8'b00000000, instruction[31:25], instruction[11:7]};
					memWrite = 1;
					aluSrc = 1;
					aluOP = 4'd0;
					casez (instruction[14:12])
						3'b000: cuOP = 6'd15;
						3'b001: cuOP = 6'd16;
						3'b010: cuOP = 6'd17;
						default: cuOP = 6'd38;
					endcase
				end
				7'b0010011: begin
					reg_1 = instruction[19:15];
					rd = instruction[11:7];
					imm = {8'b00000000, instruction[31:20]};
					regWrite = 1;
					aluSrc = 1;
					casez (instruction[14:12])
						3'b000: begin
							aluOP = 4'd0;
							cuOP = 6'd18;
						end
						3'b010: begin
							aluOP = 4'd8;
							cuOP = 6'd19;
						end
						3'b011: begin
							aluOP = 4'd7;
							cuOP = 6'd20;
						end
						3'b100: begin
							aluOP = 4'd3;
							cuOP = 6'd22;
						end
						3'b110: begin
							aluOP = 4'd2;
							cuOP = 6'd23;
						end
						3'b111: begin
							aluOP = 4'd4;
							cuOP = 6'd24;
						end
						3'b001: begin
							aluOP = 4'd5;
							cuOP = 6'd25;
						end
						3'b101:
							if (|instruction[31:22]) begin
								aluOP = 4'd9;
								cuOP = 6'd26;
							end
							else begin
								aluOP = 4'd6;
								cuOP = 6'd27;
							end
						default: cuOP = 6'd38;
					endcase
				end
				7'b0110011: begin
					reg_1 = instruction[19:15];
					reg_2 = instruction[24:20];
					rd = instruction[11:7];
					regWrite = 1;
					casez (instruction[14:12])
						3'b000:
							if (!(|instruction[31:22])) begin
								aluOP = 4'd0;
								cuOP = 6'd28;
							end
							else begin
								aluOP = 4'd1;
								cuOP = 6'd29;
							end
						3'b010: begin
							aluOP = 4'd8;
							cuOP = 6'd31;
						end
						3'b011: begin
							aluOP = 4'd7;
							cuOP = 6'd32;
						end
						3'b100: begin
							aluOP = 4'd3;
							cuOP = 6'd33;
						end
						3'b110: begin
							aluOP = 4'd2;
							cuOP = 6'd36;
						end
						3'b111: begin
							aluOP = 4'd4;
							cuOP = 6'd37;
						end
						3'b001: begin
							aluOP = 4'd5;
							cuOP = 6'd30;
						end
						3'b101:
							if (|instruction[31:22]) begin
								aluOP = 4'd9;
								cuOP = 6'd34;
							end
							else begin
								aluOP = 4'd6;
								cuOP = 6'd35;
							end
						default: cuOP = 6'd38;
					endcase
				end
				default: cuOP = 6'd38;
			endcase
	end
	initial _sv2v_0 = 0;
endmodule
module t02_edgeDetector (
	clk,
	nRst_i,
	button_i,
	button_p
);
	reg _sv2v_0;
	input wire clk;
	input wire nRst_i;
	input wire button_i;
	output reg button_p;
	reg flip1;
	reg flip2;
	always @(posedge clk or negedge nRst_i)
		if (nRst_i == 0) begin
			flip1 <= 0;
			flip2 <= 0;
		end
		else begin
			flip2 <= flip1;
			flip1 <= button_i;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		button_p = flip1 && ~flip2;
	end
	initial _sv2v_0 = 0;
endmodule
module t02_fpgaModule (
	clk,
	nrst,
	keyStrobe,
	enData,
	instruction,
	dataIn,
	writeData,
	buttons,
	halfData,
	address,
	dataOut,
	row1,
	row2,
	FPGAEnable,
	writeFPGA,
	CPUEnable,
	nrstFPGA
);
	reg _sv2v_0;
	input wire clk;
	input wire nrst;
	input wire keyStrobe;
	input wire enData;
	input wire [31:0] instruction;
	input wire [31:0] dataIn;
	input wire [31:0] writeData;
	input wire [3:0] buttons;
	input wire [15:0] halfData;
	output reg [31:0] address;
	output wire [31:0] dataOut;
	output reg [127:0] row1;
	output reg [127:0] row2;
	output wire FPGAEnable;
	output wire writeFPGA;
	output wire CPUEnable;
	output reg nrstFPGA;
	reg [2:0] state;
	reg [2:0] nextState;
	reg currCPUEnable;
	reg currFPGAEnable;
	reg currFPGAWrite;
	reg instructionTrue;
	wire nextTrue;
	wire [31:0] one;
	wire [31:0] ten;
	wire [31:0] hun;
	wire [31:0] thou;
	wire [31:0] tenthou;
	wire [31:0] hunthou;
	reg [7:0] hexop;
	reg [7:0] nextHex;
	wire [7:0] nextrt;
	reg [11:0] data;
	reg [11:0] nextData;
	reg [11:0] dataInTemp;
	reg [11:0] nextdataInTemp;
	reg [127:0] nextRow1;
	reg [127:0] nextRow2;
	assign CPUEnable = currCPUEnable;
	assign writeFPGA = currFPGAWrite;
	assign FPGAEnable = currFPGAEnable;
	always @(posedge clk or negedge nrst)
		if (!nrst)
			state <= 3'd0;
		else if (instructionTrue)
			state <= nextState;
		else if (enData)
			state <= nextState;
		else if (state == 3'd4)
			dataInTemp = nextdataInTemp;
	always @(posedge clk or negedge nrst)
		if (!nrst)
			data <= 0;
		else if (enData)
			data <= nextData;
	always @(posedge clk or negedge nrst)
		if (!nrst) begin
			row1 <= 128'ha0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0;
			row2 <= 128'ha0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0;
			hexop <= 0;
		end
		else begin
			row1 <= nextRow1;
			row2 <= nextRow2;
			hexop <= nextHex;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		if (instruction == 32'hffffffff)
			instructionTrue = 1;
		else
			instructionTrue = 0;
		casez ({state, halfData[7:0] == 8'b00100011})
			4'h1: nextState = 3'd1;
			4'h3: nextState = 3'd2;
			4'h5: nextState = 3'd3;
			4'h6:
				if (instructionTrue)
					nextState = 3'd4;
				else
					nextState = 3'd3;
			4'h9: nextState = 3'd0;
			default: nextState = state;
		endcase
	end
	bcd f2(
		.in(data),
		.out(dataOut)
	);
	bcdOut f11(
		.in(dataIn),
		.ones(one),
		.tens(ten),
		.hundred(hun),
		.thousand(thou),
		.tenthou(tenthou),
		.hunthou(hunthou)
	);
	always @(*) begin
		if (_sv2v_0)
			;
		currCPUEnable = 0;
		currFPGAEnable = 1;
		currFPGAWrite = 1;
		nrstFPGA = 1;
		nextHex = hexop;
		nextRow1 = row1;
		nextRow2 = row2;
		nextdataInTemp = 0;
		casez (state)
			3'd0:
				if (|buttons[3:0] && (((((halfData[7:0] != 8'b00100011) && (halfData[3:0] != 4'b1010)) && (halfData[3:0] != 4'b1011)) && (halfData[3:0] != 4'b1100)) && (halfData[3:0] != 4'b1101))) begin
					nextData = {data[7:4], data[3:0], halfData[3:0]};
					address = 32'd220;
					nextRow1 = {4'b0011, data[11:8], 4'b0011, data[7:4], 4'b0011, data[3:0], row1[103:0]};
				end
				else if (|buttons[3:0] && (halfData[7:0] == 8'b00101010)) begin
					nextData = dataInTemp;
					address = 32'd220;
					nextRow1 = {4'b0011, dataInTemp[11:8], 4'b0011, dataInTemp[7:4], 4'b0011, dataInTemp[3:0], row1[103:0]};
				end
				else begin
					nextData = data;
					address = 32'd320;
				end
			3'd1:
				if ((|buttons[3:0] && ((halfData[7:0] != 8'b00100011) && (halfData[7:0] != 8'b00101010))) && ((((halfData[3:0] == 4'b1010) || (halfData[3:0] == 4'b1011)) || (halfData[3:0] == 4'b1100)) || (halfData[3:0] == 4'b1101))) begin
					nextData = {8'b00000000, halfData[3:0]};
					address = 32'd260;
					casez (halfData[7:0])
						8'h0d: nextHex = 8'b11111101;
						8'h0c: nextHex = 8'b01111000;
						8'h0b: nextHex = 8'b00101101;
						8'h0a: nextHex = 8'b00101011;
						default: nextHex = hexop;
					endcase
					nextRow1 = {row1[127:64], nextHex, row1[55:0]};
				end
				else begin
					nextData = data;
					address = 32'd320;
				end
			3'd2:
				if (|buttons[3:0] && (((((halfData[7:0] != 8'b00100011) && (halfData[3:0] != 4'b1010)) && (halfData[3:0] != 4'b1011)) && (halfData[3:0] != 4'b1100)) && (halfData[3:0] != 4'b1101))) begin
					nextData = {data[7:4], data[3:0], halfData[3:0]};
					address = 32'd240;
					nextRow1 = {row1[127:24], 4'b0011, data[11:8], 4'b0011, data[7:4], 4'b0011, data[3:0]};
				end
				else if (|buttons[3:0] && (halfData[7:0] == 8'b00101010)) begin
					nextData = dataInTemp;
					address = 32'd240;
					nextRow1 = {row1[127:24], 4'b0011, dataInTemp[11:8], 4'b0011, dataInTemp[7:4], 4'b0011, dataInTemp[3:0]};
				end
				else begin
					nextData = data;
					address = 32'd320;
				end
			3'd3: begin
				currCPUEnable = 1;
				currFPGAEnable = 0;
				currFPGAWrite = 0;
				address = 32'd320;
				nextData = data;
			end
			3'd4: begin
				address = 32'd280;
				nextData = dataIn[11:0];
				currFPGAWrite = 0;
				nrstFPGA = 0;
				nextdataInTemp = {hun[3:0], ten[3:0], one[3:0]};
				if (halfData[7:0] == 8'b00100011) begin
					nextRow1 = 128'ha0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0;
					nextRow2 = 128'ha0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0;
				end
				else begin
					nextRow1 = row1;
					nextRow2 = {row2[127:56], 12'b001111010011, hunthou[3:0], 4'b0011, tenthou[3:0], 4'b0011, thou[3:0], 4'b0011, hun[3:0], 4'b0011, ten[3:0], 4'b0011, one[3:0]};
				end
			end
			default: begin
				nextData = data;
				address = 32'd320;
			end
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
module bcd (
	in,
	out
);
	input wire [11:0] in;
	output wire [31:0] out;
	assign out = (in[11:8] * 100) + ((in[7:4] * 10) + {28'b0000000000000000000000000000, in[3:0]});
endmodule
module bcdOut (
	in,
	ones,
	tens,
	hundred,
	thousand,
	tenthou,
	hunthou
);
	reg _sv2v_0;
	input wire [31:0] in;
	output reg [31:0] ones;
	output reg [31:0] tens;
	output reg [31:0] hundred;
	output reg [31:0] thousand;
	output reg [31:0] tenthou;
	output reg [31:0] hunthou;
	reg [31:0] temp;
	always @(*) begin
		if (_sv2v_0)
			;
		hunthou = in / 100000;
		temp = in % 100000;
		tenthou = temp / 10000;
		temp = temp % 10000;
		thousand = temp / 1000;
		temp = temp % 1000;
		hundred = temp / 100;
		temp = temp % 100;
		tens = temp / 10;
		ones = temp % 10;
	end
	initial _sv2v_0 = 0;
endmodule
module t02_memory_control (
	CLK,
	nRST,
	dmmRen,
	dmmWen,
	imemRen,
	busy_o,
	imemaddr,
	dmmaddr,
	dmmstore,
	ramload,
	i_ready,
	d_ready,
	Ren,
	Wen,
	ramaddr,
	ramstore,
	imemload,
	dmmload
);
	reg _sv2v_0;
	input wire CLK;
	input wire nRST;
	input wire dmmRen;
	input wire dmmWen;
	input wire imemRen;
	input wire busy_o;
	input wire [31:0] imemaddr;
	input wire [31:0] dmmaddr;
	input wire [31:0] dmmstore;
	input wire [31:0] ramload;
	output wire i_ready;
	output wire d_ready;
	output reg Ren;
	output reg Wen;
	output reg [31:0] ramaddr;
	output reg [31:0] ramstore;
	output reg [31:0] imemload;
	output reg [31:0] dmmload;
	reg [31:0] prev_dmmaddr;
	reg [31:0] prev_dmmstore;
	reg [31:0] prev_imemload;
	reg d_wait;
	reg i_wait;
	always @(posedge CLK or negedge nRST)
		if (!nRST) begin
			prev_dmmaddr <= 32'b00000000000000000000000000000000;
			prev_dmmstore <= 32'b00000000000000000000000000000000;
			prev_imemload <= 32'b00000000000000000000000000000000;
		end
		else begin
			prev_dmmaddr <= dmmaddr;
			prev_dmmstore <= dmmstore;
			prev_imemload <= imemload;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		ramaddr = 0;
		Ren = 0;
		Wen = 0;
		ramstore = 0;
		imemload = 0;
		dmmload = 0;
		i_wait = 1;
		d_wait = 1;
		if (dmmRen) begin
			ramaddr = prev_dmmaddr;
			Ren = dmmRen;
			dmmload = ramload;
			d_wait = busy_o;
		end
		else if (dmmWen) begin
			ramaddr = prev_dmmaddr;
			Wen = dmmWen;
			ramstore = prev_dmmstore;
			d_wait = busy_o;
		end
		else if (imemRen) begin
			ramaddr = imemaddr;
			Ren = imemRen;
			imemload = ramload;
			i_wait = busy_o;
		end
		else begin
			Ren = 0;
			Wen = 0;
		end
		if (i_wait)
			imemload = prev_imemload;
	end
	assign i_ready = imemRen & ~i_wait;
	assign d_ready = (dmmRen | dmmWen) & ~d_wait;
	initial _sv2v_0 = 0;
endmodule
module t02_mux (
	in1,
	in2,
	en,
	out
);
	reg _sv2v_0;
	input wire [31:0] in1;
	input wire [31:0] in2;
	input wire en;
	output reg [31:0] out;
	always @(*) begin
		if (_sv2v_0)
			;
		if (en)
			out = in1;
		else
			out = in2;
	end
	initial _sv2v_0 = 0;
endmodule
module t02_new_request_unit (
	CLK,
	nRST,
	enable,
	DataAddress,
	InstrAddress,
	DatatoWrite,
	iready,
	dready,
	FetchedData,
	FetchedInstr,
	cuOP,
	busy_o,
	cpu_dat_o,
	write_i,
	read_i,
	adr_i,
	cpu_data_i,
	sel_i
);
	reg _sv2v_0;
	input wire CLK;
	input wire nRST;
	input wire enable;
	input wire [31:0] DataAddress;
	input wire [31:0] InstrAddress;
	input wire [31:0] DatatoWrite;
	output reg iready;
	output reg dready;
	output reg [31:0] FetchedData;
	output reg [31:0] FetchedInstr;
	input wire [5:0] cuOP;
	input wire busy_o;
	input wire [31:0] cpu_dat_o;
	output reg write_i;
	output reg read_i;
	output reg [31:0] adr_i;
	output reg [31:0] cpu_data_i;
	output wire [3:0] sel_i;
	reg [2:0] state;
	reg [2:0] next_state;
	reg next_iready;
	reg next_dready;
	reg next_read_i;
	reg next_write_i;
	reg [31:0] next_FetchedData;
	reg [31:0] next_FetchedInstr;
	reg [31:0] next_adr_i;
	reg [31:0] next_cpu_dat_i;
	assign sel_i = 4'b1111;
	always @(posedge CLK or negedge nRST)
		if (!nRST) begin
			state <= 3'd0;
			adr_i <= 32'b00000000000000000000000000000000;
			cpu_data_i <= 32'b00000000000000000000000000000000;
			FetchedData <= 32'b00000000000000000000000000000000;
			FetchedInstr <= 32'b00000000000000000000000000000000;
			iready <= 1'b0;
			dready <= 1'b0;
			read_i <= 1'b0;
			write_i <= 1'b0;
		end
		else begin
			state <= next_state;
			adr_i <= next_adr_i;
			cpu_data_i <= next_cpu_dat_i;
			FetchedData <= next_FetchedData;
			FetchedInstr <= next_FetchedInstr;
			iready <= next_iready;
			dready <= next_dready;
			read_i <= next_read_i;
			write_i <= next_write_i;
		end
	always @(*) begin
		if (_sv2v_0)
			;
		next_state = state;
		next_read_i = 1'b0;
		next_write_i = 1'b0;
		next_adr_i = 32'b00000000000000000000000000000000;
		next_cpu_dat_i = 32'b00000000000000000000000000000000;
		next_iready = 1'b0;
		next_dready = 1'b0;
		next_FetchedData = 32'b00000000000000000000000000000000;
		next_FetchedInstr = 32'b00000000000000000000000000000000;
		case (state)
			3'd0:
				if (enable != 1'b0) begin
					if ((((((cuOP == 6'd10) | (cuOP == 6'd11)) | (cuOP == 6'd12)) | (cuOP == 6'd13)) | (cuOP == 6'd14)) & !dready) begin
						next_read_i = 1'b1;
						next_write_i = 1'b0;
						next_adr_i = DataAddress + 32'h33000000;
						next_state = 3'd4;
					end
					else if ((((cuOP == 6'd15) | (cuOP == 6'd16)) | (cuOP == 6'd17)) & !dready) begin
						next_read_i = 1'b0;
						next_write_i = 1'b1;
						next_adr_i = DataAddress + 32'h33000000;
						next_cpu_dat_i = DatatoWrite;
						next_state = 3'd6;
					end
					else begin
						next_read_i = 1'b1;
						next_write_i = 1'b0;
						next_state = 3'd5;
					end
				end
			3'd4: begin
				next_adr_i = adr_i;
				next_state = 3'd1;
			end
			3'd1: begin
				next_adr_i = adr_i;
				if (!busy_o) begin
					next_adr_i = 32'b00000000000000000000000000000000;
					next_dready = 1'b1;
					next_FetchedData = cpu_dat_o;
					next_state = 3'd0;
				end
			end
			3'd5: begin
				next_adr_i = InstrAddress;
				next_state = 3'd2;
			end
			3'd2: begin
				next_adr_i = adr_i;
				if (!busy_o) begin
					next_adr_i = 32'b00000000000000000000000000000000;
					next_iready = 1'b1;
					next_FetchedInstr = cpu_dat_o;
					next_state = 3'd0;
				end
			end
			3'd6: begin
				next_adr_i = adr_i;
				next_cpu_dat_i = cpu_data_i;
				next_state = 3'd3;
			end
			3'd3: begin
				next_adr_i = adr_i;
				next_cpu_dat_i = cpu_data_i;
				if (!busy_o) begin
					next_adr_i = 32'b00000000000000000000000000000000;
					next_cpu_dat_i = 32'b00000000000000000000000000000000;
					next_dready = 1'b1;
					next_state = 3'd0;
				end
			end
			default: next_state = state;
		endcase
		if (enable == 1'b0)
			next_state = 3'd0;
	end
	initial _sv2v_0 = 0;
endmodule
module t02_pc (
	cuOP,
	rs1Read,
	signExtend,
	PCaddr,
	ALUneg,
	Zero,
	iready,
	clk,
	nRST,
	enable
);
	reg _sv2v_0;
	input wire [5:0] cuOP;
	input wire [31:0] rs1Read;
	input wire [31:0] signExtend;
	output wire [31:0] PCaddr;
	input wire ALUneg;
	input wire Zero;
	input wire iready;
	input wire clk;
	input wire nRST;
	input wire enable;
	reg [31:0] next_pc;
	reg [31:0] PC;
	assign PCaddr = PC;
	wire [31:0] inter_next_pc;
	reg en_latched;
	always @(posedge clk or negedge nRST)
		if (~nRST)
			en_latched <= 1'sb0;
		else
			en_latched <= enable;
	always @(posedge clk or negedge nRST)
		if (~nRST)
			PC <= 32'h33000000;
		else
			PC <= next_pc;
	always @(*) begin
		if (_sv2v_0)
			;
		if (en_latched) begin
			if (iready)
				case (cuOP)
					6'd3: next_pc = rs1Read + signExtend;
					6'd2: next_pc = PC + (signExtend << 1);
					6'd4: next_pc = (Zero ? PC + (signExtend << 1) : PC + 4);
					6'd5: next_pc = (~Zero ? PC + (signExtend << 1) : PC + 4);
					6'd6: next_pc = (ALUneg ? PC + (signExtend << 1) : PC + 4);
					6'd7: next_pc = (~ALUneg | Zero ? PC + (signExtend << 1) : PC + 4);
					6'd8: next_pc = (ALUneg ? PC + (signExtend << 1) : PC + 4);
					6'd9: next_pc = (~ALUneg | Zero ? PC + (signExtend << 1) : PC + 4);
					default: next_pc = PC + 4;
				endcase
			else
				next_pc = PC;
		end
		else
			next_pc = 32'h33000000;
	end
	initial _sv2v_0 = 0;
endmodule
// module t02_ram (
// 	clk,
// 	nRst,
// 	write_enable,
// 	read_enable,
// 	address_DM,
// 	address_IM,
// 	data_in,
// 	data_out,
// 	instr_out,
// 	pc_enable
// );
// 	reg _sv2v_0;
// 	input wire clk;
// 	input wire nRst;
// 	input wire write_enable;
// 	input wire read_enable;
// 	input wire [5:0] address_DM;
// 	input wire [5:0] address_IM;
// 	input wire [31:0] data_in;
// 	output reg [31:0] data_out;
// 	output reg [31:0] instr_out;
// 	output reg pc_enable;
// 	reg [31:0] memory [63:0];
// 	reg state;
// 	reg next_state;
// 	// initial $readmemh("fill.mem", memory);
// 	always @(posedge clk or negedge nRst)
// 		if (!nRst)
// 			state <= 1'd0;
// 		else
// 			state <= next_state;
// 	always @(*) begin
// 		if (_sv2v_0)
// 			;
// 		pc_enable = 1'b1;
// 		next_state = state;
// 		case (state)
// 			1'd0:
// 				if (read_enable | write_enable) begin
// 					pc_enable = 1'b0;
// 					next_state = 1'd1;
// 				end
// 			1'd1: next_state = 1'd0;
// 			default:
// 				;
// 		endcase
// 	end
// 	always @(posedge clk) begin
// 		if (write_enable)
// 			memory[address_DM >> 2] <= data_in;
// 		data_out <= memory[address_DM >> 2];
// 		instr_out <= memory[address_IM >> 2];
// 	end
// 	initial _sv2v_0 = 0;
// endmodule
module t02_register_file (
	clk,
	nRST,
	reg_write,
	en,
	write_index,
	read_index1,
	read_index2,
	write_data,
	read_data1,
	read_data2
);
	reg _sv2v_0;
	input wire clk;
	input wire nRST;
	input wire reg_write;
	input wire en;
	input wire [4:0] write_index;
	input wire [4:0] read_index1;
	input wire [4:0] read_index2;
	input wire [31:0] write_data;
	output wire [31:0] read_data1;
	output wire [31:0] read_data2;
	reg [31:0] register [31:0];
	reg [31:0] nxt_register [31:0];
	always @(posedge clk or negedge nRST)
		if (!nRST) begin : sv2v_autoblock_1
			reg signed [31:0] i;
			for (i = 0; i < 32; i = i + 1)
				begin : sv2v_autoblock_2
					reg signed [31:0] j;
					for (j = 0; j < 32; j = j + 1)
						register[i][j] <= 1'b0;
				end
		end
		else if (en & reg_write) begin : sv2v_autoblock_3
			reg signed [31:0] i;
			for (i = 1; i < 32; i = i + 1)
				register[i] <= nxt_register[i];
		end
		else
			register[write_index] <= register[0];
	always @(*) begin
		if (_sv2v_0)
			;
		begin : sv2v_autoblock_4
			reg signed [31:0] i;
			for (i = 0; i < 32; i = i + 1)
				nxt_register[i] = register[i];
		end
		if (reg_write && (write_index != 5'b00000))
			nxt_register[write_index] = write_data;
		else
			nxt_register[write_index] = 32'b00000000000000000000000000000000;
	end
	assign read_data1 = register[read_index1];
	assign read_data2 = register[read_index2];
	initial _sv2v_0 = 0;
endmodule
module t02_request (
	CLK,
	nRST,
	busy_o,
	en,
	imemaddr,
	dmmaddr,
	dmmstore,
	ramload,
	cuOP,
	Ren,
	Wen,
	i_ready,
	d_ready,
	imemload,
	dmmload,
	ramaddr,
	ramstore
);
	reg _sv2v_0;
	input wire CLK;
	input wire nRST;
	input wire busy_o;
	input wire en;
	input wire [31:0] imemaddr;
	input wire [31:0] dmmaddr;
	input wire [31:0] dmmstore;
	input wire [31:0] ramload;
	input wire [5:0] cuOP;
	output reg Ren;
	output reg Wen;
	output wire i_ready;
	output wire d_ready;
	output reg [31:0] imemload;
	output wire [31:0] dmmload;
	output reg [31:0] ramaddr;
	output reg [31:0] ramstore;
	wire i_ready_i;
	wire d_ready_i;
	wire dmmRen;
	wire dmmWen;
	wire imemRen;
	wire [31:0] imemaddr_co;
	wire [31:0] dmmaddr_co;
	wire [31:0] dmmstore_co;
	wire [31:0] dmmload_co;
	wire [31:0] imemload_co;
	wire Ren_;
	wire Wen_;
	wire [31:0] ramaddr_;
	wire [31:0] ramstore_;
	wire [31:0] imemload_;
	always @(*) begin
		if (_sv2v_0)
			;
		imemload = imemload_;
		if (!en | (cuOP == 6'd39)) begin
			Ren = 1'sb0;
			Wen = 1'sb0;
			ramaddr = 1'sb0;
			ramstore = 1'sb0;
			if (cuOP == 6'd39)
				imemload = 32'hffffffff;
		end
		else begin
			Ren = Ren_;
			Wen = Wen_;
			ramaddr = ramaddr_;
			ramstore = ramstore_;
			imemload = imemload_;
		end
	end
	t02_request_unit r1(
		.CLK(CLK),
		.nRST(nRST),
		.dmmstorei(dmmstore),
		.dmmaddri(dmmaddr),
		.imemaddri(imemaddr),
		.cuOP(cuOP),
		.i_ready_i(i_ready_i),
		.d_ready(d_ready_i),
		.dmmRen(dmmRen),
		.dmmWen(dmmWen),
		.imemRen(imemRen),
		.i_ready_o(i_ready),
		.imemaddro(imemaddr_co),
		.dmmstoreo(dmmstore_co),
		.dmmaddro(dmmaddr_co),
		.busy_o(busy_o),
		.dmmloadi(dmmload_co),
		.imemloadi(imemload_co),
		.imemloado(imemload_),
		.dmmloado(dmmload),
		.d_ready_o(d_ready)
	);
	t02_memory_control m1(
		.CLK(CLK),
		.nRST(nRST),
		.imemRen(imemRen),
		.dmmRen(dmmRen),
		.dmmWen(dmmWen),
		.busy_o(busy_o),
		.imemaddr(imemaddr_co),
		.dmmaddr(dmmaddr_co),
		.dmmstore(dmmstore_co),
		.ramload(ramload),
		.i_ready(i_ready_i),
		.d_ready(d_ready_i),
		.Ren(Ren_),
		.Wen(Wen_),
		.ramaddr(ramaddr_),
		.ramstore(ramstore_),
		.dmmload(dmmload_co),
		.imemload(imemload_co)
	);
	initial _sv2v_0 = 0;
endmodule
module t02_request_unit (
	CLK,
	nRST,
	i_ready_i,
	d_ready,
	busy_o,
	cuOP,
	dmmstorei,
	dmmaddri,
	imemaddri,
	imemloadi,
	dmmloadi,
	dmmWen,
	dmmRen,
	imemRen,
	i_ready_o,
	d_ready_o,
	dmmstoreo,
	dmmaddro,
	imemaddro,
	imemloado,
	dmmloado
);
	reg _sv2v_0;
	input wire CLK;
	input wire nRST;
	input wire i_ready_i;
	input wire d_ready;
	input wire busy_o;
	input wire [5:0] cuOP;
	input wire [31:0] dmmstorei;
	input wire [31:0] dmmaddri;
	input wire [31:0] imemaddri;
	input wire [31:0] imemloadi;
	input wire [31:0] dmmloadi;
	output reg dmmWen;
	output reg dmmRen;
	output reg imemRen;
	output wire i_ready_o;
	output wire d_ready_o;
	output wire [31:0] dmmstoreo;
	output wire [31:0] dmmaddro;
	output wire [31:0] imemaddro;
	output wire [31:0] imemloado;
	output wire [31:0] dmmloado;
	reg nxt_dmmRen;
	reg nxt_dmmWen;
	always @(posedge CLK or negedge nRST)
		if (!nRST)
			dmmRen <= 0;
		else if (~busy_o)
			dmmRen <= nxt_dmmRen;
	always @(posedge CLK or negedge nRST)
		if (!nRST)
			dmmWen <= 0;
		else if (~busy_o)
			dmmWen <= nxt_dmmWen;
	always @(*) begin
		if (_sv2v_0)
			;
		imemRen = 1;
		if (i_ready_i) begin
			if (((((cuOP == 6'd10) | (cuOP == 6'd11)) | (cuOP == 6'd12)) | (cuOP == 6'd13)) | (cuOP == 6'd14)) begin
				nxt_dmmRen = 1;
				nxt_dmmWen = 0;
			end
			else if (((cuOP == 6'd15) | (cuOP == 6'd16)) | (cuOP == 6'd17)) begin
				nxt_dmmRen = 0;
				nxt_dmmWen = 1;
			end
			else begin
				nxt_dmmRen = 0;
				nxt_dmmWen = 0;
			end
		end
		else if (d_ready) begin
			nxt_dmmRen = 0;
			nxt_dmmWen = 0;
		end
		else begin
			nxt_dmmRen = 0;
			nxt_dmmWen = 0;
		end
	end
	assign imemaddro = imemaddri;
	assign dmmaddro = dmmaddri + 32'h33000000;
	assign dmmstoreo = dmmstorei;
	assign imemloado = imemloadi;
	assign dmmloado = dmmloadi;
	assign i_ready_o = i_ready_i;
	assign d_ready_o = d_ready;
	initial _sv2v_0 = 0;
endmodule
module t02_signExtender (
	imm,
	CUOp,
	immOut
);
	reg _sv2v_0;
	input wire [19:0] imm;
	input wire [5:0] CUOp;
	output reg [31:0] immOut;
	always @(*) begin
		if (_sv2v_0)
			;
		if (CUOp == 6'd2)
			immOut = {{13 {imm[19]}}, imm[7:0], imm[8], imm[18:9]};
		else if ((((((CUOp == 6'd4) || (CUOp == 6'd5)) || (CUOp == 6'd6)) || (CUOp == 6'd7)) || (CUOp == 6'd8)) || (CUOp == 6'd9))
			immOut = {{21 {imm[11]}}, imm[0], imm[10:5], imm[4:1]};
		else if (((((CUOp == 6'd18) || (CUOp == 6'd29)) || (CUOp == 6'd28)) || (CUOp == 6'd19)) || (CUOp == 6'd31))
			immOut = {{20 {imm[11]}}, imm[11:0]};
		else if ((CUOp == 6'd0) || (CUOp == 6'd1))
			immOut = {imm, 12'b000000000000};
		else
			immOut = {{20 {imm[11]}}, imm[11:0]};
	end
	initial _sv2v_0 = 0;
endmodule
`default_nettype none
module t02_top (
	clk,
	nrst,
	enable,
	ramaddr,
	ramstore,
	Ren,
	Wen,
	ramload,
	busy_o,
	lcd_en,
	lcd_rw,
	lcd_rs,
	lcd_data,
	read_row,
	scan_col,
	sel_i
);
	input wire clk;
	input wire nrst;
	input wire enable;
	output wire [31:0] ramaddr;
	output wire [31:0] ramstore;
	output wire Ren;
	output wire Wen;
	input wire [31:0] ramload;
	input wire busy_o;
	output wire lcd_en;
	output wire lcd_rw;
	output wire lcd_rs;
	output wire [7:0] lcd_data;
	input wire [3:0] read_row;
	output wire [3:0] scan_col;
	output wire [3:0] sel_i;
	wire zero;
	wire negative;
	wire regWrite;
	wire aluSrc;
	wire d_ready;
	wire i_ready;
	wire memWrite;
	wire memRead;
	wire [3:0] aluOP;
	wire [4:0] regsel1;
	wire [4:0] regsel2;
	wire [4:0] w_reg;
	wire [5:0] cuOP;
	wire [19:0] imm;
	wire [31:0] memload;
	wire [31:0] aluIn;
	wire [31:0] aluOut;
	wire [31:0] immOut;
	wire [31:0] pc;
	wire [31:0] writeData;
	wire [31:0] regData1;
	wire [31:0] regData2;
	wire [31:0] instruction;
	wire [127:0] row1;
	wire [127:0] row2;
	wire [15:0] halfData;
	wire [31:0] FPGAAdress;
	wire [31:0] FPGADataOut;
	wire FPGAEnable;
	wire writeFPGA;
	wire CPUEnable;
	wire keyStrobe;
	wire enData;
	wire nrstFPGA;
	wire write_enable;
	t02_fpgaModule a1(
		.clk(clk),
		.nrst(nrst),
		.instruction(instruction),
		.dataIn(memload),
		.buttons(read_row),
		.FPGAEnable(FPGAEnable),
		.writeFPGA(writeFPGA),
		.CPUEnable(CPUEnable),
		.address(FPGAAdress),
		.dataOut(FPGADataOut),
		.writeData(writeData),
		.nrstFPGA(nrstFPGA),
		.row1(row1),
		.row2(row2),
		.keyStrobe(keyStrobe),
		.halfData(halfData),
		.enData(enData)
	);
	wire [31:0] muxxedAddressOut;
	wire [31:0] muxxedDataOut;
	wire [31:0] intermedWriteEnable;
	t02_mux enableWrite(
		.in1({31'b0000000000000000000000000000000, writeFPGA}),
		.in2({31'b0000000000000000000000000000000, memWrite}),
		.en(FPGAEnable),
		.out(intermedWriteEnable)
	);
	t02_mux enableFpgaData(
		.in1(FPGADataOut),
		.in2(regData2),
		.en(FPGAEnable),
		.out(muxxedDataOut)
	);
	t02_mux enableFpgaAddress(
		.in1(FPGAAdress),
		.in2(aluOut),
		.en(FPGAEnable),
		.out(muxxedAddressOut)
	);
	assign write_enable = intermedWriteEnable[0];
	t02_mux aluMux(
		.in1(immOut),
		.in2(regData2),
		.en(aluSrc),
		.out(aluIn)
	);
	t02_alu arith(
		.aluOP(aluOP),
		.inputA(regData1),
		.inputB(aluIn),
		.ALUResult(aluOut),
		.zero(zero),
		.negative(negative)
	);
	t02_register_file DUT(
		.en(enable),
		.clk(clk),
		.nRST(nrst),
		.reg_write(regWrite),
		.read_index1(regsel1),
		.read_index2(regsel2),
		.read_data1(regData1),
		.read_data2(regData2),
		.write_index(w_reg),
		.write_data(writeData)
	);
	t02_control controller(
		.cuOP(cuOP),
		.instruction(instruction),
		.reg_1(regsel1),
		.reg_2(regsel2),
		.rd(w_reg),
		.imm(imm),
		.aluOP(aluOP),
		.regWrite(regWrite),
		.memWrite(memWrite),
		.memRead(memRead),
		.aluSrc(aluSrc)
	);
	t02_pc testpc(
		.clk(clk),
		.nRST(nrst),
		.ALUneg(negative),
		.Zero(zero),
		.iready(i_ready),
		.PCaddr(pc),
		.cuOP(cuOP),
		.rs1Read(regData1),
		.signExtend(immOut),
		.enable(enable)
	);
	t02_writeToReg write(
		.cuOP(cuOP),
		.memload(memload),
		.aluOut(aluOut),
		.imm(immOut),
		.pc(pc),
		.writeData(writeData),
		.negative(negative)
	);
	t02_signExtender signex(
		.imm(imm),
		.immOut(immOut),
		.CUOp(cuOP)
	);
	t02_new_request_unit ru(
		.CLK(clk),
		.nRST(nrst),
		.DataAddress(aluOut),
		.InstrAddress(pc),
		.DatatoWrite(regData2),
		.enable(enable),
		.iready(i_ready),
		.dready(d_ready),
		.FetchedData(memload),
		.FetchedInstr(instruction),
		.cuOP(cuOP),
		.busy_o(busy_o),
		.cpu_dat_o(ramload),
		.write_i(Wen),
		.read_i(Ren),
		.adr_i(ramaddr),
		.cpu_data_i(ramstore),
		.sel_i(sel_i)
	);
	t02_edgeDetector edg2(
		.clk(clk),
		.nRst_i(nrst),
		.button_i(~keyStrobe),
		.button_p(enData)
	);
	t02_keypad pad(
		.clk(clk),
		.rst(nrst),
		.receive_ready(keyStrobe),
		.data_received(halfData),
		.read_row(read_row),
		.scan_col(scan_col)
	);
	t02_lcd1602 lcd(
		.clk(clk),
		.rst(nrst),
		.row_1(row1),
		.row_2(row2),
		.lcd_en(lcd_en),
		.lcd_rw(lcd_rw),
		.lcd_rs(lcd_rs),
		.lcd_data(lcd_data)
	);
endmodule
module t02_wishbone_manager (
	nRST,
	CLK,
	DAT_I,
	ACK_I,
	CPU_DAT_I,
	ADR_I,
	SEL_I,
	WRITE_I,
	READ_I,
	ADR_O,
	DAT_O,
	SEL_O,
	WE_O,
	STB_O,
	CYC_O,
	CPU_DAT_O,
	BUSY_O
);
	reg _sv2v_0;
	input wire nRST;
	input wire CLK;
	input wire [31:0] DAT_I;
	input wire ACK_I;
	input wire [31:0] CPU_DAT_I;
	input wire [31:0] ADR_I;
	input wire [3:0] SEL_I;
	input wire WRITE_I;
	input wire READ_I;
	output reg [31:0] ADR_O;
	output reg [31:0] DAT_O;
	output reg [3:0] SEL_O;
	output reg WE_O;
	output reg STB_O;
	output reg CYC_O;
	output reg [31:0] CPU_DAT_O;
	output reg BUSY_O;
	reg [1:0] curr_state;
	reg [1:0] next_state;
	reg [31:0] next_ADR_O;
	reg [31:0] next_DAT_O;
	reg [3:0] next_SEL_O;
	reg next_WE_O;
	reg next_STB_O;
	reg next_CYC_O;
	reg [31:0] next_CPU_DAT_O;
	reg next_BUSY_O;
	always @(posedge CLK or negedge nRST) begin : All_ffs
		if (~nRST) begin
			curr_state <= 2'd0;
			CPU_DAT_O <= 1'sb0;
			BUSY_O <= 1'sb0;
			ADR_O <= 1'sb0;
			DAT_O <= 1'sb0;
			SEL_O <= 1'sb0;
			WE_O <= 1'sb0;
			STB_O <= 1'sb0;
			CYC_O <= 1'sb0;
		end
		else begin
			curr_state <= next_state;
			CPU_DAT_O <= next_CPU_DAT_O;
			BUSY_O <= next_BUSY_O;
			ADR_O <= next_ADR_O;
			DAT_O <= next_DAT_O;
			SEL_O <= next_SEL_O;
			WE_O <= next_WE_O;
			STB_O <= next_STB_O;
			CYC_O <= next_CYC_O;
		end
	end
	always @(*) begin
		if (_sv2v_0)
			;
		next_state = curr_state;
		next_ADR_O = ADR_O;
		next_DAT_O = DAT_O;
		next_SEL_O = SEL_O;
		next_WE_O = WE_O;
		next_STB_O = STB_O;
		next_CYC_O = CYC_O;
		next_BUSY_O = BUSY_O;
		case (curr_state)
			2'd0: begin
				if (WRITE_I && !READ_I) begin
					next_BUSY_O = 1'b1;
					next_state = 2'd1;
				end
				if (!WRITE_I && READ_I) begin
					next_BUSY_O = 1'b1;
					next_state = 2'd2;
				end
			end
			2'd1: begin
				next_ADR_O = ADR_I;
				next_DAT_O = CPU_DAT_I;
				next_SEL_O = SEL_I;
				next_WE_O = 1'b1;
				next_STB_O = 1'b1;
				next_CYC_O = 1'b1;
				next_BUSY_O = 1'b1;
				if (ACK_I) begin
					next_state = 2'd0;
					next_ADR_O = 1'sb0;
					next_DAT_O = 1'sb0;
					next_SEL_O = 1'sb0;
					next_WE_O = 1'sb0;
					next_STB_O = 1'sb0;
					next_CYC_O = 1'sb0;
					next_BUSY_O = 1'sb0;
				end
			end
			2'd2: begin
				next_ADR_O = ADR_I;
				next_DAT_O = 1'sb0;
				next_SEL_O = SEL_I;
				next_WE_O = 1'sb0;
				next_STB_O = 1'b1;
				next_CYC_O = 1'b1;
				next_BUSY_O = 1'b1;
				if (ACK_I) begin
					next_state = 2'd0;
					next_ADR_O = 1'sb0;
					next_DAT_O = 1'sb0;
					next_SEL_O = 1'sb0;
					next_WE_O = 1'sb0;
					next_STB_O = 1'sb0;
					next_CYC_O = 1'sb0;
					next_BUSY_O = 1'sb0;
				end
			end
			default: next_state = curr_state;
		endcase
	end
	reg prev_BUSY_O;
	wire BUSY_O_edge;
	always @(posedge CLK or negedge nRST) begin : BUSY_O_edge_detector
		if (!nRST)
			prev_BUSY_O <= 1'sb0;
		else
			prev_BUSY_O <= BUSY_O;
	end
	assign BUSY_O_edge = !BUSY_O && prev_BUSY_O;
	always @(*) begin
		if (_sv2v_0)
			;
		next_CPU_DAT_O = 32'hbad1bad1;
		if ((curr_state == 2'd2) && ACK_I)
			next_CPU_DAT_O = DAT_I;
		else if (BUSY_O_edge)
			next_CPU_DAT_O = CPU_DAT_O;
	end
	initial _sv2v_0 = 0;
endmodule
module t02_writeToReg (
	memload,
	pc,
	aluOut,
	imm,
	negative,
	cuOP,
	writeData
);
	reg _sv2v_0;
	input wire [31:0] memload;
	input wire [31:0] pc;
	input wire [31:0] aluOut;
	input wire [31:0] imm;
	input wire negative;
	input wire [5:0] cuOP;
	output reg [31:0] writeData;
	always @(*) begin
		if (_sv2v_0)
			;
		case (cuOP)
			6'd10: writeData = {{24 {memload[7]}}, memload[7:0]};
			6'd11: writeData = {{16 {memload[7]}}, memload[15:0]};
			6'd12: writeData = memload;
			6'd13: writeData = {24'b000000000000000000000000, memload[7:0]};
			6'd14: writeData = {16'b0000000000000000, memload[15:0]};
			6'd1: writeData = pc + {imm[31:12], 12'b000000000000};
			6'd0: writeData = {imm[31:12], 12'b000000000000};
			6'd2: writeData = pc + 4;
			6'd3: writeData = pc + 4;
			default: writeData = aluOut;
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
`default_nettype none
module team_02 (
`ifdef USE_POWER_PINS
	vccd1,	// User area 1 1.8V supply
	vssd1,	// User area 1 digital ground
`endif
	clk,
	nrst,
	en,
	// la_data_in,
	// la_data_out,
	// la_oenb,
	gpio_in,
	gpio_out,
	gpio_oeb,
	ADR_O,
	DAT_O,
	SEL_O,
	WE_O,
	STB_O,
	CYC_O,
	DAT_I,
	ACK_I
);
`ifdef USE_POWER_PINS
		inout vccd1;	// User area 1 1.8V supply
		inout vssd1;	// User area 1 digital ground
`endif
	input wire clk;
	input wire nrst;
	input wire en;
	// input wire [31:0] la_data_in;
	// output wire [31:0] la_data_out;
	// input wire [31:0] la_oenb;
	input wire [31:0] gpio_in;
	output wire [31:0] gpio_out;
	output wire [31:0] gpio_oeb;
	output wire [31:0] ADR_O;
	output wire [31:0] DAT_O;
	output wire [3:0] SEL_O;
	output wire WE_O;
	output wire STB_O;
	output wire CYC_O;
	input wire [31:0] DAT_I;
	input wire ACK_I;
	wire [3:0] sel_i;
	wire [31:0] ramstore;
	wire [31:0] ramaddr;
	wire [31:0] ramload;
	wire Ren;
	wire Wen;
	wire busy_o;
	t02_top top(
		.clk(clk),
		.nrst(nrst),
		.ramaddr(ramaddr),
		.ramstore(ramstore),
		.Ren(Ren),
		.Wen(Wen),
		.ramload(ramload),
		.busy_o(busy_o),
		.enable(en),
		.lcd_rs(gpio_out[0]),
		.lcd_rw(gpio_out[5]),
		.lcd_en(gpio_out[6]),
		.sel_i(sel_i),
		.lcd_data(gpio_out[14:7]),
		.read_row(gpio_in[18:15]),
		.scan_col(gpio_out[22:19])
	);
	t02_wishbone_manager wb(
		.CLK(clk),
		.nRST(nrst),
		.CPU_DAT_I(ramstore),
		.ADR_I(ramaddr),
		.SEL_I(sel_i),
		.WRITE_I(Wen),
		.READ_I(Ren),
		.CPU_DAT_O(ramload),
		.BUSY_O(busy_o),
		.ADR_O(ADR_O),
		.DAT_O(DAT_O),
		.SEL_O(SEL_O),
		.WE_O(WE_O),
		.STB_O(STB_O),
		.CYC_O(CYC_O),
		.DAT_I(DAT_I),
		.ACK_I(ACK_I)
	);
	assign gpio_oeb[0] = 1'sb0;
	assign gpio_oeb[4:1] = 1'sb1;
	assign gpio_oeb[5] = 1'sb0;
	assign gpio_oeb[6] = 1'sb0;
	assign gpio_oeb[14:7] = 1'sb0;
	assign gpio_oeb[18:15] = 4'b1111;
	assign gpio_oeb[22:19] = 1'sb0;
	assign gpio_oeb[31:23] = 1'sb1;
	assign gpio_out[31:23] = 1'sb0;
	assign gpio_out[18:15] = 1'sb0;
	assign gpio_out[4:1] = 1'sb0;
endmodule
