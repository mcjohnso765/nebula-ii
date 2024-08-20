module t02_keypad(
	input clk,
	input rst,  
	output receive_ready,
	output reg [15:0] data_received, // only use the lower 8-bit
	
	// keypad interface
	input      [3:0] read_row,
	output reg [3:0] scan_col
);
	reg [1:0] count;
	reg [7:0] keyCode;
	reg keyValid;

	// Scan one column in one clock cycle
	always @(count) begin
		case (count)
			2'b00:   scan_col <= 4'b0001;
			2'b01:   scan_col <= 4'b0010;
			2'b10:   scan_col <= 4'b0100;
			2'b11:   scan_col <= 4'b1000;
			default: scan_col <= 4'b0001;
		endcase
	end
  
	// To avoid noise
	t02_button button_control(
		.clk(clk),
		.noisy(keyValid),
		.btn_ctrl(receive_ready)
	); 
  
	always @(posedge clk, negedge rst) begin
		if (!rst) begin
			keyCode <= 8'b0000_0000;
			keyValid <= 1'b0;
			count <= 2'b00;
		end
		else begin
			if (read_row != 4'b0000) begin
				keyCode <= {scan_col, read_row};
				keyValid <= 1'b1;
			end
			else begin
				keyValid <= 1'b0;
				count <= count + 2'b01;     
			end
		end
	end
	
	always @(posedge clk) begin
		if (!rst)
			data_received <= 16'b0;
		else if (receive_ready) begin
			case (keyCode)
				8'b0000_0000: data_received <= 16'b0;
				8'b0001_0001: data_received <= {8'b0, 8'd1};
				8'b0001_0010: data_received <= {8'b0, 8'd2};
				8'b0001_0100: data_received <= {8'b0, 8'd3};
				8'b0001_1000: data_received <= {8'b0, 8'hA};
				8'b0010_0001: data_received <= {8'b0, 8'd4};
				8'b0010_0010: data_received <= {8'b0, 8'd5};
				8'b0010_0100: data_received <= {8'b0, 8'd6};
				8'b0010_1000: data_received <= {8'b0, 8'hB};
				8'b0100_0001: data_received <= {8'b0, 8'd7};
				8'b0100_0010: data_received <= {8'b0, 8'd8};
				8'b0100_0100: data_received <= {8'b0, 8'd9};
				8'b0100_1000: data_received <= {8'b0, 8'hC};
				8'b1000_0001: data_received <= {8'b0, 8'b00101010};
				8'b1000_0010: data_received <= {8'b0, 8'd0};
				8'b1000_0100: data_received <= {8'b0, 8'b00100011};
				8'b1000_1000: data_received <= {8'b0, 8'hD};
				default:      data_received <= 16'b0;
			endcase
		end
	end
	
endmodule