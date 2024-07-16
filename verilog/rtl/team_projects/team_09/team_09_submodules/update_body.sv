module update_body #(parameter MAX_LENGTH = 50)
(
    input logic clk, nrst, pulse, sync,
    input logic [2:0] direction, 
    input logic [7:0] curr_length,
    output logic [MAX_LENGTH - 1:0][7:0] body,
    output logic [7:0] head
);

logic [MAX_LENGTH - 1:0][7:0] current, next;
logic [3:0] head_x, head_y;  // Adjusting bit-width for head_x and head_y
generate
    for (genvar i = 0; i < MAX_LENGTH; i = i + 1) begin
        always_ff @(posedge clk or negedge nrst) begin
            if (~nrst) begin
                if (i == 0) begin
                    current[i] <= 8'h45;
                end else begin
                    current[i] <= 8'b0;
                end
            end else begin
                current[i] <= next[i];
            end
        end
    end
endgenerate

always_comb begin
    head_x = current[0][7:4];
    head_y = current[0][3:0];

    case (direction)
        LEFT: begin  
            head_x = current[0][7:4] - 4'd1;
            head_y = current[0][3:0];
        end
        RIGHT: begin 
            head_x = current[0][7:4] + 4'd1;
            head_y = current[0][3:0];
        end
        DOWN: begin  
            head_y = current[0][3:0] + 4'd1;
            head_x = current[0][7:4];
        end
        UP: begin   
            head_y = current[0][3:0] - 4'd1;
            head_x = current[0][7:4];
        end
        default: begin
            head_x = current[0][7:4];
            head_y = current[0][3:0];
        end
    endcase

    if (sync) begin
        for (integer i = 0; i < MAX_LENGTH; i = i + 1) begin
            if (i == 0) begin
                next[i] = 8'h45;
            end else begin
                next[i] = 8'b0;
            end
        end
    end 
    else if (pulse) begin
        for(integer i = MAX_LENGTH - 1; i >= 0; i = i - 1) begin
        if(i == 0) begin
            next[0] = {head_x, head_y};
        end
        else if(i <= curr_length) begin
            next[i] = current[i - 1];
        end
        else begin
            next[i] = 8'b0;
        end
        end
    end 
    else begin
        next = current;
    end
end

assign body = current;
assign head = {head_x, head_y};

endmodule