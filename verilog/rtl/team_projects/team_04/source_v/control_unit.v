module control_unit (
	opcode,
	RegWriteSource,
	ALUSrc,
	RegWrite,
	Jump,
	Branch,
	MemWrite,
	MemRead,
	Error
);
	reg _sv2v_0;
	input wire [6:0] opcode;
	output reg [1:0] RegWriteSource;
	output reg ALUSrc;
	output reg RegWrite;
	output reg Jump;
	output reg Branch;
	output reg MemWrite;
	output reg MemRead;
	output reg Error;
	always @(*) begin
		if (_sv2v_0)
			;
		case (opcode)
			7'b0110111: begin
				RegWrite = 1;
				ALUSrc = 0;
				RegWriteSource = 2'b10;
				MemWrite = 0;
				MemRead = 0;
				Jump = 0;
				Branch = 0;
				Error = 0;
			end
			7'b0010111: begin
				RegWrite = 1;
				ALUSrc = 1;
				RegWriteSource = 2'b11;
				MemWrite = 0;
				MemRead = 0;
				Jump = 0;
				Branch = 0;
				Error = 0;
			end
			7'b1101111: begin
				RegWrite = 1;
				ALUSrc = 1;
				RegWriteSource = 2'b11;
				MemWrite = 0;
				MemRead = 0;
				Jump = 1;
				Branch = 0;
				Error = 0;
			end
			7'b1100111: begin
				RegWrite = 1;
				ALUSrc = 1;
				RegWriteSource = 2'b11;
				MemWrite = 0;
				MemRead = 0;
				Jump = 1;
				Branch = 0;
				Error = 0;
			end
			7'b1100011: begin
				RegWrite = 0;
				ALUSrc = 0;
				RegWriteSource = 2'b00;
				MemWrite = 0;
				MemRead = 0;
				Jump = 0;
				Branch = 1;
				Error = 0;
			end
			7'b0000011: begin
				RegWrite = 1;
				ALUSrc = 1;
				RegWriteSource = 2'b01;
				MemWrite = 0;
				MemRead = 1;
				Jump = 0;
				Branch = 0;
				Error = 0;
			end
			7'b0100011: begin
				RegWrite = 0;
				ALUSrc = 1;
				RegWriteSource = 2'b00;
				MemWrite = 1;
				MemRead = 0;
				Jump = 0;
				Branch = 0;
				Error = 0;
			end
			7'b0010011: begin
				RegWrite = 1;
				ALUSrc = 1;
				RegWriteSource = 2'b00;
				MemWrite = 0;
				MemRead = 0;
				Jump = 0;
				Branch = 0;
				Error = 0;
			end
			7'b0110011: begin
				RegWrite = 1;
				ALUSrc = 0;
				RegWriteSource = 2'b00;
				MemWrite = 0;
				MemRead = 0;
				Jump = 0;
				Branch = 0;
				Error = 0;
			end
			default: begin
				RegWrite = 0;
				ALUSrc = 0;
				RegWriteSource = 2'b00;
				MemWrite = 0;
				MemRead = 0;
				Jump = 0;
				Branch = 0;
				Error = 1;
			end
		endcase
	end
	initial _sv2v_0 = 0;
endmodule
