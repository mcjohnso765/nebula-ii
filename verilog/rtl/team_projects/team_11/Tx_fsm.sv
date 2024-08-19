
module Tx_fsm(

  input logic clk,nrst,tx_ctrl, ready_signal,
  input logic bit_out,
    input logic msg_tx_ctrl,
  output logic tx_dout,
  output logic success,
  output logic enable_t, enable_s,
  output logic transmit_ready,
  output logic [1:0] current_state
);

    typedef enum logic [1:0] {IDLE= 0, TRANSFER = 1, STOP= 2} State_t;

    logic nxt_enable_t;
    logic nxt_enable_s;

    State_t next_state;

    always_ff @(posedge clk, negedge nrst) begin 
        if(!nrst) begin
            current_state <= IDLE;
            enable_t <= 0; 
            enable_s <= 0;
        end
        else begin
            current_state <= next_state; 
            enable_t <= nxt_enable_t; 
            enable_s <= nxt_enable_s;
        end
    end

    always_comb begin
        success = 1;
        nxt_enable_t = enable_t;
        nxt_enable_s = enable_s;

        next_state = current_state;
        tx_dout = 1;
        transmit_ready = 1;

        case(current_state) 
            IDLE: begin
                if(tx_ctrl == 0) begin
                    next_state = IDLE;
                    transmit_ready = 1;
                    nxt_enable_t = 0; 
                    nxt_enable_s = 0;
                    success = 1;
                end
                else begin
                    next_state = TRANSFER;
                    nxt_enable_t = 1; 
                    nxt_enable_s = 1;
                    transmit_ready = 0;
                    success = 0;
                end
            end

            TRANSFER: begin
                tx_dout = bit_out;
                nxt_enable_t = 1; 
                nxt_enable_s = 1;
                success = 0;
                transmit_ready = 0; 

                if(ready_signal == 1) begin
                    transmit_ready = 0;
                   next_state = STOP;
                end
                else begin
                    // success = 0;
                    // transmit_ready = 0; 
                    transmit_ready = 0;
                    next_state = TRANSFER;
                end
            end

            STOP: begin 
               transmit_ready = 1; 
               nxt_enable_t = 0; 
               nxt_enable_s = 0;
               next_state = IDLE;
                success = 1;
            end
            default: begin
                success = 1;
                nxt_enable_t = enable_t;
                nxt_enable_s = enable_s;

                next_state = current_state;
                tx_dout = 1;
                transmit_ready = 1;
            end
        endcase
    end

endmodule