

module Tx_ext_fsm(

  input logic clk,nrst, transmit_ready,
  input logic msg_tx_ctrl, stop,

  output logic tx_ctrl, count_enable

);

    typedef enum logic [1:0] {IDLE= 0, TRANSFER = 1, STOP= 2} State_t;

    State_t current_state, next_state;
    logic next_tx_ctrl;

    always_ff @(posedge clk, negedge nrst) begin 
        if(!nrst) begin
            current_state <= IDLE;
            tx_ctrl <= 1'b0;
        end
        else begin
            current_state <= next_state; 
            tx_ctrl <= next_tx_ctrl;
        end
    end

    always_comb begin
        next_state = current_state;

        case(current_state) 
            IDLE: begin

                if(msg_tx_ctrl == 0) begin
                    next_state = IDLE;
                end
                else begin
                    next_state = TRANSFER;
                end
            end

            TRANSFER: begin
                if(stop == 0) begin
                   next_state = TRANSFER;
                end
                else begin
                    next_state = STOP;
                end
            end
            STOP: begin 
               next_state = IDLE;
            end
            default:
                next_state = current_state;
        endcase
    end


    always_comb begin

        next_tx_ctrl = 1'b0; 
        count_enable = 0;
        case(current_state)   

            IDLE: begin
                if(msg_tx_ctrl == 0) begin
                    next_tx_ctrl = 0; 
                    count_enable = 0;
                end
                else begin
                    next_tx_ctrl = 0;
                    count_enable = 0;
                end
            end

            TRANSFER: begin
                if(transmit_ready) begin 
                    next_tx_ctrl = 1;
                    count_enable = 1;
                end
                else begin
                    next_tx_ctrl = 0;
                    count_enable = 0;
                end
            end
            STOP: begin 
                next_tx_ctrl = 0;
                count_enable = 0;
            end
            default: begin
                next_tx_ctrl = 1'b0; 
                count_enable = 0;
            end


        endcase
    end

endmodule