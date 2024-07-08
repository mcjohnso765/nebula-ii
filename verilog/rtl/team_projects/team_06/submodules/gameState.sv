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

module gameState (
    input logic button, badCollision, clk, nrst,
    input GAME_MODE gameMode,
    output GAME_STATE state
);

GAME_STATE Q, Qn;

always_comb begin
    case (Q)
        WAIT: Qn = ((button == 1)) ? RUN : WAIT;
        RUN: Qn = ((button == 1) && (badCollision == 0)) ? PAUSE : badCollision ? END_GAME : RUN;
        PAUSE: Qn = ((button == 1) && (badCollision == 0)) ? RUN : badCollision ? END_GAME : PAUSE;
        END_GAME: Qn = ((button == 1)) ? WAIT : END_GAME;
        default: Qn = WAIT;
    endcase
end 

always_ff @(posedge clk, negedge nrst) begin
    if (~nrst) begin
        Q <= WAIT;
    end else begin
        Q <= Qn;
    end
end

always_comb begin
    state = Q;
end


endmodule