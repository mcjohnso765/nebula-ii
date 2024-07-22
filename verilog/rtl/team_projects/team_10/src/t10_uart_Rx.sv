module t10_uart_Rx
#(
    parameter Clkperbaud = 1041
)

(
    input logic clk, nRst, rx_serial, rec_ready,
    output logic rx_ready,
    output logic [7:0] rx_byte,
    output logic error_led
);


typedef enum logic [2:0] {
IDLE = 3'b001, START = 3'b010, DATAIN = 3'b011, STOP = 3'b100, CLEAN = 3'b101, PARITY = 3'b110
} curr_state;

logic [7:0] temp_byte;
logic [2:0] bit_index, next_bit_index;  
curr_state state, next_state;
logic [10:0] clk_count, next_clk_count;
logic [3:0] pcount, count;
logic pbit;
logic next_err;


always_ff @(posedge clk, negedge nRst) begin
    if (~nRst) begin
        rx_byte <= 0;
        state <= IDLE;
        clk_count <= 0;
        bit_index <= 0;
        count <= 0;
        error_led <= 0;
    end else begin
        state <= next_state;
        rx_byte <= temp_byte;
        clk_count <= next_clk_count;
        bit_index <= next_bit_index;
        count <= pcount; 
        error_led <= next_err;
    end
end

always_comb begin
    temp_byte = rx_byte;

    pbit = 0;
    case (state)
        IDLE: begin
            next_err = error_led;
            rx_ready = 0;
            next_bit_index = 0;
            temp_byte = 0;
            next_clk_count = 0;
            pcount = 0;

            if (rx_serial == 0 && rec_ready)
                next_state = START;
            else
                next_state = IDLE;
        end
        START: begin
            rx_ready = 0;
            temp_byte = 0;
            next_bit_index = 0;
            pcount = 0;
            next_err = 0;
            if(clk_count == (Clkperbaud - 1)/2) begin
                if (rx_serial == 0 && rec_ready) begin
                    next_clk_count = 0;
                    next_state = DATAIN;
                end
                else begin
                    next_clk_count = clk_count +1;    
                    next_state = IDLE;
                end
            end
            else begin 
                next_clk_count = clk_count +1 ;
                next_state = START;
            end
        end
        DATAIN: begin
            temp_byte[bit_index] = rx_serial;
            rx_ready = 0;
            next_err = 0;
            if(clk_count < Clkperbaud - 1) begin
            next_clk_count = clk_count + 1;
            next_state = DATAIN;
            next_bit_index = bit_index;
            pcount = count;
            end
            else begin

            if(temp_byte[bit_index] == 1) begin // parity counter counts 1s
            pcount = count + 1;
            end
            else begin
            pcount = count;
            end
            
            next_clk_count = 0;
            
            if (bit_index < 7) begin
                next_bit_index = bit_index + 1;
                next_state = DATAIN;
            end else begin
                next_bit_index = 0;
                next_state = STOP;
            end
            end
        end
        // PARITY: begin 
        //     pbit =  rx_serial;
        //     pcount = count;
        //     rx_ready = 0;
        //     temp_byte = rx_byte;
        //     next_bit_index = 0;

        //     if(clk_count < Clkperbaud - 1) begin
        //     next_clk_count = clk_count + 1;
        //     next_state = PARITY;
        //     next_err = 0;
        //     end
        //     else begin 
        //     if ((pcount % 2 == 1) && (pbit == 0)) begin
        //     next_err = 1;
        //     next_clk_count = 0;
        //     next_state = CLEAN; // state transition logic
        //     end
        //     else if((pcount % 2 == 0) && (pbit == 1)) begin
        //     next_err = 1;
        //     next_clk_count = 0;
        //     next_state = CLEAN; // state transition logic
        //     end
        //     else 
        //     next_err = 0;
        //     next_clk_count = 0;
        //     next_state = STOP;
        //     end
        // end
        STOP: begin
            next_err = error_led;
            if(clk_count < Clkperbaud - 1) begin
            next_clk_count = clk_count + 1;
            next_state = STOP;
            end
            else begin
            next_clk_count = 0;
            next_state = CLEAN; // state transition logic
            end

            rx_ready = 1;
            temp_byte = 0;
            next_bit_index = 0; 
            pcount = 0;
        end
        CLEAN: begin 
            next_err = error_led;
            pcount = 0;
            next_clk_count = 0;
            rx_ready = 0;
            temp_byte = 0;
            next_bit_index = 0;
            next_state = IDLE;
        end
        default: begin
            next_clk_count = 0;
            rx_ready = 0;
            temp_byte = 0;
            next_bit_index = 0;
            next_state = IDLE;
            pcount = 0;
            next_err = 0;
        end
    endcase
end
endmodule
