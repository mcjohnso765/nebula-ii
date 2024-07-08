
module fsm_direction (
    input logic [3:0] direction_a,
    input logic clk, nrst, sync, pulse,
    output logic [2:0] direction
);

    logic [2:0] current, temp, temp_next, next;

    always_ff @(posedge clk, negedge nrst)
        if(~nrst) begin
            current <= STOP;
            temp <= STOP;
        end
        else begin
            current <= next;
            temp <= temp_next;
        end
    
    always_comb begin
        if((direction_a == 4'b0001) && (current != RIGHT))
            temp_next = LEFT;
        else if((direction_a == 4'b0010) && (current != LEFT))
            temp_next = RIGHT;
        else if((direction_a == 4'b0100) && (current != UP))
            temp_next = DOWN;
        else if((direction_a == 4'b1000) && (current != DOWN))
            temp_next = UP;
        else if(sync)
            temp_next = STOP;
        else
            temp_next = temp;
            
        if(pulse)
            next = temp;
        else
            next = current;
    end

    assign direction = current;

endmodule