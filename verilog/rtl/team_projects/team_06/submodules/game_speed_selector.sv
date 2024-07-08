

// typedef enum logic [1:0] {
//         NORMAL_SPEED = 2'b00,
//         FAST_SPEED = 2'b01, 
//         SLOW_SPEED = 2'b10
//     } GAME_SPEED; 


// typedef enum logic [1:0] {
//         RUN = 2'b00,
//         WAIT = 2'b01, 
//         PAUSE = 2'b10,
//         END_GAME = 2'b11
//     } GAME_STATE; 


module game_speed_selector (
    input logic button, nrst, system_clk, 
    input GAME_STATE state,
    output GAME_SPEED game_speed
);

GAME_MODE Qa,Qna;

always_comb begin 
    case (Qa)
        NORMAL_SPEED: Qna = FAST_SPEED;
        FAST_SPEED: Qna = SLOW_SPEED;
        SLOW_SPEED: Qna = NORMAL_SPEED;
        default: Qna = NORMAL_SPEED;
    endcase

    if (state != WAIT) begin
        Qna = Qa;
    end
end

always_ff @(negedge nrst, posedge system_clk) begin
    if (~nrst) begin
        Qa <= NORMAL_SPEED;
    end else if (button) begin
        //if (state == WAIT) begin
        Qa <= Qna;
        //end
        //else begin
         //   Qa <= Qa;
    //end
end
else begin
    Qa <= Qa;
end
end
always_comb begin
    game_speed = Qa;
end


endmodule