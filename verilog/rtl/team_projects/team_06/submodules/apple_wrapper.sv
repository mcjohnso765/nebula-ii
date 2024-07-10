module apple_wrapper( 
input logic system_clk, clk_body, nreset, good_collision, good_collision2,
input APPLE_LUCK apple_luck,
input logic [3:0] snake_head_x, snake_head_y, xmax, xmin, ymax, ymin,
input logic [MAX_LENGTH - 1:0] [3:0] snakeArrayX, snakeArrayY,
input logic enable_in, //enable for two apple mode (game_mode == TWO_APPLE)
input logic [3:0] x,y,
input logic [24:0] [7:0] wall_locations,
output logic apple,
output logic [7:0] apple_location1, apple_location2
);
logic [7:0] out_random, out_random_2, apple_location2a;
logic enablea2, enablea;
parameter MAX_LENGTH = 30;

two_apple_mode twoapples (.good_collision(good_collision2), .enable_in(enable_in), .system_clk(system_clk), .nreset(nreset), .apple_luck(apple_luck), 
.snake_head_x(snake_head_x), .snake_head_y(snake_head_y), .snakeArrayX(snakeArrayX), .snakeArrayY(snakeArrayY), .XMAX(xmax), 
.XMIN(xmin), .YMAX(ymax), .YMIN(ymin), .apple_possible(out_random_2), .apple_location(apple_location2_n), .enable(enablea2));

random_num_gen twomode(.enable(enablea2), .system_clk(system_clk), .nreset(nreset), .number_out(out_random_2));

always_comb begin

    if (enable_in) begin
        apple_location2a = apple_location2_n;
    end
    else begin
        apple_location2a = 8'd0;
    end

end
logic steady_e;
logic [1:0] steady;
logic [7:0] apple_location1_n, apple_location2_n;

edgeDetect off_bc (.D(steady[1]),.clk(system_clk), .nrst(nreset), .edg(steady_e));

always_ff @ (posedge system_clk, negedge nreset) begin
    if (~nreset) begin
        steady <= 1'b0;
    end else if (clk_body) begin
        steady <= steady + 2'b01;
        if ((steady + 2'b01) == 2'b11) begin
            steady <= 2'b0;
        end
    end else begin
        steady <= steady;
    end
end

always_ff @ (posedge system_clk, negedge nreset) begin
    if (~nreset) begin
        {apple_location1, apple_location2} <= {8'h55, 8'h55};
    end else if (steady_e) begin
        {apple_location1, apple_location2} <= {apple_location1_n, apple_location2a};
    end else begin
        {apple_location1, apple_location2} <= {apple_location1, apple_location2};
    end
end

apple_gen_all ab (.good_collision(good_collision), .wall_locations(wall_locations), .system_clk(system_clk), .nreset(nreset), .apple_luck(apple_luck), .snake_head_x(snake_head_x), 
.snake_head_y(snake_head_y), .snakeArrayX(snakeArrayX), .snakeArrayY(snakeArrayY), .XMAX(xmax), .XMIN(xmin), .YMAX(ymax), .YMIN(ymin), .apple_possible(out_random),
 .apple_location(apple_location1_n), .enable(enablea));

random_num_gen normal1(.enable(enablea), .system_clk(system_clk), .nreset(nreset), .number_out(out_random));

assign apple = (({y,x} ==  apple_location1) || ({y,x} == apple_location2));
endmodule