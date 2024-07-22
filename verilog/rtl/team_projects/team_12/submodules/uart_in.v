`default_nettype none
module uart_in (
	MHz10,
	nrst,
	en,
	serIn,
	dataOut,
	baudClk,
	beginRx,
	done
);
	reg _sv2v_0;
	input wire MHz10;
	input wire nrst;
	input wire en;
	input wire serIn;
	output wire [7:0] dataOut;
	output wire baudClk;
	output wire beginRx;
	output wire done;
	reg [1:0] current_state;
	reg [1:0] next_state;
	reg offset;
	reg beginSample;
	reg [3:0] count_current_state;
	reg [3:0] count_next_state;
	localparam numbits = 8;
	wire shift;
	reg [7:0] count;
	reg [7:0] next_count;
	always @(posedge MHz10 or negedge nrst)
		if (!nrst)
			current_state <= 2'd0;
		else if (en)
			current_state <= next_state;
	always @(*) begin
		if (_sv2v_0)
			;
		next_state = current_state;
		case (current_state)
			2'd0:
				if (beginRx)
					next_state = 2'd1;
				else
					next_state = 2'd0;
			2'd1:
				if (count_current_state == 8)
					next_state = 2'd2;
				else
					next_state = 2'd1;
			2'd2:
				if (serIn == 1)
					next_state = 2'd0;
				else
					next_state = 2'd3;
			2'd3: next_state = 2'd0;
		endcase
	end
	assign done = current_state == 2'd2;
	negedge_detector negedge_detector(
		.MHz10(MHz10),
		.nrst(nrst),
		.en(en),
		.in(serIn),
		.out(beginRx)
	);
	always @(posedge MHz10 or negedge nrst)
		if (~nrst)
			count <= 0;
		else
			count <= next_count;
	always @(posedge MHz10 or negedge nrst)
		if (~nrst)
			offset <= 1'sb0;
		else if ((beginRx == 1) && (current_state == 2'd0))
			offset <= 1;
		else if (beginSample == 1)
			offset <= 0;
		else
			offset <= offset;
	always @(*) begin
		if (_sv2v_0)
			;
		if ((count < 160) && (offset == 1)) begin
			next_count = count + 1;
			beginSample = 0;
		end
		else begin
			next_count = 0;
			beginSample = 1;
		end
	end
	uart_clk_div UARTclk(
		.MHz10(MHz10),
		.nrst(nrst),
		.en(en),
		.enable((beginSample == 1) && (current_state == 2'd1)),
		.clear(current_state == 2'd0),
		.at_max(baudClk)
	);
	always @(posedge MHz10 or negedge nrst)
		if (~nrst)
			count_current_state <= 0;
		else
			count_current_state <= count_next_state;
	always @(*) begin
		if (_sv2v_0)
			;
		count_next_state = count_current_state;
		if ((beginRx && (current_state == 2'd0)) || (count_current_state == 4'd8))
			count_next_state = 'b0;
		else if (baudClk && (current_state == 2'd1))
			count_next_state = count_current_state + 1;
	end
	ser_to_par register(
		.MHz10(MHz10),
		.nrst(nrst),
		.en(en),
		.enable(baudClk && (current_state == 2'd1)),
		.serial(serIn),
		.parOut(dataOut),
		.clear(current_state == 2'd3)
	);
	initial _sv2v_0 = 0;
endmodule
