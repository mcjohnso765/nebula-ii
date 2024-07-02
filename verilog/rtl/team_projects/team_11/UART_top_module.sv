module top (
  input logic clk, rst, rx_din, rx_start,
  output logic success, receive_ready,
  output logic [7:0]data_receive
);

    logic Reg_Start, Count_Start, new_clk;
    logic [7:0]din, show_internal, falling_edge;
    logic Ready;


    shift_register shifting_in(.clk(clk), .rst(rst), .Reg_Start(Reg_Start), .Ready(receive_ready), .falling_edge(falling_edge), .Din(rx_din), .data_receive(data_receive), .show_internal(show_internal));

    counter count(.clk(clk), .rst(rst), .count_start(Count_Start), .falling_edge(falling_edge), .max(4'b1010), .atmax(receive_ready));
    
    FSM test(.clk(clk), .rst(rst), .Start(rx_start && new_clk), .Ready_Sig(receive_ready), .falling_edge(falling_edge),
    .state_check(), .Success(success), .Reg_Start(Reg_Start), .Count_Start(Count_Start));

    //FSM_regi inst(.clk(clk), .rst(rst), .Ready(receive_ready), .Din(din), .data_receive(data_receive), .key_status(key_status), .ready_signal(rx_start));

    clock_divider baud(.clk(clk), .rst(rst), .new_clk(new_clk));

    edge_detect detect(.clk(clk), .rst(rst), .signal_in(rx_din), .Ready(receive_ready), .falling_edge(falling_edge));

endmodule

module clock_divider (
  input logic clk, rst,
  output logic new_clk
);

  parameter OG_CLK = 240000;
  parameter BAUD_RATE = 9600;
  parameter DIV_FACTOR = OG_CLK / BAUD_RATE;

  parameter N = 32;

  logic next_clk;
  logic [N-1:0]count;
  logic [N-1:0]next_count;

  always_ff @(posedge clk, negedge rst) begin 
    if(rst) begin
      count <= 0;
      new_clk <= 1;
    end 
    else begin
      count <= next_count;
      new_clk <= next_clk;
    end
  end

  always_comb begin
    next_clk = new_clk;
    next_count = count + 1;

    if (count == DIV_FACTOR -1) begin
      next_count = 0;
      next_clk = ~new_clk;
    end
  end
endmodule

module counter(
    input logic clk, rst, count_start, falling_edge, receive_ready, //count_start is connected to the count_start from FSM
    input logic [3:0]max,  // We will set the max to 8, or 1000 in binary in the top module
    output logic atmax, //the ready signal will be based on this
    output logic [3:0]countout
);
    logic [3:0]nextcount; //this will lead to nowehere, so probably be left open in the top instantuation 

    always_ff @(posedge clk, negedge rst)
      if (rst)
        countout <= '0;
      else
        countout <= nextcount;

    always_comb begin
        if(count_start == 1'b1)begin
            nextcount = countout + 4'b0001;
            atmax = 1'b0;
            if (countout == max)begin
                nextcount = 4'b0;
                atmax = 1'b1;
            end
        end
        else begin
            nextcount = 0;
        end
    end
endmodule

module edge_detect (
    input logic clk, rst, signal_in, Ready,
    output logic falling_edge
);

    logic prev_sig;

    always_ff @(posedge clk, posedge rst) begin
        if(rst)begin
            prev_sig = 1'b1;
        end
        else begin
            prev_sig = signal_in;
        end
    end

    always_comb begin
        if(~signal_in && prev_sig) begin
            falling_edge = 1'b1;
        end
        else begin
            if(Ready == 1)begin
                falling_edge = 1'b0;
            end
        end
    end
endmodule

module FSM(
    input logic clk, rst, Start, Ready_Sig, falling_edge,
    output logic [2:0]state_check,
    output logic Success, Reg_Start, Count_Start
);

    typedef enum logic[2:0] {IDLE, RECEIVING, STOP} turnstile_t;
    turnstile_t current_state, next_state;

    always_ff@(posedge clk, posedge rst) begin
	    if (rst)
		    current_state <= IDLE;
      else 
		    current_state <= next_state;
    end

    always_comb begin
	    case(current_state)
		    IDLE: begin
                Success = 1;
			    if (Start == 1) begin
				    next_state = RECEIVING;
                end
			    else begin
				    next_state = current_state;
			    end
                state_check = current_state;
		    end
		    RECEIVING: begin
                if (falling_edge == 1)begin
                    Count_Start = 1;
                    Reg_Start = 1;
                    Success = 0;
                    if (Ready_Sig == 1'b1) begin 
                        next_state = STOP;
                    end
                    else begin
                        next_state = current_state;
                    end
                end
			    if (falling_edge == 1'b0) begin
				    next_state = STOP;
                    Success = 1;
                end
            end
            STOP: begin
                Count_Start = 0;
                Reg_Start = 0;
                Success = 1;
			    next_state = IDLE;
                state_check = current_state;
		    end
        endcase
    end
endmodule

module shift_register (
    input logic clk, rst, Reg_Start, Ready, Din, falling_edge,
    output logic [7:0] data_receive, show_internal
);
    logic [9:0] internal_shift_register;

    always_ff @(posedge clk, posedge rst) begin
        if (rst)
            internal_shift_register <= 10'b0; // Reset internal shift register
        else
            if (Reg_Start == 1'b1) begin
                internal_shift_register <= {Din, internal_shift_register[9:1]}; // Shift data
            end
            else begin
                internal_shift_register <= 10'b0;
            end
    end

    always_comb begin
        if (Ready == 1) begin
            data_receive = {internal_shift_register[8:1]}; // Set data_receive when sync key detected
        end 
        else begin
            data_receive = 10'b0; // Clear data_receive if not ready
        end
        assign show_internal = internal_shift_register; 
    end
endmodule
