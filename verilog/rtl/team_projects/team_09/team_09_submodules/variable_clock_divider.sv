typedef enum logic [1:0]{
    TURTLE = 0, SLOW = 1, FAST = 2 
} mode_t;

module variable_clock_divider (
    input logic clk, nrst, button,
    output logic adjusted_clk
);

logic button_a, signal, pulse;
logic [1:0] mode;
logic [22:0] count, next_count;
logic [22:0] MAX_COUNT;


synchronizer synch(.button(button), .clk(clk), .nrst(nrst), .signal(signal));
edge_detect detect(.signal(signal), .clk(clk), .nrst(nrst), .change_state(button_a));
fsm_mode fsm(.signal(button_a), .clk(clk), .nrst(nrst), .mode(mode));

always_ff @(posedge clk, negedge nrst)
    if(~nrst)
        count <= 0;
    else 
        count <= next_count;

always_comb begin
    case(mode)
    FAST: 
        MAX_COUNT = 750000;
    SLOW:
        MAX_COUNT = 1500000;
    TURTLE: 
        MAX_COUNT = 2000000;
    default: 
        MAX_COUNT = 2000000;
    endcase
    
    if(count >= (MAX_COUNT - 1)) begin
        pulse = 1;
        next_count = 0;
    end
    else begin
        pulse = 0;
        next_count = count + 23'b1;
    end
end

assign adjusted_clk = pulse;

endmodule