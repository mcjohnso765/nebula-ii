module t10_msg_reg (
    input logic clk, nRst, ready, transmit_ready,
    input logic [7:0] data,
    output logic blue, tx_ctrl,
    output logic [7:0] tx_byte
);

typedef enum logic [1:0] {
IDLE = 2'b00, WAIT = 2'b01, TRANSMIT = 2'b11
} curr_state;


logic [7:0] msg, msg_rdy;
curr_state state, next_state;

always_ff @(posedge clk, negedge nRst) begin
    if (~nRst) begin 
        msg <= 8'b0;
        state <= IDLE;
    end else begin 
        msg <= msg_rdy;
        state <= next_state;
    end
end

always_comb begin 
    next_state = state;

    case (state)
        IDLE: begin 
            tx_byte = msg;
            tx_ctrl = 0;
            blue = 1'b0;
            if (ready) begin
                msg_rdy = data;
                next_state = WAIT;
            end else
                msg_rdy = msg;
        end
        WAIT: begin 
            tx_ctrl = 1;
            tx_byte = msg;
            blue = 1'b0;
            msg_rdy = msg;
            if (transmit_ready)
                next_state = TRANSMIT;
            else  
                next_state = WAIT;
        end
        TRANSMIT: begin
            msg_rdy = msg;
            tx_byte = msg;
            tx_ctrl = 1;
            blue = 1'b1;
            next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
            tx_byte = 8'b0;
            blue = 1'b0;
            tx_ctrl = 0;
            msg_rdy = 0;
        end
    endcase
end
endmodule
