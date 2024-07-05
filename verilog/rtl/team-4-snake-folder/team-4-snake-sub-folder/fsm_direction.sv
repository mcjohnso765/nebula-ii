typedef enum logic [2:0] {
    LEFT = 0, RIGHT = 1, UP = 2, DOWN = 3, STOP = 4
} direction_t;

module fsm_direction (
    input logic [3:0] direction_a,
    input logic clk, nrst, sync,
    output logic[2:0] direction
);

    direction_t current, next;

    always_ff @(posedge clk, negedge nrst)
        if(~nrst)
            current <= STOP;
        else
            current <= next;
    
    always_comb begin
        if((direction_a == 4'b0001) && (current != RIGHT))
            next = LEFT;
        else if((direction_a == 4'b0010) && (current != LEFT))
            next = RIGHT;
        else if((direction_a == 4'b0100) && (current != UP))
            next = DOWN;
        else if((direction_a == 4'b1000) && (current != DOWN))
            next = UP;
        else if(sync)
            next = STOP;
        else
            next = current;
    end

    assign direction = current;

endmodule