module t10_host_msg_reg (
    input logic clk, nRst, toggle_state, key_ready, gameEnd_host,
    input logic [7:0] setLetter,
    output logic rec_ready,
    output logic [39:0] temp_word
);

    typedef enum logic { 
        SET = 1'b0, COMPARE = 1'b1
    } casestate;
    casestate Cstate, next_state;

logic [39:0] next_temp_word;

always_ff @(posedge clk, negedge nRst) begin
    if(~nRst) begin
        temp_word <= 40'b0101111101011111010111110101111101011111;
        Cstate <= SET;
    end
    else begin
        temp_word <= next_temp_word;
        Cstate <= next_state;
    end
end

always_comb begin
    case(Cstate)
        SET: begin 
            rec_ready = 0;
            if (key_ready)
                next_temp_word = {temp_word[31:0], setLetter};
            else
                next_temp_word = temp_word;

            if (toggle_state) begin
                next_state = COMPARE;
            end else 
                next_state = SET;
        end
        COMPARE: begin
            rec_ready = 1;
            next_temp_word = temp_word;
            next_state = COMPARE;
        end
    endcase
    if (gameEnd_host) begin
        next_state = SET;
        rec_ready = 0;
        next_temp_word = 40'b0101111101011111010111110101111101011111;
    end
end 
endmodule
