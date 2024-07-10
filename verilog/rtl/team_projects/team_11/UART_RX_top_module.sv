module top_RX (
  input logic clk, nrst, rx_din,
  output logic success, receive_ready,
  output logic [7:0]data_receive, 
  output [127:0] msg
);

    logic Reg_Start, Count_Start, new_clk;
    logic falling_edge;
    logic Ready;
    logic no_count;
    logic send;
    logic start;
    logic baud_edge;
    logic [8:0]show_internal;

    RX_idle_counter secondcount(.clk(new_clk), .nrst(nrst), .falling_edge(falling_edge), .max(4'b1001),  .no_count(no_count), .countout());

    RX_shift_register shifting_in(.clk(clk), .nrst(nrst), .Reg_Start(Reg_Start), .receive_ready(send), .Din(rx_din), .data_receive(data_receive), .show_internal(show_internal), .baud_edge(baud_edge));

    RX_counter count(.clk(clk), .nrst(nrst), .count_start(Count_Start), .baud_edge(baud_edge), .max(4'b1001), .atmax(receive_ready));
    
    RX_FSM test(.clk(clk), .nrst(nrst), .receive_ready(receive_ready), .rx_din(rx_din), .falling_edge(falling_edge), .new_clk(new_clk), .Success(success), .Reg_Start(Reg_Start), .Count_Start(Count_Start), .no_count(no_count), .send(send));

    RX_clock_divider baud(.clk(clk), .nrst(nrst), .new_clk(new_clk));

    RX_edge_detect detect(.clk(clk), .nrst(nrst), .signal_in(rx_din), .falling_edge(falling_edge));

    sr_rx rx_register(.clk(clk), .nrst(nrst), .receive_ready(send), .data_receive(data_receive), .new_clk(new_clk), .msg(msg));

    RX_baud_edge_detect baud_detect(.clk(clk), .nrst(nrst), .signal_in(new_clk), .baud_edge(baud_edge));

endmodule

module RX_idle_counter(
    input logic clk, nrst, falling_edge,
    input logic [3:0]max,  
    output logic no_count,
    output logic [3:0] countout
  );
    logic [3:0]nextcount;

    always_ff @(posedge clk, negedge nrst)begin
        if (!nrst)begin
            countout <= '0;
        end
        else begin
            countout <= nextcount;
        end
    end

    always_comb begin
        no_count = 1'b0;
        if (falling_edge == 1'b1)begin
            nextcount = 4'b0;
        end
        else begin
            if (countout == max)begin
                no_count = 1'b1;
                nextcount = 4'b0;
            end
            else begin
                nextcount = countout + 1'b1;
                no_count = 1'b0;
            end
        end
    end
endmodule

module RX_shift_register (
    input logic clk, nrst, Reg_Start, Din, receive_ready, baud_edge,
    output logic [7:0]data_receive, 
    output logic [8:0]show_internal
  );
    logic [8:0] internal_shift_register;
    logic [8:0] shifted_data;

    always_ff @(posedge clk, negedge nrst) begin
        if (!nrst)
            shifted_data <= 9'b0; 
        else
            shifted_data <= internal_shift_register;
    end

    always_comb begin
        internal_shift_register = 9'b0;
        if (receive_ready == 1) begin
            data_receive = {shifted_data[8:1]};
        end 
        else begin
            if (Reg_Start == 1'b1)begin
                if(baud_edge == 1'b1)begin
                    internal_shift_register = {internal_shift_register[7:0], Din}; 
                    data_receive = 8'b0;
                end
                else begin
                    internal_shift_register = internal_shift_register;
                    data_receive = 8'b0;
                end
            end
            else begin
                internal_shift_register = 9'b0;   
                data_receive = 8'b0;            
            end
        end
    end
    assign show_internal = internal_shift_register;
endmodule

module RX_counter(
    input logic clk, nrst, count_start, baud_edge,
    input logic [3:0]max,  
    output logic atmax
  );
    logic [3:0]nextcount, countout;

    always_ff @(posedge clk, negedge nrst)
    if (!nrst)begin
        countout <= '0;
        atmax <= 1'b0;
    end
    else begin
        countout <= nextcount;
        if(countout == max)begin
            atmax <= 1'b1;
        end
        else begin
            atmax <= 1'b0;
        end
    end
    
    always_comb begin
        if(count_start == 1'b1)begin
            if(baud_edge == 1'b1)begin
                if (countout == max)begin
                    nextcount = 4'b0;
                end
                else begin  
                    nextcount = countout + 4'b0001;
                end
            end
            else begin
                nextcount = countout;
            end
        end
        else begin
            nextcount = 4'b0;
        end
    end
endmodule

module RX_FSM(
    input logic clk, nrst, receive_ready, no_count, rx_din, falling_edge, new_clk,
    output logic Success, Reg_Start, Count_Start, send
  );

    typedef enum logic[2:0] {IDLE, RECEIVING, STOP} turnstile_t;
    turnstile_t current_state, next_state;

    always_ff@(posedge clk, negedge nrst) begin
	    if (!nrst)
		    current_state <= IDLE;
        else 
		    current_state <= next_state;
    end

    always_comb begin
	    case(current_state)
		    IDLE: begin
                send = 1'b0;
                if(rx_din == 1'b0)begin
                    if(falling_edge == 1'b1)begin
                        next_state = current_state;
                        Reg_Start = 1'b0;
                        Count_Start = 1'b0;
                    end
                    else begin
                        if(new_clk == 1'b1) begin
                            Reg_Start = 1'b1;
                            Count_Start = 1'b1;
                            next_state = RECEIVING;
                        end
                        else begin
                            next_state = current_state;
                            Reg_Start = 1'b0;
                            Count_Start = 1'b0;
                        end
                    end
                end
                else begin
                    next_state = current_state;
                    Reg_Start = 1'b0;
                    Count_Start = 1'b0;
                end
            end
		    RECEIVING: begin
                Count_Start = 1'b1;
                Reg_Start = 1'b1;
                if(no_count == 1'b1)begin
                    next_state = IDLE;
                    Reg_Start = 1'b0;
                    Count_Start = 1'b0;
                    Success = 1'b0;
                    send = 1'b0;
                end
                else begin
                    if(new_clk == 1'b1)begin
                        if(receive_ready == 1'b1)begin
                            send = 1'b1;
                            Success = 1'b1;
                            next_state = STOP;
                            Count_Start = 1'b0;
                            Reg_Start = 1'b0;
                        end
                        else begin
                            Count_Start = 1'b1;
                            Reg_Start = 1'b1;
                            send = 1'b0;
                            next_state = current_state;
                            Success = 1'b0;
                        end
                    end
                    else begin
                        next_state = current_state;
                        Count_Start = 1'b0;
                        Reg_Start = 1'b0;
                        send = 1'b0;
                        Success = 1'b0;
                    end
                end
            end
            STOP: begin
                if(new_clk == 1'b1)begin
                    send = 1'b0;
                    Count_Start = 1'b0;
                    Reg_Start = 1'b0;
                    Success = 1'b0;
                    next_state = IDLE;
		        end
                else begin
                    next_state = current_state;
                end
            end
            default: begin
                Success = 1'b0;
                Reg_Start = 1'b0;
                Count_Start = 1'b0;
                next_state = current_state;
                send = 1'b0;
            end
        endcase
    end
endmodule

module RX_clock_divider (
  input logic clk, nrst,
  output logic new_clk
  );

  parameter OG_CLK = 240000;
  parameter BAUD_RATE = 9600;
  parameter DIV_FACTOR = OG_CLK / BAUD_RATE;

  parameter N = 32;

  logic next_clk;
  logic [N-1:0]count;
  logic [N-1:0]next_count;

  always_ff @(posedge clk, negedge nrst) begin 
    if(!nrst) begin
      count <= 0;
      new_clk <= 1;
    end 
    else begin
      count <= next_count;
      new_clk <= next_clk;
    end
  end

  always_comb begin
    next_clk = 0;
    next_count = count + 1;

    if (count == DIV_FACTOR -1) begin
      next_count = 0;
      next_clk = 1;
    end
  end
endmodule

module RX_edge_detect (
    input logic clk, nrst, signal_in,
    output logic falling_edge
  );

    logic prev_sig;

    always_ff @(posedge clk, negedge nrst) begin
        if(!nrst)begin
            prev_sig <= 1'b1;
        end
        else begin
            prev_sig <= signal_in;
            if(~signal_in && prev_sig) begin
                falling_edge = 1'b1;
            end
            else begin
                falling_edge = 1'b0;
            end
        end
    end
endmodule

module sr_rx(
    input logic clk,
    input logic nrst,
    input logic new_clk,
    input logic receive_ready,
    input logic [7:0] data_receive,
    output logic [127:0] msg
  );

    logic [127:0] shift_register;
    logic [127:0] shift_register_buffer;

    always_ff @(posedge clk or negedge nrst) begin 
        if (!nrst) begin
            shift_register <= 128'd0;
            shift_register_buffer <= 128'd0;
        end else begin
            if(receive_ready && new_clk) begin
                shift_register <= (shift_register << 8) | {120'b0,data_receive};
            end
            else begin 
                shift_register <= shift_register;
            end
            shift_register_buffer <= shift_register;
        end
    end

    always_comb begin
        msg = shift_register_buffer;
    end
endmodule

module RX_baud_edge_detect (
    input logic clk, nrst, signal_in,
    output logic baud_edge
  );

    logic prev_sig;

    always_ff @(posedge clk, negedge nrst) begin
        if(!nrst)begin
            prev_sig <= 1'b0;
        end
        else begin
            prev_sig <= signal_in;
            if(signal_in && ~prev_sig) begin
                baud_edge = 1'b1;
            end
            else begin
                baud_edge = 1'b0;
            end
        end
    end
endmodule