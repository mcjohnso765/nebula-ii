module apple_check_wall_mode(
    input logic [3:0] xmax, xmin, ymax, ymin,
    input logic [24:0] [7:0] wall_locations,
    input logic [7:0] apple_possible,
    input logic clk, nreset,
    output logic impossible

);

logic [2:0] error_counter;
logic [7:0] up, down, left, right;
logic collision_up, collision_down, collision_left, collision_right, collision_upn, collision_downn, collision_leftn, collision_rightn;


collisionLogic_wall above(.next_wall(up), .walls(wall_locations), .collision(collision_upn));
collisionLogic_wall below(.next_wall(down), .walls(wall_locations), .collision(collision_downn));
collisionLogic_wall right2(.next_wall(right), .walls(wall_locations), .collision(collision_rightn));
collisionLogic_wall left2(.next_wall(left), .walls(wall_locations), .collision(collision_leftn));
always_comb begin

    error_counter = 0;

    up = apple_possible + 8'd8;
    down = apple_possible - 8'd8;
    left = apple_possible - 8'd1;
    right = apple_possible + 8'd1;

    if (up[7:4]  >= ymax) begin
        error_counter = error_counter + 1;
    end

    if (down[7:4]  <= ymin) begin
        error_counter = error_counter + 1;
    end

    if (right[3:0]  >= xmax) begin
        error_counter = error_counter + 1;
    end

    if (left[3:0]  <= xmin) begin
        error_counter = error_counter + 1;
    end

    if (collision_up) begin
        error_counter = error_counter + 1;
    end

    if (collision_down) begin
        error_counter = error_counter + 1;
    end

    if (collision_right) begin
        error_counter = error_counter + 1;
    end

    if (collision_left) begin
        error_counter = error_counter + 1;
    end
  
end

always_ff @(posedge clk, negedge nreset) begin

if (~nreset) begin
    collision_down <= 0;
    collision_left <= 0;
    collision_up <= 0;
    collision_right <= 0;

    impossible <= 0;
end

else begin
    collision_down <= collision_downn;
    collision_left <= collision_leftn;
    collision_up <= collision_upn;
    collision_right <= collision_rightn;
    impossible <= (error_counter >= 3);
end

end


endmodule