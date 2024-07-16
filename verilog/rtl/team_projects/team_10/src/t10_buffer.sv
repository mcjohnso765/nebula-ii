module t10_buffer (
    input logic [7:0] Rx_byte,
    input logic rx_ready, game_rdy, clk, nRst,
    output logic [7:0] guess
);
    logic [7:0] temp_guess, next_byte;

    always_ff @(posedge clk, negedge nRst)
        if (~nRst)    
            temp_guess <= 0;
        else 
            temp_guess <= next_byte;

    always_comb begin
        if (rx_ready)
            next_byte = Rx_byte;
        else 
            next_byte = temp_guess;

        if (game_rdy)
            guess = temp_guess;
        else    
            guess = 0;
    end
endmodule
