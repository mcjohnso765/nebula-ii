
// typedef enum logic [1:0] {
//         APPLE_NORMAL = 2'b00,
//         APPLE_LUCKY = 2'b01, 
//         APPLE_UNLUCKY = 2'b10
//     } APPLE_LUCK; 

// typedef enum logic [1:0] {
//         RUN = 2'b00,
//         WAIT = 2'b01, 
//         PAUSE = 2'b10,
//         END_GAME = 2'b11
//     } GAME_STATE; 


module apple_luck_selector (
    input logic button, nrst, clk,
    input GAME_STATE state,
    output APPLE_LUCK apple_luck
);

GAME_MODE Qa;
GAME_MODE Qna;

always_comb begin 
    case (Qa)
        APPLE_NORMAL: Qna = APPLE_LUCKY;
        APPLE_LUCKY: Qna = APPLE_UNLUCKY;
        APPLE_UNLUCKY: Qna = APPLE_NORMAL;
        default: Qna = APPLE_NORMAL;
    endcase

    if (state != WAIT) begin
        Qna = Qa;
    end

end

always_ff @(negedge nrst, posedge clk) begin
    if (~nrst) begin
        Qa <= APPLE_NORMAL;
    end else if (button) begin
        //if (state == WAIT) begin
        Qa <= Qna;
        //end
        //else begin
         //   Qa<= Qa;
    //end
    end
    else begin
    Qa <= Qa;
    end
end
always_comb begin
    apple_luck = Qa;
end


endmodule