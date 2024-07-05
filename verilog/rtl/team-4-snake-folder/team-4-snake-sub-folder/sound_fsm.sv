typedef enum logic {
    OFF = 1'b0,
    ON = 1'b1
} MODE_TYPES;

module sound_fsm(
    input logic clk, nRst, goodColl, badColl, button,
    input logic [3:0] direction,
    output logic playSound,
    output MODE_TYPES mode_o // current state
);
MODE_TYPES next_state;
logic next_playSound;
always_ff @(posedge clk, negedge nRst) begin
    if (~nRst) begin
        mode_o <= ON;
        playSound <= 0;
    end else begin
        mode_o <= next_state;
        playSound <= next_playSound;
    end
end

always_comb begin
    next_playSound = playSound;
    next_state = mode_o;
    if (mode_o == ON) begin
        if (button) begin
            next_state = OFF;
        end
        next_playSound = (goodColl || badColl || |direction) ? 1'b1 : 1'b0;
    end else begin
        if (button) begin
            next_state = ON;
        end
        next_playSound = 1'b0;
    end
end
   
endmodule
