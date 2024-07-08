typedef enum logic [1:0] { 
    INIT = 0, LOOP = 1, UPDATE = 2, OVER = 3
} control_state_t;

module fsm_control (
    input logic GameOver, cmd_done, diff, clk, nrst, mode_pb,
    output logic enable_loop, init_cycle, en_update, sync_reset
);

control_state_t current, next;
logic sync, detect;

synchronizer button5(.button(mode_pb), .clk(clk), .nrst(nrst), .signal(sync));
edge_detect detect4(.signal(sync), .clk(clk), .nrst(nrst), .change_state(detect));



always_ff @(posedge clk, negedge nrst) begin
    if(~nrst)
        current <= INIT;
    else
        current <= next;
end

always_comb begin
    init_cycle = 1'b0;
    en_update = 1'b0;
    enable_loop = 1'b0;
    sync_reset = 1'b0;
    case (current)
        INIT: begin
            if(cmd_done) begin
                next = LOOP;
                init_cycle = 1'b0;
            end
            else begin
                next = INIT;
                init_cycle = 1'b1;
            end
        end
        LOOP: begin
            if(diff) begin
                next = UPDATE;
                enable_loop = 1'b0;
            end
            else if(GameOver) begin
                next = OVER;
                enable_loop = 1'b0;
            end
            else begin
                next = LOOP;
                enable_loop = 1'b1;
            end
        end
        UPDATE: begin
            if(cmd_done) begin
                next = LOOP;
                en_update = 1'b0;
            end
            else if(GameOver) begin
                next = OVER;
                en_update = 1'b0;
            end
            else begin
                next = UPDATE;
                en_update = 1'b1;
            end
        end
        OVER: begin
            if(detect) begin
                next = INIT;
                sync_reset = 1'b0;
            end
            else 
                next = OVER;
                sync_reset = 1'b1;
        end
    
    endcase
end



endmodule