module location_check #(parameter MAX_LENGTH = 50) (
    input logic [7:0] coordinate,
    input logic [MAX_LENGTH - 1: 0][7:0] body,
    input logic [6:0] curr_length,
    output logic snakeBody, snakeHead
);

logic snake_head, snake_body;


always_comb begin
    snake_head = 1'b0;
    snake_body = 1'b0;
    for(integer i = 0; i < MAX_LENGTH; i = i + 1) begin
        if(i == 0) begin
            if(body[0] == coordinate) begin
            snake_head = 1'b1;
            end
        end
        else if(i <= curr_length) begin
            if(body[i] == coordinate) begin
            snake_body = 1'b1;
            end
        end
    end
end


assign {snakeHead, snakeBody} = {snake_head, snake_body};
endmodule