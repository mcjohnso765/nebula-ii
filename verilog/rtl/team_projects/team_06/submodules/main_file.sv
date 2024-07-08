
typedef enum logic [1:0] {
        RUN = 2'b00,
        WAIT = 2'b01, 
        PAUSE = 2'b10,
        END_GAME = 2'b11
    } GAME_STATE; 

typedef enum logic [1:0] {
        TWO_APPLE = 2'b00,
        NORMAL_MODE = 2'b01, 
        WALL_SPAWN = 2'b10,
        BORDER_CHANGE = 2'b11
    } GAME_MODE; 

typedef enum logic [1:0] {
        NORMAL_SPEED = 2'b00,
        FAST_SPEED = 2'b01, 
        SLOW_SPEED = 2'b10
    } GAME_SPEED; 

typedef enum logic [1:0] {
        APPLE_NORMAL = 2'b00,
        APPLE_LUCKY = 2'b01, 
        APPLE_UNLUCKY = 2'b10
    } APPLE_LUCK; 

typedef enum logic [1:0] {
        UP = 2'b00,
        DOWN = 2'b01, 
        LEFT = 2'b10,
        RIGHT = 2'b11
    } DIRECTION; 

module main_file (
    input logic clk, nrst, button_right_in, button_left_in, button_up_in, button_down_in, button_reset_in, button_start_pause_in, enable_total,
    input logic [3:0] x,y,
    output logic apple, wall, body, head, gameover, rert
);

parameter MAX_LENGTH = 30;

logic reset_button, reset_button_a, up_direction, down_direction, left_direction, right_direction, start_pause_button, pause_clk, main_clk, clk_body;
logic good_collision, good_collision2, bad_collision,  wall_a, apple_a, body_a, head_a;
GAME_SPEED game_speed;
DIRECTION direction;
GAME_STATE game_state;
GAME_MODE game_mode;
APPLE_LUCK apple_luck;
logic [3:0] snake_head_x, snake_head_y, xmin, xmax, ymax, ymin;
logic [MAX_LENGTH - 1:0] [3:0] snakeArrayX, snakeArrayY;
logic [7:0] score, apple_location, apple_location2;
logic [24:0] [7:0] wall_locations;

clock clock1(.system_clk(clk), .nreset(reset_button), .game_state(game_state), .clk(pause_clk), .clk_main_display(main_clk), .clk_body(clk_body), 
.game_speed(game_speed));

gameMode modea(.button(right_direction), .nrst(reset_button), .state(game_state), .mode(game_mode), .system_clk(main_clk));
//right button to change game_mode

gameState state1(.button(start_pause_button), .badCollision(bad_collision), .clk(main_clk), .nrst(reset_button), .gameMode(game_mode), .state(game_state));

collisionDetector detectabc(.clk(main_clk), .wall_array(wall_locations), .nrst(reset_button), .snakeHeadX(snake_head_x), .snakeHeadY(snake_head_y), .borderXMin(xmin), 
.borderXMax(xmax), .borderYMax(ymax), .borderYMin(ymin),  .AppleX2(apple_location2[3:0]), .AppleY2(apple_location2[7:4]), .AppleX(apple_location[3:0]), 
.AppleY(apple_location[7:4]), .snakeArrayX(snakeArrayX), .snakeArrayY(snakeArrayY), .badCollision(bad_collision), .goodCollision(good_collision), 
.good_collision2(good_collision2));

apple_luck_selector luck1(.clk(main_clk), .button(down_direction), .nrst(reset_button), .state(game_state), .apple_luck(apple_luck));
// down button to change apple_luck

game_speed_selector speed1(.system_clk(main_clk), .button(up_direction), .nrst(reset_button), .state(game_state), .game_speed(game_speed));
//up button to change speed

syncEdge up_button(.clk(main_clk), .nreset(reset_button), .but(button_up_in), .direction(up_direction));
syncEdge down_button(.clk(main_clk), .nreset(reset_button), .but(button_down_in), .direction(down_direction));
syncEdge left_button(.clk(main_clk), .nreset(reset_button), .but(button_left_in), .direction(left_direction));
syncEdge right_button(.clk(main_clk), .nreset(reset_button), .but(button_right_in), .direction(right_direction));
syncEdge start_pause_button1(.clk(main_clk), .nreset(reset_button), .but(button_start_pause_in), .direction(start_pause_button));
syncEdge reset_button1(.clk(main_clk), .nreset(nrst), .but(button_reset_in), .direction(reset_button_a));
assign reset_button = ~(reset_button_a | nrst);

wall_wrapper walls(.system_clk(main_clk), .score(score), .nrst(reset_button), .x(x), .y(y), .enable_in2(game_mode == BORDER_CHANGE), .good_collision(good_collision), .enable_in(game_mode == WALL_SPAWN)
, .apple_luck(apple_luck), .snake_head_x(snake_head_x), .snake_head_y(snake_head_y), .snakeArrayX(snakeArrayX), .snakeArrayY(snakeArrayY), .wall(wall_a), 
.xmax(xmax), .xmin(xmin), .ymax(ymax), .ymin(ymin), .wall_locations(wall_locations));

apple_wrapper applesa (.system_clk(main_clk), .nreset(reset_button), .good_collision(good_collision), .apple_luck(apple_luck), .snake_head_x(snake_head_x),
.snake_head_y(snake_head_y), .xmax(xmax), .xmin(xmin), .ymin(ymin), .ymax(ymax), .snakeArrayX(snakeArrayX), .snakeArrayY(snakeArrayY), 
.enable_in(game_mode == TWO_APPLE), .x(x), .y(y), .wall_locations(wall_locations), .apple(apple_a), .apple_location1(apple_location), 
.apple_location2(apple_location2));

body_wrapper bodymain1(.system_clk(main_clk), .body_clk(clk_body), .pause_clk(pause_clk), .nreset(reset_button), .good_collision(good_collision | good_collision2), 
.bad_collision(bad_collision), .enable(1'b1), .Direction(direction), .x(x), .y(y), .body(body_a), .head(head_a), .head_x(snake_head_x), .head_y(snake_head_y), 
.body_x(snakeArrayX), .body_y(snakeArrayY), .score(score));

DirectionLogic direction1(.clk(main_clk), .bad_collision(bad_collision), .pause_clk(pause_clk), .nrst(reset_button), .up(up_direction), 
.down(down_direction), .left(left_direction), .right(right_direction), .directionOut(direction));

assign apple = (apple_a & enable_total);
assign wall = (wall_a & enable_total);
assign body = (body_a & enable_total);
assign head = (head_a & enable_total);
assign gameover = (bad_collision & enable_total);
assign rert = (apple_location == 8'h46); //clk_body ({snake_head_x, snake_head_y} == 8'hA4)

// pressing one gets out of wait mode and goes into run mode
// pressign one in run mode switches to pause mode
// changing settings work correctly
// game ends instantly after entering run mode
// does clk_body ever become one?
// head instantly runs into right wall 8'hA4 then goes ?
// apple location is default, but does not show on display


// test main_file and body_wrapper

endmodule