// typedef enum logic [1:0] {
//         RUN = 2'b00,
//         WAIT = 2'b01, 
//         PAUSE = 2'b10,
//         END_GAME = 2'b11
//     } GAME_STATE; 

// typedef enum logic [1:0] {
//         TWO_APPLE = 2'b00,
//         NORMAL_MODE = 2'b01, 
//         WALL_SPAWN = 2'b10
//     } GAME_MODE; 


module gameMode (
    input logic button, nrst, system_clk,
    input GAME_STATE state,
    output GAME_MODE mode
);

GAME_MODE Qa, Qn;

always_comb begin 
    case (Qa)
        NORMAL_MODE: Qn = TWO_APPLE;
        TWO_APPLE: Qn = WALL_SPAWN;
        WALL_SPAWN: Qn = BORDER_CHANGE;
        BORDER_CHANGE: Qn = NORMAL_MODE;
        default: Qn = NORMAL_MODE;
    endcase


end

always_ff @( negedge nrst, posedge system_clk) begin //posedge button, 
    if (~nrst) begin
        Qa <= NORMAL_MODE;
    end 
    else if (button) begin
        if (state == WAIT) begin
        Qa <= Qn;
        end
        else begin
            Qa<= Qa;
        end
    end
else begin
    Qa <= Qa;
end
end
always_comb begin
    mode = Qa;
end


endmodule