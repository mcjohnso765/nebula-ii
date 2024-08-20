
typedef enum logic [2:0] {
    NUM1, OPSEL, NUM2, RESULT, DISPLAY
} stateLog;

module t02_fpgaModule (
input logic clk, nrst, keyStrobe, enData,
input logic [31:0] instruction, dataIn, writeData,
input logic [3:0] buttons,
input logic [15:0] halfData,
output logic [31:0] address, dataOut,
output logic [127:0] row1, row2,
output logic FPGAEnable, writeFPGA, CPUEnable, nrstFPGA
);

//logic definitions
    stateLog state, nextState;
    logic currCPUEnable;
    logic currFPGAEnable;
    logic currFPGAWrite;
    logic instructionTrue, nextTrue;
		logic [31:0] one, ten, hun, thou, tenthou, hunthou;
    logic [7:0] hexop, nextHex, nextrt;
		logic [11:0] data, nextData, dataInTemp, nextdataInTemp;
		logic [127:0] nextRow1, nextRow2;
    
    
    assign CPUEnable = currCPUEnable;
    assign writeFPGA = currFPGAWrite;
    assign FPGAEnable = currFPGAEnable;

always_ff@(posedge clk, negedge nrst) begin
    if (!nrst) begin
      state <= NUM1;
    end else if (instructionTrue) begin
			state <= nextState;
		end else if (enData) begin
      state <= nextState;
		end else if (state == DISPLAY) begin
			dataInTemp = nextdataInTemp;
		end
end

always_ff@(posedge clk, negedge nrst)begin
    if(!nrst) begin
      data <= 0;
		end else if(enData) begin
      data <= nextData;
    end
end

always_ff@(posedge clk, negedge nrst)begin
	if(!nrst) begin
		row1 <= 128'ha0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0;
		row2 <= 128'ha0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0;
		hexop <= 0;
	end else begin
		row1 <= nextRow1;
		row2 <= nextRow2;
		hexop <= nextHex;
	end
end

always_comb begin
    if(instruction == 32'hffffffff)
        instructionTrue = 1;
    else 
        instructionTrue = 0;

    casez ({state, halfData[7:0] == 8'b00100011})
    {NUM1, 1'b1}: nextState = OPSEL;
    {OPSEL, 1'b1}: nextState = NUM2;
    {NUM2, 1'b1}: nextState = RESULT;
    {RESULT, 1'b0}: begin
    if (instructionTrue) 
        nextState = DISPLAY;
    else 
        nextState = RESULT;
    end
    {DISPLAY, 1'b1}: nextState = NUM1;
    default: nextState = state;
    endcase
end

bcd f2 (.in(data), .out(dataOut));
bcdOut f11 (.in(dataIn), .ones(one), .tens(ten), .hundred(hun), .thousand(thou), .tenthou(tenthou), .hunthou(hunthou));

always_comb begin
    currCPUEnable = 0;
    currFPGAEnable = 1;
    currFPGAWrite = 1;
    nrstFPGA = 1;
		nextHex = hexop;
		nextRow1 = row1;
		nextRow2 = row2;
		nextdataInTemp = 0;
    casez(state)
        NUM1: begin
            if(|buttons[3:0] && (halfData[7:0] != 8'b00100011 && halfData[3:0] != 4'b1010 && halfData[3:0] != 4'b1011 && halfData[3:0] != 4'b1100 && halfData[3:0] != 4'b1101)) begin
                nextData = {data[7:4], data[3:0], halfData[3:0]};
                //need to fix
                address = 32'd220;
								nextRow1 = {{4'b0011, data[11:8]}, {4'b0011, data[7:4]}, {4'b0011, data[3:0]}, row1[103:0]};
						end else if(|buttons[3:0] && (halfData[7:0] == 8'b00101010)) begin
								nextData = dataInTemp;
                address = 32'd220;
								nextRow1 = {{4'b0011, dataInTemp[11:8]}, {4'b0011, dataInTemp[7:4]}, {4'b0011, dataInTemp[3:0]}, row1[103:0]};
						end else begin
                nextData = data;
                address = 32'd320;
            end
        end
        OPSEL: begin
            if(|buttons[3:0] && (halfData[7:0] != 8'b00100011 && halfData[7:0] != 8'b00101010) && (halfData[3:0] == 4'b1010 || halfData[3:0] == 4'b1011 || halfData[3:0] == 4'b1100 || halfData[3:0] == 4'b1101)) begin
                nextData = {8'b0, halfData[3:0]};
                //need to fix
                address = 32'd260;
								casez(halfData[7:0])
									8'hD: nextHex = 8'b11111101; //div
									8'hC: nextHex = 8'b01111000; //mul
									8'hB: nextHex = 8'b00101101; //sub
									8'hA: nextHex = 8'b00101011; //add
									default: nextHex = hexop;
								endcase
								nextRow1 = {row1[127:64], nextHex, row1[55:0]};
            end else begin
                nextData = data;
                address = 32'd320;
            end
        end
        NUM2: begin
						if(|buttons[3:0] && (halfData[7:0] != 8'b00100011 && halfData[3:0] != 4'b1010 && halfData[3:0] != 4'b1011 && halfData[3:0] != 4'b1100 && halfData[3:0] != 4'b1101)) begin
                nextData = {data[7:4], data[3:0], halfData[3:0]};
                //need to fix
                address = 32'd240;
								nextRow1 = {row1[127:24], {4'b0011, data[11:8]}, {4'b0011, data[7:4]}, {4'b0011, data[3:0]}};
						end else if(|buttons[3:0] && (halfData[7:0] == 8'b00101010)) begin
								nextData = dataInTemp;
                address = 32'd240;
								nextRow1 = {row1[127:24], {4'b0011, dataInTemp[11:8]}, {4'b0011, dataInTemp[7:4]}, {4'b0011, dataInTemp[3:0]}};
						end else begin
                nextData = data;
                address = 32'd320;
            end
        end
        RESULT: begin
            currCPUEnable = 1;
            currFPGAEnable = 0;
            currFPGAWrite = 0;
            address = 32'd320;
            nextData = data;
        end
        DISPLAY: begin
            //need to fix, result address
            address = 32'd280;
            nextData = dataIn[11:0];
            currFPGAWrite = 0;
            nrstFPGA = 0;
						nextdataInTemp = {hun[3:0], ten[3:0], one[3:0]};
						if(halfData[7:0] == 8'b00100011) begin
							nextRow1 = 128'ha0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0;
							nextRow2 = 128'ha0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0;
						end else begin
							nextRow1 = row1;
							nextRow2 = {row2[127:56], 8'b00111101, {4'b0011, hunthou[3:0]}, {4'b0011, tenthou[3:0]}, {4'b0011, thou[3:0]}, {4'b0011, hun[3:0]}, {4'b0011, ten[3:0]}, {4'b0011, one[3:0]}};
						end
        end
        default: begin
            nextData = data;
            address = 32'd320;
        end
    endcase
end

endmodule

module bcd(
input logic [11:0] in,
output logic [31:0] out
);
assign out = in[11:8] * 100 + (in[7:4] * 10 + {28'b0, in[3:0]});
endmodule

module bcdOut(
	input logic [31:0] in,
	output logic [31:0] ones, tens, hundred, thousand, tenthou, hunthou
);
	logic [31:0] temp;
	always_comb begin
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
endmodule